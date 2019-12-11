@isTest
public with sharing class CRMBatLoadDinieghiTest {


    @testSetup
    public static void setup() {
        String responseDin = '{"resultCode":0,"resultMessage":"Ok","recuperaDinieghiSDDResponse":{"elenco":[{"canomanPratica":"20682118","canomanProgressivo":"1","canomanProgreMan":"5834588","canomanMandato":"MAN","canomanCliente":"19263416","acCognome":"C","acNome":"A"}]}}';
        ApiRest__c restdinieghi = new ApiRest__c(Method__c = 'POST' ,Test_Response__c=responseDin,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,ref__c = 'CompassInternal',Name ='ocs.recuperaDinieghiSDD',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
        insert restdinieghi;
        ApiRest__c restNote = new ApiRest__c(Method__c = 'POST' ,Test_Response__c=responseDin,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,ref__c = 'CompassInternal',Name ='ocs.recuperaDinieghiSDD',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
        insert restNote;
        ApiUtil__c uti = new ApiUtil__c(Name = 'CompassInternal' ,EndPoint__c ='https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute' ,Password__c = 'P00FLSDC',User__c = 'CDSLF00');      
        insert uti;
        XCS_Template__c templateNote = new XCS_Template__c(Name = 'Nota Diniego Mandato SDD', Body__c ='	Diniego Mandato SDD Cliente : {Cliente} Pratica : {Pratica}<br>Modalità di Pagamento : {Modalita_Pagamento} Filiale : {Filiale} Motivo Diniego : {Motivo} ');
        insert templateNote;
        TestDataFactory.insertAccountForEmail();
    }


    @isTest
    public static void runBatchTest() {
        // dinieghi response 
        UtilityMockResponse UMR = new UtilityMockResponse();
        UMR.apiname='ocs.recuperaDinieghiSDD';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class,UMR);
        SchedulableContext sc = null;
        CRMBatLoadDinieghi bat = new CRMBatLoadDinieghi();
        bat.execute(sc);
        Test.stopTest();
        // verify test
        List<Mandati_SDD__c> lista = [SELECT ID FROM Mandati_SDD__c ];
        System.assert(lista!=null && lista.size()>0);
    }


    @isTest
    public static void runBatchTestDuplicato() {
        Case cas = TestDataFactory.insertCase();
        Mandati_SDD__c mand = new Mandati_SDD__c(ProgreMan__c='5834588',Progressivo__c='1',Mandato__c='M',Caseid__c=cas.id);
        insert mand;
        // dinieghi response 
        UtilityMockResponse UMR = new UtilityMockResponse();
        UMR.apiname='ocs.recuperaDinieghiSDD';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class,UMR);
        SchedulableContext sc = null;
        CRMBatLoadDinieghi bat = new CRMBatLoadDinieghi();
        bat.execute(sc);
        Test.stopTest();
        // verify test
        List<Mandati_SDD__c> lista = [SELECT ID FROM Mandati_SDD__c ];
        System.assert(lista!=null && lista.size()>0);
    }

}