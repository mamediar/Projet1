public class OCSRecuperaDataApprovazioneRequest extends OCSRequest {
        
        public RecuperaDataApprovazioneRequest recuperaDataApprovazioneRequest {get; set;}
        
        public OCSRecuperaDataApprovazioneRequest()
        {
            serviceId = 'recuperaDataApprovazione';
            recuperaDataApprovazioneRequest = new RecuperaDataApprovazioneRequest();
        }
        
        public class RecuperaDataApprovazioneRequest
        {    	
            public String tipoPratica {get; set;}
            public String numPratica {get; set;}
        }
    }