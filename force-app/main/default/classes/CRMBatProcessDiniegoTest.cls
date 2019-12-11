@IsTest
public with sharing class CRMBatProcessDiniegoTest {

    @testSetup
    public static void setup() {
        TestDataFactory.insertMandati_SDD();
        ApiUtil__c uti = new ApiUtil__c(Name = 'CompassInternal' ,EndPoint__c ='https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute' ,Password__c = 'P00FLSDC',User__c = 'CDSLF00');      
        insert uti;
        XCS_Template__c templateNote = new XCS_Template__c(Name = 'Nota Diniego Mandato SDD', Body__c ='	Diniego Mandato SDD Cliente : {Cliente} Pratica : {Pratica}<br>Modalità di Pagamento : {Modalita_Pagamento} Filiale : {Filiale} Motivo Diniego : {Motivo} ');
        insert templateNote;
        TestDataFactory.insertAccountForEmail();
        insert new XCS_CompassParameters__c(Name = 'gestore.dinieghi.email', Value__c = 'mauro.dotti@lynxspa.com');
    }

    @isTest
    public static void runBatchTestOK() {
        ApiRest__c rest1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c='{"resultCode":0,"resultMessage":"Ok","gestioneNoteResponse":{"as400Status":"OK","as400Errore":""}}',Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,ref__c = 'CompassInternal',Name ='ocs.gestioneNote',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
        insert rest1;
        // note response 
        UtilityMockResponse UMR = new UtilityMockResponse();
        UMR.apiname='ocs.gestioneNote';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class,UMR);
        SchedulableContext sc = null;
        Map<String, String> mandatiErrati = new  Map<String, String>();  
        CRMBatProcessDiniego bat = new  CRMBatProcessDiniego(2,2,mandatiErrati);         
        Id batchJobId = Database.executeBatch(bat, 10);
        Test.stopTest();
        // verify test
        List<ContentNote> listaNote = [SELECT ID FROM ContentNote ];
        System.assert(listaNote!=null && listaNote.size()>0);
       
    }


    @isTest
    public static void runBatchTestKO() {
        ApiRest__c rest1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c='{"resultCode":0,"resultMessage":"Ok","gestioneNoteResponse":{"as400Status":"KO","as400Errore":"error"}}',Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,ref__c = 'CompassInternal',Name ='ocs.gestioneNote',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
        insert rest1;
        // note response KO
        UtilityMockResponse UMR = new UtilityMockResponse();
        UMR.apiname='ocs.gestioneNote';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class,UMR);
        SchedulableContext sc = null;
        Map<String, String> mandatiErrati = new  Map<String, String>();  
        CRMBatProcessDiniego bat = new  CRMBatProcessDiniego(2,2,mandatiErrati);         
        Id batchJobId = Database.executeBatch(bat, 10);
        Test.stopTest();
        // verify test delete mandati
        List<Mandati_SDD__c> listaMand = [SELECT ID FROM Mandati_SDD__c ];
        System.assert(listaMand==null || listaMand.size()==0);
       
    }


}