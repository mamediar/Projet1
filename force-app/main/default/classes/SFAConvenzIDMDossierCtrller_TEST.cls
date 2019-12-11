@IsTest
public class SFAConvenzIDMDossierCtrller_TEST {

  	@testSetup
    static void setup() {
  		TEST_DataFactory_Convenzionamento.SetupDossier();
    }
	@IsTest    
    static void Test1_IDM() { 
        Account Acc = [Select  Id ,OCS_External_Id__c from Account where  OCS_External_Id__c = 'D123458'];
        case CaseDossier = [select Id, status,subject from case where accountId=:acc.id]; 
        Dossier__c dossier =[SELECT Id, Name, IsCaseDossierEsistente__c,DataRiferimento__c, IdAttivita__r.AccountId  FROM Dossier__c where IdAttivita__c=:CaseDossier.Id];
        list<SFADossierDocumento__c>  Doc = [select SFAConvenzDealerDocumentsList__c  from SFADossierDocumento__c where Dossier__c=:dossier.id];
        list<String> IdDoc = new list<String>();
        Map<String, String> mapIdRispostaDocumentoAddizionali= new  Map<String, String>();
        for (SFADossierDocumento__c D : Doc){
            IdDoc.add(D.SFAConvenzDealerDocumentsList__c);
        }
        
		CaseDossier.StepAttivitaConvenzionamento__c = 'GestioneDossierDealer_DocumentiObbligatori';
		update CaseDossier;
        
        test.startTest();
        	SFAConvenzionamentoIDMDossierCtrller.Dati DatiDoInit = SFAConvenzionamentoIDMDossierCtrller.getDati(String.valueOf(dossier.Id));
        	system.debug('IDM_TEST_DatiDoInit: '+DatiDoInit);
        	SFAConvenzionamentoIDMDossierCtrller.assignToFiliale(String.valueOf(CaseDossier.Id), String.valueOf(dossier.Id), 'TEST_IDM1');
        test.stopTest();
    }
    
    @IsTest    
    static void Test1_2IDM() { 	
        Account Acc = [Select  Id ,OCS_External_Id__c from Account where  OCS_External_Id__c = 'D123458'];
        case CaseDossier = [select Id, status,subject from case where accountId=:acc.id]; 
        Dossier__c dossier =[SELECT Id, Name, IsCaseDossierEsistente__c,DataRiferimento__c, IdAttivita__r.AccountId  FROM Dossier__c where IdAttivita__c=:CaseDossier.Id];
        list<SFADossierDocumento__c>  Doc = [select SFAConvenzDealerDocumentsList__c  from SFADossierDocumento__c where Dossier__c=:dossier.id];
        list<String> IdDoc = new list<String>();
        Map<String, String> mapIdRispostaDocumentoAddizionali= new  Map<String, String>();
        for (SFADossierDocumento__c D : Doc){
            IdDoc.add(D.SFAConvenzDealerDocumentsList__c);
        }
        
		CaseDossier.StepAttivitaConvenzionamento__c = 'GestioneDossierDealer_StampaCover';
		update CaseDossier;
        
        test.startTest();
        	SFAConvenzionamentoIDMDossierCtrller.Dati DatiDoInit = SFAConvenzionamentoIDMDossierCtrller.getDati(String.valueOf(dossier.Id));
        	system.debug('IDM_TEST_DatiDoInit: '+DatiDoInit);
        	SFAConvenzionamentoIDMDossierCtrller.assignToMD(String.valueOf(CaseDossier.Id), String.valueOf(dossier.Id), 'TEST_IDM2');
        test.stopTest();
    }
}