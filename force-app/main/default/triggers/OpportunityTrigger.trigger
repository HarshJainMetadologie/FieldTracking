trigger OpportunityTrigger on Opportunity (after insert, after update, after delete, after undelete) {
    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            FieldTrackingHandler.trackChanges(Trigger.new, null, 'INSERT');
        } else if (Trigger.isUpdate) {
            FieldTrackingHandler.trackChanges(Trigger.new, Trigger.oldMap, 'UPDATE');
        } else if (Trigger.isDelete) {
            FieldTrackingHandler.trackChanges(Trigger.old, Trigger.oldMap, 'DELETE');
        } else if (Trigger.isUndelete) {
            FieldTrackingHandler.trackChanges(Trigger.new, null, 'UNDELETE');
        }
    }
}
