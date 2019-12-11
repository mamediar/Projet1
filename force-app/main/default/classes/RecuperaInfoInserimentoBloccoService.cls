//----------------------------------------------------------------------
//-- - Author       : SANA BADJI
//-- - Date         : 12/07/2019
//-- - Description  : Handle WS_RecuperaInfoInserimentoBloccoService
//----------------------------------------------------------------------

 public  class RecuperaInfoInserimentoBloccoService {
    public static Boolean hasError = false;
    public static List<ValidationError> errors = new List<ValidationError>();
    public static RecuperaInfoInserimentoBloccoResponse invoke(RecuperaInfoInserimentoBloccoRequest req){
        return (RecuperaInfoInserimentoBloccoResponse) OCSApiUtils.callApi('recuperaInfoInserimentoBlocco',
                                                                                req,
                                                                                RecuperaInfoInserimentoBloccoResponse.class);
    }

    
    public static RecuperaInfoInserimentoBloccoResponse buildRecuperaInfoInserimentoBloccoResponse (
                                                    String  numCarta,
                                                    String  bloccoCarta ){
        RecuperaInfoInserimentoBloccoResponse response;
        RecuperaInfoInserimentoBloccoRequest request = new RecuperaInfoInserimentoBloccoRequest();
        request.recuperaInfoInserimentoBloccoRequest.numCarta = numCarta;
        request.recuperaInfoInserimentoBloccoRequest.bloccoCarta = bloccoCarta;        
        response = invoke(request);
    return response;
}

/*
    *@Author SANA BADJI
    *@description Validate field Response
    *@param response : validateResponse
    *@return Boolean
    */
    public static Boolean validateResponse (RecuperaInfoInserimentoBloccoResponse response){
                
                System.debug(' ************** ValidateResponse '+response.resultCode);
                System.debug(' ************** response.resultMessage '+response.resultMessage);
                
                //System.debug(' ************** response.recuperaElencoMovimentiResponse '+response.);
                    if(response.resultCode != 0 ){
                        hasError = true;
                        errors.add(new ValidationError ('invalid Response ', 'RecuperaInfoInserimentoBloccoResponse')); }

                    if(response.resultMessage=='KO' ){
                        hasError = true;
                        errors.add(new ValidationError('InValid resultMessage','RecuperaInfoInserimentoBloccoResponse' ) );
                    }
                
            System.debug(' ************** hasError '+ hasError);
            return !hasError;
    }

}