@IsTest
public class SFAConvenzGestioneAccollo_TEST {
    
	@testSetup
    static void setup() {
        
        TEST_DataFactory_Convenzionamento.SetupAccolli();
     
    }
    
    @Istest
    static void Test1Action() {//intermediario PV

    	Account Acc = [Select  Id from Account where  OCS_External_Id__c = 'D123456'];
    	MenuConfigMatrix__mdt Conf = [SELECT Label, Destination__c, Sort_Order__c, Type__c, ApexClass__c FROM MenuConfigMatrix__mdt WHERE Parent__c = 'Nuovo Caso Cliente' AND View_Name__c =: 'CRM - Call Center' and ApexClass__c  = 'SFAGestioneAccolloDealerAction'];
        list<Accolli_Type_List__c> AccListSel =[SELECT Id from Accolli_Type_List__c where Accollo_Type_Code__c='ACC_GDO'] ;
        list<ID> typeId =  new list<Id>();
        system.debug('ListaAccollotest:  '+AccListSel);
        for(Accolli_Type_List__c T : AccListSel){
            typeId.add(T.Id);
        }    
        
        
        test.startTest();
      
        UtilityMockResponseMultipleService UMR = new UtilityMockResponseMultipleService(TEST_DataFactory_Convenzionamento.PopolaMappa());
        Test.setMock(HttpCalloutMock.class,UMR);
        
		NuovoCasoClienteController.doPreRedirect( Conf, acc.Id);    
        
        case CaseAccollo = [select Id, status,subject from case where accountId=:acc.id]; 
        Dossier__c Accollo =[SELECT Id, Name, DataRiferimento__c, IdAttivita__r.AccountId  FROM Dossier__c where IdAttivita__c=:CaseAccollo.Id];
        SFAConvenzDealerDocumentsList__c DocList = [SELECT Id FROM SFAConvenzDealerDocumentsList__c where IdDocument__c='10'];
        SFAConvenzGestioneAccolloController.InitData RespInitData = SFAConvenzGestioneAccolloController.MostraTipologie(CaseAccollo.Id);
        system.debug('RespInitData - : '+RespInitData);
        System.assert(RespInitData != null,'Mancanza Tipologie');      
        
        SFADossierDocumento__c AccolloDocumento = new SFADossierDocumento__c();
        AccolloDocumento.Dossier__c = Accollo.Id;
        AccolloDocumento.SFAConvenzDealerDocumentsList__c =DocList.Id;
        AccolloDocumento.TipoConv__c = 'ACC_DEL';
        AccolloDocumento.Rimozione_Logica__c=false;
        AccolloDocumento.DocumentType__c = 'mandatory';
        insert AccolloDocumento;
        
        Accolli_Type_List__c AccDel =[SELECT Id from Accolli_Type_List__c where Accollo_Type_Code__c='ACC_DEL'] ;
        
        Accolli_Type__c jO = New Accolli_Type__c();
        jO.Accollo_Id__c=Accollo.Id;
        jO.AccolloType__c=AccDel.id;
        jo.Rimozione_Logica__c =false;
        Insert jO;    
        
       	RespInitData = SFAConvenzGestioneAccolloController.CheckTypeSelezionati(Accollo,typeId,String.valueOf(CaseAccollo.Id));
        SFAConvenzGestioneAccolloController.DatiListaDocumenti DoclistAccollo = SFAConvenzGestioneAccolloController.getListeDocumenti(String.valueOf(CaseAccollo.Id), Accollo,typeId );
        SFAConvenzGestioneAccolloController.UpdateStepLavorazioneData aggiornaStep = SFAConvenzGestioneAccolloController.TornaAdObbligatori(String.valueOf(CaseAccollo.Id));
        //salva selezione da mettere
        aggiornaStep = SFAConvenzGestioneAccolloController.updateStepLavorazione(String.valueOf(Accollo.Id), String.valueOf(CaseAccollo.Id));
        SFAConvenzGestioneAccolloController.assignToIDM(String.valueOf(Accollo.Id), String.valueOf(CaseAccollo.Id));       
        
        System.assert(RespInitData != null,'Nessuna Selezione');     
        System.assert(DoclistAccollo != null,'Mancanza Doc');
        System.assert(aggiornaStep != null,'AggiornamentoFallito');  
        
        system.debug('RespInitData2 - : '+RespInitData);
        system.debug('DoclistAccollo - : '+DoclistAccollo);
        system.debug('aggiornaStep - : '+aggiornaStep);
        
        test.stopTest();   
    
	}       
     @Istest
    	static void Test2Action() { //ErrorePresenzaDossier

    	Account Acc = [Select  Id from Account where  OCS_External_Id__c = 'D123457'];
    	MenuConfigMatrix__mdt Conf = [SELECT Label, Destination__c, Sort_Order__c, Type__c, ApexClass__c FROM MenuConfigMatrix__mdt WHERE Parent__c = 'Nuovo Caso Cliente' AND View_Name__c =: 'CRM - Call Center' and ApexClass__c  = 'SFAGestioneAccolloDealerAction'];
            
        test.startTest();
      
        UtilityMockResponseMultipleService UMR = new UtilityMockResponseMultipleService(TEST_DataFactory_Convenzionamento.PopolaMappa());
        Test.setMock(HttpCalloutMock.class,UMR);
		NuovoCasoClienteController.doPreRedirect( Conf, acc.Id);    
        
            
        test.stopTest();   
    
	}  
    
