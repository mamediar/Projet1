public class OCSRecuperaMovAutViaggiantiResponse extends OCSResponse{
    
    public RecuperaMovAutViaggiantiResponseDTO recuperaMovimentiAutorizzazioniViaggiantiResponse {get; set;}
    
    public OCSRecuperaMovAutViaggiantiResponse() {        
        recuperaMovimentiAutorizzazioniViaggiantiResponse = new RecuperaMovAutViaggiantiResponseDTO();       
    }
    
    public class RecuperaMovAutViaggiantiResponseDTO {
        
        public RecuperaMovViaggiantiResponseDTO recuperaMovViaggiantiResponse;       
        public RecuperaAutViaggiantiResponseDTO recuperaAutViaggiantiResponse;

        public RecuperaMovAutViaggiantiResponseDTO() {
            recuperaMovViaggiantiResponse = new RecuperaMovViaggiantiResponseDTO();
            recuperaAutViaggiantiResponse = new RecuperaAutViaggiantiResponseDTO();
        }
  
    }
    public class RecuperaMovViaggiantiResponseDTO {
        
        @AuraEnabled public List<MovimentoViaggianteDTO> elencoMovimenti;
        public String as400Status;
        public String as400Errore;

        public RecuperaMovViaggiantiResponseDTO() {            
            List<MovimentoViaggianteDTO> elencoMovimenti = new List<MovimentoViaggianteDTO>();            
        }
        
    }
    public class MovimentoViaggianteDTO {
        
        @AuraEnabled public String dataOperazione;
        @AuraEnabled public String dataValuta;
        @AuraEnabled public String casuale;
        @AuraEnabled public String importo;
        @AuraEnabled public String importoSegno;
        @AuraEnabled public String dareAvere;
        @AuraEnabled public String tipoMov;
        @AuraEnabled public String esercente;
        @AuraEnabled public String citta;
        @AuraEnabled public String nazione;
        @AuraEnabled public String catMerc;
        
    }
    public class RecuperaAutViaggiantiResponseDTO {
        
        @AuraEnabled public List<AutorizzazioneViaggianteDTO> elencoAutorizzazioni;
        public String as400Status;
        public String as400Errore;
        public String progressivoAutorizzazione;

        public RecuperaAutViaggiantiResponseDTO() {            
            List<AutorizzazioneViaggianteDTO> elencoAutorizzazioni = new List<AutorizzazioneViaggianteDTO>();            
        }
    }
    public class AutorizzazioneViaggianteDTO {
        
        @AuraEnabled public String autorizzazione;
       // @AuraEnabled public String data;
       // @AuraEnabled public String ora;     
        @AuraEnabled public String data {get  { 
            if(data != null){
            String year = data.substring(0, 4);
            String month = data.substring(4, 6);
            String day = data.substring(6,8);            
       return (day + '/' + month + '/' + year);      
            }
            else 
                return '';
        }  set;}
        
        @AuraEnabled public String ora {get  { 
            String rightOra = '';
            if(ora.length() == 6) {
            String hours = ora.substring(0, 2);
            String minutes = ora.substring(2, 4);
            String seconds = ora.substring(4,6); 
                rightOra = (hours + ':' + minutes + ':' + seconds);
                
            }
            else if(ora.length() == 5) {
            String hours = ora.substring(0, 1);
            String minutes = ora.substring(1, 3);
            String seconds = ora.substring(3,5); 
                rightOra = ('0' + hours + ':' + minutes + ':' + seconds);
            }
            return rightOra;
        }  set;}       
        
        @AuraEnabled public String intermediario;
        @AuraEnabled public String codEsercente; 
        @AuraEnabled public String desEsercente;
        @AuraEnabled public String importo;
        @AuraEnabled public String importoSegno;
        @AuraEnabled public String importoDivisaEstera;
        @AuraEnabled public String divisa;
        @AuraEnabled public String stato;
        @AuraEnabled public String esito;
        @AuraEnabled public String codAzione;
        @AuraEnabled public String desAzione;
        
    }
    

/*
   @AuraEnabled public String data {get  { 
            String year = data.substring(0, 4);
            String month = data.substring(4, 6);
            String day = data.substring(6,8);            
       return (day + '/' + month + '/' + year);           
        }  set;}
        @AuraEnabled public String ora {get  { 
            String rightOra = '';
            if(ora.length() == 6) {
            String hours = ora.substring(0, 2);
            String minutes = ora.substring(2, 4);
            String seconds = ora.substring(4,6); 
                rightOra = (hours + ':' + minutes + ':' + seconds);
                
            }
            else if(ora.length() == 5) {
            String hours = ora.substring(0, 1);
            String minutes = ora.substring(1, 3);
            String seconds = ora.substring(3,5); 
                rightOra = ('0' + hours + ':' + minutes + ':' + seconds);
            }
            return rightOra;
        }  set;}
                                        
*/

    
}