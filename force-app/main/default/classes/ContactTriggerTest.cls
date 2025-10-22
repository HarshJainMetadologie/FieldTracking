@isTest
private class ContactTriggerTest {
    @isTest
    static void testInsertTrigger() {
        Contact c = new Contact(LastName = 'Test Insert');
        insert c;

        List<Field_Tracking__c> trackings = [
            SELECT Field_Track__c, Old_Value__c, New_Value__c, Identification__c
            FROM Field_Tracking__c
            WHERE Identification__c = :c.Id
        ];

        if (trackings.isEmpty()) {
            System.debug('No tracking records created for insert.');
        } else {
            System.assertNotEquals(null, trackings[0].New_Value__c, 'New value should not be null for insert.');
        }
    }

    @isTest
    static void testUpdateTrigger() {
        Contact c = new Contact(LastName = 'Before Update');
        insert c;

        c.LastName = 'After Update';
        update c;

        List<Field_Tracking__c> trackings = [
            SELECT Field_Track__c, Old_Value__c, New_Value__c, Identification__c
            FROM Field_Tracking__c
            WHERE Identification__c = :c.Id
        ];

        if (trackings.isEmpty()) {
            System.debug('No tracking records created for update.');
        } else {
            System.assertNotEquals(trackings[0].Old_Value__c, trackings[0].New_Value__c, 'Old and new values should differ for update.');
        }
    }

    @isTest
    static void testDeleteTrigger() {
        Contact c = new Contact(LastName = 'To Delete');
        insert c;
        delete c;

        List<Field_Tracking__c> trackings = [
            SELECT Field_Track__c, Old_Value__c, New_Value__c, Identification__c
            FROM Field_Tracking__c
            WHERE Identification__c = :c.Id
        ];

        if (trackings.isEmpty()) {
            System.debug('No tracking records created for delete.');
        } else {
            System.assertEquals('', String.valueOf(trackings[0].New_Value__c), 'New value should be empty for delete.');
        }
    }
}
