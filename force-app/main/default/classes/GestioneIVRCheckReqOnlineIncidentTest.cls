@isTest
public with sharing class GestioneIVRCheckReqOnlineIncidentTest {



 	@isTest
    static void testCheckCase(){	        

            XCS_Categoria__c categ = new XCS_Categoria__c(Name='Ivr Dinamico Collector', External_Id__c =  GestioneIVRCheckReqOnlineIncident.CATEG_RICHIESTE_ONLINE);
            insert categ;

            Case c = new Case();
            c.Status = 'New';
            c.Subject = 'Test';
            c.Esito__c='Esit';   
            c.Categoria_Riferimento__c = categ.id;
 	    insert c;

            c = [SELECT ID, CaseNumber FROM Case WHERE ID=:c.id];

            Test.startTest();
	    RestRequest req = new RestRequest();
	    req.requestUri ='https://localhost/services/apexrest/ivr_checkonlinecase?id='+c.CaseNumber;
	    req.httpMethod = 'GET';
            req.addHeader('Content-Type', 'application/json'); 
	    RestContext.request = req;
            Integer esito = GestioneIVRCheckReqOnlineIncident.checkOnLineCase();	        
	    System.assertEquals(1,esito); // incident presente
            req.requestUri ='https://localhost/services/apexrest/ivr_checkonlinecase?id=0';
	    RestContext.request = req;
            esito = GestioneIVRCheckReqOnlineIncident.checkOnLineCase();	        
	    System.assertEquals(0,esito); // incident NON presente
            Test.stopTest();   
     }}