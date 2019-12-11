@IsTest
public class SFAConvenzGestioneDossier_TEST {
  
    @testSetup
    static void setup() {
  		TEST_DataFactory_Convenzionamento.SetupDossier();
    }
    
    @Istest
    static void Test1Action() { 

    	Account Acc = [Select  Id from Account where  OCS_External_Id__c = 'D123456'];
    	MenuConfigMatrix__mdt Conf = [SELECT Label, Destination__c, Sort_Order__c, Type__c, ApexClass__c FROM MenuConfigMatrix__mdt WHERE Parent__c = 'Nuovo Caso Cliente' AND View_Name__c =: 'CRM - Call Center' and ApexClass__c  = 'SFAGestioneDossierDealerAction'];
        
        test.startTest();
      
        UtilityMockResponseMultipleService UMR = new UtilityMockResponseMultipleService(TEST_DataFactory_Convenzionamento.PopolaMappa());
        Test.setMock(HttpCalloutMock.class,UMR);
		NuovoCasoClienteController.doPreRedirect( Conf, acc.Id);    
      
        test.stopTest();   
    
	} 
    
    @Istest
    static void Test2Action() { //ErrorePresenzaDossier

    	Account Acc = [Select  Id from Account where  OCS_External_Id__c = 'D123458'];
    	MenuConfigMatrix__mdt Conf = [SELECT Label, Destination__c, Sort_Order__c, Type__c, ApexClass__c FROM MenuConfigMatrix__mdt WHERE Parent__c = 'Nuovo Caso Cliente' AND View_Name__c =: 'CRM - Call Center' and ApexClass__c  = 'SFAGestioneDossierDealerAction'];

        test.startTest();
      
        UtilityMockResponseMultipleService UMR = new UtilityMockResponseMultipleService(TEST_DataFactory_Convenzionamento.PopolaMappa());
        Test.setMock(HttpCalloutMock.class,UMR);
		NuovoCasoClienteController.doPreRedirect( Conf, acc.Id);    

        test.stopTest();   
    
	} 
    
    @Istest
    static void Test3Action() { 
        
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
      
        UtilityMockResponseMultipleService UMR = new UtilityMockResponseMultipleService(TEST_DataFactory_Convenzionamento.PopolaMappa());
        Test.setMock(HttpCalloutMock.class,UMR);

      	SFAConvenzGestioneDossierController.DatiListaDocumenti DoclistDossier = SFAConvenzGestioneDossierController.getListeDocumenti(String.valueOf(CaseDossier.Id),  dossier, 'Q_CV'); 
        SFAConvenzGestioneDossierController.salvaSelezioneDocumenti(String.valueOf(dossier.Id), String.valueOf(CaseDossier.Id), IdDoc,'GestioneDossierDealer_DocumentiObbligatori');
         SFAConvenzGestioneDossierController.salvaSelezioneDocumenti(String.valueOf(dossier.Id), String.valueOf(CaseDossier.Id), IdDoc,'GestioneDossierDealer_DocumentiAddizionali');
        SFAConvenzGestioneDossierController.salvaRisposteDocumentiAddizionali(String.valueOf(dossier.Id), String.valueOf(CaseDossier.Id), mapIdRispostaDocumentoAddizionali ,'GestioneDossierDealer_DocumentiAddizionali');
        SFAConvenzGestioneDossierController.UpdateStepLavorazioneData aggiornaStep = SFAConvenzGestioneDossierController.updateStepLavorazione(String.valueOf(dossier.Id), String.valueOf(CaseDossier.Id));
        
        test.stopTest();   
    
	}
    
