public class RitiroContrattiPerDealerController {
    @AuraEnabled
    public static Map<String,String> getInfo(String caseId){
        Map<String,String> res=new Map<String,String>();
        String p=[select count()
                  from Contract
                  where Case__c=:caseId and WorkStatus__c='403'].format();
        String n=[select count()
                  from Contract
                  where Case__c=:caseId].format();
        Case c=[select Account.Name,Note__c
                from case
                where id=:caseId][0];
        res.put('dealer',c.Account.Name);
        res.put('notes',c.Note__c);
        res.put('p',p);
        res.put('n',n);
        return res;
    }
    
    @AuraEnabled
    public static Boolean closeCase(String caseId){
        CaseUtils.closeCase(caseId);
        return (CaseUtils.checkStatus(caseId,'Closed'));
    }
    
    @AuraEnabled
    public static Boolean checkIfClosed(String caseId){
        return (CaseUtils.checkStatus(caseId,'Closed'));
    }
    
    @AuraEnabled
    public static void ritiraContratto(Contract c){
        ContractUtils.ritiraContratto(c);
    }
    
    @AuraEnabled
    public static void writeNotes(String caseId,String notes){
        CaseUtils.writeNotes(caseId,notes);
    }
    
    @AuraEnabled
    public static List<ContractResult> cambioStatoDocumenti(List<String> cListIds){
        List<Contract> contracts=[	select Id,Procedure__c,ContractNumber__c,WorkStatus__c
                                  from Contract
                                  where Id in :cListIds];
        List<ContractResult> dList=OCSRientroDocumentiPraticaInvoker.cambioStatoDocumenti(contracts);
        for(ContractResult cr:dList){
            if(cr.isOk()){
                Contract c;
                for(Contract temp:contracts){
                    if(temp.Id==cr.contract.Id){
                        c=temp;
                        break;
                    }
                }
                ContractUtils.ritiraContratto(c);
            }
        }
        return dList;
    }
}