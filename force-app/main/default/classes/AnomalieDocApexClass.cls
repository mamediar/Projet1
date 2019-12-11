/**---------------------------------------------------------------------------------
 * @Author Madicke BALDE
 * @Modified by LayePythagore   01/11/2019
 * @description web service for Anomalie
 * @File name : AnomalieDocApexClass
 * @date
 *---------------------------------------------------------------------------------------*/
@RestResource(UrlMapping = '/AnomalieDoc')
global with sharing class AnomalieDocApexClass extends CGMServiceWsr_1_1 {

  // Anomalie mandatory fields for POST validation  : Map contain list of field required
  public  static Map<String, String> Anomalie_MANDATORY_FIELDS_POST_MAP = new Map<String, String>{
        'codice_Anomalia__c' => 'codAnomalia',
        'Codice_Documento__c' => 'codDoc',
        'Codice_Macro_Documento__c' => 'codMacroDoc',
        'Codice_Ocs__c' => 'codOcsPratica',
        'Data_Anomalia__c' => 'dateAnomalie', 
        'Tipo_Prodotto__c' => 'tipoProdotto',
        'descrizione_Macro_Doc__c' => 'desMacroDoc',
        'descrizione_Documento__c' => 'desDoc',
        'Descrizione_Anomalia_Cliente__c' => 'desAnomaliaCliente',
        'Descrizione_Anomalia_Op__c' => 'desAnomaliaOperatore',
        'Ristampa_Contratto__c' => 'fRistampaContratto'
  };

  /*****************************************************************************
    * @Author Madicke BALDE
    * @Modified by LayePythagore   01/11/2019
    * @description Web service for Anomalie
    * @date  
  ***********************************************************************************/
  @HttpPost
  global static AnomalieDocResponse anomalieDoc(){
    String errorCode;
    AnomalieDocResponse response = new AnomalieDocResponse();
    try {
      RestRequest requestRest = RestContext.request;
      AnomalieWrapper anomalieWrapper = deserializeRequestBody(requestRest.requestBody);
      Map<String , Object> mp =  getListAnomalieDoc(anomalieWrapper);  
      Map <String , Object> returnValue =  createAnomalie(mp);
      
      System.debug('***********  create '+returnValue);
      if((Boolean) returnValue.get('exception')) {
        errorCode = (String) returnValue.get('codeException');
        String errorMessage = (String) returnValue.get('errorMessage');
        System.debug('***********  message '+errorMessage);
        throw new CGMWSUtils_1_0.CGMWSRException(errorCode, errorMessage);
      }
      response.resultCode = 0L;
      response.resultMessage ='Anomalia creata con successo';
    } catch (CGMWSUtils_1_0.CGMWSRException cgme) {     
      System.debug('#################### 1'); 
      //cgme.getMessage()
      response.resultMessage = CGMWSUtils_1_0.ERROR_MESSAGE_MAP.get(cgme.getMessage()); 
      response.resultMessage += String.isNotBlank(cgme.additionalInfo) ? ' ' + cgme.additionalInfo : '';
      response.resultCode = 1L;
    } catch (Exception ex) {
      System.debug('#################### 2'); 
      response.resultMessage = ex.getCause() +' '+ ex.getMessage();
      response.resultCode = 1L;
    }
    return response;
  }

  /*
   * @Author Madicke BALDE
   * @Modified by LayePythagore   01/11/2019
   * @description  
   * @param list of anomalieWrapper
   * @return list Anomalie_Doc__c
   */
  @HttpPut
  global static AnomalieDocResponse updateAnomalieDoc(){
    Set<String> codeAnoamies = new Set<String>();
    AnomalieDocResponse response = new AnomalieDocResponse();
    try {
      RestRequest requestRest = RestContext.request;
      AnomalieWrapper anomalieWrapper = deserializeRequestBody(requestRest.requestBody);
      Map<String , Object> mp =  getListAnomalieDoc(anomalieWrapper);
      validateData(mp, 'PUT');
      AnomalieDocService.gestatoAnomalieDoc( (List<Anomalie_Doc__c>) mp.get('anomalies') );
      response.resultMessage = '';
      response.resultCode = 0L;
      //CGM_WSR_Response response = new CGM_WSR_Response();
    } catch (CGMWSUtils_1_0.CGMWSRException cgme) {
      //String errorCode = '[KO-Anomalie0001]';
      //CGM_WSR_Response response = new CGM_WSR_Response(CGMWSUtils_1_0.RESULT_CODE_KO, CGMWSUtils_1_0.STATUS_KO,cgme.getMessage());
      //response.errorMessage += String.isNotBlank(cgme.additionalInfo) ? ' ' + cgme.additionalInfo : '';
      response.resultCode = 1L;
      response.resultMessage = cgme.getMessage();
      response.resultMessage += String.isNotBlank(cgme.additionalInfo) ? ' ' + cgme.additionalInfo : '';
    } 
    return response;
  }

  /*
    * @Author Madicke BALDE
    * @description  
    * @param list of anomalieWrapper
    * @return list Anomalie_Doc__c
    */
  public static Map<String , Object> getListAnomalieDoc(AnomalieWrapper anomalies){
    System.debug('****************** Running ******* getListAnomalieDoc'  );
    Map<String, Object> mp = new Map<String, Object>();
    List<Anomalie_Doc__c> anomaliDocs = new List<Anomalie_Doc__c>();

    //**** retrive  codOcsPratica
    mp.put('codOcsPratica', anomalies.codOcsPratica);
    mp.put('tipoProdotto', anomalies.tipoProdotto);  
    //  String codOcsPratica = listAnomalieWrapper.get(0).codOcsPratica;
    //***** get Case by codOcsPratica
    for(item item : anomalies.anomalieDocDettagliDTO.item) {
      //******** Convert String to Date
      System.debug('******  code anomalia '+ item.codAnomalia);
      Date dateAnomalie  = (!String.isBlank(item.dataAnomalia))? CGMWSUtils_1_0.formatStringToDate(item.dataAnomalia): null;
    
      //******* Create Anomalie_Doc_-c List
      Anomalie_Doc__c anomalie = new Anomalie_Doc__c();
      anomalie.codice_Anomalia__c = item.codAnomalia;
      anomalie.Codice_Documento__c = item.codDoc;
      anomalie.Codice_Macro_Documento__c = item.codMacroDoc;
      anomalie.Codice_Ocs__c = anomalies.codOcsPratica;
      anomalie.Data_Anomalia__c = dateAnomalie;
      anomalie.Tipo_Prodotto__c = anomalies.tipoProdotto;
      anomalie.descrizione_Macro_Doc__c = item.desMacroDoc;
      anomalie.descrizione_Documento__c = item.desDoc;
      anomalie.Descrizione_Anomalia_Cliente__c = item.desAnomaliaCliente;
      anomalie.Descrizione_Anomalia_Op__c = item.desAnomaliaOperatore;
      anomalie.Ristampa_Contratto__c = item.fRistampaContratto; 
      anomaliDocs.add(anomalie); 
    }
    mp.put('anomalies', anomaliDocs);
    return mp;
  }

  /*****************************************************************************************
   *@Author Madicke BALDE
   *@description method to create anomalie
   *@param list pbject wrapper class
   *@return list Anomalie_Doc__c
  ****************************************************************************************/
  public static  Map <String , Object> createAnomalie(Map <String , Object> mp){
            /**   List <Anomalie_Doc__c> anomalieDocs =  getListAnomalieDoc(listAnomalieWrapper);
                System.debug(' *************** createAnomalie ************' +anomalieDocs); */
                Map <String , Object> returnValue = new Map <String , Object>();
                Map <String , Object> rtV = new Map <String , Object>();
                try {
                  if(!mp.isEmpty()) {
                          returnValue = CaseService.getCaseBycodOCSPratica((String) mp.get('codOcsPratica'));
                            if(checkDiscordanzaCellulareInCase((Case) returnValue.get('case'))){
                              System.debug('is Discorda za');
                              CaseDomain.mailDem('2072', ((Case) returnValue.get('case')).Id, 'Anomalie Doc. E-commerce ', 'noreply@compass.it', 'Compass Banca S.P.A.');
                            }
                          for(Anomalie_Doc__c anomalie : (List<Anomalie_Doc__c>) mp.get('anomalies'))  {
                            anomalie.CaseId__c =  ((Case) returnValue.get('case')).Id;
                          } 
                            rtV = AnomalieDocService.insertAnomalies((List<Anomalie_Doc__c>) mp.get('anomalies'));
                            if( (Boolean) rtv.get('exception') ){
                                throw new CGMWSUtils_1_0.CGMWSRException('[KO-Anomalie0002]');
                            }
                          
                          returnValue.put('anomalies', (List<Anomalie_Doc__c>) rtV.get('anomalies'));
                  }
                      
                } catch (Exception e) {
                          System.debug('******** createAnomalie methode '+ e.getMessage()  );
                          String codeException =  ((Boolean)returnValue.get('exception') )? (String) returnValue.get('codeException'): (String) rtV.get('errorException');
                          System.debug('********* Exception '+codeException);
                          returnValue.put('codeException', codeException);
                          returnValue.put('exception', true);
                }
                return returnValue;  
  }

  /**************************************************************************************
    *@Author Madicke BALDE
  ***************************************************************************************/
  public static Boolean checkDiscordanzaCellulareInCase(Case c){
          Boolean isdiscordanzaCell = false;
          if(String.isNotEmpty(c.RO_Vecchio_Cellulare__c)){
            isdiscordanzaCell = true;
            c.Is_Discordanza_Cellulare__c = true;
            update c;
          }
          return isdiscordanzaCell;
    }

  /***************************************************************************************
    * @Auhtor Madicke BALDE
    * @description deserialize the request body into List AnomalieWrapper
    * @param requestBody
    * @return List AnomalieWrapper
  ****************************************************************************************/
  global static  AnomalieWrapper  deserializeRequestBody(Blob requestBody)  {
              System.debug(' ****************** deserializeRequestBody running ');
              AnomalieWrapper  anomalie = new AnomalieWrapper ();
              try {
                      String jsonRequestBody = requestBody.toString().trim();
                        anomalie = (AnomalieWrapper) JSON.deserializeStrict(jsonRequestBody,  AnomalieWrapper.class);
                    
              } catch (Exception e) {
                System.debug('************ Exception deserializeRequestBody *********');
                      System.debug('errorMessage' + e.getMessage());
                      throw new CGMWSUtils_1_0.CGMWSRException('[KO-CREQ0005]');
              }
          return anomalie;
  }

  /*******************************************************************************
      * @Author Madicke BALDE
      * @description Validate Request
      * @date
      * @
  ******************************************************************************************/
  public static void validateData (Map<String, Object> map_Anomalie, String requestType){
      System.debug('********** Running Validation');
      List<String> errorFields = new List<String>();
      if(requestType == 'POST' || requestType =='PUT'){
          for (String fieldName : Anomalie_MANDATORY_FIELDS_POST_MAP.keySet()){
              for(Anomalie_Doc__c ano: (List<Anomalie_Doc__c>) map_Anomalie.get('anomalies') ){
                  System.debug('************ date  '+ ano.get(fieldName) ); 
                  if(fieldName == 'Data_Anomalia__c' && (Date) ano.get(fieldName) == null)
                  errorFields.add(AnomalieDocApexClass.Anomalie_MANDATORY_FIELDS_POST_MAP.get(fieldName) );
                if ( fieldName != 'Data_Anomalia__c' && String.isBlank( (String) ano.get(fieldName)) ) errorFields.add(AnomalieDocApexClass.Anomalie_MANDATORY_FIELDS_POST_MAP.get(fieldName) );
                  System.debug('************ '+ ano.get(fieldName) );
              } 
              
          } 
    
        if(!errorFields.isEmpty()){
            throw new CGMWSUtils_1_0.CGMWSRException('[KO-CREQ0007]', String.join(errorFields, ', '));
        }
      } 
  }    
      
  global class AnomalieWrapper {
      global AnomalieDocDTO anomalieDocDettagliDTO {get;set;}
      global String codOcsPratica {get;set;}
      global String tipoProdotto {get; set;}
  }

  global class AnomalieDocDTO {
        global List<Item> item {get;set;}
    }


  global class Item {
    global String codAnomalia {get; set;}
    global String codDoc {get; set;}
    global String codMacroDoc {get;set;}
    global String dataAnomalia {get;set;}
    global String desAnomaliaCliente {get;set;}
    global String desAnomaliaOperatore {get;set;}
    global String desDoc {get;set;}
    global String desMacroDoc {get;set;}
    global String fRistampaContratto {get;set;} 
  }

  /*
   * @author abdoulaye.diopdev3@compass.com.dev
   * @date  01/11/2019
   * @description class AnomalieDocResponse 
   */
  global class AnomalieDocResponse extends GenericResponse {
    public Long resultCode {get; set;}
    public String resultMessage {get; set;}

    global AnomalieDocResponse(Long resultCode, String resultMessage){
        super(resultCode, resultMessage);
    }

    global AnomalieDocResponse(){
        super();
    }
  }
}