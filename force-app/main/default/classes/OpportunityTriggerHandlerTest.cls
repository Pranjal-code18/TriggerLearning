@isTest
public class OpportunityTriggerHandlerTest {
   @isTest
   public static void updateOpportunityDescriptionTest() {
    List<Opportunity> opportunities = new List<Opportunity>();
    for(Integer i =1 ; i<=5 ; i++) {
        Opportunity opp = new Opportunity();
        opp.Name = 'Oppo'+i;
        opp.Amount = 200000;
        opp.StageName = 'Prospecting';
        opp.CloseDate = System.today();
        opportunities.add(opp);
    }
    Test.startTest();
    insert opportunities;
    Test.stopTest();

    List<Opportunity> updateOpp = [SELECT Id, Description FROM Opportunity WHERE Id =: opportunities[0].Id];
    System.assertEquals('Hot Opportunity', updateOpp[0].Description);
   }

   @isTest
   public static void updateDesBasedOnStageInsertTest() {
    List<Opportunity> oppList = new List<Opportunity>();
    for(Integer i=1 ; i<=5 ; i++) {
        Opportunity opp = new Opportunity();
        opp.Name = 'opportunity' +i;
        opp.Amount = 2000;
        opp.StageName = 'Closed Lost';
        opp.CloseDate = System.today();
        oppList.add(opp);
    }
    List<Opportunity> opplistss = new List<Opportunity>();
    for(Integer i=1 ; i<=5 ; i++) {
        Opportunity opp = new Opportunity();
        opp.Name = 'opportunity' +i;
        opp.Amount = 2000;
        opp.StageName = 'Prospecting';
        opp.CloseDate = System.today();
        opplistss.add(opp);
    }
    
    Test.startTest();
    insert oppList;
    insert opplistss;
    Test.stopTest();

    List<Opportunity> oppunities = [SELECT Id, Description FROM Opportunity WHERE Id =: oppList[0].Id];
    System.assertEquals('Opportunity is Closed Lost', oppunities[0].Description);
    List<Opportunity> oppLists = [SELECT Id, Description FROM Opportunity WHERE Id =: opplistss[0].Id];
    System.assertEquals('Opportunity is open', oppLists[0].Description);
   }

   @isTest
   public static void updateDesBasedOnStageUpdateTest() {
    List<Opportunity> oppList = new List<Opportunity>();
    for(Integer i=1 ; i<=5 ; i++) {
        Opportunity opp = new Opportunity();
        opp.Name = 'opportunity' +i;
        opp.Amount = 2000;
        opp.StageName = 'Closed Lost';
        opp.CloseDate = System.today();
        oppList.add(opp);
    }
    
    Test.startTest();
    insert oppList;
    for(Opportunity opp : oppList) {
        opp.StageName = 'Prospecting';
    }
    update oppList;
    Test.stopTest();

    List<Opportunity> oppLists = [SELECT Id, Description FROM Opportunity WHERE Id =: oppList[0].Id];
    System.assertEquals('Opportunity is open', oppLists[0].Description);
   }

   @isTest
   public static void taskTest() {
    List<Opportunity> oppList = new List<Opportunity>();
    for(Integer i=1 ; i<=5 ; i++) {
        Opportunity opp = new Opportunity();
        opp.Name = 'opportunity' +i;
        opp.Amount = 2000;
        opp.StageName = 'Closed Lost';
        opp.CloseDate = System.today();
        oppList.add(opp);
    }
    
    Test.startTest();
    insert oppList;
    for(Opportunity opp : oppList) {
        opp.StageName = 'Qualification';
    }
    update oppList;
    Test.stopTest();

    List<Task> taskList = [SELECT Id FROM Task WHERE WhatId =: oppList[0].Id];
    System.assertEquals(1, taskList.size());
   }
}