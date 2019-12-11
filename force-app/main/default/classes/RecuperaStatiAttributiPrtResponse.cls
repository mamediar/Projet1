public  class RecuperaStatiAttributiPrtResponse  extends OCSAPIResponse{
     public RecuperaStatiAttributiPrtResponseDTO recuperaStatiAttributiPrtResponse{get;set;}

    public RecuperaStatiAttributiPrtResponse() {
        this.recuperaStatiAttributiPrtResponse = new RecuperaStatiAttributiPrtResponseDTO();
        this.recuperaStatiAttributiPrtResponse.elencoPratiche = new List<RecuperaStatiAttributiPrtRes>();

    }
    
    public class RecuperaStatiAttributiPrtResponseDTO {
        public List<RecuperaStatiAttributiPrtRes> elencoPratiche {get;set;}
    }


    public class RecuperaStatiAttributiPrtRes{
            public String tipoPratica {get;set;}
            public String numPratica {get;set;}
            public String statoPratica {get;set;}
            public String attributoPratica {get;set;}
            public String canale {get;set;}
   }
}