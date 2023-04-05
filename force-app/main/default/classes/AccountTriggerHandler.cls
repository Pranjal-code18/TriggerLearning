public class AccountTriggerHandler {
    public static void beforeInsert(List<Account> accounts) {
        updateRatingBasedOnIndustry(accounts);
        populateBillingToShippingAddress(accounts, NULL);
    }

    public static void afterInsert(List<Account> accounts) {
        System.debug('accounts>>'+accounts);
        createRelatedContact(accounts);
        createRelatedOpportunity(accounts);
        createAccountForShare(accounts);
        //sendEmailToContactAboutOpportunity(accounts);
        //createRelatedContactOrOpportunity(accounts);
    }

    public static void beforeUpdate(List<Account> accounts, Map<Id, Account> accountMap) {
        updateDescription(accounts, accountMap);
        populateBillingToShippingAddress(accounts, accountMap);
        preventAccountToUpdate(accounts, accountMap);
    }

    public static void afterUpdate(List<Account> accounts, Map<Id, Account> accountMap) {
        updateOwnerOfContact(accounts, accountMap);
        updateContactMailingAddress(accounts, accountMap);
        updateContactAddressUsingSOQL(accounts, accountMap);
        //updateHomePhoneOnContact(accounts, accountMap);
        updateHomePhoneOnContactSOQL(accounts, accountMap);
        updateOppRelatedToAccount(accounts, accountMap);
        //updateMailingAddress(accounts, accountMap);
    }

    public static void beforeDelete(List<Account> accounts) {
        preventAccountIfActiveYes(accounts);
        DeleteAccountBySystemAdministrator(accounts);
        preventFromDeleteIfNoOpp(accounts,NULL);
        preventIfNoContact(accounts,NULL);
    }
    //scenario-1
    private static void updateRatingBasedOnIndustry(List<Account> accounts) {
        for(Account account : accounts) {
            if(account.Industry != NULL && account.Industry == 'Media') {
                account.Rating = 'Hot';
            }
        }
    }

    private static void populateBillingToShippingAddress(List<Account> accounts, Map<Id, Account> accountMap) {
        for(Account account : accounts) {
            if(account.CopyBillingToShipping__c == true) {
                account.ShippingCity = account.BillingCity;
                account.ShippingCountry = account.BillingCountry;
                account.ShippingPostalCode = account.BillingPostalCode;
                account.ShippingState = account.BillingState;
                account.ShippingStreet = account.BillingStreet;
            }
        }
    }

    private static void createRelatedContactOrOpportunity(List<Account> accounts) {
        for(Account acc : accounts) {
            if(acc.New_Contact__c == true) {
                createRelatedContact(accounts);
            }
            if(acc.New_Opportunity__c == true && acc.Active__c == 'Yes') {
                createRelatedOpportunity(accounts);
            }
        }

    } 
    
    private static void createRelatedOpportunity(List<Account> accounts) {
        AccountTriggerHandlerService.createRelatedOpportunity(accounts);
    }

    private static void createRelatedContact(List<Account> accounts) {
        System.debug('accounts>'+accounts);
        AccountTriggerHandlerService.createRelatedContact(accounts);
    }

    private static void updateDescription(List<Account> accounts, Map<Id, Account> accountMap) {
        for(Account acc : accounts) {
            if(acc.Phone != accountMap.get(acc.Id).Phone) {
                acc.Description = 'Phone is updated! old value : '+accountMap.get(acc.Id).Phone+ 'New value : '+acc.Phone;
            }
        }
    }

    private static void updateOwnerOfContact(List<Account> accounts, Map<Id, Account> accountMap) {
        Map<Id, String> accountIdToOwnerIdMap = new Map<Id, String>();
        for(Account account : accounts) {
            if(account.OwnerId != accountMap.get(account.Id).OwnerId) {
                if(!accountIdToOwnerIdMap.containsKey(account.Id)) {
                    accountIdToOwnerIdMap.put(account.Id, account.OwnerId);
                }
            }
        List<Contact> relatedContactLists = [SELECT Id, AccountId FROM Contact WHERE AccountId =: accountIdToOwnerIdMap.keySet()];
        List<Contact> contactsToUpdateLists = new List<Contact>();
        for(Contact con : relatedContactLists) {
            Contact contact = new Contact();
            contact.Id = con.Id;
            contact.OwnerId = accountIdToOwnerIdMap.get(con.AccountId);
            contactsToUpdateLists.add(contact);
        }
        if(!contactsToUpdateLists.isEmpty()) {
            update contactsToUpdateLists;
        }
        }
    }
//scenario=5
    private static void updateContactMailingAddress(List<Account> accounts, Map<Id, Account> accountMap) {
        Map<Id, Account> idToAccountMap = new Map<Id,Account>();
        for(Account account : accounts) {
            if((account.BillingCity != accountMap.get(account.Id).BillingCity) || (account.BillingCountry != accountMap.get(account.Id).BillingCountry) 
              || (account.BillingState != accountMap.get(account.Id).BillingState) || (account.BillingStreet != accountMap.get(account.Id).BillingStreet) || (
                account.BillingPostalCode != accountMap.get(account.Id).BillingPostalCode )) {
                idToAccountMap.put(account.Id, account);
            }
        }
        List<Contact> contacts = [SELECT Id, AccountId FROM Contact WHERE AccountId =: idToAccountMap.keySet()];
        for(Contact con : contacts) {
            con.MailingCity = idToAccountMap.get(con.AccountId).BillingCity;
            con.MailingCountry = idToAccountMap.get(con.AccountId).BillingCountry;
            con.MailingPostalCode = idToAccountMap.get(con.AccountId).BillingPostalCode;
            con.MailingState = idToAccountMap.get(con.AccountId).BillingState;
            con.MailingStreet = idToAccountMap.get(con.AccountId).BillingStreet;
        }
        update contacts;
    }

    // private static void updateMailingAddress(List<Account> accounts, Map<Id, Account> accountMap) {
    //     Set<Id> accountIds = new Set<Id>();
    //     for(Account account : accounts) {
    //         if((account.BillingCity != accountMap.get(account.Id).BillingCity) || (account.BillingCountry != accountMap.get(account.Id).BillingCountry) 
    //           || (account.BillingState != accountMap.get(account.Id).BillingState) || (account.BillingStreet != accountMap.get(account.Id).BillingStreet) || (
    //             account.BillingPostalCode != accountMap.get(account.Id).BillingPostalCode )) {
    //             accountIds.add(account.Id);
    //         }
    //     }
    //     List<Account> accountLists = [SELECT Id, BillingCity, BillingCountry, BillingState, BillingStreet, BillingPostalCode, (SELECT Id, AccountId, MailingCity, MailingCountry, MailingPostalCode, MailingState, MailingStreet FROM Contacts) FROM Account WHERE Id =: accountIds];
    //     List<Contact> updateContacts = new List<Contact>();
    //     for(Account account: accountList) {
    //         if(account.Contacts != NULL) {
    //             for(Contact contact: account.Contacts) {
    //                 contact.MailingCity = account.BillingCity;
    //                 contact.MailingStreet = account.BillingStreet;
    //                 contact.MailingPostalCode = account.BillingPostalCode;
    //                 contact.MailingState = account.BillingState;
    //                 contact.MailingCountry = account.BillingCountry;
    //                 updateContacts.add(contact);
    //             }
    //         }
    //     }
    //     if(!contacts.isEmpty()) {
    //         update updateContacts;
    //     }
    // }

    //sc=16

    private static void preventIfNoContact(List<Account> accounts, Map<Id, Account> accountMap) {
        List<Case> caseList = [SELECT AccountId FROM Case WHERE AccountId =: accountMap.keySet()];
        Set<Id> accountIds=new Set<Id>();
        for(Case c : caseList) {
            accountIds.add(c.AccountId);
        }
        for(Account account : accounts) {
            if(accountIds.contains(account.id)) {
                account.adderror('Account has Case in  it, you can not delete it.'); 
            }
        }
    }
//scenario=6
    public static void updateContactAddressUsingSOQL(List<Account> accounts, Map<Id,Account> accountMap) {
        Set <Id> accountIds = new Set <Id>();
        List<Contact> contacts = new List<Contact>();
        for(Account acc : accounts) {
            if(accountMap.get(acc.Id).BillingCity != acc.BillingCity || accountMap.get(acc.Id).BillingCountry != acc.BillingCountry
            || accountMap.get(acc.Id).BillingPostalCode != acc.BillingPostalCode ||  accountMap.get(acc.Id).BillingState != acc.BillingState
            || accountMap.get(acc.Id).BillingStreet != acc.BillingStreet) {
                accountIds.add(acc.id);
                System.debug('1');
            }
        }
        List<Account> accountList = [SELECT Id,BillingCity,BillingCountry,BillingPostalCode, BillingState, BillingStreet, (SELECT Id, MailingCity, MailingCountry, MailingPostalCode, MailingState, MailingStreet  FROM Contacts) FROM Account WHERE Id =: accountIds];
        for(Account account: accountList) {
            if(account.Contacts != NULL) {
                for(Contact contact: account.Contacts) {
                    contact.MailingCity = account.BillingCity;
                    contact.MailingStreet = account.BillingStreet;
                    contact.MailingPostalCode = account.BillingPostalCode;
                    contact.MailingState = account.BillingState;
                    contact.MailingCountry = account.BillingCountry;
                    contacts.add(contact);
                }
            }
        }
        if(!contacts.isEmpty()) {
            update contacts;
        }
    }
//scenario=10,11
    private static void preventAccountToUpdate(List<Account> accounts, Map<Id, Account> accountMap) {
        for(Account account : accounts) {
            if(account.CreatedDate <= System.today()-7) {
                 account.addError('You cannot update the record. You can update only after 7 days');
            }
        }
    }
//scenario - 3
    private static void updateHomePhoneOnContact(List<Account> accounts, Map<Id, Account> accountMap) {
        Map<Id, Account> IdToAccountMap = new Map<Id, Account>();
        for(Account account : accounts) {
            if(account.Phone != accountMap.get(account.Id).Phone) {
                IdToAccountMap.put(account.Id, account);
            }
        }

        List<Contact> contactList = [SELECT Id, HomePhone, AccountId FROM Contact WHERE AccountId =: IdToAccountMap.keySet()];
        for(Contact con : contactList) {
            con.HomePhone = IdToAccountMap.get(con.AccountId).Phone;
        }
        update contactList;
    }
//scenario-4
    private static void updateHomePhoneOnContactSOQL(List<Account> accounts, Map<Id, Account> accountMap) {
        Set<Id> accountIds = new Set<Id>();
        for(Account account : accounts) {
            accountIds.add(account.Id);
        }

        List<Account> accountList = [SELECT Id, Phone,(SELECT Id, AccountId, HomePhone FROM Contacts) FROM Account WHERE Id =: accountIds];
        List<Contact> updateContact = new List<Contact>();
        for(Account account : accountList) {
            for(Contact con : account.Contacts) {
                con.HomePhone = account.Phone;
                updateContact.add(con);
            }
        }
        if(!updateContact.isEmpty()) {
            update updateContact;
        }
    }

    //sc=15

    private static void preventFromDeleteIfNoOpp(List<Account> accounts, Map<Id, Account> accountMap ) {
        List<Opportunity> opportunities = [SELECT AccountId FROM Opportunity WHERE AccountId =: accountMap.keySet()];
        Set<Id> accountIds=new Set<Id>();
        for(Opportunity opportunity : opportunities) {
            accountIds.add(opportunity.Accountid);
        }
        for(Account account : accounts)
            if(accountIds.contains(account.id)) {
                account.adderror('Account has opportunity in it, you can not delete it.'); 
                System.debug('ASDFGHJKL'); 
            }
    }
//scenario=9
    private static void preventAccountIfActiveYes(List<Account> accounts) {
        for(Account account : accounts) {
            if(account.Active__c == 'Yes') {
                account.Active__c.addError('You cannot delete account because active status is yes');
            }
        }
    }
//scenario=13
    public static void DeleteAccountBySystemAdministrator(List<Account> accounts) {
        Id profileid = Userinfo.getProfileId();
        Profile profileNames = [SELECT Name FROM Profile WHERE Id =: profileid];
        for(Account account : accounts){
            if(profileNames.Name != 'System Administrator') {
                account.addError('No Access for Deletion');
            }
        }
    }
//scenario=8
    private static void updateOppRelatedToAccount(List<Account> accounts, Map<Id, Account> accountMap) {
        Set<Id> accountIds = new Set<Id>();
        for(Account account : accounts) {
            if(account.Active__c != accountMap.get(account.Id).Active__c && account.Active__c == 'No') {
                accountIds.add(account.Id);
            }
        }

        List<Opportunity> oppLists = [SELECT Id, AccountId, StageName FROM Opportunity WHERE AccountId =: accountIds];
        if(Trigger.isExecuting) {
        for(Opportunity opp : oppLists) {
            if(opp.StageName != 'Closed Won') {
                opp.StageName = 'Closed Lost';
            }
        }
        update oppLists;
       }
    }

    //scenario=31
    private static void createAccountForShare(List<Account> accounts) {
        List<AccountShare> accountSharesToCreate = new List<AccountShare>();
        Id standardUserProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User'].Id;
        Group publicGroup = [SELECT Id FROM Group WHERE DeveloperName = 'Admins'];
        for (Account account : accounts) {
        for (User standardUser : [SELECT Id FROM User WHERE ProfileId = :standardUserProfileId]) {
            AccountShare accountShare = new AccountShare();
            accountShare.AccountId = account.Id;
            accountShare.UserOrGroupId = publicGroup.Id;
            accountShare.RowCause = 'Manual';
            accountShare.AccountAccessLevel = 'Edit';
            accountShare.OpportunityAccessLevel = 'Edit';
            accountSharesToCreate.add(accountShare);
        }
        if (accountSharesToCreate.size() > 0) {
            insert accountSharesToCreate;
        }
    }
    }
}