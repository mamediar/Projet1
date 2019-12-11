//----------------------------------------------------------------------
//-- - Author       : SANA BADJI
//-- - Date         : 12/07/2019
//-- - Description  : Handle WS_RecuperaElencoMovimentiResponse
//----------------------------------------------------------------------

public  class RecuperaElencoMovimentiResponse extends OCSAPIResponse{
    public RecuperaElencoMovimentiResponseDTO  recuperaElencoMovimentiResponse {get;set;}

    public RecuperaElencoMovimentiResponse() {
        this.recuperaElencoMovimentiResponse=new RecuperaElencoMovimentiResponseDTO();
        this.recuperaElencoMovimentiResponse.movimenti=new List<MovimentiEstrattoContoDTO>();
    }
    public class RecuperaElencoMovimentiResponseDTO {
        @AuraEnabled
        public List<MovimentiEstrattoContoDTO>  movimenti {get;set;}
    }

    public class MovimentiEstrattoContoDTO{
     @AuraEnabled   public String  dataValuta {get;set;}
     @AuraEnabled   public String  dataRegistrazione {get;set;}
     @AuraEnabled   public String  dataAcquisto {get;set;}
     @AuraEnabled   public String  causale {get;set;}
     @AuraEnabled   public String  importo {get;set;}
    }

}