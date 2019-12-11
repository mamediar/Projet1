@isTest
public class OCSRecuperaRetentionCarteResponseTest 
{
    @isTest
    public static void instanceObject()
    {
        OCSRecuperaRetentionCarteResponse res = new OCSRecuperaRetentionCarteResponse();
        OCSRecuperaRetentionCarteResponse.CartaResponse car = new OCSRecuperaRetentionCarteResponse.CartaResponse();
        car.bloccoCarta = '';
        car.esitoRetention = '';
        car.numCarta = '';
        car.prodottoAttributo = '';
        car.prodottoCarta = '';
        car.statoCarta = '';
        car.valoreRetention = '';
        res.RecuperaRetentionCarteResponse.elencoCarte.add(car);
    }    
}