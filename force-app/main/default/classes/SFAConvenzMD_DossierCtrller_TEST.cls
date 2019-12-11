@IsTest
public class SFAConvenzMD_DossierCtrller_TEST {

  	@testSetup
    static void setup() {
  		TEST_DataFactory_Convenzionamento.SetupDossier();
    }
	@IsTest    
    static void Test1_MD() { 
        Account Acc = [Select  Id ,OCS_External_Id__c from Account where  OCS_External_Id__c = 'D123458'];
        case CaseDossier = [select Id, status,subject,IsAutonomiaConvenzionamentoSede__c from case where accountId=:acc.id]; 
        Dossier__c dossier =[SELECT Id, Name, IsCaseDossierEsistente__c,DataRiferimento__c, IdAttivita__r.AccountId  FROM Dossier__c where IdAttivita__c=:CaseDossier.Id];
        
		CaseDossier.IsAutonomiaConvenzionamentoSede__c = true;
		update CaseDossier;
        
        test.startTest();
        SFAConvenzionamentoMDDossierCtrller.Dati DatiDoInit = SFAConvenzionamentoMDDossierCtrller.getDati(String.valueOf(dossier.Id));
       	SFAConvenzionamentoMDDossierCtrller.ShowButtons ShowB =  SFAConvenzionamentoMDDossierCtrller.getIfShowButtons( XCS_DispositionUtils.DOSSIER_DISPONIBILE ,'IS');
        SFAConvenzionamentoMDDossierCtrller.prendiCase(String.valueOf(CaseDossier.Id));
        SFAConvenzionamentoMDDossierCtrller.approva(String.valueOf(CaseDossier.Id),'APPROVATO MD');
        system.debug('MD_TEST_DatiDoInit: '+DatiDoInit);
        test.stopTest();
    }
    @IsTest    
    static void Test2_MD() { 
        Account Acc = [Select  Id ,OCS_External_Id__c from Account where  OCS_External_Id__c = 'D123458'];
        case CaseDossier = [select Id, status,subject from case where accountId=:acc.id]; 
        Dossier__c dossier =[SELECT Id, Name, IsCaseDossierEsistente__c,DataRiferimento__c, IdAttivita__r.AccountId  FROM Dossier__c where IdAttivita__c=:CaseDossier.Id];
        
		CaseDossier.StepAttivitaConvenzionamento__c = 'GestioneDossierDealer_DocumentiObbligatori';
		update CaseDossier;
        
        test.startTest();
        SFAConvenzionamentoMDDossierCtrller.Dati DatiDoInit = SFAConvenzionamentoMDDossierCtrller.getDati(String.valueOf(dossier.Id));
       	SFAConvenzionamentoMDDossierCtrller.ShowButtons ShowB =  SFAConvenzionamentoMDDossierCtrller.getIfShowButtons( XCS_DispositionUtils.DOSSIER_DISPONIBILE ,'CH');
        SFAConvenzionamentoMDDossierCtrller.sospendi(String.valueOf(CaseDossier.Id),'Sospendi - MD');
        SFAConvenzionamentoMDDossierCtrller.richiediMaggioriInformazioni(String.valueOf(CaseDossier.Id),'Maggiori INFO - MD');
        system.debug('MD_TEST2_DatiDoInit: '+DatiDoInit);
        test.stopTest();
    }
    @IsTest    
    static void Test3_MD() { 
        Account Acc = [Select  Id ,OCS_External_Id__c from Account where  OCS_External_Id__c = 'D123458'];
        case CaseDossier = [select Id, status,subject from case where accountId=:acc.id]; 
        Dossier__c dossier =[SELECT Id, Name, IsCaseDossierEsistente__c,DataRiferimento__c, IdAttivita__r.AccountId  FROM Dossier__c where IdAttivita__c=:CaseDossier.Id];
      
        
		CaseDossier.StepAttivitaConvenzionamento__c = 'GestioneDossierDealer_DocumentiObbligatori';
		update CaseDossier;
        
        test.startTest();
        SFAConvenzionamentoMDDossierCtrller.Dati DatiDoInit = SFAConvenzionamentoMDDossierCtrller.getDati(String.valueOf(dossier.Id));
        SFAConvenzionamentoMDDossierCtrller.respingi(String.valueOf(CaseDossier.Id),'Respingi - MD');
       
        system.debug('MD_TEST3_DatiDoInit: '+DatiDoInit);
        test.stopTest();
    }
}