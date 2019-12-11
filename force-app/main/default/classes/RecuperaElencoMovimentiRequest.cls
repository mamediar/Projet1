//----------------------------------------------------------------------
//-- - Author       : SANA BADJI
//-- - Date         : 12/07/2019
//-- - Description  : Handle WS_RecuperaElencoMovimentiRequest
//----------------------------------------------------------------------
public  class RecuperaElencoMovimentiRequest extends OCSAPIRequest{

   public  RecuperaElencoMovimentiRequestDTO  recuperaElencoMovimentiRequest   {get;set;}

    public RecuperaElencoMovimentiRequest() {
        this.serviceId='recuperaElencoMovimenti';
        this.recuperaElencoMovimentiRequest= new RecuperaElencoMovimentiRequestDTO();

    }
    public class RecuperaElencoMovimentiRequestDTO {
            public  String tipoPratica {get;set;}
            public  String numPratica {get;set;}
            public  String dataValutaDa{get; set;}
            public  String dataValutaA {get;set;}
            public  String elencoCausali {get;set;}

    }

}