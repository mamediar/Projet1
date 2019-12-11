@isTest
public class OCSRecuperaDatiFuturoResponseTest {
    
    @isTest
    public static void test() {
        
        OCSRecuperaDatiFuturoResponse dataTest = new OCSRecuperaDatiFuturoResponse();
        dataTest.cliente = new List<OCSRecuperaDatiPostVenditaResponse.PSVDatiClienteDTO>();
        dataTest.pratiche = new OCSRecuperaDatiFuturoResponse.DatiPraticaFuturoDTO[]{};
            
        OCSRecuperaDatiFuturoResponse.DatiPraticaFuturoDTO dataPra = new OCSRecuperaDatiFuturoResponse.DatiPraticaFuturoDTO();
        dataPra.getMap();
        
        
    }
    
}