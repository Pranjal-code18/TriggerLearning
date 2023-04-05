trigger UserTrigger on User (before insert, after insert) {
    if(Trigger.isAfter) {
        if(Trigger.isInsert) {
            UserTriggerHandler.afterInsert(Trigger.new);
        }
    }
    //UserTriggerHandler.beforeInsert(Trigger.new);
}