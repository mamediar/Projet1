/**
 * ***********************************************************************************
 *     * @Author Madicke BALDE
 *     * @date  17/07/2019
 *     * @description Service class for Web service RecuperaDatiPostvendita
 * ************************************************************************************
 **/
public  class RecuperaDatiPostvenditaService {
   public static  Map<String, Object> returnValuMap  = new Map<String, Object> ();
   // Error Validation List
   public static List<ValidationError> errors = new  List<ValidationError>();
   
   /**
   *@author Madicke BALDE   
   *@description method to call Web Service
   *@date 
   *@param RecuperaDatiPostvenditaRequest
   *@return RecuperaDatiPostvenditaResponse
    **/
   public static RecuperaDatiPostvenditaResponse invoker(RecuperaDatiPostvenditaRequest request){
       String jr = OCSApiUtils.getMockResponse('ocs.recuperaDatiPostvendita');
       RecuperaDatiPostvenditaResponse response = (RecuperaDatiPostvenditaResponse) JSON.deserialize(jr, RecuperaDatiPostvenditaResponse.class);
       return response;   
      //return (RecuperaDatiPostvenditaResponse) OCSApiUtils.callApi('ocs.recuperaDatiPostvendita', request, RecuperaDatiPostvenditaResponse.class );
   }

   /*****************************************************************************************************************************************
    * @author Madicke BALDE
    * @description method to build request  and invoke Web Service
    * @date
    * @param
    * @return RecuperaDatiPostvenditaResponse
    ******************************************************************************************************************************************/
   public static RecuperaDatiPostvenditaResponse buildRecuperaDatiPostvenditaRequest(String numPratica, String flagInfoCliente,
                                                                                     String filtroTipoPratica, String codCliente,
                                                                                     String cognomeCliente, String nomeCliente,
                                                                                     String dataNascitaCliente,String codFiscaleCliente,
                                                                                     String pan, String telefonoCliente,
                                                                                     String faxCliente, String emailCliente,
                                                                                     String provinciaCliente, String ragioneSociale
                                                                                        ){
       RecuperaDatiPostvenditaResponse response;
       RecuperaDatiPostvenditaRequest request = new RecuperaDatiPostvenditaRequest();
       request.serviceId='recuperaDatiPostvendita';
       request.companyType.put('value', 'COMPASS');
       request.numPratica = numPratica;
       request.flagInfoCliente = flagInfoCliente;
       request.filtroTipoPratica = filtroTipoPratica;
       request.codCliente = codCliente;
       request.cognomeCliente = cognomeCliente;
       request.nomeCliente = nomeCliente;
       request.dataNascitaCliente = dataNascitaCliente;
       request.codFiscaleCliente = codFiscaleCliente;
       request.pan = pan;
       request.telefonoCliente = telefonoCliente;
       request.faxCliente = faxCliente;
       request.emailCliente = emailCliente;
       request.provinciaCliente = provinciaCliente;
       request.ragioneSociale = ragioneSociale;
       response = invoker(request);

       return response;
   }
  /*  public static RecuperaDatiPostvenditaRequest buildRequest(String numPratica, String flagInfoCliente,
                                                                                     String filtroTipoPratica, String codCliente,
                                                                                     String cognomeCliente, String nomeCliente,
                                                                                     String dataNascitaCliente,String codFiscaleCliente,
                                                                                     String pan, String telefonoCliente,
                                                                                     String faxCliente, String emailCliente,
                                                                                     String provinciaCliente, String ragioneSociale
                                                                                        ){
     //  RecuperaDatiPostvenditaResponse response;
       RecuperaDatiPostvenditaRequest request = new RecuperaDatiPostvenditaRequest();
       request.serviceId='recuperaDatiPostvendita';
       request.companyType.put('value', 'COMPASS');
       request.numPratica = numPratica;
       request.flagInfoCliente = flagInfoCliente;
       request.filtroTipoPratica = filtroTipoPratica;
       request.codCliente = codCliente;
       request.cognomeCliente = cognomeCliente;
       request.nomeCliente = nomeCliente;
       request.dataNascitaCliente = dataNascitaCliente;
       request.codFiscaleCliente = codFiscaleCliente;
       request.pan = pan;
       request.telefonoCliente = telefonoCliente;
       request.faxCliente = faxCliente;
       request.emailCliente = emailCliente;
       request.provinciaCliente = provinciaCliente;
       request.ragioneSociale = ragioneSociale;
   
       return request;
                                                                                        } */
   
