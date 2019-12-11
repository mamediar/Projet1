public class ConfirmLotReceiptController {
    @AuraEnabled
    public static SFALotto__c[] setLotData(){
        List<SFALotto__c> res= [	select OCSLottoId__c,LotBarcode__c,Status__c,DateReceivedIDM__c,CaseId__c
                                    from SFALotto__c
                                    where Status__c='3' /*and CaseId__r.OwnerId=:idmid*/ ];
        return res;
    }

    @AuraEnabled
    public static SFALotto__c receiveLot(SFALotto__c lot){
        return SFALottoUtils.receiveLot(lot);
    }
    
    @AuraEnabled
    public static String generateURL(String filter){
        String res='/apex/ConfirmLotReceiptEXCEL?filter='+filter;
        
        return res;
    }
    
    @AuraEnabled
    public static void closeCase(){
        CaseUtils.closeCase([select Id from Case where ActivityType__c='CONLOTREC' and Status='New'].Id);
    }
}