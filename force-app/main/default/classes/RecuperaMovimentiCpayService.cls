public  class RecuperaMovimentiCpayService {
  public static  List<ValidationError> errors =  new List<ValidationError>();

   public static RecuperaMovimentiCpayResponse buildRecuperaMovimentiCpayRequest(String numPratica, 
                                                                                 String dataCompetenzaDa,
                                                                                 String dataCompetenzaA){
    RecuperaMovimentiCpayResponse response;
    RecuperaMovimentiCpayRequest request = new RecuperaMovimentiCpayRequest();
    request.serviceId = 'recuperaMovimentiCpay';
    request.companyType.put('value', 'COMPASS');
    request.recuperaMovimentiCpayRequest.numPratica = numPratica;
    request.recuperaMovimentiCpayRequest.dataCompetenzaA = dataCompetenzaA;
    request.recuperaMovimentiCpayRequest.dataCompetenzaDa = dataCompetenzaDa;
    response = invoker(request);
    // String jsonResponse = OCSApiUtils.getMockResponse('recuperaMovimentiCpay');
    // response  = (RecuperaMovimentiCpayResponse)  JSON.deserialize(jsonResponse, RecuperaMovimentiCpayResponse.class);
    return response;

   }

   public static RecuperaMovimentiCpayResponse invoker(RecuperaMovimentiCpayRequest request){
       return (RecuperaMovimentiCpayResponse) OCSApiUtils.callApi('recuperaMovimentiCpay', request, RecuperaMovimentiCpayResponse.class);
   }

   public static Boolean validateRequest(RecuperaMovimentiCpayRequest request){
       Boolean hasError = false;
       if(String.isBlank(request.serviceId)){
         hasError = true;
        errors.add(new ValidationError('Invalid ! Can\' t be empty serviceId ','RecuperaMovimentiCpayRequest') );
        //  errors.add(arg0)
       }
       if(String.isBlank(request.companyType.get('value'))){
        hasError = true;
        errors.add(new ValidationError ('Invalid ! Can\' t be empty companyType ','RecuperaMovimentiCpayRequest') );
       }
       if(String.isBlank(request.recuperaMovimentiCpayRequest.numPratica) ){
           hasError = true;
          errors.add(new ValidationError ('Invalid ! Can\' t be empty numPratica ','RecuperaMovimentiCpayRequest') );
       }
       if(String.isBlank(request.recuperaMovimentiCpayRequest.dataCompetenzaA)){
          hasError = true;
          errors.add(new ValidationError ('Invalid ! Can\' t be empty dataCompetenzaA ','RecuperaMovimentiCpayRequest') );
       }
        if(String.isBlank(request.recuperaMovimentiCpayRequest.dataCompetenzaDa )){
          hasError = true;
          errors.add(new ValidationError ('Invalid ! Can\' t be empty dataCompetenzaDa ','RecuperaMovimentiCpayRequest') );
       }

   return hasError;
   }

   public static Boolean validateResponse(RecuperaMovimentiCpayResponse response){
      Boolean hasError = false;
     if(response.resultCode == 0){
         hasError = true;
         errors.add(new ValidationError('InValid Response','RecuperaMovimentiCpayResponse' ) );
     }
     if(String.isBlank(response.resultMessage) ){
        hasError = true;
         errors.add(new ValidationError('InValid resultMessage','RecuperaMovimentiCpayResponse' ) );
     }
     if(response.recuperaMovimentiCpayResponse.elenco.size() == 0 ){
       hasError = true;
       errors.add(new ValidationError('elenco null','RecuperaMovimentiCpayResponse' ) );
     }
     if(response.recuperaMovimentiCpayResponse.elenco.size() > 0 ){
         for( RecuperaMovimentiCpayResponse.RecuperaMovimentiCpayRes res :  response.recuperaMovimentiCpayResponse.elenco ){
             if(String.isBlank(res.progressivo )){
                 hasError = true;
                 errors.add(new ValidationError('progressivo  Can\' t empty','RecuperaMovimentiCpayResponse' ) );
             }
              if(String.isBlank(res.causale )){
                 hasError = true;
                 errors.add(new ValidationError('causale  Can\' t empty','RecuperaMovimentiCpayResponse' ) );
             }
              if(String.isBlank(res.segno )){
                 hasError = true;
                 errors.add(new ValidationError('segno  Can\' t empty','RecuperaMovimentiCpayResponse' ) );
             }
             if(String.isBlank(res.importo )){
                 hasError = true;
                 errors.add(new ValidationError('importo  Can\' t empty','RecuperaMovimentiCpayResponse' ) );
             }
             if(String.isBlank(res.dataCompetenza )){
                 hasError = true;
                 errors.add(new ValidationError('dataCompetenza  Can\' t empty','RecuperaMovimentiCpayResponse' ) );
             }
             if(String.isBlank(res.progressivoMovimento )){
                 hasError = true;
                 errors.add(new ValidationError('progressivoMovimento  Can\' t empty','RecuperaMovimentiCpayResponse' ) );
             }
             if(String.isBlank(res.progressivoFase )){
                 hasError = true;
                 errors.add(new ValidationError('progressivoFase  Can\' t empty','RecuperaMovimentiCpayResponse' ) );
             }
             if(String.isBlank(res.evento )){
                 hasError = true;
                 errors.add(new ValidationError('evento  Can\' t empty','RecuperaMovimentiCpayResponse' ) );
             }
             if(String.isBlank(res.flagAbbinato )){
                 hasError = true;
                 errors.add(new ValidationError('flagAbbinato  Can\' t empty','RecuperaMovimentiCpayResponse' ) );
             }
             if(String.isBlank(res.tipoMovimento )){
                 hasError = true;
                 errors.add(new ValidationError('tipoMovimento  Can\' t empty','RecuperaMovimentiCpayResponse' ) );
             }
              if(String.isBlank(res.dataFattura )){
                 hasError = true;
                 errors.add(new ValidationError('dataFattura  Can\' t empty','RecuperaMovimentiCpayResponse' ) );
             }
             if(String.isBlank(res.progressivoFattura )){
                 hasError = true;
                 errors.add(new ValidationError('progressivoFattura  Can\' t empty','RecuperaMovimentiCpayResponse' ) );
             }
             
         }
     }
      return hasError;
   }

 public static RecuperaMovimentiCpayResponse.RecuperaMovimentiCpayRes gestitoRecuperaMovimentiCpay(List<RecuperaMovimentiCpayResponse.RecuperaMovimentiCpayRes> recuperaCpay){
       if(recuperaCpay == null || recuperaCpay.size() == 0){
           return null;
       }
       else {
           /*** Get RecuperaMovimentiCpay most recent */
           List<RecuperaMovimentiCpayRecent> listRecuperaMCpay = new List<RecuperaMovimentiCpayRecent>();
           for(RecuperaMovimentiCpayResponse.RecuperaMovimentiCpayRes recupera : recuperaCpay){
               listRecuperaMCpay.add( new RecuperaMovimentiCpayRecent (recupera) );
           }
           listRecuperaMCpay.sort();
           RecuperaMovimentiCpayResponse.RecuperaMovimentiCpayRes recent = listRecuperaMCpay[0].recuperaCpay;
           eliminandoDividendo(recent);
           return recent;
       }
   }


   public static void eliminandoDividendo(RecuperaMovimentiCpayResponse.RecuperaMovimentiCpayRes recuperaCpay){
       if(recuperaCpay == null ){
          return;
       }
       else {
           String impor = (recuperaCpay.importo).remove('-');
           Integer montant = (Integer.valueOf(impor))/100;
           recuperaCpay.importo = String.valueOf(montant);
           Datetime df= CGMWSUtils_1_0.formatStringToDatetime(recuperaCpay.dataCompetenza);
           String dateFormat = 'dd/MM/yyyy';
           String ds = df.format(dateFormat);
           recuperaCpay.dataCompetenza = ds;
       }
   }
   }