   /**
     * @author Madicke BALDE    
     * @date
     * @description
     * @param 
     * @return RecuperaDatiPostvenditaResponse
    **/
   public static RecuperaDatiPostvenditaResponse builtbuildRecuperaDatiPostvendit (String codCliente, String filtroTipoPratica, String flagInfoCliente ){
       RecuperaDatiPostvenditaResponse response;
       RecuperaDatiPostvenditaRequest request = new RecuperaDatiPostvenditaRequest();
       request.serviceId='recuperaDatiPostvendita';
       request.companyType.put('value', 'COMPASS');
       request.codCliente = codCliente;
       request.filtroTipoPratica = filtroTipoPratica;
       request.flagInfoCliente = flagInfoCliente;
       response = invoker(request);
       return response;
   }

   /**
     * @author Madicke BALDE
     * @description methode to check if response is valid
     * @date
     * @param  request
     * @return Boolean
   **/
   public static Boolean validateRequest(RecuperaDatiPostvenditaRequest request){
       Boolean hasError = false;
       if(String.isBlank(request.serviceId)){
           hasError = true;
           errors.add( new ValidationError('ServiceId can \' t be empty or null RecuperaDatiPostvenditaRequest', 'serviceId') );
       }
       if(String.isBlank( request.companyType.get('value') )){
           hasError = true;
           errors.add(new ValidationError ('companyType can \' t be empty or null RecuperaDatiPostvenditaRequest', 'companyType') );
       }

        if(String.isBlank( request.numPratica)){
           hasError = true;
           errors.add(new ValidationError ('numPratica can \' t be empty or null RecuperaDatiPostvenditaRequest', 'numPratica') );
       }

       if(String.isBlank( request.flagInfoCliente)){
           hasError = true;
           errors.add(new ValidationError ('flagInfoCliente can \' t be empty or null RecuperaDatiPostvenditaRequest', 'flagInfoCliente') );
       }

       if(String.isBlank( request.filtroTipoPratica)){
           hasError = true;
           errors.add(new ValidationError ('filtroTipoPratica can \' t be empty or null RecuperaDatiPostvenditaRequest', 'filtroTipoPratica') );
       }
        if(String.isBlank( request.codCliente)){
           hasError = true;
           errors.add(new ValidationError ('codCliente can \' t be empty or null RecuperaDatiPostvenditaRequest', 'codCliente') );
       }
        if(String.isBlank( request.codCliente)){
           hasError = true;
           errors.add(new ValidationError ('codCliente can \' t be empty or null RecuperaDatiPostvenditaRequest', 'codCliente') );
       }

        if(String.isBlank( request.cognomeCliente)){
           hasError = true;
           errors.add(new ValidationError ('cognomeCliente can \' t be empty or null RecuperaDatiPostvenditaRequest', 'cognomeCliente') );
       }

        if(String.isBlank( request.nomeCliente)){
           hasError = true;
           errors.add(new ValidationError ('nomeCliente can \' t be empty or null RecuperaDatiPostvenditaRequest', 'nomeCliente') );
       }

        if(String.isBlank( request.dataNascitaCliente)){
           hasError = true;
           errors.add(new ValidationError ('dataNascitaCliente can \' t be empty or null RecuperaDatiPostvenditaRequest', 'dataNascitaCliente') );
       }
        if(String.isBlank( request.nomeCliente)){
           hasError = true;
           errors.add(new ValidationError ('nomeCliente can \' t be empty or null RecuperaDatiPostvenditaRequest', 'nomeCliente') );
       }
        if(String.isBlank( request.codFiscaleCliente)){
           hasError = true;
           errors.add(new ValidationError ('codFiscaleCliente can \' t be empty or null RecuperaDatiPostvenditaRequest', 'codFiscaleCliente') );
       }
        if(String.isBlank( request.pan)){
           hasError = true;
           errors.add(new ValidationError ('pan can \' t be empty or null RecuperaDatiPostvenditaRequest', 'pan') );
       }

        if(String.isBlank( request.codFiscaleCliente)){
           hasError = true;
           errors.add(new ValidationError ('codFiscaleCliente can \' t be empty or null RecuperaDatiPostvenditaRequest', 'codFiscaleCliente') );
       }
        if(String.isBlank( request.pan)){
           hasError = true;
           errors.add(new ValidationError ('pan can \' t be empty or null RecuperaDatiPostvenditaRequest', 'pan') );
       }
        if(String.isBlank( request.codFiscaleCliente)){
           hasError = true;
           errors.add(new ValidationError ('codFiscaleCliente can \' t be empty or null RecuperaDatiPostvenditaRequest', 'codFiscaleCliente') );
       }
        if(String.isBlank( request.pan)){
           hasError = true;
           errors.add(new ValidationError ('pan can \' t be empty or null RecuperaDatiPostvenditaRequest', 'pan') );
       }
        if(String.isBlank( request.telefonoCliente)){
           hasError = true;
           errors.add(new ValidationError ('telefonoCliente can \' t be empty or null RecuperaDatiPostvenditaRequest', 'telefonoCliente') );
       }
        if(String.isBlank( request.faxCliente)){
           hasError = true;
           errors.add(new ValidationError ('faxCliente can \' t be empty or null RecuperaDatiPostvenditaRequest', 'faxCliente') );
       }

         if(String.isBlank( request.emailCliente)){
           hasError = true;
           errors.add(new ValidationError ('emailCliente can \' t be empty or null RecuperaDatiPostvenditaRequest', 'emailCliente') );
       }
        if(String.isBlank( request.provinciaCliente)){
           hasError = true;
           errors.add(new ValidationError ('provinciaCliente can \' t be empty or null RecuperaDatiPostvenditaRequest', 'provinciaCliente') );
       }
        if(String.isBlank( request.ragioneSociale)){
           hasError = true;
           errors.add(new ValidationError ('ragioneSociale can \' t be empty or null RecuperaDatiPostvenditaRequest', 'ragioneSociale') );
       }
       
       return hasError;
   }
   
