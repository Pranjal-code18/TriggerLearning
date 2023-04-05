public class EmployeeTriggerHandler {
    public static void afterInsert(List<Employee__c> employees) {
        updateTotalEmployeeOnAccount(employees);
    }

    public static void afterDelete(List<Employee__c> employees) {
        updateTotalEmployeeOnAccount(employees);
    }
//scenario=18
    public static void afterUndelete(List<Employee__c> employees) {
        updateTotalEmployeeOnAccount(employees);
        Set<Id> accountIds = new Set<Id>();
        for(Employee__c employee : employees) {
            accountIds.add(employee.Account__c);
        }
        EmployeeTriggerHandlerService.undeleteEmployeeIfActiveYes(accountIds);
    }
//scenario=17,20,19
    private static void updateTotalEmployeeOnAccount(List<Employee__c> employees) {
        Set<Id> employeeAccountIds = new Set<Id>();
        for(Employee__c employee : employees) {
            employeeAccountIds.add(employee.Account__c);
        }
        EmployeeTriggerHandlerService.updateTotalEmployeeOnAccount(employeeAccountIds);    
    }
}