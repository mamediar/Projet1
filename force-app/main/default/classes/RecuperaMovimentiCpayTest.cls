@isTest
public  class RecuperaMovimentiCpayTest {
    

    @TestSetup
    static void makeData(){
         String response = '{"resultCode": 0,"resultMessage": "Ok","recuperaMovimentiCpayResponse": {"elenco": [{"progressivo": "4594430","causale": "10","segno": "A",\n'+
                 ' "dataFattura": "0", "progressivoFattura": "0"}]}}';
               
       ApiRest__c test2 = new ApiRest__c(Method__c = 'POST' ,
                                           Test_Response__c= response ,
                                           Test_Request__c = 'testRequest',
                                            Mock__c = false, 
                                            User__c = 'CDSLF00',
                                            Password__c = 'P00FLSDC' ,
                                            Name ='recuperaMovimentiCpay',
                                            EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');  

    insert test2;
    }

    @IsTest
    static void invoketest(){
        Test.startTest();
        UtilityMockResponse UTM = new UtilityMockResponse();
        UTM.apiname ='recuperaMovimentiCpay';
        Test.setMock(HttpCalloutMock.class, UTM);
        RecuperaMovimentiCpayResponse response = RecuperaMovimentiCpayService.buildRecuperaMovimentiCpayRequest('1330000010', '20160101',
                                                                                                               '20160701');
        System.debug(' ****************** response '+response);
        Test.stopTest(); 
    }
    @isTest
    static void validateRequesttest(){
        Test.startTest();
        RecuperaMovimentiCpayRequest request = new  RecuperaMovimentiCpayRequest();
        request.companyType.put('value', '');
        Boolean b =  RecuperaMovimentiCpayService.validateRequest(request);
        Test.stopTest();
    }

    @isTest
    static void validateResponse(){
     Test.startTest();
    /* RecuperaMovimentiCpayResponse response = new RecuperaMovimentiCpayResponse();
     Boolean b = RecuperaMovimentiCpayService.validateResponse(response);
     System.debug(' ******** response test **'+ response.recuperaMovimentiCpayResponse.elenco); */
     String jsonString = '{"resultCode": 0,"resultMessage": "","recuperaMovimentiCpayResponse": {"elenco": [{"progressivo": "",\n'+
                 ' "causale": "","segno": "","importo": "","dataCompetenza": "","progressivoMovimento": "",\n'+
                  ' "progressivoFase": "","evento": "","flagAbbinato": "","tipoMovimento": " ","dataFattura": "",\n '+
                  ' "progressivoFattura": ""},{"progressivo": "","causale": "","segno": "","importo": "",\n'+
                  ' "dataCompetenza": "","progressivoMovimento": "","progressivoFase": "","evento": "",\n'+
                  ' "flagAbbinato": "","tipoMovimento": " ","dataFattura": "", "progressivoFattura": ""}]}}';
     RecuperaMovimentiCpayResponse response = (RecuperaMovimentiCpayResponse) JSON.deserializeStrict(jsonString, RecuperaMovimentiCpayResponse.class);
     System.debug('*********** validateResponse  '+response);
     Boolean b = RecuperaMovimentiCpayService.validateResponse(response);
     Test.stopTest();

    }
    @isTest
    static void eliminandoDividendo(){
     Test.startTest();

     Test.stopTest();

    }
}