@isTest
public with sharing class CRMBatDinieghiFlagLettoTest {

    @testSetup
    public static void setup() {
        String resp = '{"resultCode":0,"resultMessage":"Ok","dinieghiSDDFlagLetturaResponse":{"esito":"OK","erroreCanomanProgressivo":"","erroreCanomanProgreMan":""}}';
        ApiRest__c rest = new ApiRest__c(Method__c = 'POST' ,Test_Response__c=resp,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,ref__c = 'CompassInternal',Name ='ocs.dinieghiSDDFlagLettura',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
        insert rest;
        ApiUtil__c uti = new ApiUtil__c(Name = 'CompassInternal' ,EndPoint__c ='https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute' ,Password__c = 'P00FLSDC',User__c = 'CDSLF00');      
        insert uti;
        List<Mandati_SDD__c> lista = TestDataFactory.insertMandati_SDD();
        for (Mandati_SDD__c man:lista) {
            man.IsProcessato__c = true;
        }
        update lista;
    }


    @isTest
    public static void runBatchTest() {
        UtilityMockResponse UMR = new UtilityMockResponse();
        UMR.apiname='ocs.dinieghiSDDFlagLettura';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class,UMR);
        SchedulableContext sc = null;
        Map<String, String> mandatiErrati = new  Map<String, String>();  
        CRMBatDinieghiFlagLetto bat = new  CRMBatDinieghiFlagLetto();         
        Id batchJobId = Database.executeBatch(bat, 2);
        Test.stopTest();
        // verify test
        List<Mandati_SDD__c> lista = [SELECT ID, IsSendOCS__c FROM Mandati_SDD__c ];
        for (Mandati_SDD__c man:lista) {
            System.assert(man.IsSendOCS__c);
        }
    }

}