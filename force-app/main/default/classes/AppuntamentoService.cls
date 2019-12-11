/**------------------------------------------------------------------------
    *@author Madicke BALDE    
    *@date 2019/08/02
    *@description web service Appuntamento
    *--------------------------------------------------------------------------*/
    @RestResource(UrlMapping = '/Appuntamento/*')
    global with sharing class AppuntamentoService  extends CGMServiceWsr_1_1 {

        public static String  errorCode;
        public static  String  errorMessage;

        /**------------------------------------------------------------------
          *@Author Madicke BALDE
          *@description 
          *@date
         *------------------------------------------------------------------*/
        @HttpPost
        global static void appuntamento(){
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
        /**------------------------------------------------------------
          * @Author Madicke BALDE
          * @description
          * @date
         *--------------------------------------------------------------*/
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
        
        @HttpPut
        global static void appuntamentoModifica(){
            final RestRequest req = RestContext.request;
            final RestResponse resp = RestContext.response;
            try {
                String response = executeAppuntamentoModifica(req.requestBody);
                resp.statusCode = 200;
                resp.responseBody = Blob.valueOf(response); 
                
            } catch (Exception e) {
              System.debug('************** error Message '+e.getMessage());
              System.debug('************** error Message '+e.getStackTraceString() );
                
            }

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
                  Map<String, Object> returnValue = AppuntamentoDomain.appuntamentoModifica(appuntamento);
                  System.debug(' ************ executeAppuntamentoModifica returnValue  '+returnValue);
                  if(returnValue.get('error') == false && (Event) returnValue.get('event') != null ){
                  AppuntamentoModificaReturn appReturn = new AppuntamentoModificaReturn();
                  appReturn.resultCode = 0;
                  appReturn.resultMessage = 'Appuntamento modificato';
                  responseService = JSON.serialize(appReturn);
                  }
                  else if(returnValue.get('error') == false){
                  AppuntamentoModificaReturn appReturn = new AppuntamentoModificaReturn();
                  appReturn.resultCode = 1;
                  appReturn.resultMessage = (String) returnValue.get('errorMessage');
                  responseService = JSON.serialize(appReturn);
                  }
                  else if (returnValue.get('error') == true) {
                    AppuntamentoModificaReturn appReturn = new AppuntamentoModificaReturn();
                    appReturn.resultCode = 1;
                    appReturn.resultMessage = (String) returnValue.get('errorMessage');
                    responseService = JSON.serialize(appReturn);
                  }
                  

                 } catch (Exception e) {
                   AppuntamentoModificaReturn appReturn = new AppuntamentoModificaReturn();
                   appReturn.resultCode = 1;
                   appReturn.resultMessage ='KO';
                   String msg = CGMWSUtils_1_0.ERROR_MESSAGE_MAP.get(errorCode);
                   appReturn.errorMessage = msg;
                   responseService = JSON.serialize(appReturn);
                   System.debug(' ############# errorCode '+errorCode);
                   System.debug('*************  error Message '+e.getMessage());
                   System.debug('*************  error Message '+e.getStackTraceString() );  
               }
               System.debug('############ responseService ########## '+responseService);
             return responseService;
         }


        /**------------------------------------------------------------------------------
          * @Author Madicke BALDE
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
             List<EventWrapper> eventWrapperList = new List<EventWrapper>();
             DatiCliente client = new DatiCliente();
             if(eventList == null || eventList.size() == 0 ){
                    appuntamentoCertaReturn.resultCode = 1;
                    appuntamentoCertaReturn.errorMessage = 'Questo cliente non ha un appuntamento';
                    appuntamentoCertaReturn.resultMessage = 'KO';
                    responseService = JSON.serialize(appuntamentoCertaReturn);
             }
             else {

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
                 client.email = 'email';
                 client.localitaNascita = '';
                 client.privacyExtcommoffer ='';
                 client.privacyInterncommoffer ='';
                 client.privacyOtherservice = '';
                 client.privacyProfilazione = '';
                 client.provinciaNascita ='';
                 client.tipoOccupazione='';
                 client.capResidenza='';
                 client.capResidenza ='';
                 client.codiceFiscale='';
             }
                appuntamentoCertaReturn.resultCode = 0;
                appuntamentoCertaReturn.resultMessage = 'KO';
                appuntamentoCertaReturn.listaApp = eventWrapperList;
                appuntamentoCertaReturn.client = client;
                System.debug('################ appuntamentoCertaReturn '+appuntamentoCertaReturn);
                responseService = JSON.serialize(appuntamentoCertaReturn);
             } 
             catch (Exception e) {
                 System.debug(' ######### errorMessage '+e.getMessage());
                 System.debug(' ######### errorMessage '+e.getStackTraceString() ); 
             }
             return responseService;
         
        }
        /** ----------------------------------------------------------------------------
          * @Author Madicke BALDE
          * @date 20190808
          * @description 
         *-------------------------------------------------------------------------------*/
        public class AppuntamentoCertaReturn extends CGM_WSR_Response {
            public DatiCliente client;
            public List<EventWrapper> listaApp;
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
        /**------------------------------------------------------------------------------
          *@Author Madicke BALDE
          *@description execute the request
          *@date
          *@param jsonRequest : Data send by client
          *@return String : the response of web service
         *------------------------------------------------------------------------------*/
        public static String execute (Blob jsonRequest){
            String responseService;
            try {
                 AppuntamentoWrapper appuntomento = deserializeRequestBody(jsonRequest);
                 Map<String,Object> returnValue = AppuntamentoDomain.createAppuntamento(appuntomento);
                  
                   System.debug('********** execute '+returnValue.get('error'));
                   System.debug('********** event '+ returnValue.get('event'));
                 if(returnValue.get('error') == false && (Event)returnValue.get('event') != null ){
                      AppuntamentoCreaReturn appunta = new AppuntamentoCreaReturn() ;
                     appunta.resultMessage ='OK';
                     appunta.resultCode = 0;
                     System.debug('*******************  error false');
                     Event ev = (Event) returnValue.get('event');
                     System.debug('*******************  ev '+ev);
                     appunta = new AppuntamentoCreaReturn(ev.Id,'xxxx45','step');
                     responseService = JSON.serialize(appunta);
                 }
                 else if(returnValue.get('error') == true && (Event) returnValue.get('event') == null ) { 
                     AppuntamentoCreaReturn appunta = new AppuntamentoCreaReturn() ;
                     appunta.resultMessage ='KO';
                     appunta.resultCode = 1;
                     appunta.errorMessage = (String) returnValue.get('errorMessage');
                     System.debug('************* appunta '+appunta);
                     responseService = JSON.serialize(appunta);
                 }
               
 
            } catch (Exception e) {
                System.debug('******* errorMessage execute '+e.getMessage());
                System.debug('******* errorMessage execute '+e.getStackTraceString() );
                
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
               System.debug('************ Exception deserializeRequestBody *********');
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
                 appuntamento = (AppuntamentoModifica) JSON.deserialize(jsonRequest, AppuntamentoModifica.class);
             } catch (Exception e) {
               System.debug('**********  errorMessage '+e.getMessage());
               System.debug('**********  errorMessage '+e.getStackTraceString() );
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
            global String societa {get;set;}
            global String utenteEsterno {get;set;}
            global String utenteInterno {get;set;}
            global String codFiliale {get;set;}
            global String data {get;set;}
            global String ora {get;set;}
            global DatiAggiuntivi datiAggiuntivi {get;set;}
            global DatiCliente datiCliente {get;set;}
            global DatiMediaUTM datiMediaUTM {get;set;}
            global String prodottoLvl1 {get;set;}
            global String prodottoLvl2 {get;set;}
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
        }
        
        global class AppuntamentoModifica {
            global String codFiliale {get;set;}
            global String codiceFiscale {get;set;}
            global String oppID {get;set;}
            global String ora {get;set;}
            global String data {get;set;}
        }
       public class AppuntamentoCreaReturn extends CGM_WSR_Response{
           public String oppID {get;set;}
           public String contactID {get;set;}
           public String step {get;set;}
           public AppuntamentoCreaReturn(String oppId, String contactID, String step){
               super();
               this.oppID = oppId;
               this.contactID = contactID;
               this.step = step;
           }
           public AppuntamentoCreaReturn(){
               super();
           }
       }

       public class AppuntamentoModificaReturn extends CGM_WSR_Response{
           public AppuntamentoModificaReturn (){
               super();
           }
       }
           
    }