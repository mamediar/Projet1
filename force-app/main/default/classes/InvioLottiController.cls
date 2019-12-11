public class InvioLottiController {
    @AuraEnabled
    public static SFALotto__c[] setTableLotData(String caseId){
        List<SFALotto__c> res= [	select OCSLottoId__c,LotBarcode__c 
                                   	from SFALotto__c
                                  	where CaseId__c=:caseId ];
        return res;
    }
}