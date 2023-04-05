global class UpdateAndInsertAccountInEvery2Minutes implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext bc) {
        String query = 'SELECT Id FROM Account';
        System.debug('queryyyyyy'+query);
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<Account> accounts) {
        System.debug('accounts'+accounts);
        List<Account> newAccounts = new List<Account>();
        for(Integer i=1 ; i<=10 ; i++) {
            Account acc = new Account();
            acc.Name = 'AccountUpdate'+i;
            newAccounts.add(acc);
            System.debug('newAccounts1'+newAccounts);
        }
        if(!newAccounts.isEmpty()) {
            insert newAccounts;
            System.debug('newAccounts2'+newAccounts);
        }

        List<Account> oldAccount = [SELECT Id FROM Account ORDER BY CreatedDate ASC LIMIT 9];
        System.debug('oldAccount'+oldAccount);
        if(!oldAccount.isEmpty()) {
            delete oldAccount;
        }
    }

    global void finish(Database.BatchableContext bc) {

    }
}