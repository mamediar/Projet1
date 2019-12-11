@isTest
public class OCSVariazioneDatiPagamentoInvokerTest {
    
	@isTest
    static void test(){
		//-- - INIZIO MODIFICA
        //-- - Autor        : Fabio Giuliani
        //-- - Date         : 22/07/2019
        //-- - Description  : aggiunto Ref__c dentro test1, aggiunto ApiUtil__c test2 
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c='{"resultCode":0,"resultMessage":"Ok","statoPratica":"30RE"}',Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Ref__c='CompassInternal', Name ='ocs.variazioneDatiPagamento',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
       	ApiUtil__c test2 = new ApiUtil__c(Name = 'CompassInternal' ,EndPoint__c ='https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute' ,Password__c = 'P00FLSDC',User__c = 'CDSLF00');      
        insert test1;
        insert test2;
        //-- - FINE MODIFICA
        //--------------------------------------------------------------------
        test.startTest();
        UtilityMockResponse UMR = new UtilityMockResponse();
        UMR.apiname='ocs.variazioneDatiPagamento';
        Test.setMock(HttpCalloutMock.class,UMR);
        OCSVariazioneDatiPagamentoResponse crspr = OCSVariazioneDatiPagamentoInvoker.callVariazioneDatiPagamento(
        	'', // provenienza
            '', // tipo intermediario
            '', // intermediario
            '', // procedura
            '15115073713', //numeropratica
            '', // pagForma
            '', // ecFrequenza
            '', // abi
            '', // cab
            '', // cc
            '', // cinBban
            '', // cinIban
            '', // paeseIban
            '', // iban
            '', // intCc
            '', // intestConto
            '', // codiceRid
            '', // firmaSuRid
            '', // bancaInterna
            '', // pagGGValuta
            '', // lettera
            '', // tipo contatto
            '', // ammin
            '', // data iniziale
            '', // variaz Scad Rata
            '', // spese incasso
            '', // spese inc flg
            '', // codice rif ext 2
            '', // utente
            '', // pan
            '', // lunghezza pan
            ''); // data scadenza
        test.stopTest();	
    }
}