   /**
     *@author Madicke BALDE 
     *@description method to validate the response
     *@date
     *@param response
     *@return Boolean
    **/
   public static Boolean validateResponse(RecuperaDatiPostvenditaResponse response){
       Boolean hasError = false;
       if(response.resultCode != 0){
           hasError = true;
           errors.add(new ValidationError('invalid response ','resultCode') );
       }
       if(String.isBlank(response.resultMessage) || response.resultMessage !='OK' ){
           hasError = true;
           errors.add(new ValidationError('invalid resultMessage ','resultMessage') );
       }
     if(response.pratiche == null || response.pratiche.size() == 0){
         hasError = true;
         errors.add(new ValidationError('pratiche is null or empty ','pratiche') );
     }
       return !hasError;
   }
   /**
     *@author Madicke BALDE
     *@description sort the response from web service
     *@date
     *@param  RecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO List
     *@return RecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO
    **/
   public static RecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO   checkRecuperaDatiPostvendita(List<RecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO> pratiche){
        System.debug('*************** running ******* checkRecuperaDatiPostvendita '+pratiche);
        Map<Id, RecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO> mapName = new Map<Id, RecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO>();
        if(pratiche == null || pratiche.size() == 0){
                    return null;
        }
        else  {
                    List<PraticheWrapper> oppwList = new List<PraticheWrapper>();
                    for(RecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO prati : pratiche ){
                    oppwList.add(new PraticheWrapper(prati) );
              }
                    oppwList.sort();
                    RecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO  p = oppwList[0].pratiche;
                    System.debug('################# recent oppwList[0].pratiche '+oppwList[0].pratiche);
                
             return p;
        }
   }
   
