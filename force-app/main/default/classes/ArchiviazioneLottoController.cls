public class ArchiviazioneLottoController {
    @AuraEnabled
    public static GenericElement selectContracts(String data, String caseID, String attachmentType){
        GenericElement res = new GenericElement();
        Boolean isAccollo = (attachmentType.equalsIgnoreCase('Accollo'));
        if(String.isNotBlank(data)){
            String lottoID = [SELECT OCSLottoId__c
                              FROM Case
                              WHERE Id =: caseID].OCSLottoId__c;           
            Contract[] tempContracts = [SELECT Id, ContractNumber__c,OCSLottoId__c,Status,SFALotto__c,Barcode__c
                                               FROM Contract 
                                               WHERE Barcode__c =: data
                                               AND isAccollo__c =: isAccollo];                        
            if(tempContracts.isEmpty()){
                res.contratto = null;
                res.statusMessage = 'error';
                res.message = (isAccollo)?'L\'Accollo non è presente in nessun lotto.':
                						  'Il codice contratto non è presente in nessun lotto.'; 
            }else if(tempContracts[0].OCSLottoId__c == lottoID){
                res.contratto = null;
                res.statusMessage = 'warning';
                res.message = (isAccollo)?'L\'Accollo è già presente in questo lotto.':
                						  'Il codice contratto è già presente in questo lotto.';
            }else{
                String tempLottoStatus = [SELECT Id, SFALotto__r.Status__c 
                                          FROM Contract
                                          WHERE Id =: tempContracts[0].Id].SFALotto__r.Status__c;
                if(tempLottoStatus == '2'){
                    res.contratto = null;                
                    res.statusMessage = 'warning';
                    res.message   = (isAccollo)?'L\'Accollo è già presente in un lotto che è in attesa di spedizione':
                    							'Il codice contratto è già presente in un lotto che è in attesa di spedizione';
                }else res.contratto = tempContracts[0];
            }                        
            return res;
        }
        return res;
    }

    public class GenericElement{
        @AuraEnabled
        public Contract contratto  {get; set;}
        @AuraEnabled
        public String message {get; set;}
        @AuraEnabled
        public String statusMessage {get; set;}
    }     
}