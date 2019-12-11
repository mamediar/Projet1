//----------------------------------------------------------------------
//-- - Author       : SANA BADJI
//-- - Date         : 12/07/2019
//-- - Description  : Handle WS_RecuperaElencoMovimentiService
//----------------------------------------------------------------------

public  class RecuperaElencoMovimentiService {
    public static Boolean hasError = false;
    public static List<ValidationError> errors = new List<ValidationError>();
    public static RecuperaElencoMovimentiResponse invoke(RecuperaElencoMovimentiRequest req){
        return (RecuperaElencoMovimentiResponse) OCSApiUtils.callApi('recuperaElencoMovimenti',
                                                                                req,
                                                                                RecuperaElencoMovimentiResponse.class);
    }
    
    public static RecuperaElencoMovimentiResponse buildRecuperaElencoMovimentiResponse (
                                                    String  tipoPratica,
                                                    String  numPratica,
                                                    String  dataValutaDa,
                                                    String  dataValutaA,
                                                    String  elencoCausali ){
        RecuperaElencoMovimentiResponse response;
        RecuperaElencoMovimentiRequest request = new RecuperaElencoMovimentiRequest();
        request.recuperaElencoMovimentiRequest.tipoPratica = tipoPratica;
        request.recuperaElencoMovimentiRequest.numPratica = numPratica;
        request.recuperaElencoMovimentiRequest.dataValutaDa = dataValutaDa;
        request.recuperaElencoMovimentiRequest.dataValutaA = dataValutaA;
        request.recuperaElencoMovimentiRequest.elencoCausali = elencoCausali;
        
        response = invoke(request);
    return response;
}
/*
    *@Author SANA BADJI
    *@description Validate field Response
    *@param response : validateResponse
    *@return Boolean
    */
    public static Boolean validateResponse (RecuperaElencoMovimentiResponse response){
                
                System.debug(' ************** ValidateResponse '+response.resultCode);
                System.debug(' ************** response.resultMessage '+response.resultMessage);
                System.debug(' ************** response.recuperaElencoMovimentiResponse.movimenti '
                +response.recuperaElencoMovimentiResponse.movimenti.size());
                
                //System.debug(' ************** response.recuperaElencoMovimentiResponse '+response.);
                    if(response.resultCode != 0 ){
                        hasError = true;
                        errors.add(new ValidationError ('invalid Response ', 'RecuperaElencoMovimentiResponse')); }

                    if(response.resultMessage=='KO' ){
                        hasError = true;
                        errors.add(new ValidationError('InValid resultMessage','RecuperaElencoMovimentiResponse' ) );
                    }
                if (response.recuperaElencoMovimentiResponse.movimenti.size() == 0 ){
                hasError = true;
                errors.add(new ValidationError ('movimenti list can\'t be null ', 'RecuperaElencoMovimentiResponse'));
                }
            System.debug(' ************** hasError '+ hasError);
            return !hasError;
    }

    public static RecuperaElencoMovimentiResponse.MovimentiEstrattoContoDTO gestitoRecuperaElencoMovimenti(List<RecuperaElencoMovimentiResponse.MovimentiEstrattoContoDTO> movimentis ){
        if(movimentis == null || movimentis.size() == 0 ){
            return null;
        }
        else{
            System.debug('************** gestitoRecuperaElencoMovimenti '+movimentis);
            List<RecuperaElencoMovWrapper> listRecuperaElencoMovWrapper = new List<RecuperaElencoMovWrapper>();
            for(RecuperaElencoMovimentiResponse.MovimentiEstrattoContoDTO movi : movimentis){
               listRecuperaElencoMovWrapper.add(new RecuperaElencoMovWrapper(movi));
           }
           listRecuperaElencoMovWrapper.sort();
           RecuperaElencoMovimentiResponse.MovimentiEstrattoContoDTO recentMovimenti = listRecuperaElencoMovWrapper[0].movimentis;
          // CGMWSUtils_1_0.dividendoElimina(recentMovimenti.dataAcqRecuperaElencoMovimentiResponse.MovimentiEstrattoContoDTOuisto, recentMovimenti.importo);
        //   dividendoElimina(recentMovimenti);
           System.debug(' recentAftere ************* test '+recentMovimenti.importo + ' date'+recentMovimenti.dataAcquisto);
      //   if(CGMWSUtils_1_0.checkIfMovementIsInLast30days(recentMovimenti.dataAcquisto)){
               return recentMovimenti;
       //  }
      /*   else{
             return null;
         } */
       
        }
        
    }
/*public static void dividendoElimina(RecuperaElencoMovimentiResponse.MovimentiEstrattoContoDTO rc){
            if(rc == null){
                return;
            }
            else {
                String importom = (rc.importo).remove('-');
                Integer montant = Integer.valueOf(importom)/100;
                String   importoString = String.valueOf(montant);
                rc.importo = importoString;
                Datetime df= CGMWSUtils_1_0.formatStringToDatetime(rc.dataAcquisto);
                String deteformat = 'dd/MM/yyyy';
                String ds = df.format(deteformat);
                rc.dataAcquisto = ds;

                
            }
} */


}