   /**
     * @auhtor Madicke BALDE
     * @description gestito tipo Pratica CA
     * @date
     * @param PSVDatiPraticaDTO
     * @return Map<String, Object>
    **/
    public static void  checkRecuperaDatiPostvenditaCA(RecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO pratiche,  Map<String, Object> returnValuMap){
          Map<String, Object> returnVMap = new Map<String, Object>();
            if(pratiche == null || pratiche.tipoPratica!='CA'){
            return;
            }
            else {
                returnValuMap.put('tipoPratica', 'CA');
                System.debug('****************** checkRecuperaDatiPostvenditaCA ');
                RecuperaMovAutViaggiantiResponse responseMovAutViaggian = RecuperaMovAutViaggiantiService.buildRecuperaMovAutViaggiantRequest(  'CA',
                                                                                                                                                '12', 'AG', 'emettitore',
                                                                                                                                                 pratiche.numPratica, 'pan', 'dataRegistrazione', 'tipoRecord',
                                                                                                                                                'progressivo', 'protocollo', 'riga', 'tipoChiave',
                                                                                                                                                'statoAutorizzazione', 'esitoAutorizzazione', 
                                                                                                                                                'dataAutorizzazione', 'numElementi', 'S',
                                                                                                                                                'S', 'utente');
                                                                                                                                        
                System.debug('****************** checkRecuperaDatiPostvenditaCA '+responseMovAutViaggian);

                returnVMap =   RecuperaMovAutViaggiantiService.recuperaMovAutViaggiantiControl(responseMovAutViaggian);
                System.debug('********** returnVMap tipoMouv '+returnVMap.get('tipoMouv'));
                returnValuMap.put('autorizzazioni', returnVMap.get('autorizzazioni'));
                returnValuMap.put('movimenti', returnVMap.get('movimenti'));
                returnValuMap.put('tipoMouv', returnVMap.get('tipoMouv'));
                System.debug(' ******************* returnValuMap '+returnValuMap);
                
            }
    }
    
    /**
     * @auhtor Madicke BALDE
     * @description gestito tipo Pratica CO
     * @date
     * @param PSVDatiPraticaDTO
     * @return Map<String, Object>
    **/
    public static  void checkRecuperaDatiPostvenditaCO (RecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO pratiche, Map<String, Object> returnValuMap){
        if(pratiche == null || pratiche.tipoPratica!='CO'){
                return;
        }
            else {
                 returnValuMap.put('tipoPratica', 'CO');
                COGETECV1Response.MFTCOECO_ELEMENTO recentElemento;

                COGETECV1Response response = COGETECV1Service.buildCOGETECV1Response('mftcoeciNUMPRATICA', 'msfilogonUTENTEOVR', 
                                                                                    'msfilogonRIFSICOVR', 'msfilogonUTENTEAS400', 
                                                                                    'msfilogonCODINTFILIALE', 'msfilogonCREAUTENTECOLL',
                                                                                    'msfilogonPOSTAZIONE', 'mftcoeciPROGRESSIVO',
                                                                                    'mftcoeciDATASITUAZIONE', 'mftcoeciSELEZSCAD', 
                                                                                    'mftcoeciSELEZSALDO', 'mftcoeciNUMELEMENTI',
                                                                                    'msflogonTMPKEY', 'msfilogonSENDERTIPO', 
                                                                                    'msfilogonSENDERCODICE', 'msfilogonCANALEACQUISIZ', 'msfilogonTIPOCARICAMENTO');
        
        
                System.debug(' ************* validateResponse(response) response  '+response);
                System.debug(' ************* validateResponse(response) response  '+response.cogetecv1Response.mftcoecoOCCURS.size());
                Boolean b = COGETECV1Service.validateResponse(response);
                System.debug(' ************* the validateResponse(response)  '+b);
                System.debug('************ error '+COGETECV1Service.errors);
                System.debug('******** response.cogetecv1Response.mftcoecoOCCURS.size()'+response.cogetecv1Response.mftcoecoOCCURS.size());
                if(COGETECV1Service.validateResponse(response)){
                    //MFTCOECO occur = response.o
                    System.debug('*********** occur ');
                    COGETECV1Response.MFTCOECO occur = response.cogetecv1Response.mftcoecoOCCURS[0];
                    recentElemento = COGETECV1Service.gestitoCOGETECV1Service(occur.mftcoecoELEMENTO);
               }
                 returnValuMap.put('mftcoecoElemento',recentElemento);
            }
    }

