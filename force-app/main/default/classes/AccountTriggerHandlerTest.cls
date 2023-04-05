@isTest
public class AccountTriggerHandlerTest {
    @isTest
    public static void updateRatingTest() {
        List<Account> accounts = new List<Account>();
        for(Integer i=1 ; i<=5 ; i++) {
            Account acc = new Account();
            acc.Name = 'Test'+i;
            acc.Industry = 'Energy';
            accounts.add(acc);
        }
        Test.startTest();
        insert accounts;
        Test.stopTest();
        List<Account> updatedaccount = [SELECT Id, Rating, Industry FROM Account WHERE Id =: accounts[0].Id];
        System.assertEquals('Hot', updatedaccount[0].Rating);
        
    }

    @isTest
    public static void updateRatingTestupdate() {
        List<Account> accounts = new List<Account>();
        for(Integer i=1 ; i<=5 ; i++) {
            Account acc = new Account();
            acc.Name = 'Test'+i;
            acc.Industry = 'Energy';
            accounts.add(acc);
        }
        Test.startTest();
        insert accounts;
        for(Account acc : accounts) {
            acc.Industry = 'Media';
        }
        update accounts;
        Test.stopTest();
        List<Account> updatedaccount = [SELECT Id, Rating, Industry FROM Account WHERE Id =: accounts[0].Id];
        System.assertEquals('Hot', updatedaccount[0].Rating);
        
    }

    @isTest
    public static void copyBillingToShipping(){
        List<Account> accounts = new List<Account>();
        for(Integer i=1 ; i<=5 ; i++) {
            Account acc = new Account();
            acc.Name = 'Test'+i;
            acc.BillingCity = 'ghj';
            acc.BillingCountry = 'ug';
            acc.BillingPostalCode = '456790';
            acc.BillingState = 'raj';
            acc.BillingStreet = 'gfd';
            accounts.add(acc);
        }
        Test.startTest();
        insert accounts;
        Test.stopTest();

        List<Account> updateAccount = [SELECT Id, ShippingCity FROM Account WHERE Id =: accounts[0].Id];
        //System.assertEquals('ghj', updateAccount[0].ShippingCity);
    }
    @isTest
    public static void copyBillingToShippingUpdateTest(){
        List<Account> accounts = new List<Account>();
        for(Integer i=1 ; i<=5 ; i++) {
            Account acc = new Account();
            acc.Name = 'Test'+i;
            acc.BillingCity = 'ghj';
            acc.BillingCountry = 'ug';
            acc.BillingPostalCode = '456790';
            acc.BillingState = 'raj';
            acc.BillingStreet = 'gfd';
            accounts.add(acc);
        }
        Test.startTest();
        insert accounts;
        
        for(Account acc : accounts) {
            acc.CopyBillingToShipping__c = true;
        }
        update accounts;
        Test.stopTest();
        List<Account> updateAccount = [SELECT Id, ShippingCity FROM Account WHERE Id =: accounts[0].Id];
        System.assertEquals('ghj', updateAccount[0].ShippingCity);
    }
    @isTest
    public static void createRelatedContactTest(){
        List<Account> accounts = new List<Account>();
        for(Integer i=1 ; i<=5 ; i++) {
            Account acc = new Account();
            acc.Name = 'Account' +i;
            accounts.add(acc);
        }
        Test.startTest();
        insert accounts;
        Test.stopTest();
        List<Contact> conList = [SELECT Id FROM Contact WHERE AccountId =: accounts[0].Id];
        System.assert(conList!=null, 'contact not created');
    }

    @isTest
    public static void createRelatedOpportunity(){
        List<Account> accounts = new List<Account>();
        for(Integer i=1 ; i<=5 ; i++) {
            Account acc = new Account();
            acc.Name = 'Account' +i;
            accounts.add(acc);
        }
        Test.startTest();
        insert accounts;
        Test.stopTest();
        List<Opportunity> oppList = [SELECT Id FROM Opportunity WHERE AccountId =: accounts[0].Id];
        System.assert(oppList!=null, 'opportunity not created');
    }

