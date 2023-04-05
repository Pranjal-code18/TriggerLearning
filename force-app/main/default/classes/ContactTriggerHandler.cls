public class ContactTriggerHandler {
    public static void afterInsert(List<Contact> contacts) {
        sentEmail(contacts);
    }

    public static void beforeInsert(List<Contact> contacts) {
        preventFromDuplicateEmails(contacts);
    }
//scenario=21
    private static void sentEmail(List<Contact> contacts) {
            List<Messaging.Email> emailLists = new List<Messaging.Email>();
            for(Contact con : contacts) {
                if(con.Email != NULL) {
                Messaging.SingleEmailMessage emailMsg = new Messaging.SingleEmailMessage();
                String[] toAddress = new String[]{con.Email};
                emailMsg.setToAddresses(toAddress);
                String subject = 'Welcome to Metadologie' +con.FirstName;
                emailMsg.setSubject(subject);
                String disName = 'Pranjal Bansal';
                emailMsg.setSenderDisplayName(disName);
                String content = 'Hi welcome to my team';
                emailMsg.setHtmlBody(content);
                emailLists.add(emailMsg);
                }
            }
            Messaging.sendEmail(emailLists);
    }
    //sc=30
    private static void preventFromDuplicateEmails(List<Contact> contacts) {
        System.debug('contacts+'+contacts);
        List<Contact> Emails = [SELECT Email FROM Contact];
        System.debug('Emails'+Emails);
        Set<String> allEmails = new Set<String>();
        for(Contact con : Emails) {
            allEmails.add(con.Email);
        }
        System.debug('allEmails'+allEmails);
        for(Contact con : contacts) {
            System.debug('con.Email'+con.Email);
            if(con.Email != NULL) {
                System.debug('Emails.contains(con.Email)'+allEmails.contains(con.Email));
                if(allEmails.contains(con.Email)) {
                    con.Email.addError('Email is duplicate');
                }
            }
        }
    }   
}