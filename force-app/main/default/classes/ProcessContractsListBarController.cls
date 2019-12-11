public class ProcessContractsListBarController 
{
    @AuraEnabled
    public static Contract[] returnContracts (String lottoId){
       	System.debug(lottoId);
        List<Contract> res= [SELECT Id, Status, FlagAccollo__c,q_contract__c,q_sign__c,q_folder__c, ContractNumber__c, Procedure__c, SFALotto__c , Barcode__c , WorkStatus__c ,q_allyes__c,IconFormula__c
                             FROM Contract
                             WHERE SFALotto__c = :lottoId
                            ];
        return res;
    }
    /*
     @AuraEnabled
    public static ProcessContractResult getInfo(String lottoId)
    {
        ProcessContractResult res = new ProcessContractResult();
        res.contratti = returnContracts(lottoId);
        
        
        
        
        return res;
    }
    public static list<Integer> returnContractsFromProcessed (String lottoId){
       	System.debug(lottoId);
        List<Aggregate> res = [SELECT WorkStatus__c,COUNT(ID) conto FROM Contract where SFALotto__c ='a030Q000001W1hOQAS' GROUP BY ROLLUP(WorkStatus__c)];
        
        
        
        return res;
    }
    
    public class ProcessContractResult
    {
        @AuraEnabled
        List<Contract> contratti {get;set;}
        @AuraEnabled
        Integer totaleContratti {get;set;}
        @AuraEnabled    
        Integer totaleContrattiProcessati {get;set;} 
    }
    
    */
}