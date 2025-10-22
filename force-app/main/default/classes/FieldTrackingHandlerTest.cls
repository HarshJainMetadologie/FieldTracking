@isTest
private class FieldTrackingHandlerTest {

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

        List<Contact> contactList = new List<Contact>();
        for (Integer i = 1; i <= 2; i++) {
            contactList.add(new Contact(
                FirstName = 'Test' + i,
                LastName = 'User' + i,
                Email = 'test' + i + '@example.com',
                Phone = '1234567890',
                OwnerId = UserInfo.getUserId()
            ));
        }
        insert contactList;
    }

    @isTest
    static void testInsertTracking() {
        List<Opportunity> newOpps = [SELECT Id, Name, StageName, CloseDate, Amount FROM Opportunity];
        Test.startTest();
        FieldTrackingHandler.trackChanges(newOpps, null, 'INSERT');
        Test.stopTest();

        List<Field_Tracking__c> trackingRecords = [
            SELECT Field_Track__c, Object_Name__c, Status__c, New_Value__c
            FROM Field_Tracking__c
            WHERE Object_Name__c = 'Opportunity'
        ];
        System.assert(trackingRecords.size() > 0, 'Tracking records should be created for insert.');
        System.assertEquals('INSERT', trackingRecords[0].Status__c, 'Status should be INSERT.');
    }

    @isTest
    static void testUpdateTracking() {
        List<Opportunity> opps = [SELECT Id, Name, StageName, Amount FROM Opportunity];
        Map<Id, SObject> oldMap = new Map<Id, SObject>();
        for (Opportunity o : opps) {
            oldMap.put(o.Id, o.clone(false, true));
            o.StageName = 'Qualification';
        }

        Test.startTest();
        FieldTrackingHandler.trackChanges(opps, oldMap, 'UPDATE');
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
    static void testDeleteTracking() {
        List<Contact> contacts = [SELECT Id, FirstName, LastName FROM Contact];
        Map<Id, SObject> oldMap = new Map<Id, SObject>();
        for (Contact c : contacts) {
            oldMap.put(c.Id, c);
        }

        Test.startTest();
        FieldTrackingHandler.trackChanges(null, oldMap, 'DELETE');
        Test.stopTest();

        List<Field_Tracking__c> trackingRecords = [
            SELECT Field_Track__c, Object_Name__c, Status__c, Old_Value__c, New_Value__c
            FROM Field_Tracking__c
            WHERE Object_Name__c = 'Contact' AND Status__c = 'DELETE'
        ];
        System.assert(trackingRecords.size() > 0, 'Tracking records should be created for delete.');
        System.assertEquals('', trackingRecords[0].New_Value__c, 'New value should be empty for delete.');
    }

    @isTest
    static void testNoRecords() {
        Test.startTest();
        FieldTrackingHandler.trackChanges(new List<SObject>(), new Map<Id, SObject>(), 'UPDATE');
        FieldTrackingHandler.trackChanges(null, null, 'DELETE');
        Test.stopTest();

        System.assert(true, 'Method should handle empty input without exceptions.');
    }
}
