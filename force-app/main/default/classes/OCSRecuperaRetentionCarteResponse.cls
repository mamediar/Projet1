public class OCSRecuperaRetentionCarteResponse extends OCSResponse
{
    public RecuperaRetentionCarte recuperaRetentionCarteResponse{get;set;}
    
    public OCSRecuperaRetentionCarteResponse()
    {
        recuperaRetentionCarteResponse = new RecuperaRetentionCarte();
        recuperaRetentionCarteResponse.elencoCarte = new List<CartaResponse>();
    }
    
    public class RecuperaRetentionCarte
    {
        public List<CartaResponse> elencoCarte{get; set;}
    }
    public class CartaResponse
    {
       public String numCarta {get; set;}
       public String statoCarta {get; set;}
       public String bloccoCarta {get; set;}
       public String prodottoCarta {get; set;}
       public String esitoRetention {get; set;}
       public String valoreRetention {get; set;}
       public String prodottoAttributo {get; set;}
    }
}