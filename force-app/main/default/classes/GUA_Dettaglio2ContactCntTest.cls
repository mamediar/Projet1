/**
*@author 		Mame bousso kane
*created 		04/10/2019
*descripttion 	test of the GUA_Dettaglio2ContactCnt class
*/
@isTest
public class GUA_Dettaglio2ContactCntTest {
	@isTest
    static void testGetRecuperaUtenzeIntermediario(){
        String codiceIntermediario='60757';
        String codiceUtenza='';
        Test.startTest();
    	GUA_Dettaglio2ContactCnt.getRecuperaUtenzeIntermediario(codiceIntermediario, codiceUtenza);
   		Test.stopTest();        
    }
    
    @isTest
    public static void resetPassWordTest(){
        Map<String ,Object> returnValue = GUA_Dettaglio2ContactCnt.resetPassWord('utenza');
    }
}