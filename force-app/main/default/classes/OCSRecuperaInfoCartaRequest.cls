public class OCSRecuperaInfoCartaRequest extends OCSRequest {
    public RecuperaInfoCartaRequest recuperaInfoCartaRequest {get; set;}
    
    //oggetto serviceId-recuperaInfoCarta
    public OCSRecuperaInfoCartaRequest()
    {
        serviceId = 'recuperaInfoCarta';
        recuperaInfoCartaRequest = new RecuperaInfoCartaRequest();
    }
    
    public class RecuperaInfoCartaRequest {
        //mappa companyType con coppia value-COMPASS ereditato da OCSRequest
        
        //mappa recuperaInfoCarta con coopie nunCarta-numero e emettitore-:
        public string numCarta {get; set;}
        public string emettitore {get; set;}
    }  
}