@isTest
public with sharing class GestioneIVRRetentionIVRTest {
    
    @TestSetup
    static void makeData(){
        //String response1 = '{"resultCode": 0,"resultMessage": "Ok","recuperaDatiRetentionResponse": {"elencoPratiche": [{"tipoPratica": "CO","numPratica": "16132993","statoPratica": "91","attributoPratica": "","dataPrimaScadenza": "20160615","dataUltimaScadenza": "20210515","codProdotto": "PE","desProdotto": "Prestiti con estinzione","modalitaPagamento": "RI","importoFinanziato": "3000000","montante": "3115800","saldoPratica": "0","dataEstinzione": "20180821","dataLiquidazione": "20160503","codCliente": "10963362","agente": "12"}]}}';
        String response1 = '{"resultCode": 0,"resultMessage": "Ok","recuperaDatiRetentionResponse": {"elencoPratiche": [{"tipoPratica": "CO","numPratica": "16132993","dataUltimaScadenza": "20210515","codProdotto": "PE","codCliente": "10963362"}]}}';
        ApiRest__c rest1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c=response1, Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,ref__c = 'CompassInternal',Name ='ocs.recuperaDatiRetention',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
        ApiUtil__c uti = new ApiUtil__c(Name = 'CompassInternal' ,EndPoint__c ='https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute' ,Password__c = 'P00FLSDC',User__c = 'CDSLF00');      
        insert rest1;
        insert uti;	 
        
        String response2 = '{"resultCode":0,"resultMessage":"Ok","pratiche":[{"numPratica":"12867779","codCliente":"7064531","abi":"3015","cab":"3200","numConto":"000004004925"}]}';
 		ApiRest__c rest2 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c=response2, Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,ref__c = 'CompassInternal',Name ='ocs.recuperaDatiPostVendita',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
		insert rest2;
        
        XCS_Disposition__c disposition1 = new XCS_Disposition__c(Name='xxx', External_Id__c = GestioneIVRRetentionIVR.DIS_RETENTION_INSERITA);
        insert disposition1;
        XCS_Categoria__c categ = new XCS_Categoria__c(Name='backonff_inbound', External_Id__c = GestioneIVRRetentionIVR.CAT_BKOFFICE_INBOUND);
        insert categ;
        
        
        Case c = new Case();
        c.Status = 'New';
        c.Subject = 'Test';
        c.Esito__c='Esit';   
        c.Categoria_Riferimento__c = categ.id;    
        c.NumeroPratica__c = '0001';
        insert c;
        
        
        
        CRM_Retention__c crm_retention = new CRM_Retention__c(Utente__c = 'Franco',Case__c = c.id);
        insert crm_retention;
        
    }
    
    
    private  static void setRestRequestResponse(GestioneIVRRetentionIVR.RetentionRequest request){
        String myJSON = JSON.serialize(request);
        RestRequest req = new RestRequest();
        req.requestUri ='https://compass--dev.my.salesforce.com/services/apexrest/ivr_retention';
        req.httpMethod = 'POST';
        req.addHeader('Content-Type', 'application/json'); 
        req.requestBody = Blob.valueOf(myJSON);
        RestContext.request = req;
        RestContext.response = new RestResponse();
        
    }
    
    
    @isTest
    static void testRetention1(){	        
        // case esistente per pratica
        Test.startTest();
        GestioneIVRRetentionIVR.RetentionRequest request = new GestioneIVRRetentionIVR.RetentionRequest('0001','WE',1);
        setRestRequestResponse(request);
        system.assertEquals(0, GestioneIVRRetentionIVR.retention('0001','WE',1));
        Test.stopTest();   
    }
    
    @isTest
    static void testRetention2(){	        
        
        Account acc = new Account(
            Name = 'MARIO ROSSI',                        
            Data_Nascita__c = Date.valueOf('1944-08-23'),
            Utilizzato_per_Reclami__c = false,           
            COM_NumeroTotali_Pratiche__c = '0',          
            Customer_Type__c = 'Compass',
            OCS_External_Id__c ='C10963362',
            Codice_Cliente__c ='10963362'
            
        );
        insert acc;
        
        Account_Retention__c accRetention = new Account_Retention__c(Name='AccRet',Esito__c = 'GIO',Customer__c = acc.id);
        insert accRetention;
        
        Test.startTest();
        GestioneIVRRetentionIVR.RetentionRequest request = new GestioneIVRRetentionIVR.RetentionRequest('16132993','CO',1);
        setRestRequestResponse(request);
        UtilityMockResponse UMR = new UtilityMockResponse();
        UMR.apiname='ocs.recuperaDatiRetention';
        Test.setMock(HttpCalloutMock.class,UMR);
        GestioneIVRRetentionIVR.retention('16132993','CO',1); 
        system.assertEquals(0, GestioneIVRRetentionIVR.retention('0001','WE',1));	        
        
        Test.stopTest();   
    }
    
    @isTest
    static void testRetention3(){	        
        
        Account acc = new Account(
            Name = 'MARIO ROSSI',                        
            Data_Nascita__c = Date.valueOf('1944-08-23'),
            Utilizzato_per_Reclami__c = false,           
            COM_NumeroTotali_Pratiche__c = '0',          
            Customer_Type__c = 'Compass',				
            OCS_External_Id__c ='C11111111'			
        );
        insert acc;
        
        Account acc2 = new Account(
            Name = 'MARIO BIANCHI',                        
            Data_Nascita__c = Date.valueOf('1944-08-23'),
            Utilizzato_per_Reclami__c = false,           
            COM_NumeroTotali_Pratiche__c = '0',          
            Customer_Type__c = 'Compass',
            OCS_External_Id__c ='C10963362'			
        );
        insert acc2;
        
        Account_Retention__c accRetention = new Account_Retention__c(Name='AccRet',Esito__c = 'UPS',Customer__c = acc2.id);
        insert accRetention;
        
        Test.startTest();
        GestioneIVRRetentionIVR.RetentionRequest request = new GestioneIVRRetentionIVR.RetentionRequest('16132993','CO',1);
        setRestRequestResponse(request);
        UtilityMockResponse UMR = new UtilityMockResponse();
        UMR.apiname='ocs.recuperaDatiRetention';
        Test.setMock(HttpCalloutMock.class,UMR);
        // 10963362 codiceCliente Mock
        GestioneIVRRetentionIVR.retention('16132993','CO',1); 
        
        Test.stopTest();   
    }
    
    @isTest
    static void testRetention4(){	        
        
        Account acc = new Account(
            Name = 'MARIO ROSSI',                        
            Data_Nascita__c = Date.valueOf('1944-08-23'),
            Utilizzato_per_Reclami__c = false,           
            COM_NumeroTotali_Pratiche__c = '0',          
            Customer_Type__c = 'Compass',				
            OCS_External_Id__c ='C11111111'			
        );
        insert acc;
        
        Account acc2 = new Account(
            Name = 'MARIO BIANCHI',                        
            Data_Nascita__c = Date.valueOf('1944-08-23'),
            Utilizzato_per_Reclami__c = false,           
            COM_NumeroTotali_Pratiche__c = '0',          
            Customer_Type__c = 'Compass',
            OCS_External_Id__c ='C10963363'			
        );
        insert acc2;
        
       	Account_Retention__c accRetention = new Account_Retention__c(Name='AccRet',Esito__c = 'ESP',Customer__c = acc.id);
        insert accRetention;
        
        Test.startTest();        
        ApiUtil__c uti = new ApiUtil__c(Name = 'CompassInternal' ,EndPoint__c ='https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute' ,Password__c = 'P00FLSDC',User__c = 'CDSLF00');      
        
        GestioneIVRRetentionIVR.RetentionRequest request = new GestioneIVRRetentionIVR.RetentionRequest('16132993','CO',1);
        setRestRequestResponse(request);
        UtilityMockResponse UMR = new UtilityMockResponse();
        UMR.apiname='ocs.recuperaDatiRetention';
        Test.setMock(HttpCalloutMock.class,UMR);
        
        system.debug('@@@RSP: '+request);
        system.assertEquals(0, GestioneIVRRetentionIVR.retention('16132993','CO',1));
        Test.stopTest();
          
    }
    
        @isTest
    static void testRetention5(){	        
        
        Account acc = TestDataFactory.insertAccount();
       	Account_Retention__c accRetention = new Account_Retention__c(Name='AccRet',Esito__c = 'ESP',Customer__c = acc.id,Prt1__c='NO|18005991');
        insert accRetention;
        
        Test.startTest();        
        system.assertEquals(false, GestioneIVRRetentionIVR.findPratichePartner(accRetention));
        Test.stopTest();
          
    }
    
    
}