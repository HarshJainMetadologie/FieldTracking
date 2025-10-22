public with sharing class FieldTrackingController {
    @AuraEnabled(cacheable=true)
    public static List<Field_Tracking__c> getOpportunityTracking() {
        return [SELECT Harsh02__Field_Track__c, Harsh02__Object_Name__c, Harsh02__Action_Date__c, Harsh02__Action_Time__c,Harsh02__Status__c, Harsh02__Old_Value__c, Harsh02__New_Value__c, Harsh02__User__c, Harsh02__Identification__c
            FROM Harsh02__Field_Tracking__c
            WHERE Harsh02__Object_Name__c = 'Opportunity'
            ORDER BY Harsh02__Action_Date__c DESC, Harsh02__Action_Time__c DESC
            LIMIT 100
        ];
    }
}
