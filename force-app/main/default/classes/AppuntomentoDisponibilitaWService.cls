/**
  *@Auhtor Madicke BALDE
  *@description
  *@date
 */
  @RestResource(UrlMapping = '/appuntamentoDisponibilita') 
global with sharing class AppuntomentoDisponibilitaWService  extends CGMServiceWsr_1_1{
     public static String  errorCode;
     public static  String  errorMessage;
    /**
      *@Author Madicke BALDE
      *@date 2019/08/22 appuntomentoDisponibilita Web service
      *@description Post Methode for 
     */
    @HttpPost
    global static void appuntomentoDisponibilita(){
        final RestRequest req = RestContext.request;
        final RestResponse res = RestContext.response;
        try {
            String resp = execute(req.requestBody);
            res.statusCode = (AppuntamentoError.hasError)?500:200;
            
            res.responseBody = Blob.valueOf(resp);
            
        } catch (Exception e) {
                System.debug('************** code Filiale x'+ errorCode);
                String errm =  CGMWSUtils_1_0.ERROR_MESSAGE_MAP.get(errorCode);
                CGM_WSR_Response response = new CGM_WSR_Response();
                response.errorCode = errorCode;
                response.resultMessage = 'KO';
                response.errorMessage = errm +' '+ errorMessage;
                response.resultCode = 1;
                String rb = JSON.serialize(response);
                res.responseBody = Blob.valueOf(rb);
                res.statusCode = 500;
                System.debug('**********  errorMessage '+e.getMessage());
                System.debug('**********  errorMessage '+e.getStackTraceString() );
            
        }
   
    }
    /**---------------------------------------------------------------------------------
      *@Author Madicke BALDE
      *@description
      *@date
      *@param
      *@return String 
      *---------------------------------------------------------------------------------*/
    public static String execute(Blob jsonRequest){
      AppuntamentoDisponibilitaCompletaReturn appreturn ;
      Set<ora> oraSet = new Set<Ora>();
      String responseService;
        try {
                  AppuntomentoDisponibilitaWrapper appuntomento = deserializeRequest(jsonRequest);
                  Set<Time> listTime  = AppuntamentoDomainWS.appuntamentoDisponilitaCompleta(appuntomento.codFiliale, appuntomento.data);
                  System.debug(' ################ (AppuntamentoError.hasError ws '+ AppuntamentoError.hasError);
             if(AppuntamentoError.hasError){
                  appreturn = new AppuntamentoDisponibilitaCompletaReturn();
                  appreturn.resultCode = 1;
                  appreturn.resultMessage = 'KO';
                  appreturn.errorMessage = AppuntamentoError.errorMessage;
                  responseService = JSON.serialize(appreturn);
             }
             else{
               for (Time t :  listTime  ) {
                   String slt = CGMWSUtils_1_0.convertTimeToString(t);
                   oraSet.add(new ora(slt));  
               }
                  appreturn = new AppuntamentoDisponibilitaCompletaReturn(oraSet);
                  responseService = JSON.serialize(appreturn);   
             }
        
        } catch (Exception e) {
                appreturn = new AppuntamentoDisponibilitaCompletaReturn();
                //  String errm =  CGMWSUtils_1_0.ERROR_MESSAGE_MAP.get(errorCode);
                appreturn.resultCode = 1;
                appreturn.resultMessage= 'KO';
                appreturn.errorMessage = AppuntamentoError.errorMessage;
                responseService = JSON.serialize(appreturn);
                //  System.debug('*************** exception execute'+ errorCode);
                System.debug(' ************ errorMessage '+e.getMessage());
                System.debug(' ************ errorMessage '+e.getStackTraceString() ); 
            
        }
        System.debug('##################### ############## responseService '+responseService);
       return responseService;
    }
    /**--------------------------------------------------------------------------------
      *@Auhtor Madicke BALDE
      *@description 
      *@date
     *----------------------------------------------------------------------------------*/
    global class AppuntomentoDisponibilitaWrapper{
        public String codFiliale {get;set;}
        public String data {get;set;}
    }
    /**----------------------------------------------------------------------------------
      *@Auhtor Madicke BALDE
      *@description
      *@date
      *@param requestBody
      *@return AppuntomentoDisponibilitaWrapper
     *--------------------------------------------------------------------------------------*/
    global static AppuntomentoDisponibilitaWrapper deserializeRequest(Blob requestBody){
                AppuntomentoDisponibilitaWrapper appWrapper = new AppuntomentoDisponibilitaWrapper();
        try {
                String jsonString = requestBody.toString().trim();
                appWrapper = (AppuntomentoDisponibilitaWrapper) JSON.deserializeStrict(jsonString, AppuntomentoDisponibilitaWrapper.class);
            
         } catch (Exception e) {
                AppuntamentoError.hasError = true;
                AppuntamentoError.errorMessage = 'Invalid Request Body';
                System.debug('***********  errorMessage '+e.getMessage());
                System.debug(' *************** error '+e.getStackTraceString());
                throw new CGMWSUtils_1_0.CGMWSRException('[KO-CREQ0005]');  
        }
        return appWrapper;
    }

    /**-------------------------------------------------------------------------------------
      *@Author Madicke BALDE
      *@description wrapper class for web service response
      *@date 2019/08/22
     *---------------------------------------------------------------------------------------*/
    public class AppuntamentoDisponibilitaCompletaReturn extends GenericResponse{
            Set<Ora> ora {get;set;}
            String errorMessage;
            public AppuntamentoDisponibilitaCompletaReturn(){
                super();
            }
            public AppuntamentoDisponibilitaCompletaReturn (Set<Ora> ora ){
            super();
            this.ora = ora;
            }
            public AppuntamentoDisponibilitaCompletaReturn (String errorMessage){
              super();
              this.errorMessage = errorMessage;
            }

    }
    /**-----------------------------------------------------------------------------
      *@Author Madicke BALDE
      *@description Wrapper Class
      *@date 2019/08/22
     *--------------------------------------------------------------------------------*/
    public class Ora {
        public String ora {get;set;}
        public Ora(String ora){
            this.ora = ora;
        }
    }
}