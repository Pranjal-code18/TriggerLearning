public class AccountService {
    public static void updateOpportunityStageName(Set<Id> accountIds) {
        List<Opportunity> opportunities = [SELECT AccountId, CloseDate, Name, StageName FROM Opportunity WHERE AccountId =: accountIds AND StageName != 'Closed Won'];
        if(OpportunityService.handleRecursion) {
            for(Opportunity opportunity : opportunities) { 
                opportunity.StageName = 'Closed won'; 
            }
            if(!opportunities.isEmpty()){
                update opportunities;
                System.debug('opp>'+opportunities);
            }
        }
    }

    public static void updateRating(Set<Id> accountIds) {
        System.debug('inservice'+accountIds);
        for(Account account : [SELECT Id, Rating, Industry FROM Account WHERE Id =: accountIds]) {
            if(account.Industry == 'Media' || account.Industry == 'Energy') {
                account.Rating = 'Hot';
            }
        }
    }
}