//----------------------------------------------------------------------
//-- - Author       : SANA BADJI
//-- - Date         : 12/07/2019
//-- - Description  : Handle WS_RecuperaInfoInserimentoBloccoResponse
//----------------------------------------------------------------------
public  class RecuperaInfoInserimentoBloccoResponse extends OCSAPIResponse {
    public  RecuperaInfoInserimentoBloccoResponseDTO  recuperaInfoInserimentoBloccoResponse   {get;set;}
    public RecuperaInfoInserimentoBloccoResponse() {
        this.recuperaInfoInserimentoBloccoResponse=new RecuperaInfoInserimentoBloccoResponseDTO();

    }

    public class RecuperaInfoInserimentoBloccoResponseDTO{
        public  String dataInserimento {get;set;}
        public  String oraInserimento {get;set;}
        public  String dataInizioValidita {get;set;}
        public  String dataFineValidita {get;set;}
        public  String flagAnnullato {get;set;}
        public  String dataAnnullo {get;set;}
        public  String oraAnnullo {get;set;}
    }
}