    /**
     * @auhtor Madicke BALDE
     * @description gestito tipo Pratica CP
     * @date
     * @param PSVDatiPraticaDTO
     * @return Map<String, Object>
    **/
    public static void checkRecuperaDatiPostvenditaCP (RecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO pratiche, Map<String, Object> returnValuMap){
            System.debug('********* checkRecuperaDatiPostvenditaCP ');
            if(pratiche == null || pratiche.tipoPratica!='CP'){
                 return;
            }
                else {
                    returnValuMap.put('tipoPratica', 'CP');
                    RecuperaMovimentiCpayResponse response = RecuperaMovimentiCpayService.buildRecuperaMovimentiCpayRequest('numPratica', 'dataCompetenzaDa', 'dataCompetenzaA');
                    RecuperaMovimentiCpayResponse.RecuperaMovimentiCpayRes mostRecent = RecuperaMovimentiCpayService.gestitoRecuperaMovimentiCpay(response.recuperaMovimentiCpayResponse.elenco);
                    returnValuMap.put('recuperaCpay', mostRecent);
                   // return mostRecent;
                }
    }
    
    /** --------------------------------------------------------------------------------------------
     * @auhtor Madicke BALDE
     * @description gestito tipo Pratica CA
     * @date
     * @param PSVDatiPraticaDTO
     * @return Map<String, Object>
    *---------------------------------------------------------------------------------------------- */
    public static Map<String, Object> recuperaDatiPostvenditaControl(Id idCase, GestioneRichiestaOnline1Cnt.QuestionManagement objName){
                System.debug(' ********** running recuperaDatiPostvenditaControl **** ');
                
        returnValuMap.put('error',false);
        try {
                System.debug('************ qm '+ objName);
                GestioneRichiestaOnline1Cnt.QuestionManagement qm = (GestioneRichiestaOnline1Cnt.QuestionManagement) objName;
                Case c = CaseService.getCaseBiId(idCase);
                String  dataNascitaCliente;
                if( c.Id != null){
                    String filtroPratica = buildFiltroPratica(qm.products);
                    System.debug('************** filtroPratica '+filtroPratica);
                    RecuperaDatiPostvenditaResponse response = buildRecuperaDatiPostvenditaRequest(c.NumeroPratica__c, '',
                                                                                                '', c.Codice_Cliente__c, c.Account.LastName, 
                                                                                                c.Account.FirstName, 'dataNascitaCliente', c.Account.Codice_Fiscale__c,
                                                                                                c.pan__c, c.Account.Phone, c.Account.Fax, c.Account.BusinessEmail__c,
                                                                                                c.Account.ResidenceProvince__c, c.Account.Region_Name__c); 
                    
                    
                    System.debug('*********** response *********** '+response);
                    System.debug('***********  Validatio, *********** '+RecuperaDatiPostvenditaService.validateResponse(response));
                    if(!RecuperaDatiPostvenditaService.validateResponse(response)){
                        System.debug('*********** if error *********** ');
                        returnValuMap.put('error', true);
                        returnValuMap.put('errorMessage', RecuperaDatiPostvenditaService.errors);
                    }
                    else {
                            RecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO  p = checkRecuperaDatiPostvendita(response.pratiche);
                            System.debug('************ PSVDatiP$raticaDTO  *********** '+ p.dataCaricamento);
                            System.debug('********** checkPraticheIsValide(p) '+checkPraticheIsValide(p));
                            if(checkPraticheIsValide(p)){
                                returnValuMap.put('isPraticaOK', true);
                                checkRecuperaDatiPostvenditaCA(p, returnValuMap);
                                checkRecuperaDatiPostvenditaCO(p, returnValuMap);
                                checkRecuperaDatiPostvenditaCP(p, returnValuMap); 
                            }
                            else {
                                returnValuMap.put('isPraticaOK', false);
                            }
                        System.debug('*************** map in RecuperaDati ******* '+ returnValuMap);
                    }
                    }
        }
        catch (Exception e) {
                    returnValuMap.put('error', true);
                    System.debug(' *********************** errorMessage RecuperaDatiPostvenditaControl '+e.getMessage());
                    System.debug(' *********************** errorMessage '+e.getStackTraceString() );

        }
        return returnValuMap;
    }

