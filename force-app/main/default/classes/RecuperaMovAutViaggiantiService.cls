public class RecuperaMovAutViaggiantiService {
  public static   List<ValidationError> errors = new List<ValidationError>();
   
   public static RecuperaMovAutViaggiantiResponse invoke(RecuperaMovAutViaggiantiRequest req){
       return (RecuperaMovAutViaggiantiResponse) OCSApiUtils.callApi('ocs.recuperaMovAutViaggianti',
                                                                      req,
                                                                     RecuperaMovAutViaggiantiResponse.class);
   }

   public static RecuperaMovAutViaggiantiResponse  
                  buildRecuperaMovAutViaggiantRequest (String provenienza,
                                                        String intermediario,
                                                        String tipoIntermediario,
                                                        String emettitore,
                                                        String numPratica,
                                                        String pan,
                                                        String dataRegistrazione,
                                                        String tipoRecord,
                                                        String progressivo,
                                                        String protocollo,
                                                        String riga,
                                                        String tipoChiave,
                                                        String statoAutorizzazione,
                                                        String esitoAutorizzazione,
                                                        String dataAutorizzazione,
                                                        String numElementi,
                                                        String flagMovimenti,
                                                        String flagAutorizzazioni,
                                                        String utente
                                                                                         ){
       RecuperaMovAutViaggiantiResponse response;
       RecuperaMovAutViaggiantiRequest request = new RecuperaMovAutViaggiantiRequest();
       request.serviceId = 'recuperaMovAutViaggianti';
       request.companyType.put('value', 'COMPASS');
       request.recuperaMovimentiAutorizzazioniViaggiantiRequest.provenienza = provenienza;
       request.recuperaMovimentiAutorizzazioniViaggiantiRequest.tipoIntermediario = tipoIntermediario;
        request.recuperaMovimentiAutorizzazioniViaggiantiRequest.intermediario = intermediario;
        request.recuperaMovimentiAutorizzazioniViaggiantiRequest.emettitore = emettitore;
        request.recuperaMovimentiAutorizzazioniViaggiantiRequest.numPratica = numPratica;
        request.recuperaMovimentiAutorizzazioniViaggiantiRequest.pan = pan;
        request.recuperaMovimentiAutorizzazioniViaggiantiRequest.dataRegistrazione = dataRegistrazione;
        request.recuperaMovimentiAutorizzazioniViaggiantiRequest.tipoRecord = tipoRecord;
        request.recuperaMovimentiAutorizzazioniViaggiantiRequest.progressivo = progressivo;
        request.recuperaMovimentiAutorizzazioniViaggiantiRequest.protocollo = protocollo;
        request.recuperaMovimentiAutorizzazioniViaggiantiRequest.riga = riga;
        request.recuperaMovimentiAutorizzazioniViaggiantiRequest.tipoChiave = tipoChiave;
        request.recuperaMovimentiAutorizzazioniViaggiantiRequest.statoAutorizzazione = statoAutorizzazione;
        request.recuperaMovimentiAutorizzazioniViaggiantiRequest.esitoAutorizzazione = esitoAutorizzazione;
        request.recuperaMovimentiAutorizzazioniViaggiantiRequest.dataAutorizzazione = dataAutorizzazione;
        request.recuperaMovimentiAutorizzazioniViaggiantiRequest.numElementi = numElementi;
        request.recuperaMovimentiAutorizzazioniViaggiantiRequest.flagMovimenti = flagMovimenti;
        request.recuperaMovimentiAutorizzazioniViaggiantiRequest.flagAutorizzazioni = flagAutorizzazioni;
        request.recuperaMovimentiAutorizzazioniViaggiantiRequest.utente = utente;
        
        response = invoke(request);
        return response;
   }

   public static Boolean validateRequest(RecuperaMovAutViaggiantiRequest request){
        Boolean hasError = false;
        if(String.isBlank(request.serviceId)){
            hasError = true;
            errors.add(new ValidationError('ServiceId Can t be Empty', 'serviceId RecuperaMovAutViaggiantiRequest'));
        }
        if(String.isBlank(request.companyType.get('value'))){
            hasError = true;
            errors.add(new ValidationError('companyType Can t be Empty', 'companyType RecuperaMovAutViaggiantiRequest'));
        }
     /*   if(request.recuperaMovimentiAutorizzazioniViaggiantiRequest == null){
            hasError = true;
            errors.add(new ValidationError(' recuperaMovimentiAutorizzazioniViaggiantiRequest  Can t be null', 'recuperaMovimentiAutorizzazioniViaggiantiRequest'));
        } */
        if(String.isBlank(request.recuperaMovimentiAutorizzazioniViaggiantiRequest.provenienza)){
            hasError = true;
            errors.add( new ValidationError(' provenienza can t be empty', 'provenienza' ));
        }
        if(String.isBlank(request.recuperaMovimentiAutorizzazioniViaggiantiRequest.tipoIntermediario)){
            hasError = true;
            errors.add( new ValidationError(' tipoIntermediario can t be empty', 'tipoIntermediario' ));
        }
        if(String.isBlank(request.recuperaMovimentiAutorizzazioniViaggiantiRequest.intermediario)){
            hasError = true;
            errors.add( new ValidationError(' intermediario can t be empty', 'intermediario' ));
        }
        if(String.isBlank(request.recuperaMovimentiAutorizzazioniViaggiantiRequest.emettitore)){
            hasError = true;
            errors.add( new ValidationError(' emettitore can t be empty', 'emettitore' ));
        }
        if(String.isBlank(request.recuperaMovimentiAutorizzazioniViaggiantiRequest.numPratica)){
            hasError = true;
            errors.add( new ValidationError(' numPratica can t be empty', 'numPratica' ));
        }

        if(String.isBlank(request.recuperaMovimentiAutorizzazioniViaggiantiRequest.pan)){
            hasError = true;
            errors.add( new ValidationError(' pan can t be empty', 'numPratica' ));
        }

        if(String.isBlank(request.recuperaMovimentiAutorizzazioniViaggiantiRequest.dataRegistrazione)){
            hasError = true;
            errors.add( new ValidationError(' dataRegistrazione can t be empty', 'dataRegistrazione' ));
        }

        if(String.isBlank(request.recuperaMovimentiAutorizzazioniViaggiantiRequest.tipoRecord)){
            hasError = true;
            errors.add( new ValidationError(' tipoRecord can t be empty', 'tipoRecord' ));
        }

        if(String.isBlank(request.recuperaMovimentiAutorizzazioniViaggiantiRequest.progressivo)){
            hasError = true;
            errors.add( new ValidationError(' progressivo can t be empty', 'progressivo' ));
        }

        if(String.isBlank(request.recuperaMovimentiAutorizzazioniViaggiantiRequest.protocollo)){
            hasError = true;
            errors.add( new ValidationError(' protocollo can t be empty', 'protocollo' ));
        }

        if(String.isBlank(request.recuperaMovimentiAutorizzazioniViaggiantiRequest.riga)){
            hasError = true;
            errors.add( new ValidationError(' riga can t be empty', 'riga' ));
        }
        if(String.isBlank(request.recuperaMovimentiAutorizzazioniViaggiantiRequest.tipoChiave)){
            hasError = true;
            errors.add( new ValidationError(' tipoChiave can t be empty', 'tipoChiave' ));
        }
        if(String.isBlank(request.recuperaMovimentiAutorizzazioniViaggiantiRequest.statoAutorizzazione)){
            hasError = true;
            errors.add( new ValidationError(' statoAutorizzazione can t be empty', 'statoAutorizzazione' ));
        }
        if(String.isBlank(request.recuperaMovimentiAutorizzazioniViaggiantiRequest.esitoAutorizzazione)){
            hasError = true;
            errors.add( new ValidationError(' esitoAutorizzazione can t be empty', 'esitoAutorizzazione' ));
        }
        if(String.isBlank(request.recuperaMovimentiAutorizzazioniViaggiantiRequest.dataAutorizzazione)){
            hasError = true;
            errors.add( new ValidationError(' dataAutorizzazione can t be empty', 'dataAutorizzazione' ));
        }
        if(String.isBlank(request.recuperaMovimentiAutorizzazioniViaggiantiRequest.numElementi)){
            hasError = true;
            errors.add( new ValidationError(' numElementi can t be empty', 'numElementi' ));
        }
        if(String.isBlank(request.recuperaMovimentiAutorizzazioniViaggiantiRequest.flagMovimenti)){
            hasError = true;
            errors.add( new ValidationError(' flagMovimenti can t be empty', 'flagMovimenti' ));
        }

        if(String.isBlank(request.recuperaMovimentiAutorizzazioniViaggiantiRequest.flagAutorizzazioni)){
            hasError = true;
            errors.add( new ValidationError(' flagAutorizzazioni can t be empty', 'flagAutorizzazioni' ));
        }
        if(String.isBlank(request.recuperaMovimentiAutorizzazioniViaggiantiRequest.Utente)){
            hasError = true;
            errors.add( new ValidationError(' Utente can t be empty', 'Utente' ));
        }

    return hasError;
   }
   public static Boolean validateResponse(RecuperaMovAutViaggiantiResponse response){
       Boolean hasError = false;
       if(response.resultCode == null ||  response.resultCode == 0 ){
           hasError = true;
           errors.add( new ValidationError('resultCode can t be empty','resultCode RecuperaMovAutViaggiantiResponse')  );
       }
       if(String.isBlank(response.resultMessage) ){
           hasError = true;
            errors.add( new ValidationError('resultMessage can t be empty','resultMessage RecuperaMovAutViaggiantiResponse ')  );
          // errors.add('resultMessage can t be empty ', 'resultMessage RecuperaMovAutViaggiantiResponse ');
       }
       if(response.recuperaMovimentiAutorizzazioniViaggiantiResponse.recuperaMovViaggiantiResponse.elencoMovimenti == null){
           hasError = true;
          errors.add(new ValidationError('elencoMovimenti list  can t be empty','elencoMovimenti') );
       } 
       if(String.isBlank(response.recuperaMovimentiAutorizzazioniViaggiantiResponse.recuperaMovViaggiantiResponse.as400Errore)){
           hasError = true;
           errors.add(new ValidationError('as400Errore can t be empty','as400Errore') );
       }
       if(String.isBlank(response.recuperaMovimentiAutorizzazioniViaggiantiResponse.recuperaMovViaggiantiResponse.as400Status )){
           hasError = true;
           errors.add(new ValidationError('as400Status can t be empty ', ' as400Status ')  );
       }
       if(response.recuperaMovimentiAutorizzazioniViaggiantiResponse.recuperaAutViaggiantiResponse.elencoAutorizzazioni == null){
           hasError = true;
           errors.add(new ValidationError('as400Errore can t be empty','as400Errore') );
       }
       return hasError;
   } 

   public static Map<String,Object> recuperaMovAutViaggiantiControl(RecuperaMovAutViaggiantiResponse response){
    
          RecuperaMovAutViaggiantiResponse.AutorizzazioneViaggianteDTO autorizzazioni = autorizzazioniMostRecentDate(response.recuperaMovimentiAutorizzazioniViaggiantiResponse.recuperaAutViaggiantiResponse.elencoAutorizzazioni) ;
          //RecuperaMovAutViaggiantiResponse.MovimentoViaggianteDTO movimenti;
          Map<String,Object> movimentiMap = gestitoMovimenti(response.recuperaMovimentiAutorizzazioniViaggiantiResponse.recuperaMovViaggiantiResponse.elencoMovimenti);
          System.debug('*************  movimentiMap test '+movimentiMap);
        //  if(movimentiMap.get('elencoMovimenti') != null)
         if(autorizzazioni != null) movimentiMap.put('autorizzazioni',autorizzazioni);  
    
            return movimentiMap;
   }

  public static RecuperaMovAutViaggiantiResponse.AutorizzazioneViaggianteDTO autorizzazioniMostRecentDate(List<RecuperaMovAutViaggiantiResponse.AutorizzazioneViaggianteDTO> autorizzazionis){
     if(autorizzazionis == null || autorizzazionis.size() == 0 ){
         return null ;
     }
     else {
         List<AuthorizzaWrapperCompareDate> listAuthorizzaWrapper = new List<AuthorizzaWrapperCompareDate>();
       
         Integer cpt = 1;
         for (RecuperaMovAutViaggiantiResponse.AutorizzazioneViaggianteDTO autho : autorizzazionis) {
                listAuthorizzaWrapper.add(new AuthorizzaWrapperCompareDate(autho) );
         }
         listAuthorizzaWrapper.sort();
         RecuperaMovAutViaggiantiResponse.AutorizzazioneViaggianteDTO authoriRecent = listAuthorizzaWrapper[0].authori; 
       //  eliminandoDividendoImporto(authoriRecent);
         System.debug('******************* autorizzazioniMostRecentDate authoriRecent '+authoriRecent);
         return authoriRecent;
        // RecuperaMovAutViaggiantiResponse.AutorizzazioneViaggianteDTO mostRecentAuth = mapAuthorizzaWrapper.get(listAuthorizzaWrapper[0].position);
     }
  }
/*public static void eliminandoDividendoImporto(RecuperaMovAutViaggiantiResponse.AutorizzazioneViaggianteDTO authoriRecent){
 if(authoriRecent == null ){
         return ;
 }
 else {
        String impor = (authoriRecent.importo).remove('-');
        Integer montant = (Integer.valueOf(impor))/100;
        authoriRecent.importo = String.valueOf(montant);
        Datetime df= CGMWSUtils_1_0.formatStringToDatetime(authoriRecent.data);
        String deteformat = 'dd/MM/yyyy';
        String ds = df.format(deteformat);
        authoriRecent.data = ds;
 }
} */

public static Map<String , Object> gestitoMovimenti(List<RecuperaMovAutViaggiantiResponse.MovimentoViaggianteDTO>  movimentis ){
        RecuperaMovAutViaggiantiResponse.MovimentoViaggianteDTO recentMovi;
        Map<String , Object> returnValueMap = new Map<String , Object>();
        if(movimentis == null || movimentis.size() == 0){
            //call web service elemcoM
                System.debug('************ movimentis ********  null '+movimentis);
                RecuperaElencoMovimentiResponse recuperaElencoMovimentiResp = RecuperaElencoMovimentiService.buildRecuperaElencoMovimentiResponse('tipoPratica', 'numPratica', 
                                                                                                                        'dataValutaDa', 'dataValutaA', 'elencoCausali');
                System.debug(' ************ recuperaElencoMovimentiResp *** '+recuperaElencoMovimentiResp);
                RecuperaElencoMovimentiResponse.MovimentiEstrattoContoDTO removimenti = RecuperaElencoMovimentiService.gestitoRecuperaElencoMovimenti(recuperaElencoMovimentiResp.recuperaElencoMovimentiResponse.movimenti);
                System.debug('************ movimenti test '+removimenti);
                returnValueMap.put('tipoMouv','RecuperaElencoMovimentiResponse.MovimentiEstrattoContoDTO');
                returnValueMap.put('movimenti',removimenti); 
        }
        else {
                returnValueMap.put('tipoMouv','RecuperaMovAutViaggiantiResponse.MovimentoViaggianteDTO');
                List<RecuperaMovAutViaggiantiResponse.MovimentoViaggianteDTO> moveList = getmovimentiwithTipoF(movimentis);
                List<MovementiWrapperCompareDate> listMovAuthorizzaWrapper = new List<MovementiWrapperCompareDate>();
                for( RecuperaMovAutViaggiantiResponse.MovimentoViaggianteDTO m: moveList){
                            listMovAuthorizzaWrapper.add(new MovementiWrapperCompareDate(m) );
                }
                listMovAuthorizzaWrapper.sort();
                recentMovi = listMovAuthorizzaWrapper[0].movementi;
            //  dividendoElimina(recentMovi);
            if(checkIfMovementIsInLast30days (recentMovi)){
                returnValueMap.put('movimenti',recentMovi);
             }
            else {
                returnValueMap.put('movimenti',null);
            }
            }
            System.debug('********************* gestitoMovimenti returnValueMap'+returnValueMap);
           return  returnValueMap;

}
  
public static  List<RecuperaMovAutViaggiantiResponse.MovimentoViaggianteDTO> getmovimentiwithTipoF(List<RecuperaMovAutViaggiantiResponse.MovimentoViaggianteDTO> mvs){
 List<RecuperaMovAutViaggiantiResponse.MovimentoViaggianteDTO> listmvs = new List<RecuperaMovAutViaggiantiResponse.MovimentoViaggianteDTO>();
 for(RecuperaMovAutViaggiantiResponse.MovimentoViaggianteDTO m : mvs){
     if(m.tipoMov == 'F'){
       listmvs.add(m);
     }
 }
 return listmvs;
}
 /*public static void dividendoElimina(RecuperaMovAutViaggiantiResponse.MovimentoViaggianteDTO rmv){
        String impor = (rmv.importo).remove('-');
        Integer montant = (Integer.valueOf(impor))/100;
        rmv.importo = String.valueOf(montant);
        Datetime df= CGMWSUtils_1_0.formatStringToDatetime(rmv.dataOperazione);
        String deteformat = 'dd/MM/yyyy';
        String ds = df.format(deteformat);
        rmv.dataOperazione = ds;
 }  */
  /**
    *@author Madicke BALDE
    *@date 2019/07/29
    *@description check movementi is in last 30 day
    *@param RecuperaMovAutViaggiantiResponse.MovimentoViaggianteDTO mv
    *@return Boolean
   **/
  public static Boolean checkIfMovementIsInLast30days (RecuperaMovAutViaggiantiResponse.MovimentoViaggianteDTO mv){
        System.debug('*************** running   checkIfMovementIsInLast30days   ');
        Boolean inLast30Days = false;
        Date dateOperationLast30days = (Date.today()).addDays(-30);
        Date dateOperation = CGMWSUtils_1_0.formatStringToDate(mv.dataOperazione);
        System.debug('************dateOperation '+dateOperation);
        if(dateOperationLast30days > dateOperation ){
            inLast30Days = true;
        }
        System.debug('************ inLast30Days'+inLast30Days);
        return !inLast30Days;
  }
}