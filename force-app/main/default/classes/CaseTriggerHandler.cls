public class CaseTriggerHandler {
    public static void afterInsert(List<Case> cases) {
        CaseTriggerHandlerService.populateCaseNumberOnAccount(cases);
        CaseTriggerHandlerService.populateTotalPartnerAndCustomerCase(cases);
    }
}