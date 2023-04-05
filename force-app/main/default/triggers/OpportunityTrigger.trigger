trigger OpportunityTrigger on Opportunity (before insert, after insert, before update, after update, after delete, after undelete) {
    if(Trigger.isBefore) {
        if(Trigger.isInsert) {
            OpportunityTriggerHandler.beforeInsert(Trigger.new);
        }
        else if(Trigger.isUpdate) {
            OpportunityTriggerHandler.beforeUpdate(Trigger.new, Trigger.oldMap);
        }
        else if(Trigger.isDelete) {
          OpportunityTriggerHandler.beforeDelete(Trigger.old);
        }
    }
    if(Trigger.isAfter) {
        if(Trigger.isInsert) {
            OpportunityTriggerHandler.afterInsert(Trigger.new);
        }
         else if(Trigger.isUpdate) {
            OpportunityTriggerHandler.afterUpdate(Trigger.new, Trigger.oldMap);
         }
         else if(Trigger.isDelete) {
            OpportunityTriggerHandler.afterDelete(Trigger.old);
         }
         else if(Trigger.isUndelete) {
            OpportunityTriggerHandler.afterUndelete(Trigger.new);
         }
    }
}