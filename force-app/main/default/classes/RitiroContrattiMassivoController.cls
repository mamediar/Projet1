public class RitiroContrattiMassivoController {
    @AuraEnabled
    public static List<Contract> getContracts(){
        List<Contract> contracts=[	select Id,Barcode__c,WorkStatus__c,ContractNumber__c,Procedure__c, AccountId
                                  from Contract 
                                  where Case__r.ActivityType__c='RITCON'
                                  and Case__r.Status='New'];
        
        System.debug('contracts: '+contracts);
        
        return contracts;
    }
    
    @AuraEnabled
    public static ContractResult checkContract(String barcode,List<Contract> contracts){
        ContractResult res=null;
        Contract c=null;
        for(Integer i=0;i<contracts.size();i++){
            if(contracts.get(i).Barcode__c.equals(barcode)){
                c=contracts.get(i);
                break;
            }
        }
        if(c!=null){
            res=updateContractDocuments(c);
            if(res.isOk()){
                ContractUtils.ritiraContratto(c);
                if([select Id from Contract where Case__c=:c.Case__c and WorkStatus__c='402'].size()==0){
                    CaseUtils.closeCase(c.Case__c);
                }
            }
            
        }
        return res;
    }
    
    @AuraEnabled
    public static ContractResult updateContractDocuments(Contract c){
        return OCSRientroDocumentiPraticaInvoker.cambioStatoDocumenti(c);
    }
}