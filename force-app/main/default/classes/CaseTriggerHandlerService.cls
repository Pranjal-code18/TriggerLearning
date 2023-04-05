public class CaseTriggerHandlerService {
    public static void populateCaseNumberOnAccount(List<Case> cases) {
        List<Account> accounts = new List<Account>();
        for(Case cs : cases) {
            Account acc = new Account();
            acc.Latest_Case_Number__c = cs.CaseNumber;
            acc.Id = cs.AccountId;
            accounts.add(acc);
        }
        if(!accounts.isEmpty()) {
            update accounts;
        }
    }
//sc=22
    public static void populateTotalPartnerAndCustomerCase(List<Case> cases) {
        System.debug('cases>'+cases);
        List<Case> partnerCaseLists = [SELECT RecordType.DeveloperName, AccountId FROM Case WHERE RecordType.DeveloperName =: 'Partner_Case'];
        System.debug('parent'+partnerCaseLists);
        List<Case> customerCaseLists = [SELECT RecordType.DeveloperName, AccountId FROM Case WHERE RecordType.DeveloperName =: 'Customer_Case'];
        System.debug('customerCaseLists'+customerCaseLists);
        Map<Id, Integer> accountIdToParentCaseMap = new Map<Id, Integer>();
        Map<Id, Integer> accountIdToCustomerCaseMap = new Map<Id, Integer>();
        for(Case cs : partnerCaseLists) {
            if(!accountIdToParentCaseMap.containsKey(cs.AccountId)) {
                accountIdToParentCaseMap.put(cs.AccountId, 0);
                }
                accountIdToParentCaseMap.put(cs.AccountId,accountIdToParentCaseMap.get(cs.AccountId)+1);
        }
        System.debug('accountIdToParentCaseMap'+accountIdToParentCaseMap);

        for(Case cs : customerCaseLists) {
            if(!accountIdToCustomerCaseMap.containsKey(cs.AccountId)) {
                accountIdToCustomerCaseMap.put(cs.AccountId, 0);
                }
                accountIdToCustomerCaseMap.put(cs.AccountId,accountIdToCustomerCaseMap.get(cs.AccountId)+1);
        }
        System.debug('accountIdToCustomerCaseMap'+accountIdToCustomerCaseMap);
        
        List<Account> relatedAccounts = new List<Account>();
        for(Account acc : [SELECT Id FROM Account WHERE Id =: accountIdToParentCaseMap.keySet() OR Id =: accountIdToCustomerCaseMap.keySet()]) {
            Account account = new Account();
            acc.Total_Customer_Case__c = accountIdToCustomerCaseMap.get(acc.Id);
            acc.Total_Partner_Case__c = accountIdToParentCaseMap.get(acc.Id);
            account.Id = acc.Id;
            relatedAccounts.add(acc);
        }
        if(!relatedAccounts.isEmpty()) {
            update relatedAccounts;
            System.debug('relatedAccounts>'+relatedAccounts);
        }
    }
}