    @Istest
    	static void Test3Action() {//Intermediaro CQ con dossier Presente

    	Account Acc = [Select  Id from Account where  OCS_External_Id__c = 'D123458'];
    	MenuConfigMatrix__mdt Conf = [SELECT Label, Destination__c, Sort_Order__c, Type__c, ApexClass__c FROM MenuConfigMatrix__mdt WHERE Parent__c = 'Nuovo Caso Cliente' AND View_Name__c =: 'CRM - Call Center' and ApexClass__c  = 'SFAGestioneAccolloDealerAction'];
        
        test.startTest();     
        
        case Dossier = [select Id, status,subject from case where accountId=:acc.id]; 
        
        system.debug('dati dossier: '+dossier.subject+'--'+dossier.status); 
            
       
        UtilityMockResponseMultipleService UMR = new UtilityMockResponseMultipleService(TEST_DataFactory_Convenzionamento.PopolaMappa());
        Test.setMock(HttpCalloutMock.class,UMR);
        NuovoCasoClienteController.doPreRedirect( Conf, acc.Id);     
         
    	case CaseAccollo = [select Id, status,subject ,Categoria_Riferimento__r.External_Id__c from case where accountId=:Acc.id and Categoria_Riferimento__r.External_Id__c ='3709']; 
       system.debug('CaseAccolloTest3: '+CaseAccollo) ;    
        SFAConvenzGestioneAccolloController.AnnullaAccollo(String.valueOf(CaseAccollo.Id), 'TESTAnnulla');
        test.stopTest();  
	}  

