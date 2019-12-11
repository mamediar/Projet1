public class GestionePraticheSmarriteSGController {
    //private static List<Contract> selectedContracts = new List<Contract>();
    //private static Cache.SessionPartition sessionPart = Cache.Session.getPartition('local.part1');
    
    @AuraEnabled
    public static List<Contract> selectContract(){
        List<Contract> res = new List<Contract>();
        try {
            res = [SELECT Id,DataSmarrimento__c,LostDays__c,OCSLottoId__c,ContractNumber,ContractNumber__c,isAccollo__c,StartDate,AccountName__c,AccountFiscalCode__c,AccountBirthdate__c,AccountBirthcity__c,AccountBirthprovince__c,AccountCity__c,AccountProvince__c,ProductType__c,Procedure__c
                   FROM Contract
                   WHERE WorkStatus__c in ('3', '404') AND isAccollo__c = false];
        } catch(Exception e){
            System.debug('Errore nel metodo \'selectContract\' della classe apex \'GestionePraticheSmarriteSGController\'');
            return res;
        }
        return res;
    }
    
    @AuraEnabled
    public static ConcatUrlAndContract generatePDF(List<Contract> reportedContracts){
        String urlAttach = null;
       	ConcatUrlAndContract cuac = new ConcatUrlAndContract();
        if(!reportedContracts.isEmpty()) {
            urlAttach = '';
            List<Contract> contractsOk = new List<Contract>();
            List<Contract> contractsKO = new List<Contract>();
            OCSCambioStatoFilterList response = OCSCambioStatoPraticaInvoker.multiInvoke(reportedContracts, 'D');
            System.debug(response.listaOk);
            for(ContractResult cr : response.listaKO) {
                    contractsKO.add(cr.contract);
                }
            cuac.ContractKO = contractsKO ;
            System.debug('CONTRATTO KO' + contractsKO);
            if(!response.listaOk.isEmpty()) {
                for(ContractResult c : response.listaOk) {
                    contractsOk.add(c.contract);
                }
                urlAttach = generatePDFPreviewURL(contractsOk,'false','');
                // CompassUtils.attachFile(CompassUtils.fileNewInstance(urlAttach, caseId, 'Rapporto', 'pdf'), caseId);
                denounceContracts(contractsOk);
                //sessionPart.put('selC', selectedContracts);  
            }
            cuac.Url = urlAttach;
            cuac.ContractOK = contractsOK ;
        }
        return cuac;
    }
    
    public class ConcatUrlAndContract
    {
 		@AuraEnabled
        public String Url {get; set;}
        @AuraEnabled
        public List<Contract> ContractKO {get; set;}
        @AuraEnabled
        public List<Contract> ContractOK {get; set;}
    }
 
    public static Boolean denounceContracts(List<Contract> contractsToDenounce){
        //System.debug((List<Contract>)sessionPart.get('selC'));
        Boolean res = false;
        if(!contractsToDenounce.isEmpty()) {
            for(Contract c : contractsToDenounce) {
                //if(!((List<Contract>)sessionPart.get('selC')).contains(c)) return res;
                c.WorkStatus__c = '4';
            }
            update contractsToDenounce;
            res = true;
        }
        return res;
    }
   
    @AuraEnabled
    public static String generatePDFPreviewURL(List<Contract> contractList, String isPreview , String uniqCode ){
        String res = '';
        //String branch = [SELECT Id, Account.Name FROM Case WHERE Id =: caseId].Account.Name;
        if(!contractList.isEmpty()) {
            res = '/apex/GestionePraticheSmarritePDF'+ (contractList.size() > 1 ? 'Multi' : 'Singolo') +'?contractIds=';
            for(Contract c : contractList) res += c.Id + ',';
            res = res.substring(0, res.length() - 1);
        }
        if(isPreview.equalsIgnoreCase('true'))
        {
            res = res + '&' + uniqCode ;
        }
        return res;
    }
     	@AuraEnabled
    	public static String caseGetInstance(List<Contract> contractList)
        {
            Boolean res = false;
        	String uniqCode = '';
        	if(!contractList.isEmpty()) 
            {
              	//String recordTypeId = [SELECT Id  FROM RecordType  WHERE DeveloperName = 'SFA_Archiviazione_Lotti_Pratiche_Smarrite_Contratti_Smarriti'].Id;
                String recordTypeId = [SELECT Id  FROM RecordType  WHERE DeveloperName = 'SFA_Archiviazione_Lotti'].Id;
                String SGID = GroupUtils.getQueue('SERVIZI_GENERALI').Id;
                // Inizializzo il Caso.
                List<AggregateResult> Numero = [SELECT Count(Id)conto FROM Case where CreatedDate = TODAY and Categoria_riferimento__r.External_Id__c= 'AT0020' Group By Categoria_riferimento__r.External_Id__c];
                DateTime data = Date.today();
                Integer intero = 1;    
                if(Numero.size() > 0)
           		{intero += (Integer)Numero[0].get('conto');}    
                uniqCode = data.format('yyyyMMdd') + '-' + intero;
				system.debug('-----------' + uniqCode);    
               	Case instanceCase = new Case(CodiceDenuncia__c = uniqCode, recordTypeId = recordTypeId, Categoria_riferimento__r = new XCS_Categoria__c(External_Id__c = 'AT0020'), Subject = 'Contratti Smarriti', OwnerId = SGID) ;
                system.debug(instanceCase);
                insert instanceCase;
                for(Contract c : contractList) c.Case__c = instanceCase.Id;
           	    update contractList;
                res = true;  
       		}
            System.debug('*** uniqCode :: ' + uniqCode);
            return uniqCode;   
		}
}