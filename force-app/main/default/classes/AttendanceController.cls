public class AttendanceController {
    
        @AuraEnabled
        public static List<Attendance__c> createRecord(String currentUserId){
         List<Attendance__c> attendanceRecord = new List<Attendance__c>();
         List<Attendance__c> getAttendanceRecords = [SELECT Id, EmployeeName__c, CreatedDate,Date_and_Time_IN__c  FROM Attendance__c WHERE EmployeeName__c=: currentUserId AND CreatedDate=TODAY];
        System.debug('record.size()>'+getAttendanceRecords.size());
         try {
               if(getAttendanceRecords.size()==0){ 
                 Datetime now = Datetime.now();
                 Attendance__c attendance = new Attendance__c();
                 attendance.Date_and_Time_IN__c = now;
                 attendance.EmployeeName__c = currentUserId;
                 attendanceRecord.add(attendance);
                 if(!attendanceRecord.isEmpty()) {
                     insert attendanceRecord;
                     System.debug(attendanceRecord);
                 }
               }
               else{
                     ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error Message');
                     ApexPages.addMessage(myMsg);
                 }
              return attendanceRecord;
             
         } catch (Exception e) {
             throw new AuraHandledException(e.getMessage());
         }
        }
     
       @AuraEnabled
       public static List<Attendance__c> updateAttendanceRecord(String currentUserId){
         try {
           Datetime now = Datetime.now();
            List<Attendance__c> getAttendanceRecords = [SELECT Id,EmployeeName__c,Date_and_Time_OUT__c, Date_and_Time_IN__c FROM Attendance__c WHERE EmployeeName__c =:currentUserId AND CreatedDate = TODAY];
             Attendance__c attendance = new Attendance__c();
             attendance.Id = getAttendanceRecords[0].Id;
             attendance.Date_and_Time_OUT__c = now;
             attendance.EmployeeName__c = currentUserId;
             getAttendanceRecords.add(attendance);
             update attendance;
             return getAttendanceRecords;
         } catch (Exception e) {
             throw new AuraHandledException(e.getMessage());
         }
       }
     
       @AuraEnabled
       public static List<demo> getDetails(String currentUserId){
         List<demo> demos = new List<demo>();
         List<Attendance__c> punchInRecords = [SELECT Date_and_Time_IN__c,EmployeeName__c, CreatedDate,Date_and_Time_OUT__c  FROM Attendance__c WHERE EmployeeName__c =:currentUserId Order by CreatedDate DESC LIMIT 2];
         System.debug('punchInRecords'+punchInRecords);
         try {
             for(Attendance__c attendance : punchInRecords) {
               demo wrap = new demo();
               wrap.punchIn = string.valueof(attendance.Date_and_Time_IN__c);
               wrap.punchOut = string.valueof(attendance.Date_and_Time_OUT__c);
               demos.add(wrap);
             }
             if(!punchInRecords.isEmpty()){
              }
              System.debug('demos'+demos);
             return demos;
         } catch (Exception e) {
             throw new AuraHandledException(e.getMessage());
         }
       }
       public class demo{
         @AuraEnabled public string punchIn{get;set;}
         @AuraEnabled public string punchOut{get;set;}
       }
         @AuraEnabled
         public static Time checkTimeValidity(String currentUserId){
           try {
             List<Attendance__c> records = [SELECT Date_and_Time_OUT__c,EmployeeName__c, CreatedDate,Date_and_Time_IN__c FROM Attendance__c WHERE EmployeeName__c =:currentUserId AND CreatedDate = TODAY];
             return records[0].Date_and_Time_IN__c.time();
           } catch (Exception e) {
             throw new AuraHandledException(e.getMessage());
           }
         }
         @AuraEnabled(cacheable = true)
         public static String getCustomSettings(){
           try {
             BlockAttendanceCreation__c timePunchIN = BlockAttendanceCreation__c.getInstance();
             return timePunchIN.Fixed_PunchIn_time__c;
           } catch (Exception e) {
             throw new AuraHandledException(e.getMessage());
           }
         }

         @AuraEnabled(cacheable = true)
         public static List<Attendance__c> fetchContactsByUserId(String userId) {
          System.debug('Inside attendance controller');
          try {
            List<Attendance__c> att = [SELECT Id,EmployeeName__c,Date_and_Time_OUT__c, Date_and_Time_IN__c, Total_Worked_Hours__c, CreatedById FROM Attendance__c WHERE EmployeeName__c =: userId LIMIT 10];
            System.debug(att);
            return [SELECT Id,EmployeeName__c,Date_and_Time_OUT__c, Date_and_Time_IN__c, Total_Worked_Hours__c, CreatedById FROM Attendance__c WHERE EmployeeName__c =: userId LIMIT 10];
            
          } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
          }
         }
     
}