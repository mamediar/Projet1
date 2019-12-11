/**-----------------------------------------------------------------------
  *@Author Madicke BALDE
  *@description 
  @date 2019/08/29
 *---------------------------------------------------------------------*/
 @RestResource(UrlMapping = '/AppuntoOccupazioneFilialess')
global with sharing class AppuntamentoOccupazioneFiliale  extends CGMServiceWsr_1_1 {
 
  @HttpPost
  global static void appuntamentoOccupazioneFiliale (){
            final RestRequest req = RestContext.request;
            final RestResponse resp = RestContext.response;
    try {
          String response = execute(req.requestBody);
          resp.statusCode = 200;
          resp.responseBody = Blob.valueOf(response); 
          System.debug(' ################### responseBody '+resp);
      
    } catch (Exception e) {
      System.debug(' #################  errorMessage ########## '+e.getMessage() );
      System.debug(' #################  errorMessage ########## '+ e.getStackTraceString() );
    }

  }
  /**------------------------------------------------------------------------------
    *@Author Madicke BALDE
    *@description
    *@date
    *@param  jsonRequest
    *@return AppuntamentoOccupazioneWrapper
   *-------------------------------------------------------------------------------------*/
  public static AppuntamentoOccupazioneWrapper deserializeRequest(Blob jsonRequest){
      AppuntamentoOccupazioneWrapper  appuntamento = new AppuntamentoOccupazioneWrapper();
      try {
        String jsonRequestBody = jsonRequest.toString().trim();
        appuntamento = (AppuntamentoOccupazioneWrapper) JSON.deserializeStrict(jsonRequestBody, AppuntamentoOccupazioneWrapper.class);
        return appuntamento;
      } catch (Exception e) {
        System.debug(' ############## errorMessage '+e.getMessage());
        System.debug(' ############## errorMessage '+e.getStackTraceString() );
        throw new CGMWSUtils_1_0.CGMWSRException('[KO-CREQ0005]');
        
      }
  }
  
  /**------------------------------------------------------------------------------
    *@Author Madicke BALDE
    *@description
    *@param jsonRequest
   *------------------------------------------------------------------------------*/
  public static String execute(Blob jsonRequest){
     AppuntamentoOccupazioneFilialeReturn appuntamentoReturn;
     String responseWService;
   try {
       AppuntamentoOccupazioneWrapper appuntaOccupa = deserializeRequest(jsonRequest);
       Account filiale = AppuntamentoDomainWS.ckeckFilialeExistence(appuntaOccupa.codiceFiliale);
       Date dtIni = CGMWSUtils_1_0.formatStringToDate(appuntaOccupa.dataInizio);
       Date dtEnd = CGMWSUtils_1_0.formatStringToDate(appuntaOccupa.dataEnd);
       String response = AppuntamentoDomainWS.appuntamentoOccupazionniFiliale(dtIni, dtEnd, filiale);
       System.debug(' ##################### response '+response);
        appuntamentoReturn = new AppuntamentoOccupazioneFilialeReturn(response);
        appuntamentoReturn.resultCode = 0;
        appuntamentoReturn.resultMessage = 'OK';
     //   appuntamentoReturn.r
        responseWService = JSON.serialize(appuntamentoReturn);
        
     
   } catch (Exception e) {
      appuntamentoReturn = new AppuntamentoOccupazioneFilialeReturn();
      appuntamentoReturn.resultCode = 1;
      appuntamentoReturn.resultMessage ='K0';
     System.debug('################# errorMessage execute  ###########  '+e.getMessage());
     System.debug('################# errorMessage ###########  execute  '+e.getStackTraceString() );
     responseWService = JSON.serialize(appuntamentoReturn);
   }
   System.debug(' ######################### responseWService '+responseWService);
   return responseWService;
  }
  public class AppuntamentoOccupazioneFilialeReturn extends GenericResponse{
     String chaine;
     public AppuntamentoOccupazioneFilialeReturn(){
       super();
     }
      public AppuntamentoOccupazioneFilialeReturn(String chaine){
       super();
       this.chaine = chaine;
     }


  }
  public class  AppuntamentoOccupazioneWrapper {
    public String dataInizio {get;set;}
    public String dataEnd  {get;set;}
    public String codiceFiliale {get;set;}
  }
  
   
}