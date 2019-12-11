/**
*@author 		Mame bousso kane
*created 		19/09/2019
*descripttion 	test of the AppuntamentoListaFilialiRequest class
*/
@isTest
public class AppuntamentoListaFilialiRequestTest {
	@isTest
    static void test(){
        Test.startTest();
        AppuntamentoListaFilialiRequest request = new AppuntamentoListaFilialiRequest('','');
   		Test.stopTest();
    }
    //Map<String, String> getParametri()
    @isTest
    static void testGetParametri(){
        Test.startTest();
        AppuntamentoListaFilialiRequest request = new AppuntamentoListaFilialiRequest('','');
        Map<String, String> valueReturn = request.getParametri();
   		Test.stopTest();
    }
}