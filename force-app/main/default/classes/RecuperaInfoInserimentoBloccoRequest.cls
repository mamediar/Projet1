//----------------------------------------------------------------------
//-- - Author       : SANA BADJI
//-- - Date         : 12/07/2019
//-- - Description  : Handle WS_RecuperaInfoInserimentoBloccoRequest
//----------------------------------------------------------------------
public  class RecuperaInfoInserimentoBloccoRequest extends OCSAPIRequest{
    public  RecuperaInfoInserimentoBloccoRequestDTO  recuperaInfoInserimentoBloccoRequest   {get;set;}
    public RecuperaInfoInserimentoBloccoRequest() {
        this.serviceId='recuperaInfoInserimentoBlocco';
        this.recuperaInfoInserimentoBloccoRequest= new RecuperaInfoInserimentoBloccoRequestDTO();
    }

    public class RecuperaInfoInserimentoBloccoRequestDTO {
        public  String numCarta {get;set;}
        public  String bloccoCarta {get;set;}
    }
}