public class RecuperaPraticheAggiornateResponse extends OCSAPIResponse {
   
   public RecuperaPraticheAggiornateResponseDTO recuperaPraticheAggiornateResponse {get;set;}

    public RecuperaPraticheAggiornateResponse() {
        this.recuperaPraticheAggiornateResponse = new RecuperaPraticheAggiornateResponseDTO();
        this.recuperaPraticheAggiornateResponse.elenco = new  List<RecuperaPraticheAggiornateResp>();

    }

    public class RecuperaPraticheAggiornateResponseDTO {
        public List<RecuperaPraticheAggiornateResp>  elenco ; 
    }

    public class RecuperaPraticheAggiornateResp {
        public String numPratica {get;set;}
        public String statoAttuale {get;set;}
        public String attributoAttuale {get;set;}
        public String dataUltimoAggiornamento {get;set;}
        public String oraUltimoAggiornamento {get;set;}
      /*  public  RecuperaPraticheAggiornateResp (String numPratica, String statoAttuale,String attributoAttuale, String dataUltimoAggiornamento, String oraUltimoAggiornamento ){
            this.numPratica = numPratica;
            this.statoAttuale = statoAttuale;
            this.attributoAttuale = attributoAttuale;
            this.dataUltimoAggiornamento = dataUltimoAggiornamento;
            this.oraUltimoAggiornamento = oraUltimoAggiornamento;
        } */
        
        
    }
}