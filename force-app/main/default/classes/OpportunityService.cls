public class OpportunityService {
    public static Boolean handleRecursion = true;
    public static void updateAccountStatus(Set<Id> accountIds) {
        List<Account> accounts = [SELECT Id, Status__c FROM Account WHERE Id =: accountIds AND Status__c = 'inactive'];
        for(Account account : accounts) {
            account.Status__c = 'active';
            handleRecursion = false;
        }
        if(!accounts.isEmpty()){
            update accounts;
            System.debug('account>'+accounts);
        } 
    }
}