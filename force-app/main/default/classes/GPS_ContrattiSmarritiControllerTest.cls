@isTest
public class GPS_ContrattiSmarritiControllerTest {
    
    public class CaseInfo{
        @InvocableVariable(required = true label = 'Categoria External Id')
        public String CategoriaExternalId;
        @InvocableVariable(required = true)
        public String sourceId;
        @InvocableVariable(required = true)
        public String recordTypeDeveloperName;
        @InvocableVariable(required = true)
        public String subject;
        @InvocableVariable(required = true label = 'Developer Name Owner')
        public String ownerDeveloperName;
    }
    
    @isTest
    public static void copyFilesToNewCaseTest(){
        Account tempAccount = new Account(
            Name = 'Filiale Test',
            FiscalCode__c = 'DNTLNDXXXXXXXXXX',
            Birthcity__c = 'MI',
            //Provincia_Nascita__pc = 'MI',
            Data_Nascita__c = Date.today()
            //PersonMailingCity = 'MI'
        );
        insert tempAccount;
        
        XCS_Categoria__c cat = new XCS_Categoria__c(
        	Name = 'Archive Lost Contract',
            External_Id__c = 'AT0063'
        );
        
        insert cat;
        
        List<Contract> tempContractList = new List<Contract>();
        for(Integer i = 0; i < 8; i++)
            tempContractList.add(new Contract(
                AccountId = tempAccount.Id,
                ContractNumber__c = '000XXXXXXXXX'
            ));
        insert tempContractList;
        
        Case tempCase = new Case();
        insert tempCase;
        
        System.assert(CompassUtils.attachFile(CompassUtils.fileNewInstance('/apex/GestionePraticheSmarritePDFSingolo', tempCase.Id, 'fileTest', 'pdf'), tempCase.Id));
        System.debug(CompassUtils.isThereAttach(tempCase.Id));
        
        List<GPS_ContrattiSmarritiController.CaseInfo> tempCaseInfoList = new List<GPS_ContrattiSmarritiController.CaseInfo>();
        
        GPS_ContrattiSmarritiController.CaseInfo tempCaseInfo = new GPS_ContrattiSmarritiController.CaseInfo();
        tempCaseInfo.CategoriaExternalId = 'AT0063';
        tempCaseInfo.sourceId = tempCase.Id;
        tempCaseInfo.recordTypeDeveloperName = 'SFA_Archiviazione_Lotti_Archive_Lost_Contracts';  
        tempCaseInfo.subject = 'Archive Lost Contracts';
        tempCaseInfo.ownerDeveloperName = 'IDM2';
        tempCaseInfoList.add(tempCaseInfo);
        
        GPS_ContrattiSmarritiController.copyFilesToNewCase(tempCaseInfoList);
        //System.debug(tempCaseInfo.Id);
    }
}