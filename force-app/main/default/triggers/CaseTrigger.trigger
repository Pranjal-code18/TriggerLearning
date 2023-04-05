trigger CaseTrigger on Case (before insert, after insert, after update) {
    if(Trigger.isAfter) {
        if(Trigger.isInsert) {
            CaseTriggerHandler.afterInsert(Trigger.new);
        }
    }

}