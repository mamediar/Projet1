public class XCS_CaseListComponentControllerApex {
    
    @AuraEnabled
    public static List<Case> doInitApex(String caseId, String caseStatus){
        Case currentCase= [SELECT AccountId FROM Case WHERE Id=: caseId];
        if(String.isNotBlank(currentCase.AccountId)){
            return [SELECT AccountId, Categoria_Rif_Parent__c, Esito__c, CaseNumber, Id, Status, CreatedDate, Categoria_Riferimento__r.Name,Subject FROM Case WHERE AccountId=: currentCase.AccountId AND Status=: caseStatus ORDER BY CreatedDate DESC];
        }
        else{
            return new List<Case>();
        }
    }
}