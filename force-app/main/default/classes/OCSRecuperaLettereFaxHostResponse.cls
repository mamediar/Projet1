public class OCSRecuperaLettereFaxHostResponse extends OCSResponse{
    @AuraEnabled
    public RecuperaLettereFaxHostResponseDTO recuperaLettereFaxHostResponseDTO {get; set;}
    
    public OCSRecuperaLettereFaxHostResponse(){
        recuperaLettereFaxHostResponseDTO = new RecuperaLettereFaxHostResponseDTO();
    }
    
    
    public class RecuperaLettereFaxHostResponseDTO{
        @AuraEnabled
        public List<LetteraFaxHostDTO> elencoLettere {get; set;} 
        
        
        public RecuperaLettereFaxHostResponseDTO(){
            elencoLettere = new List<LetteraFaxHostDTO>();
        }        
    }
    
    
    public class LetteraFaxHostDTO{
        @AuraEnabled
        public String procedura {get; set;}
        @AuraEnabled
        public String codCliente {get; set;}
        @AuraEnabled
        public String numPratica {get; set;}
        @AuraEnabled
        public String codLettera {get; set;}
        @AuraEnabled
        public String modalitaInvio {get; set;}
        @AuraEnabled
        public String oggettoFaxHost {get; set;}
        @AuraEnabled
        public String descrizioneFaxHost {get; set;}
        @AuraEnabled
        public String data {get; set;}
        @AuraEnabled
        public String ora {get; set;}
        @AuraEnabled
        public String operatore {get; set;}
        @AuraEnabled
        public String operatoreFaxHost {get; set;}
        @AuraEnabled
        public String numero {get; set;}
        @AuraEnabled
        public String email {get; set;}
    }
}