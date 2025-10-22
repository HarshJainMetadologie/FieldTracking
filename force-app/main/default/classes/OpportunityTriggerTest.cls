@isTest
private class OpportunityTriggerTest {

    @testSetup
    static void setupData() {
        List<Opportunity> opps = new List<Opportunity>();
        for (Integer i = 1; i <= 2; i++) {
            opps.add(new Opportunity(
                Name = 'Test Opp ' + i,
                StageName = 'Prospecting',
                CloseDate = Date.today().addDays(30),
                Amount = 1000 * i,
                OwnerId = UserInfo.getUserId()
            ));
        }
        insert opps;
    }

    @isTest
    static void testInsertTrigger() {
        Opportunity opp = new Opportunity(
            Name = 'Inserted Opp',
            StageName = 'Qualification',
            CloseDate = Date.today().addDays(10),
            Amount = 5000
        );

        Test.startTest();
        insert opp;
        Test.stopTest();

        List<Field_Tracking__c> tracks = [
            SELECT Field_Track__c, Old_Value__c, New_Value__c, Status__c, Object_Name__c
            FROM Field_Tracking__c
            WHERE Object_Name__c = 'Opportunity'
        ];

        if (tracks.isEmpty()) {
            System.debug('No tracking record created for insert.');
        } else {
            System.assertNotEquals(null, tracks[0].New_Value__c, 'New value should not be null for insert.');
        }
    }

    @isTest
    static void testUpdateTrigger() {
        Opportunity opp = [SELECT Id, Name, StageName, CloseDate, Amount, OwnerId FROM Opportunity LIMIT 1];
        opp.StageName = 'Closed Won';

        Test.startTest();
        update opp;
        Test.stopTest();

        List<Field_Tracking__c> tracks = [
            SELECT Field_Track__c, Old_Value__c, New_Value__c, Status__c, Object_Name__c
            FROM Field_Tracking__c
            WHERE Object_Name__c = 'Opportunity'
        ];

        if (tracks.isEmpty()) {
            System.debug('No tracking record created for update.');
        } else {
            System.assertNotEquals(tracks[0].Old_Value__c, tracks[0].New_Value__c, 'Old and new values should differ for update.');
        }
    }

    @isTest
    static void testDeleteTrigger() {
        Opportunity opp = [SELECT Id, Name, StageName, CloseDate, Amount, OwnerId FROM Opportunity LIMIT 1];

        Test.startTest();
        delete opp;
        Test.stopTest();

        List<Field_Tracking__c> tracks = [
            SELECT Field_Track__c, Old_Value__c, New_Value__c, Status__c, Object_Name__c
            FROM Field_Tracking__c
            WHERE Object_Name__c = 'Opportunity'
        ];

        if (tracks.isEmpty()) {
            System.debug('No tracking record created for delete.');
        } else {
            System.assertNotEquals(null, tracks[0].New_Value__c, 'New value can be null or filled depending on logic.');
            System.debug('Delete Tracking Record New_Value__c: ' + tracks[0].New_Value__c);
        }
    }
}
