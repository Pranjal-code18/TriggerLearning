public class OpportunityTriggerHandler {
    public static void beforeInsert(List<Opportunity> opportunities) {
        updateDescriptionBasedOnAmount(opportunities);
    }

    public static void beforeUpdate(List<Opportunity> opportunities, Map<Id, Opportunity> opportunityMap) {
        updateDescription(opportunities, opportunityMap);
        updateStageToClosedLost(opportunities, opportunityMap);
    }

    public static void beforeDelete(List<Opportunity> opportunities) {
        OpportunityDeleteBySystemAdminstrator(opportunities);
    }

    public static void afterInsert(List<Opportunity> opportunities) {
        updateAccountLatestAmountField(opportunities);
        updateTotalAmountOnAnnualRevenue(opportunities, NULL);
        updateAccountAnnualRevenue(opportunities);
    }

    public static void afterUpdate(List<Opportunity> opportunities, Map<Id, Opportunity> opportunityMap) {
        createTaskOnOpportunity(opportunities, opportunityMap);
    }

    public static void afterDelete(List<Opportunity> opportunities) {
        updateAccountAnnualRevenue(opportunities);
    }

    public static void afterUndelete(List<Opportunity> opportunities) {
        updateAccountAnnualRevenue(opportunities);
    }

    private static void updateDescriptionBasedOnAmount(List<Opportunity> opportunities) {
        for(Opportunity opp : opportunities) {
            if(opp.Amount != NULL && opp.Amount > 100000) {
                opp.Description = 'Hot Opportunity';
            }
        }
    }

    private static void updateAccountLatestAmountField(List<Opportunity> opportunities) {
        OpportunityTriggerHandlerService.updateAccountLatestAmountField(opportunities);
    }

    //sc=12
    public static void updateStageToClosedLost(List<Opportunity> opportunities, Map<Id,Opportunity> opportunityMap ) {
        for(Opportunity opportunity : opportunities) {
            if(opportunity.StageName == 'Closed Lost' && opportunity.StageName != opportunityMap.get(opportunity.Id).StageName && opportunity.Closed_Lost_Reason__c == NULL) {
                opportunity.Closed_Lost_Reason__c.addError('Please populate Closed Lost Reason');
            }
        }
    }
    //sc=2,26
    private static void updateDescription(List<Opportunity> opportunities, Map<Id, Opportunity> opportunityMap) {
        for(Opportunity opp : opportunities) {
            if(opp.StageName != opportunityMap.get(opp.Id).StageName && (opp.StageName == 'Closed Won' || opp.StageName == 'Closed Lost')) {
                opp.Description = 'Opportunity is '+opp.StageName;
            }
            else {
                opp.Description = 'Opportunity is open';
            }
        }
    }

    private static void updateTotalAmountOnAnnualRevenue(List<Opportunity> opportunities, Map<Id, Opportunity> opportunityMap) {
        System.debug('opportunities'+opportunities);
        Set<Id> accountIds = new Set<Id>();
        for(Opportunity opp : opportunities) {
            accountIds.add(opp.AccountId);
        }
         
        OpportunityTriggerHandlerService.updateTotalAmountOnAnnualRevenue(accountIds);
    }
//scenario=7
    public static void createTaskOnOpportunity(List<Opportunity> opportunities, Map<Id, Opportunity> opportunityMap) {
        List<Task> taskToInsert = new list<Task>();
        for(Opportunity opp : opportunities) {
            Task tasks = new Task();
            tasks.whatId = opp.Id;
            if(opp.StageName == 'Prospecting') {
                tasks.subject = 'Prospecting';
            }
            else if(opp.StageName == 'Qualification') {
                tasks.subject = 'Qualification';
            }
            else  if(opp.StageName == 'Needs Analysis') {
                tasks.subject = 'Needs Analysis';
            }
            else if(opp.StageName == 'Closed Won') {
                tasks.subject = 'Closed Won';
            }
            else if(opp.StageName == 'Closed Lost') {
                tasks.subject = 'Closed Lost';
            }
            taskToInsert.add(tasks);
        }
        if(!taskToInsert.isEmpty())
            insert taskToInsert ;
    }
//sc=23
    public static void updateAccountAnnualRevenue(List<Opportunity> Opportunities){
        Set<Id> accountIds = new Set<Id>();
        for(Opportunity opportunity :Opportunities){
            if(opportunity.AccountId != NULL){
                accountIds.add(opportunity.AccountId);
            }
        }
        OpportunityTriggerHandlerService.updateAccountAnnualRevenue(accountIds);
    }

    //sc=14

    private static void OpportunityDeleteBySystemAdminstrator(List<Opportunity> opportunities) {
        Id profileId = UserInfo.getProfileId();
        Profile profileName = [SELECT Name,Id FROM Profile WHERE Id =: profileid LIMIT 1];
        for(Opportunity opportunity : opportunities) {
            if((opportunity.StageName == 'Closed Won' || opportunity.StageName == 'Closed Lost') && profileName.Name != 'System Administrator') {
                 opportunity.addError('No Access for Deletion');
            }
        }
    }
}