@isTest
public class OCSRecuperaDatiPostvenditaResponseTest {
    
    @isTest
    public static void test() {
        
        OCSRecuperaDatiPostVenditaResponse ob = new OCSRecuperaDatiPostVenditaResponse();
         
        OCSRecuperaDatiPostVenditaResponse.PSVDatiPraticaDTO[] dataTestPra = new OCSRecuperaDatiPostVenditaResponse.PSVDatiPraticaDTO[]{};
        OCSRecuperaDatiPostVenditaResponse.PSVDatiClienteDTO[] dataTestCli = new OCSRecuperaDatiPostVenditaResponse.PSVDatiClienteDTO[]{};
        OCSRecuperaDatiPostVenditaResponse.PSVDatiClienteDTO clientTest = new OCSRecuperaDatiPostVenditaResponse.PSVDatiClienteDTO();
        OCSRecuperaDatiPostVenditaResponse.PSVDatiPraticaDTO praticaTest = new  OCSRecuperaDatiPostVenditaResponse.PSVDatiPraticaDTO();
         
            
        clientTest.cap='';
        praticaTest.abi='';
        
        clientTest.getMap();
        praticaTest.getMap();
        
    }
    
}