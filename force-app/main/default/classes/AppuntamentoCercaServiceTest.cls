/**
*@author 		Mame bousso kane
*created 		16/08/2019
*descripttion 	test of the AppuntamentoCercaService class
*/
@isTest
public class AppuntamentoCercaServiceTest {
    
	@isTest
    static void testBuildAppuntamentoCerca(){
        String  societa ='' ;
        String  utenteEsterno ='' ;
        String  utenteInterno ='' ;
        String  codiceFiscale ='' ;
        AppuntamentoCercaService appuntamentoCercaService = new AppuntamentoCercaService();
        AppuntamentoCercaResponse response = appuntamentoCercaService.buildAppuntamentoCerca(societa,utenteEsterno,utenteInterno,codiceFiscale);
    }
    
    @isTest
    static void testInvoker(){
        AppuntamentoCercaRequest request=new AppuntamentoCercaRequest();
        AppuntamentoCercaService appuntamentoCercaService = new AppuntamentoCercaService();
        AppuntamentoCercaResponse response = appuntamentoCercaService.invoker(request);
    }
}