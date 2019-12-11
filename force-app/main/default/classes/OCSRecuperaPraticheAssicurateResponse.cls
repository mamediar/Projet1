public class OCSRecuperaPraticheAssicurateResponse extends OCSResponse{
    @AuraEnabled
    public List<PraticaAssicurataDTO> elencoPratiche;
    
    
   public OCSRecuperaPraticheAssicurateResponse(){
       this.elencoPratiche = new  List<PraticaAssicurataDTO>();
    }
    
    @AuraEnabled
    public static void init(List<PraticaAssicurataDTO> elencoPratiche){
        if(elencoPratiche == null) return;
        for(PraticaAssicurataDTO temp : elencoPratiche){
            temp.denominazione = temp.nome+' '+temp.cognome;
            if(temp.dataInizioCopertura != null && temp.dataInizioCopertura.length() > 0){
                String s = temp.dataInizioCopertura;
                temp.dataInizioCopertura = s.substring(6, 8)+'-'+s.substring(4, 6)+'-'+s.substring(0, 4);
            }
            if(temp.dataFineCopertura != null && temp.dataFineCopertura.length() > 0){
                String s = temp.dataFineCopertura;
                temp.dataFineCopertura = s.substring(6, 8)+'-'+s.substring(4, 6)+'-'+s.substring(0, 4);
                Date d= Date.newInstance(Integer.valueOf(s.substring(0, 4)), Integer.valueOf(s.substring(4, 6)), Integer.valueOf(s.substring(6, 8)));
            	temp.scaduto = system.today() > d ? 'true' : 'false'; 
            }
             if(temp.dataRichiesta != null && temp.dataRichiesta.length() > 0){
                String s = temp.dataRichiesta;
                temp.dataRichiesta = s.substring(6, 8)+'-'+s.substring(4, 6)+'-'+s.substring(0, 4);
            }
             if(temp.dataNascita != null && temp.dataNascita.length() > 0){
                String s = temp.dataNascita;
                temp.dataNascita = s.substring(6, 8)+'-'+s.substring(4, 6)+'-'+s.substring(0, 4);
            }
            
        }
        
    }
    
    public class PraticaAssicurataDTO{
        @AuraEnabled
        public String filiale{get;set;}
        @AuraEnabled
        public String numPratica{get;set;}
        @AuraEnabled
        public String tipoPratica{get;set;}
        @AuraEnabled
        public String statoPratica{get;set;}
        @AuraEnabled
        public String bloccoPratica{get;set;}
        @AuraEnabled
        public String codFiscale{get;set;}
        @AuraEnabled
        public String dataRichiesta{get;set;}
        @AuraEnabled
        public String assicurazione{get;set;}
        @AuraEnabled	
        public String noteAssicurazione{get;set;}
        @AuraEnabled
        public String dataInizioCopertura{get;set;}
        @AuraEnabled
        public String dataFineCopertura{get;set;}
        @AuraEnabled
        public String cognome{get;set;}
         @AuraEnabled
        public String nome{get;set;}
        @AuraEnabled
        public String denominazione{get;set;}
         @AuraEnabled
        public String dataNascita{get;set;}
        @AuraEnabled
        public String luogoNascita{get;set;}
        @AuraEnabled
        public String codCliente{get;set;}
          @AuraEnabled
        public String scaduto{get;set;}
        
    }
}