    /**---------------------------------------------------------------------------------------------
     * @auhtor Madicke BALDE
     * @description build filtroPratica
     * @date
     * @param ProductObject List
     * @return String
    *------------------------------------------------------------------------------------------------*/
    public static String buildFiltroPratica( List<GestioneRichiestaOnline1Cnt.ProductObject>  productObjets ){
        String filtropratica='';
        Integer cmpt = 0;
        for( GestioneRichiestaOnline1Cnt.ProductObject ob : productObjets){
               filtropratica  =filtropratica + ob.prodotto +'#';
        }
        return filtropratica.removeEnd('#');
    }

    /**
      * @author Madicke BALDE
      * @descriptio
      *@date
     */
    public static Boolean checkPraticheIsValide(RecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO pratiche ){
        System.debug('############################# checkPraticheIsValide '+pratiche.tipoPratica);
       Boolean isPraticheOK = false;
      if(pratiche == null ){
         return isPraticheOK;
      }  
      else{
           switch on pratiche.tipoPratica {
               when  'CA' {
                  if( checkStatoAttributoBlank(pratiche.codStatoPratica,pratiche.codAttributoPratica)||
                      checkStatoAttributoCF(pratiche.codStatoPratica,pratiche.codAttributoPratica) ||
                      checkStatoAttributoAN(pratiche.codStatoPratica,pratiche.codAttributoPratica) ||
                      checkStatoAttributoFP(pratiche.codStatoPratica,pratiche.codAttributoPratica)||
                      checkStatoAttributoFPRB(pratiche.codStatoPratica,pratiche.codAttributoPratica) ){
                          isPraticheOK = true;
                      }
               }
               when 'CP' {  
                    if (checkStatoAttributo50Blank(pratiche.codStatoPratica, pratiche.codAttributoPratica) ){
                        isPraticheOK = true;
                    }
               }
               when else {
                   System.debug('pratiche.codStatoPratica '+pratiche.codStatoPratica);
                   System.debug('pratiche.codAttributoPratica '+pratiche.codAttributoPratica);
                   if(checkStatoAttributo40Blank(pratiche.codStatoPratica, pratiche.codAttributoPratica)){
                       isPraticheOK = true;
                   }
                     
               }
           }
           return isPraticheOK;
      }

    }

