public class PositionTriggerHelper {
    public static void beforeInsert(List<Position__c> positions) {
        populateValuesInField(positions);
    }

    private static void populateValuesInField(List<Position__c> positions) {
        for(Position__c position : positions) {
            if(position.Open_Date__c == NULL && position.Min_Pay__c == NULL && position.Max_Pay__c == NULL) {
                position.Open_Date__c = System.today();
                position.Min_Pay__c = 10000;
                position.Max_Pay__c = 15000;
            }
        }
    }
}