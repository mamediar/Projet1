@IsTest
public class SFAConvenzGestioneAccollo_IDM_TEST {
	@testSetup
    static void setup() {
        
        TEST_DataFactory_Convenzionamento.SetupAccolli();
  
    }
    
    @IsTest 
    static void TEST_AccIDM_1() {
        
        Account Acc = [Select  Id from Account where  OCS_External_Id__c = 'D123460'];
        case CaseAccollo = [select Id, status,subject from case where accountId=:Acc.id]; 
        Dossier__c Accollo =[SELECT Id, Name, DataRiferimento__c, IdAttivita__r.AccountId  FROM Dossier__c where IdAttivita__c=:CaseAccollo.Id];
       // SFADossierDocumento__c DossDoc =[SELECT Id, Name  FROM SFADossierDocumento__c where Dossier__c=:Accollo.Id];
        test.startTest();
       		SFAConvenzionamento2IDMAccolloCtrller.Dati DatiDoInit = SFAConvenzionamento2IDMAccolloCtrller.getDati(String.valueOf(Accollo.Id));
        	system.debug('IDM_TEST_DatiDoInit: '+DatiDoInit);
        	SFAConvenzionamento2IDMAccolloCtrller.assignToFiliale(String.valueOf(CaseAccollo.Id), String.valueOf(Accollo.Id), 'TEST_IDM1');
        test.stopTest();   
    }
    
    
    @IsTest 
    static void TEST_AccIDM_2() {
        
        Account Acc = [Select  Id from Account where  OCS_External_Id__c = 'D123458'];
        case CaseAccollo = [select Id, status,subject from case where accountId=:Acc.id]; 
        Dossier__c Accollo =[SELECT Id, Name, DataRiferimento__c, IdAttivita__r.AccountId  FROM Dossier__c where IdAttivita__c=:CaseAccollo.Id];
       // SFAConvenzionamento2IDMAccolloCtrller IDMController =  new SFAConvenzionamento2IDMAccolloCtrller();
       test.startTest();
       		SFAConvenzionamento2IDMAccolloCtrller.CancellazioneRimossi(String.valueOf(CaseAccollo.Id));
        	SFAConvenzionamento2IDMAccolloCtrller.AnnullaAccollo(String.valueOf(CaseAccollo.Id),'TEST_IDM2_Annulla');
        test.stopTest();
    } 
    
    @IsTest 
    static void TEST_AccIDM_3() {
        
        Account Acc = [Select  Id from Account where  OCS_External_Id__c = 'D123460'];
        case CaseAccollo = [select Id, status,subject from case where accountId=:Acc.id]; 
        Dossier__c Accollo =[SELECT Id, Name, DataRiferimento__c, IdAttivita__r.AccountId  FROM Dossier__c where IdAttivita__c=:CaseAccollo.Id];
        SFADossierDocumento__c DossDoc =[SELECT Id, Name,SFAConvenzDealerDocumentsList__c FROM SFADossierDocumento__c where Dossier__c=:Accollo.Id limit 1];
        test.startTest();
        	SFAConvenzionamento2IDMAccolloCtrller.Dati DatiDoInit = SFAConvenzionamento2IDMAccolloCtrller.getDati(String.valueOf(Accollo.Id));
        	system.debug('IDM_TEST_DatiDoInit: '+DatiDoInit);
        
        	SFAConvenzionamento2IDMAccolloCtrller.AggiornaRecordNascosto(String.valueOf(DossDoc.Id) ,DossDoc.SFAConvenzDealerDocumentsList__c);

        	SFAConvenzionamento2IDMAccolloCtrller.assignToMD(String.valueOf(CaseAccollo.Id), String.valueOf(Accollo.Id), 'TEST_IDM3 - AssignToMD');
        test.stopTest();
    }
}