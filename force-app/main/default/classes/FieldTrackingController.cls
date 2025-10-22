public with sharing class FieldTrackingController {
    @AuraEnabled(cacheable=true)
    public static List<Field_Tracking__c> getOpportunityTracking() {
        return [
            SELECT Field_Track__c, Object_Name__c, Action_Date__c, Action_Time__c,
                   Status__c, Old_Value__c, New_Value__c, User__c, Identification__c
            FROM Field_Tracking__c
            ORDER BY Action_Date__c DESC, Action_Time__c DESC
            LIMIT 100
        ];
    }
}