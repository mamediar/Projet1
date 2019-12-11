@IsTest
public class SFAConvenzGestioneAccollo_MD_TEST {
	@testSetup
    static void setup() {
    /*    String responseApi = '{"resultCode":0,"resultMessage":"Ok","rientroAddendumConvenzionatoResponse":{"elenco":[{"partimestp":"20190924145651829507","codice":"16039294","stato":"003","tipint":"5","datainv":"20190911","nota":"003"}]}}';
        
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' , Test_Response__c= responseApi, Test_Request__c = 'testRequest', Mock__c = false, User__c = 'CDSLF00',Password__c = 'P00FLSDC' , Name =RientroAddendumConvenzionatoInvoker.SERVICE_NAME,Ref__c='CompassInternal',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
        insert test1;

        ApiUtil__c uti = new ApiUtil__c(Name = 'CompassInternal' ,EndPoint__c ='https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute' ,Password__c = 'P00FLSDC',User__c = 'CDSLF00');      

        insert uti;*/
        
        TEST_DataFactory_Convenzionamento.SetupAccolli();
  
    }
    @IsTest 
    static void TEST_Acc_MD_1() {
        
        Account Acc = [Select  Id from Account where  OCS_External_Id__c = 'D123460'];
        case CaseAccollo = [select Id, status,subject from case where accountId=:Acc.id]; 
        Dossier__c Accollo =[SELECT Id, Name, DataRiferimento__c, IdAttivita__r.AccountId  FROM Dossier__c where IdAttivita__c=:CaseAccollo.Id];
          test.startTest();
        SFAConvenzionamento2MDAccolloCtrller.Dati DatiDoInit = SFAConvenzionamento2MDAccolloCtrller.getDati(String.valueOf(Accollo.Id));
        system.debug('MD_TEST_1_DatiDoInit: '+DatiDoInit);
        SFAConvenzionamento2MDAccolloCtrller.ShowButtons AbilitaPuls = SFAConvenzionamento2MDAccolloCtrller.getIfShowButtons(XCS_DispositionUtils.ACCOLLO_COMPLETO_IDM, 'CH' );
          system.debug('MD_TEST_1_AbilitaPuls: '+AbilitaPuls);
         test.stopTest();
    }
    
	@IsTest 
    static void TEST_Acc_MD_2() {
        
        Account Acc = [Select  Id from Account where  OCS_External_Id__c = 'D123458'];
        case CaseAccollo = [select Id, status,subject from case where accountId=:Acc.id]; 
        Dossier__c Accollo =[SELECT Id, Name, DataRiferimento__c, IdAttivita__r.AccountId  FROM Dossier__c where IdAttivita__c=:CaseAccollo.Id];
       // SFAConvenzionamento2IDMAccolloCtrller IDMController =  new SFAConvenzionamento2IDMAccolloCtrller();
          test.startTest();
        SFAConvenzionamento2MDAccolloCtrller.prendiCase(String.valueOf(CaseAccollo.Id));
        SFAConvenzionamento2MDAccolloCtrller.CancellazioneRimossi(String.valueOf(CaseAccollo.Id));
        SFAConvenzionamento2MDAccolloCtrller.AnnullaAccollo(String.valueOf(CaseAccollo.Id),'TEST_Acc_MD_2_Annulla');
          test.stopTest();
    } 
    
    @IsTest 
    static void TEST_Acc_MD_3() {
        
        Account Acc = [Select  Id from Account where  OCS_External_Id__c = 'D123460'];
        case CaseAccollo = [select Id, status,subject from case where accountId=:Acc.id]; 
        Dossier__c Accollo =[SELECT Id, Name, DataRiferimento__c, IdAttivita__r.AccountId  FROM Dossier__c where IdAttivita__c=:CaseAccollo.Id];
         test.startTest();
        SFAConvenzionamento2MDAccolloCtrller.richiediMaggioriInformazioni(String.valueOf(CaseAccollo.Id), 'TEST_Acc_MD_3_RichiediInfo') ;
         test.stopTest();
    }
    
    @IsTest 
    static void TEST_Acc_MD_4() {
        
        Account Acc = [Select  Id from Account where  OCS_External_Id__c = 'D123460'];
        case CaseAccollo = [select Id, status,subject from case where accountId=:Acc.id]; 
        Dossier__c Accollo =[SELECT Id, Name, DataRiferimento__c, IdAttivita__r.AccountId  FROM Dossier__c where IdAttivita__c=:CaseAccollo.Id];
         test.startTest();
        SFAConvenzionamento2MDAccolloCtrller.sospendi(String.valueOf(CaseAccollo.Id), 'TEST_Acc_MD_4_Sospendi') ;
        SFAConvenzionamento2MDAccolloCtrller.richiediMaggioriInformazioni(String.valueOf(CaseAccollo.Id), 'TEST_Acc_MD_4_RichiediInfo') ;
         test.stopTest();
    }
    @IsTest 
    static void TEST_Acc_MD_5() {
        
        Account Acc = [Select  Id from Account where  OCS_External_Id__c = 'D123460'];
        case CaseAccollo = [select Id, status,subject from case where accountId=:Acc.id]; 
        Dossier__c Accollo =[SELECT Id, Name, DataRiferimento__c, IdAttivita__r.AccountId  FROM Dossier__c where IdAttivita__c=:CaseAccollo.Id];
         test.startTest();
        SFAConvenzionamento2MDAccolloCtrller.respingi(String.valueOf(CaseAccollo.Id), 'TEST_Acc_MD_5_Respingi') ;
        SFAConvenzionamento2MDAccolloCtrller.AnnullaAccollo(String.valueOf(CaseAccollo.Id),'');
         test.stopTest();

    }
    
    @IsTest 
    static void TEST_Acc_MD_6() {
        
        Account Acc = [Select OCS_External_Id__c, Id from Account where  OCS_External_Id__c = 'D123460'];
        case CaseAccollo = [select Id, status,subject from case where accountId=:Acc.id]; 
        Dossier__c Accollo =[SELECT Id, Name, DataRiferimento__c, IdAttivita__r.AccountId  FROM Dossier__c where IdAttivita__c=:CaseAccollo.Id];
        
        test.startTest();
      
        UtilityMockResponseMultipleService UMR = new UtilityMockResponseMultipleService(TEST_DataFactory_Convenzionamento.PopolaMappa());
        Test.setMock(HttpCalloutMock.class,UMR);
		 
        boolean Esito = SFAConvenzionamento2MDAccolloCtrller.approva(String.valueOf(CaseAccollo.Id), 'TEST_Acc_MD_6_Approva',6, string.valueOf(Acc.OCS_External_Id__c));
        SFAConvenzionamento2MDAccolloCtrller.Dati DatiDoInit = SFAConvenzionamento2MDAccolloCtrller.getDati(String.valueOf(Accollo.Id));
        test.stopTest();   
        

    }
    
}