/**
*@author 		Mame bousso kane
*created 		19/09/2019
*descripttion 	test of the AppuntamentoListaFilial class
*/
@isTest
public with sharing class AppuntamentoListaFilialiTest {
    @testSetup 
    static void testSetup() {
    Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName()
                  .get('Branch').getRecordTypeId();
    Account acct2= new Account(Name='test', RecordTypeId = recordTypeId);
    insert acct2;
	}

     @isTest
    static void testListFiliali(){
   
        Test.startTest();
   		RestRequest req = new RestRequest();
   		RestResponse response = new RestResponse();
   		req.requestURI ='/services/apexrest/AppuntamentoListaFiliali/';
       	RestContext.request = req;
   		RestContext.response = response;        
   		AppuntamentoListaFiliali.listFilialis();
   		Test.stopTest();
    }
}