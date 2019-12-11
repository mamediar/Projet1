public class ProcessContractsBarcodeController {
    @AuraEnabled
    public static SFALotto__c[] returnSfalottiRelatedToCase (){
        List<SFALotto__c> res= [	select Id,OCSLottoId__c,LotBarcode__c,BranchId__c,account__c,CaseId__c
                                   	from SFALotto__c
                                  	where Status__c = '4' ];
        system.debug(res);
        return res;
    }
}