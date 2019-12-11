/*
*@Author Madicke BALDE  
*@description class to Invoke web service RecuperaPraticheAggiornate
*@Date 2019/06/20
*/
public  class RecuperaPraticheAggiornateInvoker {

/**
*@Author Madicke BALDE  
*@description invoke web service RecuperaPraticheAggiornate
*@param RecuperaPraticheAggiornateRequest : req
*@return RecuperaPraticheAggiornateResponse
*/
public static RecuperaPraticheAggiornateResponse invoke(RecuperaPraticheAggiornateRequest req){
        System.debug('************ RecuperaPraticheAggiornateResponse');
    return(RecuperaPraticheAggiornateResponse) OCSApiUtils.callApi('recuperaPraticheAggiornate', req, RecuperaPraticheAggiornateResponse.class);
    }
    /**
    *@Author Madicke BALDE
    *@description build RecuperaPraticheAggiornateRequest
    *@param dataInizio
    *@param oraInizio
    *@param filtroPartner
    *@return RecuperaPraticheAggiornateResponse
    */
    public static RecuperaPraticheAggiornateResponse build_recuperaPraticheAggiornateRequest( String dataInizio, String oraInizio, String filtroPartner){
         RecuperaPraticheAggiornateRequest requete = new RecuperaPraticheAggiornateRequest();
          RecuperaPraticheAggiornateResponse response ;
         
       //  try {
      /**    requete.serviceId= 'recuperaPraticheAggiornate';
          requete.companyType.put('value','COMPASS'); */
          requete.recuperaPraticheAggiornateRequest.dataInizio =   dataInizio;
          requete.recuperaPraticheAggiornateRequest.oraInizio = oraInizio;
          requete.recuperaPraticheAggiornateRequest.filtroPartner = filtroPartner;
          response =  invoke(requete);
             
      /*   } catch (Exception e) {
             System.debug('********** error Message  build_recuperaPraticheAggiornateRequest'+e.getMessage());
             System.debug('**********  '+ e.getStackTraceString());
             
         }       */
           return response;
}

}