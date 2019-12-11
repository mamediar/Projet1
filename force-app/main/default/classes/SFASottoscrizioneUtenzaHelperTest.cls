@isTest
public with sharing class SFASottoscrizioneUtenzaHelperTest {



    @isTest
    public static void PDFAccettazioneTest(){

        String responseApi = '{"resultCode":0,"resultMessage":"Ok","dcCreaDocumentoResponse":{"documentoGenerato":[{"tipoDocumento":"VARIE","allegatoAssicurativo":null,"stream":"JVBERi0xLjcKJe"}]}}';
        
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,
                                          Test_Response__c= responseApi,
                                          Test_Request__c = 'testRequest',
                                          Mock__c = false,
                                          User__c = 'CDSLF00',
                                          Password__c = 'P00FLSDC' ,
                                          Name ='ocs.dcCreaDocumento',
                                          Ref__c='CompassInternal',
                                          EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
        insert test1;
        ApiUtil__c uti = new ApiUtil__c(Name = 'CompassInternal' ,EndPoint__c ='https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute' ,Password__c = 'P00FLSDC',User__c = 'CDSLF00');      
        insert uti;


        Test.startTest();
        UtilityMockResponse UMR = new UtilityMockResponse();
        UMR.apiname='ocs.dcCreaDocumento';
        Test.setMock(HttpCalloutMock.class,UMR);

        Account acc = TestDataFactory.insertAccount();
        SFASottoscrizioneUtenzaHelper.PDF pdf = SFASottoscrizioneUtenzaHelper.getPDFAddendumAccettazioneGDO(acc.id);
        System.assert(pdf!=null);
        Test.stopTest();
    }

    @isTest
    public static void PDFPropostaTest(){

        String responseApi = '{"resultCode":0,"resultMessage":"Ok","dcCreaDocumentoResponse":{"documentoGenerato":[{"tipoDocumento":"VARIE","allegatoAssicurativo":null,"stream":"JVBERi0xLjcKJe"}]}}';
        
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,
                                          Test_Response__c= responseApi,
                                          Test_Request__c = 'testRequest',
                                          Mock__c = false,
                                          User__c = 'CDSLF00',
                                          Password__c = 'P00FLSDC' ,
                                          Name ='ocs.dcCreaDocumento',
                                          Ref__c='CompassInternal',
                                          EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
        insert test1;
        ApiUtil__c uti = new ApiUtil__c(Name = 'CompassInternal' ,EndPoint__c ='https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute' ,Password__c = 'P00FLSDC',User__c = 'CDSLF00');      
        insert uti;

        Account acc = TestDataFactory.insertAccount();

        Test.startTest();
        UtilityMockResponse UMR = new UtilityMockResponse();
        UMR.apiname='ocs.dcCreaDocumento';
        Test.setMock(HttpCalloutMock.class,UMR);

        SFASottoscrizioneUtenzaHelper.PDF pdf = SFASottoscrizioneUtenzaHelper.getPDFAddendumPropostaGDO(acc.id);
        System.assert(pdf!=null);
        Test.stopTest();
    }



    @isTest
    public static void PDFElencoIncaricatiTest(){
        Case caso = TestDataFactory.insertCase();
        Test.startTest();
        PageReference pageRef = Page.SFAElencoIncaricatiPDF;

        Test.setCurrentPage(pageRef); 

        String base64 = SFASottoscrizioneUtenzaHelper.getBase64PDFElencoIncaricati(caso.id);
        System.assert(base64!=null);
        Test.stopTest();

    }
}