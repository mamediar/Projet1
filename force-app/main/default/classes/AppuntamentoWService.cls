/**----------------------------------------------------------------------
 * @Author Madicke BALDE
 * @Modified by LayePythagore   01/11/2019
 * @description Apex class to create and update Appuntamento
 **--------------------------------------------------------------------*/
@RestResource(UrlMapping = '/AppuntamentoWS/*')
global with sharing class AppuntamentoWService  extends CGMServiceWsr_1_1{
 
  /**-------------------------------------------------
   * @Author Madicke BALDE
   * @description web service to create Appuntamento
   *-------------------------------------------------*/
  @HttpPost
  global static void appuntamentoWSrv(){
    final RestRequest req = RestContext.request;
    final RestResponse res = Restcontext.response;
    try {
      String response = execute(req.requestBody);
      System.debug('***************** response ++++ '+ response);
      res.statusCode = 200;
      res.responseBody = Blob.valueOf(response); 
    } catch (Exception e) {
      res.statusCode = 500;
      System.debug('******** errorMessage '+e.getMessage());
      System.debug('******** errorMessage '+e.getStackTraceString());
    }
  }

  /**------------------------------------------------------------------------
    * @Author Madicke BALDE
    * @description web service to update appuntamento
    *-----------------------------------------------------------------------*/
  @HttpPut
  global static void appuntamentoModifica(){
    System.debug(' ############## appuntamentoModifica ');
    final RestRequest req = RestContext.request;
    final RestResponse resp = RestContext.response;
    try {
        String response = executeAppuntamentoModifica(req.requestBody);
        resp.statusCode = 200;
        resp.responseBody = Blob.valueOf(response);
    } catch (Exception e) {
      System.debug('************** error Message '+e.getMessage());
      System.debug('************** error Message '+e.getStackTraceString());
    }
  }
    
  /**------------------------------------------------------------
   * @Author Madicke BALDE
   * @Modified by LayePythagore   01/11/2019
   * @description
   * @date
   *-----------------------------------------------------------*/
  @HttpGet
  global static void appuntamentoCerca(){
    RestRequest request = RestContext.request;
    RestResponse res = Restcontext.response;
    String codiceFiscale = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
    System.debug('########### codiceFiscale ####### '+codiceFiscale);
    try {
      String response = executeAppuntaCerca(codiceFiscale);
      res.statusCode = 200;
      /* String message = 'This client have no appuntomento';
      String response = (events == null || events.listaApp.size() == 0)?message :JSON.serialize(events); */      
      res.responseBody = Blob.valueOf(response);
    } catch (Exception e) {
        System.debug(' ***************** errorMessage '+e.getMessage());
        System.debug(' ***************** errorMessag '+e.getStackTraceString() );
    }
  }
    
  /**------------------------------------------------------------------------------
   * @Author Madicke BALDE
   * @Modified by LayePythagore   01/11/2019
   * @description execute the request
   * @date
   * @param jsonRequest : Data send by client
   * @return String : the response of web service
   *------------------------------------------------------------------------------*/
  public static String execute (Blob jsonRequest){
    Event ev = new Event();
    String responseService;
    try {
      AppuntamentoWrapper appuntomentowrp = deserializeRequestBody(jsonRequest);
      ev = AppuntamentoDomainWS.gestitoAppuntamento(appuntomentowrp);
      System.debug(' ###############  AppuntamentoError  '+ AppuntamentoError.hasError);
      System.debug(' ###############  AppuntamentoError Message  '+ AppuntamentoError.errorMessage);
      System.debug(' ###############  eventUpdate Response  '+ev);
      if(!AppuntamentoError.hasError){
        AppuntamentoCreaReturn  responseAppuntamento =  new AppuntamentoCreaReturn(ev.Id, AppuntamentoDomainWS.personContactId, 'step');
        responseAppuntamento.resultCode = 0L;
        responseAppuntamento.resultMessage = 'OK';
        responseService = JSON.serialize(responseAppuntamento);
      } else {
        AppuntamentoCreaReturn  responseAppuntamento =  new AppuntamentoCreaReturn();
        responseAppuntamento.resultCode = 1L;
        responseAppuntamento.resultMessage ='KO';
        responseAppuntamento.errorMessage = AppuntamentoError.errorMessage;
        responseService = JSON.serialize(responseAppuntamento);
      }
    } catch (Exception e) {
      System.debug('******* errorMessage execute '+AppuntamentoError.hasError);
      if(AppuntamentoError.hasError){
        AppuntamentoCreaReturn  responseAppuntamento =  new AppuntamentoCreaReturn();
        responseAppuntamento.resultCode = 1L;
        responseAppuntamento.resultMessage ='KO';
        responseAppuntamento.errorMessage = AppuntamentoError.errorMessage;
        responseService = JSON.serialize(responseAppuntamento);
      }      
      System.debug('******* responseAppuntamento ############   '+responseService);
      System.debug('******* errorMessage execute '+e.getMessage());
      System.debug('******* errorMessage execute '+e.getStackTraceString());        
    }
    System.debug(' ################# responseService '+responseService);
    return responseService;
  }

  /**-----------------------------------------------------------------------
    *@Author Madicke BALDE
    *@description 
    *@date
    *@param jsonRequest
    *@return String 
  *------------------------------------------------------------------------*/
  public static String executeAppuntamentoModifica(Blob jsonRequest){
    String responseService ;
    try {
        AppuntamentoModifica appuntamento = deserializeRequestPut(jsonRequest);
        Map<String, Object> returnValue = AppuntamentoDomainWS.appuntamentoModifica(appuntamento);
        System.debug(' ************ executeAppuntamentoModifica returnValue  '+returnValue);
        if(AppuntamentoError.hasError == false && ((Event) returnValue.get('event')).Id != null ){
        AppuntamentoModificaReturn appReturn = new AppuntamentoModificaReturn();
        appReturn.resultCode = 0;
        appReturn.resultMessage = 'Appuntamento modificato';
        responseService = JSON.serialize(appReturn);
        } else {
          System.debug(' ########## appuntamento Modifica else  ');
          AppuntamentoModificaReturn appReturn = new AppuntamentoModificaReturn();
          appReturn.resultCode = 1;
          appReturn.resultMessage = AppuntamentoError.errorMessage;
          responseService = JSON.serialize(appReturn);
        }
      } catch (Exception e) {
        System.debug(' ##################### eception test');
        System.debug(' ##################### eception AppuntamentoError.codeErreor'+AppuntamentoError.codeErreor);
        AppuntamentoModificaReturn appReturn = new AppuntamentoModificaReturn();
        appReturn.resultCode = 1;
        appReturn.resultMessage ='KO';
        //String msg = AppuntamentoError.errorMessage;
        String msg = CGMWSUtils_1_0.ERROR_MESSAGE_MAP.get(AppuntamentoError.codeErreor);
        appReturn.errorMessage = msg;
        responseService = JSON.serialize(appReturn);
        //  System.debug(' ############# errorCode '+errorCode);
        System.debug('*************  error Message '+e.getMessage());
        System.debug('*************  error Message '+e.getStackTraceString() );   
        responseService = JSON.serialize(appReturn);
    }
    System.debug('############ responseService ########## '+responseService);
    return responseService;
  }

  /**------------------------------------------------------------------------------
    * @Author Madicke BALDE
    * @Modified by LayePythagore   01/11/2019
    * @date 2019/08/0/
    * @description
    * @param codiceFiscale
    * @return AppuntamentoCertaReturn
    *------------------------------------------------------------------------------*/
  public static  String executeAppuntaCerca(String codiceFiscale){
    System.debug('########### running ######### executeAppuntaCerca ');
    AppuntamentoCertaReturn appuntamentoCertaReturn = new AppuntamentoCertaReturn();
    String responseService;
    try {
      List<Event> eventList = AppuntomentoQuery.appuntomentoCerca(codiceFiscale);
      System.debug('********* eventList '+eventList);
      System.debug('********* eventList size '+eventList.size() );
      List<EventWrapper> eventWrapperList = new List<EventWrapper>();
      DatiCliente client = new DatiCliente();
      if(eventList == null || eventList.size() == 0 ){
        System.debug(' ################# running  eventList size 0');
        appuntamentoCertaReturn.resultCode = 1;
        appuntamentoCertaReturn.errorMessage = 'Questo cliente non ha un appuntamento';
        appuntamentoCertaReturn.resultMessage = 'KO';
        responseService = JSON.serialize(appuntamentoCertaReturn);
        System.debug(' ################# responseService '+responseService);
      } else {

        for( Event ev : eventList){
          String dateString = CGMWSUtils_1_0.ToString(ev.ActivityDate);
          Datetime activityTime = ev.ActivityDateTime;
          String ora = CGMWSUtils_1_0.ToString(activityTime.time());
          String h = ora.substring(0, 2)+':'+ora.substring(2,4);
          System.debug('********** Name '+ev.Desk__r.Branch__r.Name);
          eventWrapperList.add(new EventWrapper(ev.Desk__r.Branch__r.OCS_External_Id__c, dateString , ev.Desk__r.Branch__r.Name, ev.id, h,'tuto '));
        }
        Event ev = eventList[0];
        client.nome = ev.Customer__r.FirstName;
        client.cognome = ev.Customer__r.LastName;
        client.sesso = ev.Sesso__c;
        client.cellulare = ev.Telefono_Cellulare__c;
        client.email = ev.Customer__r.PersonEmail;
        client.localitaNascita = '';
        client.privacyExtcommoffer ='';
        client.privacyInterncommoffer ='';
        client.privacyOtherservice = '';
        client.privacyProfilazione = '';
        client.provinciaNascita ='';
        client.tipoOccupazione=ev.Tipo_Occupazione__c;
        client.capResidenza='';
        client.capResidenza ='';
        client.codiceFiscale= ev.Desk__r.Branch__r.OCS_External_Id__c;
        appuntamentoCertaReturn.resultCode = 0;
        appuntamentoCertaReturn.resultMessage = 'OK';
        appuntamentoCertaReturn.listaApp = eventWrapperList;
        appuntamentoCertaReturn.client = client;
        System.debug('################ appuntamentoCertaReturn '+appuntamentoCertaReturn);
        responseService = JSON.serialize(appuntamentoCertaReturn);
      }
    } catch (Exception e) {
        System.debug(' ######### errorMessage '+e.getMessage());
        System.debug(' ######### errorMessage '+e.getStackTraceString() ); 
    }
    return responseService;
  }

  /**------------------------------------------------------------------------------
    *@Author Madicke BALDE
    *@description method to deserialize the request send by client
    *@date
    *@param requestBody : request send by client
    *@return AppuntamentoWrapper : wrapper class 
    *-------------------------------------------------------------------------------*/
  global static  AppuntamentoWrapper  deserializeRequestBody(Blob requestBody)  {
    System.debug(' ****************** deserializeRequestBody running ');
    AppuntamentoWrapper  appuntamento = new AppuntamentoWrapper ();
    try {
            String jsonRequestBody = requestBody.toString().trim();
                appuntamento = (AppuntamentoWrapper) JSON.deserializeStrict(jsonRequestBody,  AppuntamentoWrapper.class);
            
    } catch (Exception e) {
              AppuntamentoError.hasError = true;
              AppuntamentoError.errorMessage = 'Request Body invalid';
              System.debug('************ Exception deserializeRequestBody error  *********');
              System.debug('errorMessage' + e.getMessage());
              throw new CGMWSUtils_1_0.CGMWSRException('[KO-CREQ0005]');
    }
    return appuntamento;
  }

  /**---------------------------------------------------------------------------------
   *@Author Madicke BALBE
   *@description
   *@date 2019/08/27
   *@param requestBody
   *@param AppuntamentoModifica
  *---------------------------------------------------------------------------------*/
  global static AppuntamentoModifica deserializeRequestPut(Blob requestBody){
        AppuntamentoModifica appuntamento = new AppuntamentoModifica();
        try {
            String jsonRequest = requestBody.toString().trim();
            appuntamento = (AppuntamentoModifica) JSON.deserializeStrict(jsonRequest, AppuntamentoModifica.class);
        } catch (Exception e) {
          System.debug('**********  errorMessage '+e.getMessage());
          System.debug('**********  errorMessage '+e.getStackTraceString() );
          AppuntamentoError.hasError = true;
          AppuntamentoError.errorMessage = CGMWSUtils_1_0.ERROR_MESSAGE_MAP.get('[KO-CREQ0005]');
          AppuntamentoError.codeErreor = '[KO-CREQ0005]';
          throw new CGMWSUtils_1_0.CGMWSRException('[KO-CREQ0005]');
        }
        return appuntamento;
  }

  /**-------------------------------------------------------------------------------
    *@Author Madicke BALDE
    *@date
    *@description
    *--------------------------------------------------------------------------------*/
  global class AppuntamentoWrapper {
    /*   global String societa {get;set;}
      global String utenteEsterno {get;set;}
      global String utenteInterno {get;set;} */
      global String codFiliale {get;set;}
      global String data {get;set;}
      global String ora {get;set;}
      global DatiAggiuntivi datiAggiuntivi {get;set;} 
      global DatiCliente datiCliente {get;set;}
      global DatiMediaUTM datiMediaUTM {get;set;}
      global String codProdotto {get;set;}
      global String oppID {get;set;}
      global String prodottoLvl1 {get;set;}
      global String prodottoLvl2 {get;set;}
      global String societa {get;set;}
      global String utenteEsterno {get;set;}
      global String utenteInterno {get;set;}
      
  }

  /**-------------------------------------------------------------------------------
    *@Author Madicke BALDE
    *@description
    *@date
    *--------------------------------------------------------------------------------*/
  global class DatiCliente{
      global String nome {get;set;}
      global String cognome {get;set;}
      global String sesso {get;set;}
      global String localitaNascita {get;set;}
      global String provinciaNascita {get;set;}
      global String capResidenza {get;set;}
      global String dataNascita {get;set;}
      global String privacyExtcommoffer {get;set;}
      global String privacyInterncommoffer {get;set;}
      global String privacyOtherservice {get;set;}
      global String privacyProfilazione {get;set;}
      global String tipoOccupazione {get;set;}
      global String contactID {get;set;}
      global String email {get;set;}
      global String cellulare {get;set;}
      global String codiceFiscale {get;set;}
      global String siglaProvinciaResidenza {get;set;}
      global String indirizzoResidenza {get;set;}
      global String localitaResidenza {get;set;}
  }

  /**-------------------------------------------------------------------------------
    *@Author Madicke BALDE
    *@description
    *@date
    *--------------------------------------------------------------------------------*/
  global class DatiMediaUTM {
      global String mediacode {get;set;}
      global String mediacodeInt {get;set;}
      global String utmCampaign {get;set;}
      global String utmContent {get;set;}
      global String utmDate {get;set;}
      global String utmHistory {get;set;}
      global String utmMedium {get;set;}
      global String utmSource {get;set;}
      global String utmTerm {get;set;}
      
  }

  /**--------------------------------------------------------------------------------
    *@Author Madicke BALDE
    *@description
    *date 2019/08/23
    *---------------------------------------------------------------------------------*/
  global class DatiAggiuntivi {
      global String agente {get;set;}
      global String crm_i_id {get;set;}
      global String durata {get;set;}
      global String extReferrer {get;set;}
      global String importo {get;set;}
      global String prodottoOcs {get;set;}
      global String rata {get;set;}
      global String tabella {get;set;}
      global String taeg {get;set;}
      global String tan {get;set;}
  }

  /**--------------------------------------------------------------------------------
   * @Author Madicke BALDE
   * @description wrapper class for appuntamentoCrea return
   *--------------------------------------------------------------------------------*/
  global class AppuntamentoCreaReturn extends GenericResponse {
    global String appID {get;set;}
    global String contactID {get;set;}
    global String step {get;set;}
    global String errorCode {get;set;}
    global String errorMessage {get;set;}
    global AppuntamentoCreaReturn(){
        super();
    }

    global AppuntamentoCreaReturn(String appId, String contactID, String step){
      this.appID = appId;
      this.contactID = contactID;
      this.step = step;
    }
  }

  /**----------------------------------------------------------------------------------
   * @Author Madicke BALDE
   * @description wrapper class for update Appuntamento
  **----------------------------------------------------------------------------------*/
  global class AppuntamentoModifica {
          global String codFiliale {get;set;}
          global String codiceFiscale {get;set;}
          global String oppID {get;set;}
          global String ora {get;set;}
          global String data {get;set;}
          global String societa {get;set;}
          global String utenteEsterno {get;set;}
          global String utenteInterno{get;set;}
          
  }

  /**-------------------------------------------------------------------------------------
      *@Author Madicke BALDE
      *@description wrapper class for return update Appuntamento
  *-------------------------------------------------------------------------------------*/
  global class AppuntamentoModificaReturn extends GenericResponse {
    global String errorCode {get;set;}
    global String errorMessage {get;set;}
    global AppuntamentoModificaReturn (){
        super();
    }
  }

  /** ----------------------------------------------------------------------------
    * @Author Madicke BALDE
    * @date 20190808
    * @description 
    *-------------------------------------------------------------------------------*/
  global class AppuntamentoCertaReturn extends GenericResponse {
    global DatiCliente client;
    global List<EventWrapper> listaApp;
    global String errorCode {get;set;}
    global String errorMessage {get;set;}
  }

  public class EventWrapper {
    public Id oppID;
    public String codeFiliale;
    public String data;
    public String ora;
    public String nomeFiliale;
    public String titolo;

    public EventWrapper(String codeFiliale, String data, String nomeFiliale, Id oppID, String ora, String titolo ){
      this.codeFiliale = codeFiliale;
      this.data = data;
      this.nomeFiliale = nomeFiliale;
      this.oppID = oppID;
      this.ora = ora;
      this.titolo = titolo;
      this.oppID = oppID;
    }
  }
}