    public static Boolean checkStatoAttributoBlank(String stato, String attributo ){
         Boolean isOk = false;
         if(String.isBlank(stato)){
            return isOk;
        }
         else if(Integer.valueOf(stato) == 50 && String.isBlank(attributo)){
             isOk = true;
         }
      return isOk;
    }

    public static Boolean checkStatoAttributoCF(String stato, String attributo){
        Boolean isOk = false;
        if(String.isBlank(stato)){
            return isOk;
        }
       else if(Integer.valueOf(stato) == 30 && attributo.equals('CF')){
            isOk = true;
        }
        return isOk;
    }

     public static Boolean checkStatoAttributoAN(String stato, String attributo){
        Boolean isOk = false;
        if(String.isBlank(stato)){
            return isOk;
        }
       else  if( Integer.valueOf(stato) == 30 && (attributo.equals('RT') || attributo.equals('AN')) ){
            isOk = callRecuperaInfoInserimentoBlocco('numeroCarta', 'bloccoCarta', attributo, true);
            System.debug('************* isOK checkStatoAttributoAN '+isOk);
        }
        return isOk;
    }

    public static Boolean callRecuperaInfoInserimentoBlocco(String numeroCarta, String bloccoCarta, String attributo, Boolean b){
        Boolean isOK = b;
      if(attributo.equals('AN') ){
           RecuperaInfoInserimentoBloccoResponse response = RecuperaInfoInserimentoBloccoService.buildRecuperaInfoInserimentoBloccoResponse('numCarta', 'bloccoCarta');
           if(RecuperaInfoInserimentoBloccoService.validateResponse(response)){
               Date inserimentoDate = CGMWSUtils_1_0.formatStringToDate(response.recuperaInfoInserimentoBloccoResponse.dataInserimento);
               if(checkDataInserimento(inserimentoDate)){
                 isOK = true;
               }
               else {
                   isOK = false;
               }
           }
           else {
               isOK = false;
           }
      }
      return isOK;
    }

    public static Boolean checkDataInserimento(Date dateValue){
        System.debug('******* dateValue.addMonths(12) '+dateValue.addMonths(12));
        if(dateValue.addMonths(12) > Date.today() ){
             System.debug('******* dateValue.addMonths(12)  OK');
            return true;    
        }
        else {
              System.debug('******* dateValue.addMonths(12)  NO');
            return false;
        }
    }

    public static Boolean checkStatoAttributoFP(String stato, String attributo){
        Boolean isOk = false;
        if(String.isBlank(stato)){
            return isOk;
        }
       else  if(Integer.valueOf(stato) == 60 && (!attributo.equals('AN') || !attributo.equals('FP')|| !attributo.equals('LS') ||
                                      !attributo.equals('CV') || !attributo.equals('CE') || !attributo.equals('PP')||
                                     !attributo.equals('VI') || !attributo.equals('RT'))){
                                      isOk = true;
                                      
                                     }

        return isOk;
    }
    public static Boolean checkStatoAttributoFPRB(String stato, String attributo){
        Boolean isOk = false;
        if(String.isBlank(stato)){
            return isOk;
        }
        else  if(Integer.valueOf(stato) == 60 && attributo.equals('RB')){
            isOk = true;
        }
        return isOk;
    }

    public static Boolean checkStatoAttributo40Blank(String stato, String attributo){
        Boolean isOk = false;
        if(String.isBlank(stato)){
            return isOk;
        }
        else if(Integer.valueOf(stato) == 40 && String.isBlank(attributo)){
            isOk = true;
            return  isOk;
        }
        else {
           return isOk;
        }
       
    }
    public static Boolean checkStatoAttributo50Blank(String stato, String attributo){
        Boolean isOk = false;
        if(String.isBlank(stato)){
            return isOk;
        }
       else if(Integer.valueOf(stato) == 50 && String.isBlank(attributo)){
            isOk = true;
            return  isOk;
        }
        else {
           return isOk;
        }
       
    }

}