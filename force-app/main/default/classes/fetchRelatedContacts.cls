public class fetchRelatedContacts {
    @AuraEnabled(cacheable = true)
    public static List<Contact> fetchContactsByReportingManager(String userId) {
        System.debug('userId>'+userId);
        try {
            List<Contact> con = new List<Contact>();
            con =  [SELECT ID, Name , LastName, FirstName, Email, Phone FROM Contact WHERE Reporting_Manager__c =: userId];
            return con;
        }
         catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }   
    }
}