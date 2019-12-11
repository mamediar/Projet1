@isTest
public  class SFAElencoIncaricatiPDFControllerTest {


   @isTest
    public static void test1(){

        String responseApi = '{"resultCode":0,"resultMessage":"Ok","recuperaDatiCatenaCollegatiDealerRuoliResponse":{"elenco":[{"codCollegato":"5149594","codConvenzionato":"0","cognome":"DAIUL","nome":"ERNESTO ALDO","dataApertura":"20180418","firmatario":"S","rappresentante":"S"}]}}';
        
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,
                                          Test_Response__c= responseApi,
                                          Test_Request__c = 'testRequest',
                                          Mock__c = false,
                                          User__c = 'CDSLF00',
                                          Password__c = 'P00FLSDC' ,
                                          Name =RecuperaDatiCatColDealerRuoliInvoker.SERVICE_NAME,
                                          Ref__c='CompassInternal',
                                          EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
        insert test1;

        ApiUtil__c uti = new ApiUtil__c(Name = 'CompassInternal' ,EndPoint__c ='https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute' ,Password__c = 'P00FLSDC',User__c = 'CDSLF00');      

        insert uti;

        Account acc = TestDataFactory.insertAccount();
        Case caso = TestDataFactory.insertCase();
        caso.AccountId = acc.id;
        update caso;

        Test.startTest();
        UtilityMockResponse UMR = new UtilityMockResponse();
        UMR.apiname=RecuperaDatiCatColDealerRuoliInvoker.SERVICE_NAME;
        Test.setMock(HttpCalloutMock.class,UMR);
        PageReference pageRef = Page.SFAElencoIncaricatiPDF;
        Test.setCurrentPage(pageRef);        
        ApexPages.StandardController sc = new ApexPages.StandardController(caso); 
        ApexPages.currentPage().getParameters().put('IdCase',caso.id);

        SFAElencoIncaricatiPDFController controller = new SFAElencoIncaricatiPDFController(sc);
        controller.init();
        System.assert(controller.listaCollegati!=null && controller.listaCollegati.size()>0);
        Test.stopTest();
    }



}