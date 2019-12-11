@isTest
public with sharing class GestioneIVRCustomerSatisfactionEsitoTest {
 	
	 
	 @TestSetup
	 static void makeData(){
        ApiRest__c rest1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c='{"resultCode":0,"resultMessage":"Ok","OCSGestioneNoteResponse":{"as400Status":"Ok","as400Errore":""}}',Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,ref__c = 'CompassInternal',Name ='ocs.gestioneNote',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
        String response = '{"resultCode":0,"resultMessage":"Ok","pratiche":[{"numPratica":"800000329783","codCliente":"9529124"}],"cliente":[{"cognome":"UTMOBZE","codCliente":"9529151","nome":"LERRIO"}]}';
        ApiRest__c rest2 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Ref__c='CompassInternal', Name ='ocs.recuperaDatiPostvendita',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
        ApiUtil__c uti = new ApiUtil__c(Name = 'CompassInternal' ,EndPoint__c ='https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute' ,Password__c = 'P00FLSDC',User__c = 'CDSLF00');      
        insert rest1;
        insert rest2;
        insert uti;		 

	    Account acc = new Account(
            Name = 'MARIO ROSSI',                        
            Data_Nascita__c = Date.valueOf('1944-08-23'),
            Utilizzato_per_Reclami__c = false,           
            COM_NumeroTotali_Pratiche__c = '0',          
            Customer_Type__c = 'Compass',
            OCS_External_Id__c ='C5000',
            Codice_Cliente__c ='5000'

        );
        insert acc;

        XCS_Disposition__c disposition1 = new XCS_Disposition__c(Name='xxx', External_Id__c = GestioneIVRCustomerSatisfactionEsito.DISP_RECALL_ESITO_NEG);
        insert disposition1;
        XCS_Categoria__c categ = new XCS_Categoria__c(Name='Ivr Dinamico Collector', External_Id__c = GestioneIVRCustomerSatisfactionEsito.CATEG_BACKOFFICE_INBOUND);
        insert categ;
        Product2 prod = new Product2(Name='nessun prood',RSS_External_Id__c = GestioneIVRCustomerSatisfactionEsito.ID_NESSUN_PRODOTTO);
        insert prod;
        Group coda = new Group(Name='COD', DeveloperName = GestioneIVRCustomerSatisfactionEsito.QUEUE_SATISFATCION);
        insert coda;
      

	 }


     private  static void setRestRequestResponse(GestioneIVRCustomerSatisfactionEsito.CustomerSatistfactionRequest request){

	        String myJSON = JSON.serialize(request);
	        RestRequest req = new RestRequest();
	        req.requestUri ='https://localhost/services/apexrest/ivr_customerSatisfaction';
	        req.httpMethod = 'POST';
            req.addHeader('Content-Type', 'application/json'); 
	        req.requestBody = Blob.valueOf(myJSON);
	        RestContext.request = req;
			RestContext.response = new RestResponse();

     }
	 
	@isTest
    static void testCustomerSatisfaction(){	        
	          
            Test.startTest();
	        GestioneIVRCustomerSatisfactionEsito.CustomerSatistfactionRequest request = new GestioneIVRCustomerSatisfactionEsito.CustomerSatistfactionRequest('82930420394334','800000329783','WE','02',1,2,0,1);
            setRestRequestResponse(request);
            UtilityMockResponse UMR = new UtilityMockResponse();
            UMR.apiname='ocs.recuperaDatiPostvendita';
            Test.setMock(HttpCalloutMock.class,UMR);
            GestioneIVRCustomerSatisfactionEsito.doPost('82930420394334','800000329783','WE','02',1,1,0,1); 
            Test.stopTest();   
            String body =RestContext.response.responseBody.toString();
			System.Assert(body.contains('0'));    // OK  	        
     }

 	@isTest
    static void testCustomerSatisfaction2(){	        
	          
            Test.startTest();
	        GestioneIVRCustomerSatisfactionEsito.CustomerSatistfactionRequest request = new GestioneIVRCustomerSatisfactionEsito.CustomerSatistfactionRequest('82930420394334','800000329783','WE','03',2,1,4,4);
            setRestRequestResponse(request);
            UtilityMockResponse UMR = new UtilityMockResponse();
            UMR.apiname='ocs.recuperaDatiPostvendita';
            Test.setMock(HttpCalloutMock.class,UMR);
            GestioneIVRCustomerSatisfactionEsito.doPost('82930420394334','800000329783','WE','03',2,1,4,4); 
            Test.stopTest();   
            String body =RestContext.response.responseBody.toString();
			System.Assert(body.contains('0'));   // OK   	        
     }    


 	@isTest
    static void testCustomerSatisfactionError(){	        
	          
            Test.startTest();
 	        GestioneIVRCustomerSatisfactionEsito.CustomerSatistfactionRequest request = new GestioneIVRCustomerSatisfactionEsito.CustomerSatistfactionRequest(null,null,'WE','03',2,1,4,4);
            setRestRequestResponse(request);

            UtilityMockResponse UMR = new UtilityMockResponse();
            UMR.apiname='ocs.recuperaDatiPostvendita';
            Test.setMock(HttpCalloutMock.class,UMR);
            GestioneIVRCustomerSatisfactionEsito.doPost(null,null,'WE','03',2,1,4,4); 
            Test.stopTest();   
            String body =RestContext.response.responseBody.toString();
			System.Assert(body.contains('1'));   // ERROR  	        
	        
     }    


}