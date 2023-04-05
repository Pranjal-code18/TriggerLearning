trigger EmployeeTrigger on Employee__c (after insert, after delete, after undelete) {
    if(Trigger.isAfter) {
        if(Trigger.isInsert) {
            EmployeeTriggerHandler.afterInsert(Trigger.new);
        }
        else if(Trigger.isDelete) {
            System.debug('inside trigger');
            EmployeeTriggerHandler.afterDelete(Trigger.old);
        }
        else if(Trigger.isUndelete) {
            EmployeeTriggerHandler.afterUndelete(Trigger.new);
        }
    }
}