public  class Invoker {

    public static RecuperaStatiAttributiPrtResponse invoke(RecuperaStatiAttributiPrtRequest req){
        System.debug('************* Running invoker ****** ');
        String jr = OCSApiUtils.getMockResponse('recuperaStatiAttributiPrt');
       // RecuperaStatiAttributiPrtResponse response = (RecuperaStatiAttributiPrtResponse) JSON.deserialize(jr,RecuperaStatiAttributiPrtResponse.class);
        //return response;
      //  System.debug(ApiUtils.callApi('recuperaStatiAttributiPrt', req, RecuperaStatiAttributiPrtResponse.class,'C'));
        return (RecuperaStatiAttributiPrtResponse) OCSApiUtils.callApi('recuperaStatiAttributiPrt', req, RecuperaStatiAttributiPrtResponse.class,'C');
            
    }

    public static RecuperaPraticheAggiornateResponse invoke(RecuperaPraticheAggiornateRequest req){
        System.debug('************ RecuperaPraticheAggiornateResponse');
        return(RecuperaPraticheAggiornateResponse) OCSApiUtils.callApi('recuperaPraticheAggiornate', req, RecuperaPraticheAggiornateResponse.class,'C');
    }


    public static RecuperaPraticheAggiornateResponse build_recuperaPraticheAggiornateRequest( String dataInizio, String oraInizio, String filtroPartner){
            RecuperaPraticheAggiornateRequest requete = new RecuperaPraticheAggiornateRequest();
            RecuperaPraticheAggiornateResponse response ;
            
            try {
            requete.serviceId= 'recuperaPraticheAggiornate';
            requete.companyType.put('value','COMPASS');
            requete.recuperaPraticheAggiornateRequest.dataInizio =   dataInizio;
            requete.recuperaPraticheAggiornateRequest.oraInizio = oraInizio;
            requete.recuperaPraticheAggiornateRequest.filtroPartner = filtroPartner;
            response = Invoker.invoke(requete);
                
            } catch (Exception e) {
                System.debug('********** error Message  build_recuperaPraticheAggiornateRequest'+e.getMessage());
                System.debug('**********  '+ e.getStackTraceString());
                
            }
            
            return response;

    }

}