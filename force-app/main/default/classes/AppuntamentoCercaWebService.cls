/**-----------------------------------------------------------------------------------------
  *@Author Madicke BALDE
  *@description  Apex class to search appuntomento  by codice Fiscale or Codice OCS Customer
  *@date 2019/09/10
 *-------------------------------------------------------------------------------------------*/
@RestResource(UrlMapping = '/appuntomentoCerca') 
global with sharing class AppuntamentoCercaWebService  extends CGMServiceWsr_1_1 {
     /** Map contains Required field */
     public static final Map<String,String> REQUIRED_FIELDS = new Map<String,String>{
         'codiceFiscale' => '',
         'codiceOcs' => ''
     };

    /**  Request Type: POST */
    public final static String TYPE_POST = 'POST';
    /**  Request Type: PUT */
    public final static String TYPE_PUT = 'PUT';

       @HttpPost
        global static void appuntamentoCerca(){
                final RestRequest req = RestContext.request;
                final RestResponse res = Restcontext.response;
                try {
                        String response = executeAppuntaCerca(req.requestBody);
                        System.debug('***************** response ++++ '+ response);
                        res.statusCode =(AppuntamentoError.hasError)?500:200;
                        res.responseBody = Blob.valueOf(response); 
                } catch (Exception e) {
                        res.statusCode = 500;
                        System.debug('******** errorMessage '+e.getMessage());
                        System.debug('******** errorMessage '+e.getStackTraceString());

                }
        }
       
        
         /**------------------------------------------------------------------------------
          * @Author Madicke BALDE
          * @date 2019/08/0/
          * @description
          * @param codiceFiscale
          * @return AppuntamentoCertaReturn
         *------------------------------------------------------------------------------*/
        public static  String executeAppuntaCerca(Blob jsonRequest){
             System.debug('########### running ######### executeAppuntaCerca ');
             AppuntamentoCertaReturn appuntamentoCertaReturn = new AppuntamentoCertaReturn();
             String responseService;
             try {
                    AppuntamentoCercaWrapper wrapper = deserializeRequest(jsonRequest);
                    setMapData(wrapper);
                    validateFields(REQUIRED_FIELDS, 'POST');
                    List<Event> eventList = AppuntamentoDomainWS.getEventByCodeOcsFiscale(wrapper.codiceFiscale, wrapper.codiceOcs);
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
                        client.email = ev.Customer__r.PersonEmail;
                        client.localitaNascita = '';
                        client.dataNascita = ev.Customer__r.Birthprovince__c;
                        Integer privacyComm = (ev.Customer__r.Extcommoffer__pc)?0:1;
                        client.privacyExtcommoffer = String.valueOf(privacyComm);
                        Integer privacyInter =  (ev.Customer__r.Interncommoffer__pc)?0:1;
                        client.privacyInterncommoffer = String.valueOf(privacyInter);
                        Integer otherService = (ev.Customer__r.OtherService__pc)?0:1;
                        client.privacyOtherservice = String.valueOf(otherService);
                        Integer privacyProfil = (ev.Customer__r.Privacy_Profilazione__pc)?0:1;
                        client.privacyProfilazione = String.valueOf(privacyProfil);
                        client.provinciaNascita = ev.Customer__r.Birthprovince__c;
                        client.tipoOccupazione=ev.Tipo_Occupazione__c;
                        client.capResidenza='';
                        client.capResidenza ='';
                        client.codiceFiscale= ev.Desk__r.Branch__r.OCS_External_Id__c;
                        client.contactID = ev.Customer__r.PersonContactId;
                        appuntamentoCertaReturn.resultCode = 0;
                        appuntamentoCertaReturn.resultMessage = 'OK';
                        appuntamentoCertaReturn.listaApp = eventWrapperList;
                        appuntamentoCertaReturn.client = client;
                        System.debug('################ appuntamentoCertaReturn '+appuntamentoCertaReturn);
                        responseService = JSON.serialize(appuntamentoCertaReturn);
                    }
                    
                    } 
                    catch (Exception e) {
                            appuntamentoCertaReturn.resultCode = 1;
                            appuntamentoCertaReturn.resultMessage ='KO';
                            appuntamentoCertaReturn.errorMessage = CGMWSUtils_1_0.ERROR_MESSAGE_MAP.get(AppuntamentoError.codeErreor) + ' '+AppuntamentoError.errorMessage;
                            System.debug(' ######### errorMessage '+e.getMessage());
                            System.debug(' ######### errorMessage '+e.getStackTraceString() ); 
                            responseService = JSON.serialize(appuntamentoCertaReturn);
                    }
                    return responseService;
        }

      /*  public static Set<String> getFields(String codiceFiscale, String codiceOcs){
            Set<String> fields = new Set<String>{codiceFiscale, codiceOcs};
           return fields;
        } */

        /**------------------------------------------------------------------------
          *@Author Madicke BALDE
          *@description deserializeRequest
          *@param jsonRequest : Requete JSON
          *@return AppuntamentoCercaWrapper
         *-------------------------------------------------------------------------*/
        public static AppuntamentoCercaWrapper deserializeRequest(Blob jsonRequest){
                 AppuntamentoCercaWrapper app = new AppuntamentoCercaWrapper();
            try {
                String stringRequest = jsonRequest.toString().trim();
                app = (AppuntamentoCercaWrapper) JSON.deserializeStrict(stringRequest, AppuntamentoCercaWrapper.class);
                
            } catch (Exception e) {
               System.debug(' ########## errorMessage '+e.getMessage());
               System.debug(' ########## errorMessage '+e.getStackTraceString() );
            }
            return app;
        }

        public class AppuntamentoCercaWrapper{
            public String codiceFiscale;
            public String codiceOcs;
        }

        /** ----------------------------------------------------------------------------
          * @Author Madicke BALDE
          * @date 20190808
          * @description 
         *-------------------------------------------------------------------------------*/
        public class AppuntamentoCertaReturn extends GenericResponse {
            public String errorMessage;
            public DatiCliente client;
            public List<EventWrapper> listaApp;
        }
    

    public class EventWrapper {
            public Id oppID;
            public String codFiliale;
            public String data;
            public String ora;
            public String nomeFiliale;
            public String titolo;

            public EventWrapper(String codFiliale, String data, String nomeFiliale, Id oppID, String ora, String titolo ){
                this.codFiliale = codFiliale;
                this.data = data;
                this.nomeFiliale = nomeFiliale;
                this.oppID = oppID;
                this.ora = ora;
                this.titolo = titolo;
                this.oppID = oppID;
               
            }
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
            global String indirizzoResidenza {get;set;}
            global String localitaResidenza {get;set;}
            global String siglaProvinciaResidenza {get;set;}
           
   }
   /**------------------------------------------------------------------------------------
     *@Author Madicke BALDE
     *@description check if request is Valid
     *@param  fieldRequired : MAP Required Field
     *@param  requestType : request type
    *--------------------------------------------------------------------------------------*/
   public static  void validateFields(Map<String,String> fieldRequired, String requestType){
       List<String> errorfield = new List<String>();
       if(requestType == 'POST'){
           for(String fieldName: fieldRequired.keySet()){
                    if(String.isBlank((String)fieldRequired.get(fieldName))  ){
                        errorfield.add(fieldName);
                    }
           }
       }
       if(!errorfield.isEmpty() && errorfield.size() == 2){
           AppuntamentoError.hasError = true;
           AppuntamentoError.codeErreor ='[KO-CREQ0007]';
           AppuntamentoError.errorMessage = String.join(errorfield, ' ');
           System.debug(' #################### validateFields '+ errorfield);
           throw new CGMWSUtils_1_0.CGMWSRException('[KO-CREQ0007]', String.join(errorfield, ' '));
       }
   }
   
   /**---------------------------------------------------------------------------------
     *@Author Madicke BALDE
     *@description method to set Map Data
     *@param  wrapper : Data json converted to  AppuntamentoCercaWrapper Object
    *-----------------------------------------------------------------------------------*/
   public static void setMapData(AppuntamentoCercaWrapper wrapper){
       REQUIRED_FIELDS.put('codiceFiscale', wrapper.codiceFiscale);
       REQUIRED_FIELDS.put('codiceOcs', wrapper.codiceOcs);
   }
}