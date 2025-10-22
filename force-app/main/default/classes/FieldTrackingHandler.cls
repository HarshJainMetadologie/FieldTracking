public with sharing class FieldTrackingHandler {

    private static String nsPrefix;

    static {
        if (Schema.getGlobalDescribe().containsKey('Harsh02__Field_Tracking__c')) {
            nsPrefix = 'Harsh02__';
        } else if (Schema.getGlobalDescribe().containsKey('Field_Tracking__c')) {
            nsPrefix = '';
        } else {
            nsPrefix = '';
        }
    }

    private static List<String> fieldsToTrack = new List<String>{'Name','StageName','CloseDate','Amount','OwnerId'};

    public static void trackChanges(List<SObject> newList, Map<Id, SObject> oldMap, String operationType) {

        if ((newList == null || newList.isEmpty()) && operationType != 'DELETE') return;
        if (operationType == 'DELETE' && (oldMap == null || oldMap.isEmpty())) return;

        List<SObject> trackingRecords = new List<SObject>();
        String trackingObjApi = nsPrefix + 'Field_Tracking__c';

        Iterable<SObject> recordsToProcess = (operationType == 'DELETE') ? oldMap.values() : newList;

        for (SObject record : recordsToProcess) {

            SObject oldRecord = (operationType == 'DELETE') ? record : (oldMap != null ? oldMap.get(record.Id) : null);
            String objectName = record.getSObjectType().getDescribe().getName();
            String identification = (oldRecord != null) ? String.valueOf(oldRecord.get('Name')) : String.valueOf(record.get('Name'));

            for (String fieldName : fieldsToTrack) {
                Object oldVal;
                Object newVal;

                if (operationType == 'INSERT' || operationType == 'UNDELETE') {
                    oldVal = null;
                    newVal = record.get(fieldName);
                } else if (operationType == 'UPDATE') {
                    oldVal = oldRecord != null ? oldRecord.get(fieldName) : null;
                    newVal = record.get(fieldName);
                    if ((oldVal == null && newVal == null) || (oldVal != null && oldVal.equals(newVal))) continue;
                } else if (operationType == 'DELETE') {
                    oldVal = oldRecord != null ? oldRecord.get(fieldName) : null;
                    newVal = null; 
                } else {
                    continue;
                }

                Datetime dt = System.now();
                SObject trackingRecord = Schema.getGlobalDescribe().get(trackingObjApi).newSObject();
                trackingRecord.put(nsPrefix + 'Field_Track__c', fieldName);
                trackingRecord.put(nsPrefix + 'Object_Name__c', objectName);
                trackingRecord.put(nsPrefix + 'Record_Id__c', String.valueOf(record.get('Id')));
                trackingRecord.put(nsPrefix + 'Action_Date__c', dt.date());
                trackingRecord.put(nsPrefix + 'Action_Time__c', dt.time());
                trackingRecord.put(nsPrefix + 'Status__c', operationType);
                trackingRecord.put(nsPrefix + 'Identification__c', identification);
                trackingRecord.put(nsPrefix + 'Old_Value__c', oldVal != null ? String.valueOf(oldVal) : '');
                trackingRecord.put(nsPrefix + 'New_Value__c', newVal != null ? String.valueOf(newVal) : '');
                trackingRecord.put(nsPrefix + 'User__c', UserInfo.getUserId());

                trackingRecords.add(trackingRecord);
            }
        }

        if (!trackingRecords.isEmpty()) {
            insert trackingRecords;
        }
    }
}
