public with sharing class FieldTrackingController {

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

    @AuraEnabled(cacheable=true)
    public static List<SObject> getOpportunityTracking() {
        String soql = 'SELECT ' + nsPrefix + 'Field_Track__c, '+ nsPrefix + 'Object_Name__c, '+ nsPrefix + 'Action_Date__c, '+ nsPrefix + 'Action_Time__c, '+ nsPrefix + 'Status__c, '
            + nsPrefix + 'Old_Value__c, '+ nsPrefix + 'New_Value__c, '+ nsPrefix + 'User__c, '+ nsPrefix + 'Identification__c '
            + 'FROM ' + nsPrefix + 'Field_Tracking__c '
            + 'ORDER BY ' + nsPrefix + 'Action_Date__c DESC, ' + nsPrefix + 'Action_Time__c DESC '
            + 'LIMIT 100';

        return Database.query(soql);
    }
}
