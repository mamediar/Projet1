/**
*@author 		Mame bousso kane
*created 		19/08/2019
*descripttion 	test of the AppuntamentoListaFilial class
*/
@isTest
public class AppuntamentoListaComuniTest {

    @testSetup 
    static void testSetup() {
      XCS_Town__c xcsTown= new XCS_Town__c(Catastale__c='A001', Comune__c='',Provincia_Desc__c='PADOVA');
      insert xcsTown;
	}
    
     @isTest
    static void testListComuni(){
   
        Test.startTest();
   		RestRequest req = new RestRequest();
   		RestResponse response = new RestResponse();
   		req.requestURI ='/services/apexrest/AppuntamentoListaComuni/PADOVA';
   		req.requestBody = Blob.valueOf('PADOVA');
       	RestContext.request = req;
   		RestContext.response = response;        
   		AppuntamentoListaComuni.listComuni();
   		Test.stopTest();
    }
}