	@Istest
    static void Test4Controller() {
               
        Account Acc = [Select  Id from Account where  OCS_External_Id__c = 'D123459'];
        case CaseAccollo = [select Id, status,subject from case where accountId=:Acc.id]; 
        Dossier__c Accollo =[SELECT Id, Name, DataRiferimento__c, IdAttivita__r.AccountId  FROM Dossier__c where IdAttivita__c=:CaseAccollo.Id];
        
        list<Accolli_Type_List__c> AccListSel =[SELECT Id from Accolli_Type_List__c where Accollo_Type_Code__c='ACC_GDO'] ;
        system.debug('ListaAccollotest:  '+AccListSel);
        list<ID> typeId =  new list<Id>();
        
        for(Accolli_Type_List__c T : AccListSel){
            typeId.add(T.Id);
        }  
        
         
        test.startTest();
        
        SFAConvenzGestioneAccolloController.InitData RespInitData  = SFAConvenzGestioneAccolloController.RecuperaContesto(String.valueOf(CaseAccollo.Id));

        UtilityMockResponseMultipleService UMR = new UtilityMockResponseMultipleService(TEST_DataFactory_Convenzionamento.PopolaMappa());
        Test.setMock(HttpCalloutMock.class,UMR);
        
     	 RespInitData  = SFAConvenzGestioneAccolloController.checkDossierEsistente(String.valueOf(CaseAccollo.Id));
         system.debug('RespInitData5 - : '+RespInitData);
        
        PageReference pageRef = Page.SFAConvenzGestioneAccolloGeneraCover;
		Test.setCurrentPage(pageRef);

		ApexPages.currentPage().getParameters().put('dossierId',String.valueOf(Accollo.Id));
         //  String AccId = ApexPages.currentPage().getParameters().put('AccId',Acc.OCS_External_Id__c);
          //String Tipo = ApexPages.currentPage().getParameters().put('Tipo','Accollo');
          //String CaseId = ApexPages.currentPage().getParameters().put('CaseId',CaseAcc);
		SFAConvenzGestAccolloGeneraCoverCtrller coverController =  new SFAConvenzGestAccolloGeneraCoverCtrller();
        coverController.getDocumenti();
        
        test.stopTest();   
    }
    @Istest
    static void Test5_AccolloDaSede() {
        Account Acc = [Select  Id, OCS_External_Id__c  from Account where  OCS_External_Id__c = 'D123457'];
        string CaseAcc = SFAConvenz2DossierAccolloSedeCtrller.CreaCaseNote('Accollo', Acc.OCS_External_Id__c,'TEST_ADS', '');
        system.debug('Test5_AccolloDaSede- CaseAcc - : '+CaseAcc);
        
        string ResCover =  SFAConvenz2DossierAccolloSedeCtrller.CreaCover('Accollo',Acc.OCS_External_Id__c , CaseAcc);
        PageReference pageRef = Page.SFAConvenzGestioneAccolloGeneraCover;
		Test.setCurrentPage(pageRef);

		ApexPages.currentPage().getParameters().put('dossierId','');
        String AccId = ApexPages.currentPage().getParameters().put('AccId',Acc.OCS_External_Id__c);
        String Tipo = ApexPages.currentPage().getParameters().put('Tipo','Accollo');
        String CaseId = ApexPages.currentPage().getParameters().put('CaseId',CaseAcc);
		SFAConvenzGestAccolloGeneraCoverCtrller coverController =  new SFAConvenzGestAccolloGeneraCoverCtrller();
        test.startTest();
        coverController.getDocumenti();
        test.stopTest();
    }
    
     @Istest
    static void Test6_DossieroDaSede() 
    {
       Account Acc = [Select  Id, OCS_External_Id__c  from Account where  OCS_External_Id__c = 'D123457'];
       string Errore = SFAConvenz2DossierAccolloSedeCtrller.CreaCaseNote('Dossier', '666667','TEST_DDS', ''); 
       system.debug('Test6_DossieroDaSede- Errore - : '+Errore); 
       string CaseDoss = SFAConvenz2DossierAccolloSedeCtrller.CreaCaseNote('Dossier', Acc.OCS_External_Id__c,'TEST_DDS', '');
       system.debug('Test6_DossieroDaSede- CaseDoss - : '+CaseDoss);
        
       PageReference pageRef = Page.SFAConvenzGestioneDossierGeneraCover;
	   Test.setCurrentPage(pageRef);

	   ApexPages.currentPage().getParameters().put('dossierId','');
       String AccId = ApexPages.currentPage().getParameters().put('AccId',Acc.OCS_External_Id__c);
       String Tipo = ApexPages.currentPage().getParameters().put('Tipo','Dossier');
       String CaseId = ApexPages.currentPage().getParameters().put('CaseId',CaseDoss);
       test.startTest();
	   SFAConvenzGestDossierGeneraCoverCtrller coverController =  new SFAConvenzGestDossierGeneraCoverCtrller();
       coverController.getDocumenti();
       test.stopTest();
    }
}