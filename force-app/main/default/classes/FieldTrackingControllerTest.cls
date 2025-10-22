@isTest
private class FieldTrackingControllerTest {

    private static List<Field_Tracking__c> createTestData(Integer count) {
        List<Field_Tracking__c> trackingList = new List<Field_Tracking__c>();
        for (Integer i = 0; i < count; i++) {
            trackingList.add(new Field_Tracking__c(
                Harsh02__Field_Track__c = 'StageName',
                Harsh02__Object_Name__c = 'Opportunity',
                Harsh02__Action_Date__c = Date.today().addDays(-i),
                Harsh02__Action_Time__c = Time.newInstance(15, 30, 0, 0),
                Harsh02__Status__c = 'Updated',
                Harsh02__Old_Value__c = 'Prospecting',
                Harsh02__New_Value__c = 'Closed Won', 
                Harsh02__User__c = UserInfo.getUserId(),
                Harsh02__Identification__c = 'Opp_' + i 
            ));
        }

        insert trackingList;
        return trackingList;
    }


    @isTest
    static void testGetOpportunityTracking_Positive() {
        createTestData(5);

        Test.startTest();
        List<Field_Tracking__c> result = FieldTrackingController.getOpportunityTracking();
        Test.stopTest();

        System.assertNotEquals(0, result.size(), 'Expected records to be returned.');
        System.assert(result.size() <= 100, 'Result should not exceed 100.');
        System.assertEquals('Opportunity', result[0].Harsh02__Object_Name__c, 'Object name should match.');
    }

    @isTest
    static void testGetOpportunityTracking_NullFields() {
        createTestData(5);

        Test.startTest();
        List<Field_Tracking__c> result = FieldTrackingController.getOpportunityTracking();
        Test.stopTest();

        System.assertNotEquals(0, result.size(), 'Expected records to be returned even with nulls.');
        for (Field_Tracking__c rec : result) {
            System.assert(rec.Harsh02__Field_Track__c != null, 'Field_Track should always be present.');
            System.assertEquals('Opportunity', rec.Harsh02__Object_Name__c);
        }
    }

    @isTest
    static void testGetOpportunityTracking_ExceedLimit() {
        createTestData(150);

        Test.startTest();
        List<Field_Tracking__c> result = FieldTrackingController.getOpportunityTracking();
        Test.stopTest();

        System.assertEquals(100, result.size(), 'Should return only 100 records due to LIMIT 100.');
    }

    @isTest
    static void testGetOpportunityTracking_NoData() {
        Test.startTest();
        List<Field_Tracking__c> result = FieldTrackingController.getOpportunityTracking();
        Test.stopTest();

        System.assertNotEquals(null, result, 'Result should not be null.');
        System.assertEquals(0, result.size(), 'Result list should be empty when no records exist.');
    }
}
