@isTest
private class FieldTrackingControllerTest {

    private static List<Field_Tracking__c> createTestData(Integer count, String status) {
        List<Field_Tracking__c> trackingList = new List<Field_Tracking__c>();

        for (Integer i = 0; i < count; i++) {
            trackingList.add(new Field_Tracking__c(
                Field_Track__c = 'StageName',
                Object_Name__c = 'Opportunity',
                Action_Date__c = Date.today().addDays(-i),
                Action_Time__c = Time.newInstance(15, 30, 15, 500),
                Status__c = status,
                Old_Value__c = 'Prospecting',
                New_Value__c = 'Closed Won',
                User__c = UserInfo.getUserId(),
                Identification__c = 'Opp_' + i
            ));
        }

        insert trackingList;
        return trackingList;
    }

    @isTest
    static void testGetOpportunityTracking_Positive() {
        createTestData(5, 'INSERT');

        Test.startTest();
        List<Field_Tracking__c> result = FieldTrackingController.getOpportunityTracking();
        Test.stopTest();

        System.assertNotEquals(0, result.size(), 'Expected some records to be returned.');
        System.assert(result.size() <= 100, 'Result should not exceed 100.');
        System.assertEquals('Opportunity', result[0].Object_Name__c, 'Object name should match.');
    }

    @isTest
    static void testGetOpportunityTracking_ExceedLimit() {
        createTestData(150, 'INSERT');

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