    @isTest
    public static void createContactOrOppBasedOnCheckboxTest() {
        List<Account> accounts = new List<Account>();
        for(Integer i=1 ; i<=5 ; i++) {
            Account acc = new Account();
            acc.Name = 'Account'+i;
            acc.Active__c = 'Yes';
            acc.New_Contact__c = true;
            acc.New_Opportunity__c = true;
            accounts.add(acc);
        }
        Test.startTest();
        insert accounts;
        Test.stopTest();

        List<Contact> conList = [SELECT Id FROM Contact WHERE Id =: accounts[0].Id];
        List<Opportunity> oppList = [SELECT Id FROM Opportunity WHERE Id =: accounts[0].Id];
        System.assert(conList!=null, 'contact not inserted');
        System.assert(oppList!=null, 'opportunity not inserted');
    }

    @isTest
    public static void updateDescriptionUponPhoneUpdationTest(){
        List<Account> accounts = new List<Account>();
        for(Integer i=1 ; i<=5 ; i++) {
            Account acc = new Account();
            acc.Name = 'Pranjal' +i;
            acc.Phone = '980098765';
            accounts.add(acc);
        }
        Test.startTest();
        insert accounts;
        
        for(Account acc : accounts) {
            acc.Phone = '6578987890';
        }
        update accounts;
        Test.stopTest();
        List<Account> updateAccount = [SELECT Id, Description, Phone FROM Account WHERE Id =: accounts[0].Id];
        System.assertEquals('6578987890', updateAccount[0].Phone);

    }
    
    @isTest
    public static void updateContactPhoneTest(){
        List<Account> accounts = new List<Account>();
        List<Contact> contacts = new List<Contact>();
        for(Integer i=1 ; i<=5 ; i++) {
            Account acc = new Account();
            acc.Name = 'Test Account' +i;
            acc.Phone = '87909879';
            accounts.add(acc);
        }
        System.debug('accounts1>>'+accounts);
        insert accounts;
        System.debug('accounts2>>'+accounts);
        for(Account acc : accounts) {
            Contact con = new Contact();
            con.LastName = acc.Name;
            con.AccountId = acc.Id;
            contacts.add(con);
        }
        insert contacts;
        Test.startTest();
        for(Account acc : accounts) {
            acc.Phone = '63893902';
        }
        update accounts;
        Test.stopTest();

       List<Contact> contactList= [SELECT Id, HomePhone, AccountId FROM Contact WHERE Id =: contacts[0].Id];
       System.assertEquals('63893902', contactList[0].HomePhone);
    }

    @isTest
    public static void updateContactMailingAddressTest(){
        List<Account> accounts = new List<Account>();
        List<Contact> contacts = new List<Contact>();
        for(Integer i=1 ; i<=5 ; i++) {
            Account acc = new Account();
            acc.Name = 'Test Account' +i;
            acc.Phone = '87909879';
            accounts.add(acc);
        }
        System.debug('accounts1>>'+accounts);
        insert accounts;
        System.debug('accounts2>>'+accounts);
        for(Account acc : accounts) {
            Contact con = new Contact();
            con.LastName = acc.Name;
            con.AccountId = acc.Id;
            contacts.add(con);
        }
        insert contacts;
        Test.startTest();
        for(Account acc : accounts) {
            acc.BillingState = 'hgsd';
            acc.BillingStreet = 'njdo';
            acc.BillingPostalCode = '638792';
            acc.BillingCountry = 'gudis';
            acc.BillingCity = 'gshdfv';
        }
        update accounts;
        Test.stopTest();
        List<Contact> contactList= [SELECT Id, MailingCity, AccountId FROM Contact WHERE Id =: contacts[0].Id];
       System.assertEquals('gshdfv', contactList[0].MailingCity);
    }

    @isTest
    public static void beforeDeleteTest(){
        List<Account> accounts = new List<Account>();
        for(Integer i=1 ; i<=5 ; i++) {
            Account acc = new Account();
            acc.Name = 'Test Account' +i;
            acc.Phone = '87909879';
            acc.Active__c = 'Yes';
            accounts.add(acc);
        }
        Test.startTest();
        insert accounts;
        Boolean exceptionThrown = false;
        try {
          delete accounts;
        }
        catch(Exception e) {
            exceptionThrown = true;
            Boolean expectedExceptionThrown = (e.getMessage().contains('Active account cannot be deleted'))?true:false;
            System.assertEquals(true, expectedExceptionThrown, e.getMessage());
        }
        System.assertEquals(true, exceptionThrown, 'No exception was thrown');
        Test.stopTest();
    }
}