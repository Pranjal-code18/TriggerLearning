public class OpportunityTriggerHandlerService {
    public static void updateAccountLatestAmountField(List<Opportunity> opportunities) {
        List<Account> accounts = new List<Account>();
        for(Opportunity opp : opportunities) {
            Account acc = new Account();
            acc.Id = opp.AccountId;
            acc.Latest_Opportunity_Amount__c = opp.Amount;
            accounts.add(acc);
        }
        if(!accounts.isEmpty()) {
            update accounts;
        }
    }

    public static void updateTotalAmountOnAnnualRevenue(Set<Id> accountIds) {
        List<Account> accountLists = [SELECT Id, Opp__c, AnnualRevenue FROM Account WHERE Id =: accountIds];
        System.debug('accountLists'+accountLists);
        for(Account acc : accountLists) {
            acc.AnnualRevenue = acc.Opp__c;
        }
        System.debug('accountLists'+accountLists);
        update accountLists;
        System.debug('accountLists'+accountLists);
    }
    public static void updateAccountAnnualRevenue( Set<Id> AccountIds) {
        List<Account> accounts = [SELECT id,AnnualRevenue,(SELECT accountId,Amount FROM Opportunities) 
        FROM account WHERE id =: AccountIds];

        for(Account account :accounts){
            Decimal total = 0;
            for(Opportunity opportunity: account.opportunities){
                total+= opportunity.Amount;
            }
            account.AnnualRevenue = total;
        }
        if(!accounts.isEmpty()){
            update accounts;
        }
    }
}