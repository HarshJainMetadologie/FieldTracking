@isTest
private class FieldTrackingHandlerTest {

    @testSetup
    static void setupData() {
        List<Opportunity> opps = new List<Opportunity>();
        for (Integer i = 1; i <= 3; i++) {
            opps.add(new Opportunity(
                Name = 'Opp ' + i,
                StageName = 'Prospecting',
                CloseDate = Date.today().addDays(10),
                Amount = 1000 * i,
                OwnerId = UserInfo.getUserId()
            ));
        }
        insert opps;

        List<Contact> cons = new List<Contact>();
        for (Integer i = 1; i <= 3; i++) {
            cons.add(new Contact(
                FirstName = 'Test' + i,
                LastName = 'User' + i,
                Email = 'test' + i + '@example.com',
                Phone = '1234567890',
                OwnerId = UserInfo.getUserId()
            ));
        }
        insert cons;
    }

    private static List<Field_Tracking__c> createTracking(Integer count) {
        List<Field_Tracking__c> listFT = new List<Field_Tracking__c>();
        for (Integer i = 0; i < count; i++) {
            listFT.add(new Field_Tracking__c(
                Field_Track__c = 'StageName',
                Object_Name__c = 'Opportunity',
                Action_Date__c = Date.today(),
                Action_Time__c = Time.newInstance(12, 30, 0, 0),
                Status__c = 'UPDATE',
                Old_Value__c = 'Prospecting',
                New_Value__c = 'Closed Won',
                User__c = UserInfo.getUserId(),
                Identification__c = 'Opp_' + i
            ));
        }
        insert listFT;
        return listFT;
    }

    @isTest
    static void testGetOpportunityTracking_Positive() {
        delete [SELECT Id FROM Field_Tracking__c]; // isolate test data
        createTracking(5);

        Test.startTest();
        List<Field_Tracking__c> res = FieldTrackingController.getOpportunityTracking();
        Test.stopTest();

        System.assert(res.size() > 0, 'Records should exist');
        System.assertEquals('Opportunity', res[0].Object_Name__c, 'Object name should be Opportunity');
    }

    @isTest
    static void testGetOpportunityTracking_NoData() {
        delete [SELECT Id FROM Field_Tracking__c];

        Test.startTest();
        List<Field_Tracking__c> res = FieldTrackingController.getOpportunityTracking();
        Test.stopTest();

        System.assertNotEquals(null, res, 'Result should not be null');
        System.assertEquals(0, res.size(), 'Expected no tracking records');
    }

    @isTest
    static void testInsertUpdateDeleteOpportunity() {
        Opportunity opp = [SELECT Id, Name, StageName, CloseDate, Amount, OwnerId FROM Opportunity LIMIT 1];

        Test.startTest();
        opp.StageName = 'Closed Won';
        update opp;

        opp = [SELECT Id FROM Opportunity LIMIT 1];
        delete opp;
        Test.stopTest();

        List<Field_Tracking__c> tracks = [
            SELECT Id, Field_Track__c, Object_Name__c, Status__c, Old_Value__c, New_Value__c
            FROM Field_Tracking__c
            WHERE Object_Name__c = 'Opportunity'
        ];

        System.assert(tracks.size() > 0, 'Tracking records should exist');
    }

    @isTest
    static void testInsertUpdateDeleteContact() {
        Contact con = [SELECT Id, FirstName, LastName, Email, Phone, OwnerId FROM Contact LIMIT 1];

        Test.startTest();
        con.LastName = 'Updated';
        update con;

        con = [SELECT Id FROM Contact LIMIT 1];
        delete con;
        Test.stopTest();

        List<Field_Tracking__c> tracks = [
            SELECT Id, Field_Track__c, Object_Name__c, Status__c, Old_Value__c, New_Value__c
            FROM Field_Tracking__c
            WHERE Object_Name__c = 'Contact'
        ];

        System.assert(tracks.size() > 0, 'Tracking records should exist');
    }
}
