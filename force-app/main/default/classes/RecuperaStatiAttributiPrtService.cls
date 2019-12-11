/*
*@Author SANA BADJI  
*@description service class for web service RecuperaStatiAttributiPrt
*
*/
public  class RecuperaStatiAttributiPrtService {
    public static List<RecuperaStatiAttributiPrtError> errors = new List<RecuperaStatiAttributiPrtError>();
    /*
    *@Author SANA BADJI
    *@description Validate field Response
    *@param response : RecuperaStatiAttributiPrtResponse
    *@return Boolean
    */
    public static Boolean validateResponse (RecuperaStatiAttributiPrtResponse response){
                Boolean hasError = false;
                System.debug(' ************** ValidateResponse '+response.resultCode);
                try {
                      if(response.resultCode != 0 ){
                            hasError = true;
                            errors.add(new RecuperaStatiAttributiPrtError ('Response invalid', 'RecuperaStatiAttributiPrtResponse')); }
                    
                if(response.recuperaStatiAttributiPrtResponse == null ){
                            hasError = true;
                            errors.add(new RecuperaStatiAttributiPrtError ('No records Retrieved ', 'RecuperaStatiAttributiPrtResponse'));
                            }
                if (response.recuperaStatiAttributiPrtResponse.elencoPratiche.size() == 0 ){
                    hasError = true;
                    errors.add(new RecuperaStatiAttributiPrtError ('No records Retrieved elencoPratiche ', 'RecuperaStatiAttributiPrtResponse'));
                }
                    
                } catch (Exception e) {
                    System.debug(' ***********  errorMessage ValidateResponse '+e.getMessage());
                     System.debug(' *********** ValidateResponse '+e.getStackTraceString());
                }   
                System.debug(' ************** hasError '+ hasError);
                return !hasError;
    }
}