@isTest
public with sharing class GestioneIVRCustomerCollectorDataTest {
  
   @TestSetup
   static void makeData(){
	   	XCS_CompassParameters__c  xcsCompass = new XCS_CompassParameters__c(Name = 'ivr.maxcall', Value__c = '3');
		insert xcsCompass;
		Collectors__c collector = new Collectors__c(Ragione_Sociale__c = 'srl', Telefono__c = '07293034',Rnt_Code__c = '729342');
		insert collector;
		Account acc = new Account(name = 'Test',OCS_External_id__c = 'C082394234');
		insert acc;

   }  
 

     private  static void setRestRequestResponse(GestioneIVRCustomerCollectorData.CustomerCollectorDataRequest request){

	        String myJSON = JSON.serialize(request);
	        RestRequest req = new RestRequest();
	        req.requestUri ='https://localhost/services/apexrest/ivr_customerCollectorData';
	        req.httpMethod = 'POST';
            req.addHeader('Content-Type', 'application/json'); 
	        req.requestBody = Blob.valueOf(myJSON);
	        RestContext.request = req;
			RestContext.response = new RestResponse();

     }


  	@isTest
    static void testCallcollectorData(){	        
            
			Test.startTest();
	        GestioneIVRCustomerCollectorData.CustomerCollectorDataRequest request = new GestioneIVRCustomerCollectorData.CustomerCollectorDataRequest('92034234234','2340092','P1','082394234','729342','0');
            setRestRequestResponse(request);
            GestioneIVRCustomerCollectorData.doPost('92034234234','2340092','P1','082394234','729342','0');	  
            Test.stopTest();   
			String body =RestContext.response.responseBody.toString();
			System.Assert(body.contains(GestioneIVRCustomerCollectorData.OK));      
     }	             

	@isTest
    static void testCallcollectorError(){	        
            
			Test.startTest();
	        GestioneIVRCustomerCollectorData.CustomerCollectorDataRequest request = new GestioneIVRCustomerCollectorData.CustomerCollectorDataRequest(null,null,'P1','082394234','729342','0');
			setRestRequestResponse(request);
            GestioneIVRCustomerCollectorData.doPost(null,null,'P1','082394234','729342','0');
            Test.stopTest();   
			String body =RestContext.response.responseBody.toString();
			System.Assert(body.contains(GestioneIVRCustomerCollectorData.ERROR_PARAMETERS));      	        
     }


	@isTest
    static void testMovimentazioneIndividuata(){	        

			IVR_CTI_Collector__c ivrCtiCollector1 = new IVR_CTI_Collector__c(Phone_call_UUID__c ='0001',Numero_Pratica__c='0001',Tipo_Pratica__c ='CA',Flag_Mossa__c = true);
			insert ivrCtiCollector1;           
			Test.startTest();
	        GestioneIVRCustomerCollectorData.CustomerCollectorDataRequest request = new GestioneIVRCustomerCollectorData.CustomerCollectorDataRequest('10000','0001','CA','082394234','729342','1');
			setRestRequestResponse(request);
            GestioneIVRCustomerCollectorData.doPost('10000','0001','CA','082394234','729342','1');
            Test.stopTest();   
			String body =RestContext.response.responseBody.toString();
			System.Assert(body.contains(GestioneIVRCustomerCollectorData.MOVIMENTAZIONE_INDIVIDUATA));      	        
     }


	@isTest
    static void testSogliaRaggiunta(){	        
			IVR_CTI_Collector__c ivrCtiCollector1 = new IVR_CTI_Collector__c(Phone_call_UUID__c ='0001',Numero_Pratica__c='0002',Tipo_Pratica__c ='CA');
			IVR_CTI_Collector__c ivrCtiCollector2 = new IVR_CTI_Collector__c(Phone_call_UUID__c ='0002',Numero_Pratica__c='0002',Tipo_Pratica__c ='CA');
			IVR_CTI_Collector__c ivrCtiCollector3 = new IVR_CTI_Collector__c(Phone_call_UUID__c ='0003',Numero_Pratica__c='0002',Tipo_Pratica__c ='CA');
			IVR_CTI_Collector__c ivrCtiCollector4 = new IVR_CTI_Collector__c(Phone_call_UUID__c ='0003',Numero_Pratica__c='0002',Tipo_Pratica__c ='CA');
			insert ivrCtiCollector1;
			insert ivrCtiCollector2;
			insert ivrCtiCollector3;
			insert ivrCtiCollector4;
           
			Test.startTest();
	        GestioneIVRCustomerCollectorData.CustomerCollectorDataRequest request = new GestioneIVRCustomerCollectorData.CustomerCollectorDataRequest('10000','0002','CA','082394234','729342','0');
			setRestRequestResponse(request);
            GestioneIVRCustomerCollectorData.doPost('10000','0002','CA','082394234','729342','0');	        
            Test.stopTest();   
			String body =RestContext.response.responseBody.toString();
			System.Assert(body.contains(GestioneIVRCustomerCollectorData.SOGLIA_RAGGIUNTA));      	        

     }


	@isTest
    static void testCallcollectorErrorInInsert(){	        
            
			Test.startTest();
	        GestioneIVRCustomerCollectorData.CustomerCollectorDataRequest request = new GestioneIVRCustomerCollectorData.CustomerCollectorDataRequest('92034234234','1234567890123456789012','P1','082394234','729342','0');
            setRestRequestResponse(request);
            GestioneIVRCustomerCollectorData.doPost('92034234234','1234567890123456789012','P1','082394234','729342','0');	        
            Test.stopTest();   
     }


}