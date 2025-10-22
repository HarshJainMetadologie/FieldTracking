@isTest
private class OpportunityTriggerTest {

    @testSetup
    static void setupTestData() {
        List<Opportunity> oppList = new List<Opportunity>();
        for (Integer i = 1; i <= 3; i++) {
            oppList.add(new Opportunity(
                Name = 'Opp ' + i,
                StageName = 'Prospecting',
                CloseDate = Date.today().addDays(30),
                Amount = 1000 * i,
                OwnerId = UserInfo.getUserId()
            ));
        }
        insert oppList;
    }

    @isTest
    static void testInsertTrigger() {
        Opportunity opp = new Opportunity(
            Name = 'New Insert Opp',
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(15),
            Amount = 5000,
            OwnerId = UserInfo.getUserId()
        );

        Test.startTest();
        insert opp;
        Test.stopTest();

        List<Field_Tracking__c> trackingRecords = [
            SELECT Field_Track__c, Object_Name__c, Status__c
            FROM Field_Tracking__c
            WHERE Object_Name__c = 'Opportunity' AND Status__c = 'INSERT'
        ];
        System.assert(trackingRecords.size() > 0, 'Tracking records should be created for insert.');
    }

    @isTest
    static void testUpdateTrigger() {
        Opportunity opp = [SELECT Id, StageName FROM Opportunity LIMIT 1];
        opp.StageName = 'Qualification';

        Test.startTest();
        update opp;
        Test.stopTest();

        List<Field_Tracking__c> trackingRecords = [
            SELECT Field_Track__c, Object_Name__c, Status__c, Old_Value__c, New_Value__c
            FROM Field_Tracking__c
            WHERE Object_Name__c = 'Opportunity' AND Status__c = 'UPDATE'
        ];
        System.assert(trackingRecords.size() > 0, 'Tracking records should be created for update.');
        System.assert(trackingRecords[0].Old_Value__c != trackingRecords[0].New_Value__c, 'Old and new values should differ.');
    }

    @isTest
    static void testDeleteTrigger() {
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];

        Test.startTest();
        delete opp;
        Test.stopTest();

        List<Field_Tracking__c> trackingRecords = [
            SELECT Field_Track__c, Object_Name__c, Status__c, Old_Value__c, New_Value__c
            FROM Field_Tracking__c
            WHERE Object_Name__c = 'Opportunity' AND Status__c = 'DELETE'
        ];
        System.assert(trackingRecords.size() > 0, 'Tracking records should be created for delete.');
        System.assertEquals('', trackingRecords[0].New_Value__c, 'New value should be empty for delete.');
    }
}
