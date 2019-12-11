public with sharing class GestionePraticheSmarritePDFController {
    
    public List<Contract> contractList {get;set;}
    public String uniqCode {get;set;}
    //public String branch {get; set;}
    
    public GestionePraticheSmarritePDFController(){}
    
    public void init(){
        contractList = new List<Contract>();
        //branch = ApexPages.currentPage().getParameters().get('branch');
        String idscsv = ApexPages.currentPage().getParameters().get('contractIds');        
        String[] ids = idscsv.split(',');
        selectContracts(ids);
        uniqCode = ApexPages.currentPage().getParameters().get('uniqCode');
        /*if(String.isBlank(uniqCode)){
        //    List<AggregateResult> Numero = [SELECT Count(Id)conto FROM Case where CreatedDate = TODAY and ActivityType__c = 'CONSMA' Group By ActivityType__c];
        //   DateTime data = Date.today();
        //    Integer intero =  1;
        //    if(Numero.size() > 0)
        //    {
        //        intero += (Integer)Numero[0].get('conto');
       //     }
       //     uniqCode = data.format('yyyyMMdd') + '-' + intero;
       // }*/
        
        //String tempUrl = ApexPages.currentPage().getUrl();
    }

    private void selectContracts(String[] ids){
        for(String i : ids) if(i.left(3) != '800') return;        
        Contract[] tempList = [SELECT Id, ContractNumber__c, AccountName__c, AccountFiscalCode__c, AccountBirthcity__c, AccountProvince__c, AccountBirthdate__c, AccountCity__c 
                              FROM Contract
                              WHERE Id in :ids];
        contractList.addAll(tempList);
    }
}