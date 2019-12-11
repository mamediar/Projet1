/**
*@author 		Mame bousso kane
*created 		19/09/2019
*descripttion 	test of the AppuntamentoListaFilialiService class
*/
@isTest
public class AppuntamentoListaFilialiServiceTest {
	@testSetup 
    static void testSetup() {
        //List<SObject> aList = Test.loadData(Account.sObjectType,'FILIALE');
	}
    
    @isTest
    static void testBuildAppuntamentoListaFiliali(){
        Test.startTest();
        AppuntamentoListaFilialiService filiali= new AppuntamentoListaFilialiService();
 		AppuntamentoListaFilialiResponse response= filiali.buildAppuntamentoListaFiliali('test','test','test');

   		Test.stopTest();
    }
    
    @isTest
    static void testValidteResponse(){
        Test.startTest();
        AppuntamentoListaFilialiResponse response = new AppuntamentoListaFilialiResponse();
        AppuntamentoListaFilialiService filiali= new AppuntamentoListaFilialiService();
 		Boolean resp= filiali.validteResponse(response);

   		Test.stopTest();
    }
    
    @isTest
    static void testValidteRequest(){
        Test.startTest();
        AppuntamentoListaFilialiRequest request = new AppuntamentoListaFilialiRequest();
        AppuntamentoListaFilialiService filiali= new AppuntamentoListaFilialiService();
 		Boolean response= filiali.validteRequest(request);

   		Test.stopTest();
    }
    
}