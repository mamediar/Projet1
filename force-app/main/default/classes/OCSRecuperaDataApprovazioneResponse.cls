public class OCSRecuperaDataApprovazioneResponse extends OCSResponse {
        @AuraEnabled
        public RecuperaDataApprovazioneResponse recuperaDataApprovazioneResponse {get; set;}
        
        public OCSRecuperaDataApprovazioneResponse()
        {
           recuperaDataApprovazioneResponse = new RecuperaDataApprovazioneResponse();            
        }
        public class RecuperaDataApprovazioneResponse{    
             @AuraEnabled	
            public String dataApprovazione {get; set;}            
        }
    }