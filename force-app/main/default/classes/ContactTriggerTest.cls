@isTest
private class ContactTriggerTest {

    @testSetup
    static void setupTestData() {
        List<Contact> contacts = new List<Contact>();
        for (Integer i = 1; i <= 3; i++) {
            contacts.add(new Contact(
                FirstName = 'Test' + i,
                LastName = 'User' + i,
                Email = 'test' + i + '@example.com',
                Phone = '1234567890',
                OwnerId = UserInfo.getUserId()
            ));
        }
        insert contacts;
    }

    @isTest
    static void testInsertTrigger() {
        Contact c = new Contact(
            FirstName = 'New',
            LastName = 'Contact',
            Email = 'newcontact@example.com',
            Phone = '9876543210',
            OwnerId = UserInfo.getUserId()
        );

        Test.startTest();
        insert c;
        Test.stopTest();

        // Use plain API name without namespace
        List<Field_Tracking__c> trackingRecords = [
            SELECT Field_Track__c, Object_Name__c, Status__c
            FROM Field_Tracking__c
            WHERE Object_Name__c = 'Contact' AND Status__c = 'INSERT'
        ];
        System.assert(trackingRecords.size() > 0, 'Tracking records should be created for insert.');
    }

    @isTest
    static void testUpdateTrigger() {
        Contact c = [SELECT Id, FirstName, LastName, Phone FROM Contact LIMIT 1];
        c.Phone = '1112223333';

        Test.startTest();
        update c;
        Test.stopTest();

        List<Field_Tracking__c> trackingRecords = [
            SELECT Field_Track__c, Object_Name__c, Status__c, Old_Value__c, New_Value__c
            FROM Field_Tracking__c
            WHERE Object_Name__c = 'Contact' AND Status__c = 'UPDATE'
        ];
        System.assert(trackingRecords.size() > 0, 'Tracking records should be created for update.');
        System.assert(trackingRecords[0].Old_Value__c != trackingRecords[0].New_Value__c, 'Old and new values should differ.');
    }

    @isTest
    static void testDeleteTrigger() {
        Contact c = [SELECT Id FROM Contact LIMIT 1];

        Test.startTest();
        delete c;
        Test.stopTest();

        List<Field_Tracking__c> trackingRecords = [
            SELECT Field_Track__c, Object_Name__c, Status__c, Old_Value__c, New_Value__c
            FROM Field_Tracking__c
            WHERE Object_Name__c = 'Contact' AND Status__c = 'DELETE'
        ];
        System.assert(trackingRecords.size() > 0, 'Tracking records should be created for delete.');
        System.assertEquals('', trackingRecords[0].New_Value__c, 'New value should be empty for delete.');
    }
}