    @Istest
    static void Test4Action() { 
        
    	Account Acc = [Select  Id ,OCS_External_Id__c from Account where  OCS_External_Id__c = 'D123458'];
        case CaseDossier = [select Id, status,subject from case where accountId=:acc.id]; 
        Dossier__c dossier =[SELECT Id, Name, IsCaseDossierEsistente__c,DataRiferimento__c, IdAttivita__r.AccountId  FROM Dossier__c where IdAttivita__c=:CaseDossier.Id];
		CaseDossier.StepAttivitaConvenzionamento__c = 'GestioneDossierDealer_DocumentiAddizionali';
		update CaseDossier;
        list<SFADossierDocumento__c>  Doc = [select SFAConvenzDealerDocumentsList__c  from SFADossierDocumento__c where Dossier__c=:dossier.id];
        list<String> IdDoc = new list<String>();
        Map<String, String> mapIdRispostaDocumentoAddizionali= new  Map<String, String>();
        for (SFADossierDocumento__c D : Doc){
            IdDoc.add(D.SFAConvenzDealerDocumentsList__c);
        }
        test.startTest();
      
        UtilityMockResponseMultipleService UMR = new UtilityMockResponseMultipleService(TEST_DataFactory_Convenzionamento.PopolaMappa());
        Test.setMock(HttpCalloutMock.class,UMR);
        
     	SFAConvenzGestioneDossierController.InitData RespInitData   = SFAConvenzGestioneDossierController.checkDossierEsistente(String.valueOf(CaseDossier.Id));
      	SFAConvenzGestioneDossierController.DatiListaDocumenti DoclistDossier = SFAConvenzGestioneDossierController.getListeDocumenti(String.valueOf(CaseDossier.Id),  dossier, 'Q_CV'); 
       
        
        SFAConvenzGestioneDossierController.UpdateStepLavorazioneData aggiornaStep = SFAConvenzGestioneDossierController.updateStepLavorazione(String.valueOf(dossier.Id), String.valueOf(CaseDossier.Id));
          
        
         system.debug('aggiornaStep - : '+RespInitData);
        
        test.stopTest();   
    
	}
    @IsTest
       static void Test5Action() { 
        
    	Account Acc = [Select  Id ,OCS_External_Id__c from Account where  OCS_External_Id__c = 'D123458'];
        case CaseDossier = [select Id, status,subject,StepAttivitaConvenzionamento__c from case where accountId=:acc.id]; 
        Dossier__c dossier =[SELECT Id, Name, IsCaseDossierEsistente__c,DataRiferimento__c, IdAttivita__r.AccountId  FROM Dossier__c where IdAttivita__c=:CaseDossier.Id];
		
         list<SFADossierDocumento__c>  Doc = [select SFAConvenzDealerDocumentsList__c  from SFADossierDocumento__c where Dossier__c=:dossier.id];
        list<String> IdDoc = new list<String>();
        Map<String, String> mapIdRispostaDocumentoAddizionali= new  Map<String, String>();
        for (SFADossierDocumento__c D : Doc){
            IdDoc.add(D.SFAConvenzDealerDocumentsList__c);
        }
           
        CaseDossier.StepAttivitaConvenzionamento__c = 'GestioneDossierDealer_DocumentiCollegati';
		update CaseDossier;
           
        test.startTest();
      
        UtilityMockResponseMultipleService UMR = new UtilityMockResponseMultipleService(TEST_DataFactory_Convenzionamento.PopolaMappa());
        Test.setMock(HttpCalloutMock.class,UMR);
         SFAConvenzGestioneDossierController.salvaSelezioneDocumenti(String.valueOf(dossier.Id), String.valueOf(CaseDossier.Id), IdDoc,'GestioneDossierDealer_DocumentiCollegati');
     	SFAConvenzGestioneDossierController.UpdateStepLavorazioneData aggiornaStep = SFAConvenzGestioneDossierController.updateStepLavorazione(String.valueOf(dossier.Id), String.valueOf(CaseDossier.Id));
                PageReference pageRef = Page.SFAConvenzGestioneDossierGeneraCover;
	    Test.setCurrentPage(pageRef);

	    ApexPages.currentPage().getParameters().put('dossierId',String.valueOf(dossier.Id));
       // String AccId = ApexPages.currentPage().getParameters().put('AccId',Acc.OCS_External_Id__c);
       // String Tipo = ApexPages.currentPage().getParameters().put('Tipo','Dossier');
       // String CaseId = ApexPages.currentPage().getParameters().put('DossierId',String.valueOf(dossier.Id));
		string res = SFAConvenzGestioneDossierController.generaCoverDossierUrl(String.valueOf(dossier.Id));
	    SFAConvenzGestDossierGeneraCoverCtrller coverController =  new SFAConvenzGestDossierGeneraCoverCtrller();
        coverController.getDocumenti();   
        SFAConvenzGestioneDossierController.assignToIDM(String.valueOf(dossier.Id), String.valueOf(CaseDossier.Id));  
        
       }
    
    @Istest
    static void Test6Action() { 

    	Account Acc = [Select  Id from Account where  OCS_External_Id__c = 'D123459'];
    	MenuConfigMatrix__mdt Conf = [SELECT Label, Destination__c, Sort_Order__c, Type__c, ApexClass__c FROM MenuConfigMatrix__mdt WHERE Parent__c = 'Nuovo Caso Cliente' AND View_Name__c =: 'CRM - Call Center' and ApexClass__c  = 'SFAGestioneDossierDealerAction'];
        
        test.startTest();
      
        UtilityMockResponseMultipleService UMR = new UtilityMockResponseMultipleService(TEST_DataFactory_Convenzionamento.PopolaMappa());
        Test.setMock(HttpCalloutMock.class,UMR);
		NuovoCasoClienteController.doPreRedirect( Conf, acc.Id);    
      
        test.stopTest();   
    
	} 
}