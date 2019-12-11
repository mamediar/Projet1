/*------------------------------------------------------------------
*  @description  CreaProspect web service 
*  @author  Madicke BALDE
*  @date  13/03/2019
*-------------------------------------------------------------------- */
@RestResource(UrlMapping = '/CreaProspect')
global with sharing class RequestOnlineApexClass extends CGMServiceWsr_1_1 {

    // Map contains require field to call web service
    public  static Map<String, String> Case_MANDATORY_FIELDS_POST_MAP = new Map<String, String>{
            'codProdottoCRM' => ''
    };
    public static String  errorCode;
    public static  String  errorMessage;
    public Map<String, Object> dataMap = new Map<String, Object>();
    public  static   Map<String, Object> data = new Map<String, Object>();

     /**  Request Type: POST */
    public final static String TYPE_POST = 'POST';
    /**  Request Type: PUT */
    public final static String TYPE_PUT = 'PUT';



    /*****************************************************************************************
    * HttpGet method is used to capture a HttpGet request has been sent to our rest apex class.
    *
    * Used to request data on the basis of a parameter sent in the URL
    *
    * @description
    *            CreaAggiornaRichiestaOnline create list of case
    *
    * @return CGMWSRResponse
    ***********************************************************************************************/
    @HttpPost
    global static void  CreaAggiornaRichiestaOnline (){
        final RestRequest req = RestContext.request;
        final RestResponse res = Restcontext.response;
         
        try {
                System.debug('*********** runningCreaAggiornaRichiestaOnline ');
                System.debug(' ############# reqRequestBody '+req.requestBody);
                String responseb = execute(req.requestBody);
                res.statusCode = 200;
                res.responseBody = Blob.valueOf(responseb);
               
          }  catch (Exception e) {
                System.debug('exeption ********* '+errorCode);
                String errm =  CGMWSUtils_1_0.ERROR_MESSAGE_MAP.get(errorCode);
                System.debug(' ************* errm'+errm);
                CGM_WSR_Response response = new CGM_WSR_Response();
             /*   response.errorCode = errorCode;
                response.resultMessage = 'KO';
                response.errorMessage = errm +' '+ errorMessage;
                response.resultCode = 1;*/
                response.resultCode = 1;
                response.resultMessage = errm +' '+ errorMessage;
                String rb = JSON.serialize(response);
                res.responseBody = Blob.valueOf(rb);
                res.statusCode = 500;
            return;
            
        }

    }
    

    /**********************************************************************************************
     * @author Madicke BALDE
     * Deserialize the rest request body
     * @param requestBody rest request body
     *@date 2019/07/31
     * @return the request body deserialized in the case wrapper class
     * @code 01
     ********************************************************************************************/

     public static CreaProspectRequest  deserializeReqBody (Blob requestBody){
          try {

            String jsonRequestBody = requestBody.toString().trim();
            System.debug('************** jsonRequestBody '+ jsonRequestBody);
            CreaProspectRequest creaprospectRequest =
                    (CreaProspectRequest) JSON.deserializeStrict(jsonRequestBody, CreaProspectRequest.class);
             System.debug('*** CreaProspectRequest ############# '+CreaProspectRequest);
            return creaprospectRequest;
        } catch (Exception ex) {
            System.debug('errorMessage' + ex.getMessage());
            System.debug('************ '+ex.getStackTraceString());
             errorCode = '[KO-CREQ0005]';
             System.debug('************  errorCode '+errorCode);
            throw new CGMWSUtils_1_0.CGMWSRException('[KO-CREQ0005]');
          
        }

     }
    
    /**
    *@Author Madicke BALDE  
    *@description method to execute request
     *@param jsonRequest : the json request
     *@param String : the String response
     */
    public static String execute(Blob jsonRequest){
        String responseV;
        Case c ;
        try {
             System.debug('*********** running execute');
                CreaProspectRequest creaProspectRequest = deserializeReqBody(jsonRequest);
                createCaseRichData(creaProspectRequest); 
                validateData(Case_MANDATORY_FIELDS_POST_MAP, TYPE_POST);
                System.debug('*********** running execute');
                Product2 produit = ProdottoService.getProdottoByCode(creaProspectRequest.datiProdotti[0].codProdottoCRM);
               // Product2 produit = new Product2();
                c =  (Case) data.get('case');
                setSubjectCategorie(c, produit);
              /*  c.Subject = 'Richiesta online per'+produit.Livello__c+'-'+produit.parameter_product_Ivl2__c;
                 c.Categoria__c = 'Centro Recupero';*/
                System.debug('*********** test in execute ********** '+c.Id);
                Account a = (Account) data.get('account');
                Map<Account,Account> accountMap = new Map<Account,Account>();
                accountMap.put(a, null);
               // XCSGestioneAnagrafica.execute(accountMap, false, false);
                 XCSGestioneAnagrafica.deduplica(accountMap, false);
                c.Product__c = produit.Id;
                System.debug('********************** accountMap '+accountMap.get(a).Id);
                System.debug('******************* AccountId***************** '+a.Id);
                c.AccountId = accountMap.get(a).Id;
                
                CreaProspectService.gestatoRequestOnline(c, a, produit, CreaProspectRequest.idAnagCRM);
                Map<String, Object> resp =  CreaProspectService.returnValueMap;
                System.debug('************ resp Map  *********** '+resp);
                for (String key : resp.keySet()){
                      System.debug('************ resp Map  *********** '+resp.get(key));
                } 
                System.debug('################# case '+resp.get('case'));
                Integer fea ;
            if(resp.get('case') != null){
                 fea =   checkFea(((Case)resp.get('case')).Id);
                    System.debug('********* caseId '+c.Id);
                    String caseNumber = CaseService.getCaseNumner(c.Id);
                    String  numPratica =  CaseService.getNumeroPratica(c.Id);
                    // String codOcsPratica, String codProdottoCRM, Integer flagFea,String incidentIdCRM,String tipoProdotto 
                   
                   
                 /*  if(((Case)resp.get('case')).RO_fea__c == null){
                     fea = 0;
                    }
                    else{
                       fea =  (((Case)resp.get('case')).RO_fea__c == true?1:0);
                    }   */
                  
                    DatiProdotto dp = build_DatiProdotto(numPratica, produit.ProductCode, fea, caseNumber, c.Tipo_Prodotto__c);  
                     Map<String, Object> caseMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(c));    
                   
                    CreaProspectResponse response = new CreaProspectResponse( (Id)caseMap.get('AccountId'), dp);
                    response.resultCode = 1;
                    response.resultMessage ='OK';
                    System.debug('********* CaseNumber '+caseNumber);
                    responseV = JSON.serialize(response);
            }
            if(resp.get('codeErreur') != null){
                    CGM_WSR_Response response = new CGM_WSR_Response(); 
                    /**  response.errorCode = 'xxx';
                    response.resultMessage = 'OK'; */
                    if(String.isNotEmpty((String)  resp.get('codiceCliente'))){
                        response.errorMessage = CGMWSUtils_1_0.ERROR_MESSAGE_MAP.get('[CRAPROS-001]');
                    }
                    else {
                        response.errorMessage = CGMWSUtils_1_0.ERROR_MESSAGE_MAP.get('[CRAPROS-002]');
                    } 
                   
                    response.resultCode = 9;
                    responseV = JSON.serialize(response);
            }
            if(resp.get('caseId') != null){
                  //  String caseNumber = CaseService.getCaseNumner((String)resp.get('caseId'))
                  
                  //  System.debug(' ##################### c.NumeroPratica__c '+c.NumeroPratica__c);
                     
                     fea =  checkFea(((Case)resp.get('caseId')).Id );
                     Case cc = (Case)resp.get('caseId');
                     Map<String, Object> caseMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(cc));
                      
                     System.debug(' ##################### cc '+cc ); 
                     System.debug(' ##################### cc  Id'+cc.Id ); 
                     System.debug(' ##################### (Case)resp.get(caseId) '+caseMap.keySet());
                      System.debug(' ##################### (Case)resp.get(caseId) Account '+(Id) caseMap.get('AccountId'));

                    DatiProdotto dp = build_DatiProdotto(((Case)resp.get('caseId')).NumeroPratica__c, produit.ProductCode, fea , ((Case)resp.get('caseId')).CaseNumber, c.Tipo_Prodotto__c);      
                    CreaProspectResponse response = new CreaProspectResponse((Id) caseMap.get('AccountId'), dp); 
                    response.resultCode = 1;
                    response.resultMessage ='OK';
                    //System.debug('********* CaseNumber '+caseNumber);
                    responseV = JSON.serialize(response);   
            } 
           
        } catch (Exception ex) {
            System.debug('*************** error Message '+ex.getMessage());
            System.debug('*************** error Message '+ex.getStackTraceString());
        } 
        
        return responseV;
    } 
    /**
    *@author Madicke BALDE
    *@description this methode create Case/Account/RO_CRMRich_online_prescoring__c/RO_CRMRich_online_steplog__c object
    *@param creaprospect
    */
    public static void createCaseRichData(CreaProspectRequest creaprospect){
            System.debug(' ************  creaprospect '+creaprospect);
            /******************************** Create Account Object **************************** */
            String professione = String.isNotBlank(creaprospect.professione) ?  AccountService.getPickListValuesIntoList(creaprospect.professione) : null;
            Account account = new Account(
            LastName = creaprospect.cognome,
            FirstName = creaprospect.nome,
            PersonEmail = creaprospect.email,
            BusinessEmail__c = creaprospect.email,
            PersonHomePhone =    creaprospect.recapitoTel,
          //  Codice_Cliente__c = creaprospect.idAnagOcs,
            Codice_Fiscale__c = creaprospect.codiceFiscale,
            Occupation_Lvl1__c = professione,
           // OCS_External_Id__c = creaprospect.idAnagOcs,
            Codice_Fiscale__pc = creaprospect.codiceFiscale
           // RSS_External_Id__c = creaprospect.idAnagCRM,
            //Status__pc         = creaprospect.stato
            );
            setBooleanFielConsensoPrivacy(account, 'Ma_Opt_In__pc',creaprospect.ConsensoPrivacy2);
            setBooleanFielConsensoPrivacy(account, 'OtherService__pc',creaprospect.ConsensoPrivacy2);
            setBooleanFielConsensoPrivacy(account, 'Privacy_Profilazione__pc',creaprospect.ConsensoPrivacy2);
            data.put('account', account);
            //***************** Create Objet Case **************************************
            // Case c = new Case();
            Case c = (checkCaseExistence(creaprospect.datiProdotti[0].incidentIdCRM) == null) ?new Case() : checkCaseExistence(creaprospect.datiProdotti[0].incidentIdCRM);
            // Case c = null;
            Date utm_date = (String.isNotBlank(creaprospect.utm_Date))? CGMWSUtils_1_0.formatStringToDate(creaprospect.utm_Date): null;

            setStringField(c, 'Tipo_Prodotto__c', creaprospect.datiProdotti[0].tipoProdotto);
            //  Case c = new Case();

            setStringField(c, 'Codice_Cliente__c', creaprospect.idAnagOcs);

            setStringField(c, 'RO_Link_Bozza__c', creaprospect.linkBozza);

            setStringField(c, 'RO_Engine_channel__c', creaprospect.engine_channel);

            setStringField(c, 'RO_Current_Step__c', creaprospect.step);

            setStringField(c, 'RO_idpartner__c', creaprospect.idPartnerOcs);

            setStringField(c, 'RO_idcarrello__c', creaprospect.idCarrello);

            setStringField(c, 'utm_source__c', creaprospect.utm_Source);

            setStringField(c, 'utm_medium__c', creaprospect.utm_Medium);

            setStringField(c, 'utm_content__c', creaprospect.utm_Content);

            setStringField(c, 'utm_campaign__c', creaprospect.utm_Campaign);
            setStringField(c, 'utm_term__c', creaprospect.utm_Term);
            setStringField(c, 'utm_history__c', creaprospect.utm_History);
            setStringField(c, 'AccountId', creaprospect.utm_History);
            // c.utm_date__c = utm_date;
            setDateFields(c, 'utm_date__c', creaprospect.utm_Date);
            setBooleanFields(c,'RO_fea__c', creaprospect.datiProdotti[0].flagFea);
            // System.debug(' *********************** c.RO_fea__c '+c.RO_fea__c); 
            /*   setStringField(c, 'Privacy_Profilazione__pc', creaprospect.consensoPrivacy4);
            setStringField(c, 'OtherService__pc', creaprospect.consensoPrivacy3); */

            //  setStringField(c, 'Ro_Privacy_OptIn__c', creaprospect.consensoPrivacy2); 
            setStringField(c, 'RO_Mediacode__c', creaprospect.utm_Mediacode);
            setStringField(c, 'NumeroPratica__c', creaprospect.datiProdotti[0].codOcsPratica);
            setStringField(c, 'Status', creaprospect.stato);
            setStringField(c, 'AccountId', creaprospect.idAnagCRM);
            setStringField(c, 'stato_ocs__c', creaprospect.statoOcs);

            setStringField(c, 'Attributi_Pratica__c', creaprospect.attributiPratica);

            setStringField(c, 'Stato_Pratica__c', creaprospect.idAnagOcs);
            c.Origin = 'WEB';                
            data.put('case',c);

            /*************  RO_CRMRich_online_prescoring__c object  *****************************/
            RO_CRMRich_online_prescoring__c rop = new RO_CRMRich_online_prescoring__c();
          //  rop.Pricing__c = creaprospect.enginePricing;
            rop.Channel__c = creaprospect.canale ;
            rop.RO_Input_motore__c = creaprospect.engineInput_XML;
            // rop.RO_output_motore__c = creaprospect.engineOutput_XML;
            data.put('rop', rop); 

            /*************  RO_CRMRich_online_steplog__c  object  *****************************/
            RO_CRMRich_online_steplog__c ros = new RO_CRMRich_online_steplog__c();
            ros.RO_CRMStep__c = creaprospect.step;
            ros.RO_CRMModalita_firma__c = creaprospect.modalitaFirma;
            ros.RO_CRMModalita_richiesta__c = creaprospect.modalitaRichiesta;
            ros.RO_documenti__c = creaprospect.docsUploaded;
            data.put('ros', ros);


            // *********************** Create MAP FOR REQUIRE FIELD ************************ 
            // System.debug(' ***************** codProdottoCRM '+creaprospect.codProdottoCRM);
            Case_MANDATORY_FIELDS_POST_MAP.put('codProdottoCRM', creaprospect.datiProdotti[0].codProdottoCRM);
    }

    /**********************************************************************************************************
     * Check if case with got informations already exists in the system. If a verified
     *
     * case exists
     *
     * @param  caseId : the Case Id
     *
     * @return case of verified case was found
     *
     * @code 01
     ***************************************************************************************************************/
    global static Case checkCaseExistence(String caseNumber) {
        if (String.isNotBlank(caseNumber)) {
            List<Case> cases = [
                    SELECT
                            Id, caseNumber, RO_Current_Step__c, Status,
                           RO_idpartner__c, RO_idcarrello__c,Tipo_Prodotto__c
                    FROM Case
                    WHERE
                            caseNumber = :caseNumber
            ];
            if (!cases.isEmpty()) {
                return cases[0];
            }
        }
        return null;
    }


    /** -----------------------------------------------------------------
     * @description This method verify the validat case
     * @param cas : 
     * @param requestType
     * @return  void
     *-------------------------------------------------------------------*/
   global static void validateData( Map<String, String> fieldRequire, String requestType){
       System.debug(' ************ ruuning validateData ');
        List<String> errorFields = new List<String>();
        
        // Iterate over mandatory fields
        if (requestType == 'POST') { 
       for(String fieldName : fieldRequire.keySet() ) {
                    if( String.isBlank( (String) fieldRequire.get(fieldName)) )
                      errorFields.add(fieldName);
            
                     }
        }
        if(!errorFields.isEmpty() ){
            System.debug('*********  errorFields not empty ');
            errorCode ='[KO-CREQ0007]';
            errorMessage = String.join(errorFields, ', ');
            throw new CGMWSUtils_1_0.CGMWSRException('[KO-CREQ0007]', String.join(errorFields, ', '));
        }
   }


    /**---------------------------------------------------------
      * @author Madicke BALDE
      * @description  wrapper class to costom web service response
     *--------------------------------------------------------------*/
    global class CreaProspectResponse extends GenericResponse {
        public String idCrm;
        public DatiProdotto datiprodotto;
        public CreaProspectResponse (){
            super();
        }
        public CreaProspectResponse (String idCrm, DatiProdotto datiprodotto){
            super();
            this.datiprodotto = datiprodotto;
            this.idCrm = idCrm;
        }   
    }

    /**------------------------------------------------------------------------
    * @author Madicke BALDE
    * @description wrapper class for response
    *--------------------------------------------------------------------------*/
    global class DatiProdotto {
        public String codOcsPratica;
        public String codProdottoCRM;
        public  Integer flagFea;
        public String incidentIdCRM;
        public String tipoProdotto;

        public DatiProdotto(String codOcsPratica, String codProdottoCRM, Integer flagFea, String incidentIdCRM,String tipoProdotto){
          this.codOcsPratica = codOcsPratica;
          this.codProdottoCRM = codProdottoCRM;
          this.flagFea = flagFea;
          this.incidentIdCRM = incidentIdCRM;
          this.tipoProdotto = tipoProdotto;

        }
    }

    public  static DatiProdotto build_DatiProdotto(String codOcsPratica, String codProdottoCRM, Integer flagFea,String incidentIdCRM,String tipoProdotto  ){
          DatiProdotto dp = new DatiProdotto(codOcsPratica, '1;'+codProdottoCRM, flagFea, incidentIdCRM, tipoProdotto);
          return dp;
    }
    

    /***************************************************************************
      * @Author Madicke BALDE
      * @description wrapper class for deserialization
      * @date 
    ****************************************************************************/
    public class CreaProspectRequest {
    /*    public String tipoPratica { get; set; }
        public String vecchioCell { get; set; }
        public  String nuovoCell { get; set; } */
        public  String linkBozza { get; set; }
        public String step { get; set; }
        public String utm_Source { get; set; }
        public String utm_Medium { get; set; }
        public String utm_Content { get; set; }
        public String utm_Campaign { get; set; }
        public String utm_Term { get; set; }
        public String utm_Date { get; set; }
        public String utm_History { get; set; }
        public String utm_Mediacode {get; set;} 
        public String docsUploaded {get;set;}
      //  public String codProdottoCRM { get; set; }
        //public Integer flagFea { get; set; }
        public String cognome { get; set; }
        public String privacy { get; set; }
        public String privacy2 { get; set; }
        public String privacyProfil { get; set; }
        public String nome { get; set; }
        public String recapitoTel { get; set; }
        public String codiceFiscale { get; set; }
        public String employment { get; set; }
      //  public String tipoProdotto { get; set; }
        public String email { get; set; }
        public String inputMotore {get; set;}
        public String ouputMotore {get; set;}
        public String engine_Pricing {get; set;}
        public String engineInput_XML {get;set;}
        public String engineOutput_XML {get;set;}
        public String modalitaFirma {get; set;}
        public String modalitaRichiesta {get;set;}
        public String engine_channel {get;set;}
        public String documenti {get;set;}
        public String consensoPrivacy {get;set;}
        public String consensoPrivacy2 {get; set;}
        public String consensoPrivacy3 {get; set;}
        public String consensoPrivacy4 {get; set;}
        public String idAnagOcs {get; set;} 
        public String idAnagCRM {get;set;}
        public String professione {get; set;}  
      // public String incidentIdCRM {get; set;}  
      // public String codOcsPratica {get;set;}
        public String id {get;set;}
        public String stato {get;set;}
        public String idPartnerOcs {get;set;}
        public String idCarrello {get;set;}
        public String statoOcs {get;set;}
        public String attributiPratica {get;set;}
        public String statoPratica {get;set;}
        public String dataFineValid {get;set;}
        public String dataIns {get;set;}
        public String dataUltimaVar {get;set;}
        public String codUteUltimaVar {get;set;}
        public String codUteIns {get;set;}
        public String canale {get;set;}
        public String operatore {get;set;}
        public List<DatiProdotti>  datiProdotti {get;set;}
    }

    public class DatiProdotti {
        public String codOcsPratica {get;set;}
        public String codProdottoCRM {get;set;}
        public String flagFea {get;set;}
        public String incidentIdCRM {get;set;}
        public String opIdCRM {get;set;}
        public String tipoProdotto {get;set;}
    }

    /*****************************************************************************
      * @Author Madicke BALDE
      * @description  
      * @date
    *******************************************************************************/  
    public static void setStringField(Case c , String fieldName, String fieldValue){
        System.debug('************* runnginh  setStringField ******* ');
        if(fieldValue == null) return;
        if(fieldValue.trim().equals('')) c.put(fieldName, null);
        else c.put(fieldName, fieldValue);      
    }

    /*****************************************************************************
      * @Author Madicke BALDE
      * @description
      * @date
    *****************************************************************************/
    public static void setDateFields(Case c, String fieldName, String fieldValue){
        if(fieldValue == null) return;
        if(fieldValue.trim().equals('')) c.put(fieldName, null);
        else c.put(fieldName, CGMWSUtils_1_0.formatStringToDate(fieldValue));
    }

    /*****************************************************************************
      * @Author Madicke BALDE
      * @description 
      * @date
    ******************************************************************************/
    public static void setBooleanFields(Case c, String fieldName, String fieldValue){
        if(fieldValue == null) return;
        else {
            Integer fieldV = Integer.valueOf(fieldValue);
            Boolean value = (fieldV == 1)?true:false;
            c.put(fieldName, value);
        }
    }
    /**------------------------------------------------------------------------------------------
      *@Author Madicke BALDE
      *@description
      *@param
      *@param
      *@param
      *---------------------------------------------------------------------------------------------*/
    public static void setBooleanFielConsensoPrivacy(Account c , String fieldName, String fieldValue){
        if(fieldValue == null) return;
        else {
          //  Integer fieldV = Integer.valueOf(fieldValue);
            Boolean value = (fieldValue == 'S')?true:false;
            c.put(fieldName, value);
        }
    } 

    public static Integer checkFea(Id idCase){
      Case c = [SELECT Id, RO_fea__c FROM Case WHERE Id=: idCase ];
      System.debug('############### c.RO_fea__c '+c.RO_fea__c);
      if(c.RO_fea__c == null) return 0;
         Integer f = (c.RO_fea__c == true)?1:0;
         
         return f;
      
    }

    public static void setSubjectCategorie(Case c, Product2 p){
      c.Subject = 'Richiesta online per '+p.Parent__r.Name+'-'+p.Name;
    //  Case ca = [SELECT Id, CategoriaExternalId__c, Categoria_Riferimento__r.Name FROM Case WHERE Id=:c.Id]; 
     XCS_Categoria__c categorie = [SELECT Id, Name FROM XCS_Categoria__c WHERE Name='Richieste Online'];
     c.Categoria_Riferimento__c = categorie.Id;
     /* System.debug('############### categorie '+ca.Categoria_Riferimento__r.Name);
      System.debug('############### categorie '+ca.CategoriaExternalId__c);*/
    //  c.Categoria__c = '1324 – Richieste Online';
    }
    }