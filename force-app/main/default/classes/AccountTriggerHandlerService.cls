public class AccountTriggerHandlerService {
    public static void createRelatedContact(List<Account> accounts) {
        List<Contact> newContacts = new List<Contact>();
        for(Account account : accounts) {
            Contact con = new Contact();
            con.LastName = account.Name;
            con.Email = 'pranjalbansal589@gmail.'+account.Name;
            con.AccountId = account.Id;
            newContacts.add(con);
        }
        if(!newContacts.isEmpty()) {
            insert newContacts;
            System.debug('newContacts>'+newContacts);
        }
    }

    public static void createRelatedOpportunity(List<Account> accounts) {
        List<Opportunity> opportunityList = new List<Opportunity>();
        for(Account acc : accounts) {
            Opportunity opp = new Opportunity();
            opp.Name = acc.Name;
            opp.AccountId = acc.Id;
            opp.StageName = 'Prospecting';
            opp.CloseDate = System.today();
            opportunityList.add(opp);
        }
        if(!opportunityList.isEmpty()) {
            insert opportunityList;
        }
    }
}