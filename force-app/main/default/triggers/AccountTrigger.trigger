trigger AccountTrigger on Account (before insert, after insert, before update, after update, before delete) {
    if(Trigger.isBefore) {
        if(Trigger.isInsert) {
            AccountTriggerHandler.beforeInsert(Trigger.new);
        }
        else if(Trigger.isUpdate) {
            AccountTriggerHandler.beforeUpdate(Trigger.new, Trigger.oldMap);
        }
        else if(Trigger.isDelete) {
            AccountTriggerHandler.beforeDelete(Trigger.old);
        }
    }
    if(Trigger.isAfter) {
        if(Trigger.isInsert) {
            AccountTriggerHandler.afterInsert(Trigger.new);
        }
        else if(Trigger.isUpdate) {
            AccountTriggerHandler.afterUpdate(Trigger.new, Trigger.oldMap);
        }
    }
}