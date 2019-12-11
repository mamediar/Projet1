@isTest
public  class RecuperaMovAutViaggiantiTest {

    @TestSetup
    static void makeData(){
  String response = '{"resultCode": 0, "resultMessage": "Ok", "recuperaMovimentiAutorizzazioniViaggiantiResponse" : {\n'
  +' "recuperaMovViaggiantiResponse": { "elencoMovimenti": [],"as400Status": null, "as400Errore": null}}}' ;                            
  
 /*  String response = '{"resultCode": 0, "resultMessage": "Ok", "recuperaMovimentiAutorizzazioniViaggiantiResponse" : {\n'
  +' "recuperaMovViaggiantiResponse": { "elencoMovimenti": [],"as400Status": null, "as400Errore": null},\n'
  +'  "recuperaAutViaggiantiResponse": {"elencoAutorizzazioni": [{ "autorizzazione": "422874","data": "20160812","ora": "203001","intermediario": "2438468", \n'
  + ' "codEsercente": "POP EMILIA PAGL","desEsercente": "","importo": "25000","importoSegno": "","importoDivisaEstera": "25000","divisa": "978","stato": "C","esito": "A",\n'
  + '  "codAzione": "000",  "desAzione": "approved"  }],  "progressivoAutorizazione": "004","as400Status": null,"as400Errore": ""}}}' ;                            */
   
   ApiRest__c api = new ApiRest__c(Method__c = 'POST' ,
                                           Test_Response__c= response ,
                                           Test_Request__c = 'testRequest',
                                            Mock__c = false, 
                                            User__c = 'CDSLF00',
                                            Password__c = 'P00FLSDC' ,
                                            Name ='ocs.recuperaMovAutViaggianti',
                                            EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');  

    insert api;
    }
    
@IsTest
static void invoketest(){
        
    Test.startTest();
    UtilityMockResponse UTM = new UtilityMockResponse();
    UTM.apiname ='ocs.recuperaMovAutViaggianti';
    Test.setMock(HttpCalloutMock.class, UTM);
    RecuperaMovAutViaggiantiResponse response =
    RecuperaMovAutViaggiantiService.buildRecuperaMovAutViaggiantRequest('CA', 'AG', '12', '', '32184278299',  
                                                          '', '', '', '','', '',  '', '','', '','', 'N', 'S', '');
    System.debug(' ********************* response **************** '+response);     
    // System.debug(' ******* recuperaMovViaggiantiResponse '+response.recuperaMovViaggiantiResponse.recuperaMovViaggiantiResponse);                                                                     
    //   System.assertEquals(0, response, 'pass');
    System.debug('***************** resulrtCode ********** '+ response.resultCode);
    System.debug('***************** resultCodeMessage ********** '+ response.resultMessage );
    //  System.assertEquals('OK', response.resultMessage , 'pass'); 

    System.assertEquals(0, response.resultCode, '*** pass ** ');
    //  System.assertEquals('OK', response.resultMessage, 'succes');
    Test.stopTest();
        
    }

@isTest
static void validateRequesttest(){

   Test.startTest();
   RecuperaMovAutViaggiantiRequest request = new RecuperaMovAutViaggiantiRequest();
   request.companyType.put('value','');
  // request.recuperaMovimentiAutorizzazioniViaggiantiRequest = null;
   Boolean b = RecuperaMovAutViaggiantiService.validateRequest(request);
   System.debug(RecuperaMovAutViaggiantiService.errors);
   System.debug('*********** test '+request.recuperaMovimentiAutorizzazioniViaggiantiRequest);

   System.assert(b);
   System.assert(RecuperaMovAutViaggiantiService.errors.size() >  0 );
  
    Test.stopTest();
}

@isTest
static void validateResponse(){
 Test.startTest();
    String chaine = '{"resultCode": 0,"resultMessage": "Ok","recuperaMovimentiAutorizzazioniViaggiantiResponse": {"recuperaMovViaggiantiResponse": { \n'+
    ' "elencoMovimenti": [ {"dataOperazione":"","dataValuta":"","causale":"","importo":"","importoSegno":"","dareAvere":"","tipoMov":"","esercente":"","citta":"","nazione":"","catMerc":""}],\n'+
    ' "as400Status": null,"as400Errore": null},"recuperaAutViaggiantiResponse": {"elencoAutorizzazioni": [ \n'+
    '{"autorizzazione": "422874","data": "20160812","ora": "203001","intermediario": "2438468","codEsercente": "POP EMILIA PAGL", \n'+
    ' "desEsercente": "","importo": "25000", "importoSegno": "","importoDivisaEstera": "25000","divisa": "978","stato": "C","esito": "A",\n '+
    ' "codAzione": "000","desAzione": "approved"},{"autorizzazione": "218493","data": "20160520","ora": "104030","intermediario": "12",\n'+
    ' "codEsercente": "","desEsercente": "","importo": "50000", "importoSegno": "","importoDivisaEstera": "0","divisa": "","stato": "C", \n'+
    ' "esito": "A","codAzione": "","desAzione": ""}],"progressivoAutorizazione": "004","as400Status": null,"as400Errore": ""}}}}';
    RecuperaMovAutViaggiantiResponse response1 = (RecuperaMovAutViaggiantiResponse) JSON.deserializeStrict(chaine, RecuperaMovAutViaggiantiResponse.class);

    System.debug('************ la chaine **** '+response1);
    System.debug('************ resp '+response1.recuperaMovimentiAutorizzazioniViaggiantiResponse.recuperaAutViaggiantiResponse.elencoAutorizzazioni);
    System.debug('************ resp '+response1.recuperaMovimentiAutorizzazioniViaggiantiResponse.recuperaAutViaggiantiResponse.progressivoAutorizazione);
    System.debug('************ resp '+response1.recuperaMovimentiAutorizzazioniViaggiantiResponse.recuperaAutViaggiantiResponse.as400Errore);
    System.debug('************ resp '+response1.recuperaMovimentiAutorizzazioniViaggiantiResponse.recuperaAutViaggiantiResponse.as400Status);
    System.debug('************ resp '+response1.recuperaMovimentiAutorizzazioniViaggiantiResponse.recuperaMovViaggiantiResponse.as400Status );
    System.debug('************ resp '+response1.recuperaMovimentiAutorizzazioniViaggiantiResponse.recuperaMovViaggiantiResponse.as400Errore );
    System.debug('************ resp '+response1.recuperaMovimentiAutorizzazioniViaggiantiResponse.recuperaMovViaggiantiResponse.elencoMovimenti );
    System.debug('************ resp '+response1.recuperaMovimentiAutorizzazioniViaggiantiResponse.recuperaAutViaggiantiResponse.elencoAutorizzazioni[0].desAzione);
    System.debug('************ resp '+response1.recuperaMovimentiAutorizzazioniViaggiantiResponse.recuperaAutViaggiantiResponse.elencoAutorizzazioni[0].desEsercente);
    System.debug('************ resp '+response1.recuperaMovimentiAutorizzazioniViaggiantiResponse.recuperaAutViaggiantiResponse.elencoAutorizzazioni[0].divisa);
    System.debug('************ resp '+response1.recuperaMovimentiAutorizzazioniViaggiantiResponse.recuperaAutViaggiantiResponse.elencoAutorizzazioni[0].esito);
    System.debug('************ resp '+response1.recuperaMovimentiAutorizzazioniViaggiantiResponse.recuperaAutViaggiantiResponse.elencoAutorizzazioni[0].importo);
    System.debug('************ resp '+response1.recuperaMovimentiAutorizzazioniViaggiantiResponse.recuperaAutViaggiantiResponse.elencoAutorizzazioni[0].importoSegno);
    System.debug('************ resp '+response1.recuperaMovimentiAutorizzazioniViaggiantiResponse.recuperaAutViaggiantiResponse.elencoAutorizzazioni[0].intermediario);
    System.debug('************ resp '+response1.recuperaMovimentiAutorizzazioniViaggiantiResponse.recuperaAutViaggiantiResponse.elencoAutorizzazioni[0].ora);
    System.debug('************ resp '+response1.recuperaMovimentiAutorizzazioniViaggiantiResponse.recuperaAutViaggiantiResponse.elencoAutorizzazioni[0].stato);
    System.debug('************ resp '+response1.recuperaMovimentiAutorizzazioniViaggiantiResponse.recuperaAutViaggiantiResponse.elencoAutorizzazioni[0].autorizzazione);
    System.debug('************ resp '+response1.recuperaMovimentiAutorizzazioniViaggiantiResponse.recuperaAutViaggiantiResponse.elencoAutorizzazioni[0].data);
    System.debug('************ resp '+response1.recuperaMovimentiAutorizzazioniViaggiantiResponse.recuperaAutViaggiantiResponse.elencoAutorizzazioni[0].importoDivisaEstera);
    System.debug('************ resp '+response1.recuperaMovimentiAutorizzazioniViaggiantiResponse.recuperaAutViaggiantiResponse.elencoAutorizzazioni[0].codAzione);
    System.debug('************ resp '+response1.recuperaMovimentiAutorizzazioniViaggiantiResponse.recuperaAutViaggiantiResponse.elencoAutorizzazioni[0].codEsercente);
    System.debug('************ resp '+response1.recuperaMovimentiAutorizzazioniViaggiantiResponse.recuperaMovViaggiantiResponse.elencoMovimenti[0].causale);
    System.debug('************ resp '+response1.recuperaMovimentiAutorizzazioniViaggiantiResponse.recuperaMovViaggiantiResponse.elencoMovimenti[0].citta );
    System.debug('************ resp '+response1.recuperaMovimentiAutorizzazioniViaggiantiResponse.recuperaMovViaggiantiResponse.elencoMovimenti[0].dareAvere );
    System.debug('************ resp '+response1.recuperaMovimentiAutorizzazioniViaggiantiResponse.recuperaMovViaggiantiResponse.elencoMovimenti[0].importo );
    System.debug('************ resp '+response1.recuperaMovimentiAutorizzazioniViaggiantiResponse.recuperaMovViaggiantiResponse.elencoMovimenti[0].importoSegno );
    System.debug('************ resp '+response1.recuperaMovimentiAutorizzazioniViaggiantiResponse.recuperaMovViaggiantiResponse.elencoMovimenti[0].tipoMov );
    System.debug('************ resp '+response1.recuperaMovimentiAutorizzazioniViaggiantiResponse.recuperaMovViaggiantiResponse.elencoMovimenti[0].esercente );
    System.debug('************ resp '+response1.recuperaMovimentiAutorizzazioniViaggiantiResponse.recuperaMovViaggiantiResponse.elencoMovimenti[0].catMerc );
    System.debug('************ resp '+response1.recuperaMovimentiAutorizzazioniViaggiantiResponse.recuperaMovViaggiantiResponse.elencoMovimenti[0].dataOperazione );
    System.debug('************ resp '+response1.recuperaMovimentiAutorizzazioniViaggiantiResponse.recuperaMovViaggiantiResponse.elencoMovimenti[0].dataValuta );
    System.debug('************ resp '+response1.recuperaMovimentiAutorizzazioniViaggiantiResponse.recuperaMovViaggiantiResponse.elencoMovimenti[0].nazione );
    System.assertNotEquals(null, response1.recuperaMovimentiAutorizzazioniViaggiantiResponse.recuperaAutViaggiantiResponse.elencoAutorizzazioni, '** pass **');
    Test.stopTest();
}

@isTest
static void validateResp(){
Test.startTest();
RecuperaMovAutViaggiantiResponse response =  new RecuperaMovAutViaggiantiResponse();
System.debug(' ****************** validateResp '+response.recuperaMovimentiAutorizzazioniViaggiantiResponse.recuperaMovViaggiantiResponse.elencoMovimenti);
Boolean b = RecuperaMovAutViaggiantiService.validateResponse(response);
System.assertEquals(null, response.recuperaMovimentiAutorizzazioniViaggiantiResponse.recuperaMovViaggiantiResponse.elencoMovimenti, '*** pass ***');

Test.stopTest();

}

@isTest
static void recuperaMovAutViaggiantiControltest(){
Test.startTest();
String jsonResponse = '{"resultCode": 0,"resultMessage": "Ok","recuperaMovimentiAutorizzazioniViaggiantiResponse": {\n'+
                      ' "recuperaMovViaggiantiResponse": {"elencoMovimenti": [],"as400Status": null,"as400Errore": null},\n'+
                      ' "recuperaAutViaggiantiResponse": {"elencoAutorizzazioni": [{ "autorizzazione": "422874", "data": "20160812",\n'+
                    '"ora": "203001","intermediario": "2438468","codEsercente": "POP EMILIA PAGL", "desEsercente": "","importo": "25000",\n'+
                    '"importoSegno": "","importoDivisaEstera": "25000",  "divisa": "978","stato": "C", "esito": "A","codAzione": "000",\n'+
                    ' "desAzione": "approved" }, {"autorizzazione": "418385", "data": "20160811", "ora": "110912","intermediario": "2438468",\n'+
                    ' "codEsercente": "POP EMILIA LANC", "desEsercente": "", "importo": "25000","importoSegno": "","importoDivisaEstera": "25000",\n'+
                    ' "divisa": "978",  "stato": "C", "esito": "A", "codAzione": "000","desAzione": "approved"},{  "autorizzazione": "391000",\n'+
                   ' "data": "20160801","ora": "95713", "intermediario": "2438468", "codEsercente": "C R DELLA PROVI", "desEsercente": "","importo": "25000",\n'+
                  
                    '"importoSegno": "", "importoDivisaEstera": "25000",  "divisa": "978", "stato": "C", "esito": "A", "codAzione": "000",\n'+
                   '  "desAzione": "approved"  },\n'+
                 '{  "autorizzazione": "218493", "data": "20160520", "ora": "104030", "intermediario": "12", "codEsercente": "", "desEsercente": "",\n'+
                 ' "importo": "50000", "importoSegno": "", "importoDivisaEstera": "0",  "divisa": "","stato": "C", "esito": "A",\n'+
                 ' "codAzione": "", "desAzione": ""  } ],"progressivoAutorizazione": "004", "as400Status": null, "as400Errore": "" }  }}';

 RecuperaMovAutViaggiantiResponse response = (RecuperaMovAutViaggiantiResponse) JSON.deserialize(jsonResponse, RecuperaMovAutViaggiantiResponse.class); 

Map<String,Object> returnValue =  RecuperaMovAutViaggiantiService.recuperaMovAutViaggiantiControl(response);
System.debug('************** map '+ returnValue);
Test.stopTest();

}
}