public  class RecuperaStatiAttributiPrtRequest extends OCSAPIRequest {
  public  RecuperaStatiAttributiPrtRequestDTO recuperaStatiAttributiPrtRequest {get;set;}

  public RecuperaStatiAttributiPrtRequest() {
  this.serviceId = 'recuperaStatiAttributiPrt';
  this.recuperaStatiAttributiPrtRequest = new RecuperaStatiAttributiPrtRequestDTO();
  this.recuperaStatiAttributiPrtRequest.elencoPratiche = new List<RecuperaStatiAttributiPrtReq>();

    }

    public class RecuperaStatiAttributiPrtRequestDTO {
         public   List<RecuperaStatiAttributiPrtReq>  elencoPratiche  ;
    }
   public class RecuperaStatiAttributiPrtReq {
            public String tipoPratica {get;set;}
            public String numPratica {get;set;}
            public String statoPratica {get;set;}
            public String attributoPratica {get;set;}
            public String canale {get;set;}

            public RecuperaStatiAttributiPrtReq(String tipoPratica, String numPratica, String statoPratica,String attributoPratica, String canale){
                 this.tipoPratica = tipoPratica;
                 this.numPratica = numPratica;
                 this.statoPratica = statoPratica;
                 this.attributoPratica = attributoPratica;
                 this.canale = canale;
            }
   }
   
  public  void buildElencoPratica(String tipoPratica, String numPratica, String statoPratica,String attributoPratica, String canale){
  this.recuperaStatiAttributiPrtRequest.elencoPratiche.add(new RecuperaStatiAttributiPrtReq(tipoPratica, numPratica,statoPratica,attributoPratica, canale) );
  
  }


}