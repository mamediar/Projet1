/**
 * Utils class for Compass rest web services
 *
 * @author  Moussa Fofana
 * @version 1.0
 * @description Utils class for Compass rest web services
 * @testedIn  CGMWSUtilsTst_1_0
 * @uses
 * @code
 * @errorcode [ERR:CL-XXXYYZZ]
 * @history
 * 2019-03-13 : Moussa Fofana - Original
 */
global with sharing class CGMWSUtils_1_0 {

    global static final String STATUS_OK = 'OK';
    global static final String STATUS_KO = 'KO';
    global static final Integer RESULT_CODE_OK = 0;
    global static final Integer RESULT_CODE_KO = 1;
    /** Map of error code to error message */
    global static final Map<String, String> ERROR_MESSAGE_MAP = new Map<String, String> {

        '[KO-ERROR0001]' => 'Internal server error.',
        
        '[KO-LOGIN0001]' => 'Bad request. Missing or invalid App-authorization header field.',
        '[KO-LOGIN0002]' => 'We cannot find your email address. Have you registered by clicking on the REGISTER button?', //'Invalid email address. Lead does not exist on system.',
        '[KO-LOGIN0003]' => 'Incorrect password. Can you try again, or use the FORGOT PASSWORD button? ', //'Unauthorized access. Provided password is not valid.',
        '[KO-LOGIN0004]' => 'Bad request. Invalid App-authorization header field. [email:password] must be encoded in base 64.',
        '[KO-LOGIN0005]' => 'We recognize your email. To keep you safe, please click on the link in the email we sent you', //'Email address not verified.',
        
        '[KO-CREQ0001]' => 'Bad request. Invalid case id.',
        '[KO-CREQ0002]' => 'Bad request. Invalid cliente canale.',
        '[KO-CREQ0003]' => 'Bad request. Invalid or not allowed query parameters.',
        '[KO-CREQ0004]' => 'Unauthorized access.',
        '[KO-CREQ0005]' => 'Invalid request body.',
        '[KO-CREQ0006]' => 'Impossible to identify the case to update. Please specify a valid case id.',
        '[KO-CREQ0007]' => 'Bad request. Missing required fields.',
        '[KO-CREQ0008]' => 'Verified case already exists in the system with provided informations.',
        '[KO-CREQ0009]' => 'block the rest of the query',

        '[KO-ROCRMRichLog0001]' => 'Impossible to create object RO_CRMRich_online_steplog__c.',
         '[KO-ROCRMRichLogPresc0001]' => 'Impossible to create object RO_CRMRich_online_prescoring__c.',

        '[KO-CREC0001]' => 'Impossible to create object Case.',
        '[KO-Account0001]' => 'Impossible to create  Account',

        '[KO-Anomalie0001]' =>  'Anomalie does not existe',
        '[KO-Anomalie0002]' =>  'Insertion Anomalie Failed',
        '[KO-Anomalie0003]' => 'Case Not Find with OcsPratica',
        '[KO-Anomalie0004]' => 'Anomaly insert successfully',

         '[KO-ERR012]' => 'invalid date field', 
         //********************  Code Product2 ******************************
        '[KO-PROD001]' => 'product not found with this codProdottoCRM',
         '[KO-PROD002]' => 'product not found with this prodottoLvl1',
        '[KO-FILIALE001]' => 'Filiale Not Found whith this CodeFiliale',
        '[KO-ACC0000001]'  => 'Customer NOT Found ',
        '[KO-APP0001]' => 'Appuntamento NOT Found',

        //#############################" CreaProspect ################################""
        '[CRAPROS-001]' => 'Gentile Cliente, ci risulta essere già presente una richiesta a suo nome. Per controllare lo stato della sua pratica\n'+
                           'utilizzi il link inviato nel momento della sua richiesta. Nel caso in cui sia stato smarrito contatti il numero 800774433 tasto 3',

        '[CRAPROS-002]' => 'Gentile Cliente, ci risulta essere già presente una richiesta a suo nome non ancora conclusa: può riprenderla utilizzando il link inviato all’ atto di richiesta.\n'+
        'Nel caso in cui il link sia stato smarrito  o voglia annullare la richiesta per iniziarne una nuova contatti il numero 800774433 tasto 3'

       // '[ERR00APM001]' => 'The new appointment date must be future and not passed'

    };

    /** Generic Compass  WSR Exception */
    global virtual class CGMWSRException extends Exception {

        global String additionalInfo;

        global CGMWSRException(String message, String additionalInfo) {

            this(message);
            this.additionalInfo = additionalInfo;
        }
    }

   

    /**
     * [getRequestTimestamp description]
     *
     * @param timestamp record's timestamp
     *
     * @return timestamp in milliseconds
     *
     * @code 01
     */
    global static Long getRequestTimestamp(Datetime timestamp) {

        // Returns the number of milliseconds since January 1, 1970, 00:00:00 GMT represented by this DateTime object.
        return timestamp != null ? timestamp.getTime() : null;
    }


    /**
     * [getRequestTimestamp description]
     *
     * @return timestamp in milliseconds
     *
     * @code 06
     */
    global static Long getRequestTimestamp() {

        // Returns the number of milliseconds since January 1, 1970, 00:00:00 GMT represented by this DateTime object.
        return getRequestTimestamp(System.now());
    }

   /*
   * @description  get Id recordType 
   *
   * @param obj : the Object Name
   *
   * @param  recName the developerName
   *
   * @return Id
   */
    global static Id getRecordTypeId(string obj ,string recName){

        Id recTypeId;
        if(obj!= null && recName != null){
            recTypeId= Schema.getGlobalDescribe().get(obj).getDescribe().getRecordTypeInfosByDeveloperName().get(recName).getRecordTypeId();
        }
       
        return  recTypeId;
    }

   
 /*   global static Map<String, Object> makeObject(){
        Map<String, Object> data = new Map<String, Object>();
      System.debug('LastName '+RequestOnlineApexClass.dataWraaper.cognome);
        Account account = new Account(
              LastName = RequestOnlineApexClass.dataWraaper.cognome,
              FirstName = RequestOnlineApexClass.dataWraaper.nome,
              PersonEmail = RequestOnlineApexClass.dataWraaper.email,
              BusinessEmail__c = RequestOnlineApexClass.dataWraaper.email,
              Phone = RequestOnlineApexClass.dataWraaper.phone,
              Codice_Cliente__c = RequestOnlineApexClass.dataWraaper.idAnagOcs,
              Codice_Fiscale__c = RequestOnlineApexClass.dataWraaper.fiscalCode,
              Occupation_Lvl1__c = RequestOnlineApexClass.dataWraaper.professione 

          );
        data.put('account', account);

        // *********************** Create MAP FOR REQUIRE FIELD ************************ 
        RequestOnlineApexClass.Case_MANDATORY_FIELDS_POST_MAP.put('codProdottoCRM',RequestOnlineApexClass.dataWraaper.codProdottoCRM);
        RequestOnlineApexClass.Case_MANDATORY_FIELDS_POST_MAP.put('Codice_Cliente',RequestOnlineApexClass.dataWraaper.Codice_Cliente);
        RequestOnlineApexClass.Case_MANDATORY_FIELDS_POST_MAP.put('AccountId',RequestOnlineApexClass.dataWraaper.AccountId);
        data.put('DATA_MANDATORY_FIELD', RequestOnlineApexClass.Case_MANDATORY_FIELDS_POST_MAP);

    //***************** Create Objet Case **************************************
        Case c = new Case();
        Date utm_date = (String.isNotBlank(RequestOnlineApexClass.dataWraaper.utm_date))? formatStringToDate(RequestOnlineApexClass.dataWraaper.utm_date): null;
        Boolean fea = (RequestOnlineApexClass.dataWraaper.flagFea)?true : false;
        System.debug('fea ********* '+ fea);
        c.AccountId = String.isNotBlank(RequestOnlineApexClass.dataWraaper.accountId) ? RequestOnlineApexClass.dataWraaper.accountId : null;
        c.Tipo_Prodotto__c = String.isNotBlank(RequestOnlineApexClass.dataWraaper.tipoProdotto) ? RequestOnlineApexClass.dataWraaper.tipoProdotto : null;
        c.Codice_Cliente__c = String.isNotBlank(RequestOnlineApexClass.dataWraaper.codice_Cliente) ? RequestOnlineApexClass.dataWraaper.codice_Cliente : null;
        c.RO_Link_Bozza__c = String.isNotBlank(RequestOnlineApexClass.dataWraaper.linkBozza) ? RequestOnlineApexClass.dataWraaper.linkBozza : null;
        c.RO_Engine_channel__c = String.isNotBlank(RequestOnlineApexClass.dataWraaper.engine_channel) ? RequestOnlineApexClass.dataWraaper.linkBozza : null;
        c.RO_Current_Step__c = String.isNotBlank(RequestOnlineApexClass.dataWraaper.step) ? RequestOnlineApexClass.dataWraaper.step : null;
        c.RO_idpartner__c = String.isNotBlank(RequestOnlineApexClass.dataWraaper.param_idpartner) ? RequestOnlineApexClass.dataWraaper.param_idpartner : null;
        c.RO_idcarrello__c = String.isNotBlank(RequestOnlineApexClass.dataWraaper.param_idcarrello) ? RequestOnlineApexClass.dataWraaper.param_idcarrello : null;
        c.utm_source__c = String.isNotBlank(RequestOnlineApexClass.dataWraaper.utm_source) ? RequestOnlineApexClass.dataWraaper.utm_source : null;
        c.utm_medium__c = String.isNotBlank(RequestOnlineApexClass.dataWraaper.utm_medium) ? RequestOnlineApexClass.dataWraaper.utm_medium : null;
        c.utm_content__c = String.isNotBlank(RequestOnlineApexClass.dataWraaper.utm_content) ? RequestOnlineApexClass.dataWraaper.utm_content : null;
        c.utm_campaign__c = String.isNotBlank(RequestOnlineApexClass.dataWraaper.utm_campaign) ? RequestOnlineApexClass.dataWraaper.utm_campaign : null;
        c.utm_term__c = String.isNotBlank(RequestOnlineApexClass.dataWraaper.utm_term) ? RequestOnlineApexClass.dataWraaper.utm_term : null;
        c.utm_history__c = String.isNotBlank(RequestOnlineApexClass.dataWraaper.utm_history) ? RequestOnlineApexClass.dataWraaper.utm_history : null;
        c.utm_date__c = utm_date;
        c.RO_fea__c = fea;
        c.Ro_privacy_profil__c = String.isNotBlank(RequestOnlineApexClass.dataWraaper.consensoPrivacy4)? RequestOnlineApexClass.dataWraaper.consensoPrivacy4 : null;
        c.RO_Privacy_OtherService__c = String.isNotBlank(RequestOnlineApexClass.dataWraaper.consensoPrivacy3)? RequestOnlineApexClass.dataWraaper.consensoPrivacy3 : null;
        c.Ro_Privacy_OptIn__c = String.isNotBlank(RequestOnlineApexClass.dataWraaper.consensoPrivacy2)? RequestOnlineApexClass.dataWraaper.consensoPrivacy2 : null; 
      // c.Id  = String.isNotBlank(RequestOnlineApexClass.dataWraaper.param_incident_id ) ? RequestOnlineApexClass.dataWraaper.param_incident_id  : null;
        c.RO_Mediacode__c = String.isNotBlank(RequestOnlineApexClass.dataWraaper.UTM_Mediacode )? RequestOnlineApexClass.dataWraaper.UTM_Mediacode  : null;
        //c.CaseNumber = String.isNotBlank(RequestOnlineApexClass.dataWraaper.incidentIdCRM )? RequestOnlineApexClass.dataWraaper.incidentIdCRM  : null;
        c.NumeroPratica__c = String.isNotBlank(RequestOnlineApexClass.dataWraaper.codOcsPratica )? RequestOnlineApexClass.dataWraaper.codOcsPratica  : null; 
        data.put('case',c);

       
        RO_CRMRich_online_prescoring__c rop = new RO_CRMRich_online_prescoring__c();
        rop.Pricing__c = RequestOnlineApexClass.dataWraaper.engine_pricing;
        rop.Channel__c = RequestOnlineApexClass.dataWraaper.engine_channel;
        rop.RO_Input_motore__c = RequestOnlineApexClass.dataWraaper.engineInput_XML;
        rop.RO_output_motore__c = RequestOnlineApexClass.dataWraaper.engineOutput_XML;
        data.put('rop', rop); 

     
        RO_CRMRich_online_steplog__c ros = new RO_CRMRich_online_steplog__c();
        ros.RO_CRMStep__c = RequestOnlineApexClass.dataWraaper.step;
        ros.RO_CRMModalita_firma__c = RequestOnlineApexClass.dataWraaper.modalitaFirma;
        ros.RO_CRMModalita_richiesta__c = RequestOnlineApexClass.dataWraaper.modalitaRichiesta;
        ros.RO_documenti__c = RequestOnlineApexClass.dataWraaper.docsUploaded;
        data.put('ros', ros); 
        return data;   

    } */

    
/*
    *@description Get template email by developerName
    *@param developerName
    *@return liste of template
*/
public  static List<EmailTemplate> getTemplateByDeveloperName(String developerName){
            List<EmailTemplate> templates = [SELECT Id, Subject, HtmlValue FROM EmailTemplate WHERE DeveloperName =: developerName];
            return templates;
}
/*
    *@Author Madicke BALDE
    *@description Get information about batch job
    *@param  batchableContext : Database.BatchableContext
    *@return AsyncApexJob
*/
public static  AsyncApexJob getInformationAbout_Batch(Database.BatchableContext batchableContext){
       AsyncApexJob a = [SELECT Id, Status,
                                NumberOfErrors, 
                                JobItemsProcessed,
                                TotalJobItems, 
                                CreatedDate
                                FROM AsyncApexJob
                                WHERE Id = :batchableContext.getJobId()];
            return a;

    }

/*
   *@description format DateTime to String
   *@param createdDate : DateTime to convert
   *@param numberHours : 
   *@return String
*/
public static String formatDate(Datetime createdDate, Integer numberHours){
                String datechaine = String.valueOfGmt(createdDate);
                List<String> datestimes = datechaine.split(' ');

                String dates = datestimes[0];
                String times = datestimes[1];

                List<String> timesplit = times.split(':');
                List<String> datesplit = dates.split('-');

                String year = datesplit[0]  ;
                String month =(datesplit[1].startsWith('0') )? datesplit[1].substring(1) :  datesplit[1]  ;
                String days =  (datesplit[2].startsWith('0'))? datesplit[2].substring(1) :  datesplit[2]  ; 
                
                String hours = (timesplit[0].startsWith('0'))? timesplit[0].substring(1) : timesplit[0]  ;
            
                Integer h = Integer.valueOf(hours) + numberHours;
                Integer day =  Integer.valueOf(days);
                if(h == 24) h = 0;
                if(h == 25) h = 1;
                if( h == 0  || h== 1)  day = day + 1;
                 System.debug('******* days '+ days);
                String minutes = (timesplit[1].startsWith('0'))? timesplit[1].substring(1) : timesplit[1]  ; 
                String secondes = (timesplit[2].startsWith('0'))? timesplit[2].substring(1) : timesplit[2]; 

                String newDate = secondes+' '+minutes+' '+h+' '+day+' '+month+' '+'?'+' '+year;
                return newDate;
   }
/**
  *@description convert string into Date
  *@param formatedString : string to convert
  *@return Date 
**/
  public static Date formatStringToDate(String formatedString){
            try {
                    if(formatedString.length() > 8) throw new CGMWSUtils_1_0.CGMWSRException('[KO-ERR012]');
                    String years = formatedString.substring(0,4);
                    String month = formatedString.substring(4,6);
                    String day   =  formatedString.substring(6,8);
                    String todate = years+'-'+month+'-'+day;
                    Date dt = Date.valueOf(todate);
                    return dt;

            } catch (Exception e) {
                   AppuntamentoError.hasError = true;
                   AppuntamentoError.codeErreor = '[KO-ERR012]';
                   RequestOnlineApexClass.errorCode='[KO-ERR012]';
                   AppuntamentoError.errorMessage ='Date Non Valid';
                   throw new CGMWSUtils_1_0.CGMWSRException('[KO-ERR012]');
            }
  }

  /**
    *@Author Madicke BALDE
    *@description
    *@date
    *@param String date
    *@return Date
   */
  public static String getDayOfWeek(String formatedString){
     try {
                   System.debug(' ################ getDayOfWeek formatedString'+formatedString);
                    String years = formatedString.substring(0,4);
                    String month = formatedString.substring(4,6);
                    String day   =  formatedString.substring(6,8);
                     System.debug(' ################ month'+month);
                    String todate = day+'/'+month+'/'+ years;
                    System.debug(' ################ todate'+todate);
                    Date d = Date.parse(todate);
                    System.debug('################# d '+d);
                    Datetime dt = Datetime.newInstance(d.year(), d.month(), d.day());
                    String dayeOfWeek = dt.format('EEEE')+'__c';
                    return dayeOfWeek;

            } catch (Exception e) {
                 System.debug(' ################### errorMessage '+e.getMessage());
                 System.debug(' ################### errorMessage '+e.getStackTraceString() );
                   AppuntomentoDisponibilitaWService.errorCode='[KO-ERR012]';
                   throw new CGMWSUtils_1_0.CGMWSRException('[KO-ERR012]');
            }
  }
  public static Datetime formatStringToDatetime(String value){
          String years = value.substring(0,4);
          String month = value.substring(4,6);
          String day   =  value.substring(6,8);
          String ds = years+'-'+month+'-'+day+' '+'00:00:00';
          Datetime dt = Datetime.newInstance(Integer.valueOf(years), Integer.valueOf(month), Integer.valueOf(day));
          return dt;
  }

/**************************************************************************
    *@description 
    *@param ID Account : idAccount
    *@param String name of Campaign : nameOfCampaign
    *@param String Link : link
     *@param Anomalie_Doc__c List : anomalies
****************************************************************************/
  public static void  sendEmailByInvioDEM (List<Anomalie_Doc__c> anomalies ){

        if(anomalies.size() > 0 ){
              Id idAccount = anomalies[0].CaseId__r.AccountId;   
              String link = anomalies[0].CaseId__r.RO_Link_Bozza__c;
              String nameOfCampaign = anomalies[0].CaseId__r.CampaignId__r.Name; 

              String demParam2 = anomalies[0].Descrizione_Anomalia_Op__c;
              String demParam3 = anomalies[1].Descrizione_Anomalia_Op__c;
              Date today = Date.today();
              System.debug('************ Running sendEmailByInvioDEM');
        }
  }

//Check if Object is NULL or Blank
  public static boolean isNotNullOrEmpty(string str){
        return str!=null || !String.isBlank(str); 
   }

/**************************************************************************
  *@Author Madicke BALDE          
  *@description Convert time into String
  *@param value : Time
  *@return String 
**************************************************************************/
public static String ToString(Time Value)
  {
    // string representation if a Time value 
     System.debug(' ************ Time ' + Value);
     String hours =  (Value.hour()< 10 )?0+''+String.valueOf(Value.hour()):String.valueOf(Value.hour());
     String minutes = (Value.minute() < 10)?0+''+String.valueOf(Value.minute()):String.valueOf(Value.minute());
     String seconde = (Value.second() < 10)?0+''+String.valueOf(Value.second()):String.valueOf(Value.second());
     String timeString = hours+''+minutes+''+seconde;
     System.debug(' ************ returnTime' + timeString);
     return timeString;
  }

/***************************************************** 
  *@Author Madicke BALDE      
  *@description convert Date to String
  *@param value : Date
  *@return String 
*******************************************************/
public static String ToString(Date Value)
  {
     // string representation if a Date value 
      System.debug(' ************ Date ' + Value);
       String days = (Value.day() < 10) ? 0+''+String.valueOf(Value.day()):String.valueOf(Value.day());
       Integer years =   Value.year();
       String  month =(Value.month() < 10 )?0+''+String.valueOf(Value.month()):String.valueOf(Value.month());
       String  dateString = years+''+month+''+days;
       System.debug(' ************ dateString ' + dateString);
       return dateString;
  }

  public static String formatedDatimeToStringSchedulable(DateTime dt){
        //String  dateString = ' ';
       //  String newDate = secondes+' '+minutes+' '+h+' '+day+' '+month+' '+'?'+' '+year;
       String  dateString;
       System.debug('##################### dt '+dt);
       try {
        String  days = (dt.day() < 10) ? 0+''+String.valueOf(dt.day()):String.valueOf(dt.day());
        Integer years =   dt.year();
        String  month =(dt.month() < 10 )?0+''+String.valueOf(dt.month()):String.valueOf(dt.month());
        String hours =  (dt.hour()< 10 )?0+''+String.valueOf(dt.hour()):String.valueOf(dt.hour());
        String minutes = (dt.minute() < 10)?0+''+String.valueOf(dt.minute()):String.valueOf(dt.minute());
        String seconde = (dt.second() < 10)?0+''+String.valueOf(dt.second()):String.valueOf(dt.second());

        dateString = seconde + ' '+minutes+' '+hours + ' '+days + ' '+month + ' '+ ' '+'?'+' '+years;
         
       } catch (Exception e) {
              System.debug('############################ errorMessage '+e.getMessage());
              System.debug('############################## error '+e.getStackTraceString());
       }
      
        return  dateString;
  }

  public static Boolean comparedDateTime(Datetime d1, Datetime d2){
    Boolean returnValue = false;
     System.debug('DateTime now '+d1);
     System.debug('Time30__c now '+d2);
    if( d1.isSameDay(d2) && d1 >= d2 ){
      returnValue = true;
    }
    return returnValue;
  } 

/*********************************************************
*@author Madicke BALDE
*@description method to lauch batch
*@param Case Map : caseMap
*@param name schedulable : mn
*@param time to execute class : numHour
**********************************************************/
public static void schedulableJob(Map<Id, Case> caseMap, String mn, Integer numHour){
  if(caseMap == null || caseMap.size() == 0){
      return;
  }
  else {
      Map<String, String> returnValue =  CaseService.parseNameJobAndCronExp(numHour);
      System.debug('*********** cronExp *** '+returnValue.get('cronExp'));
      
      System.schedule(returnValue.get('namejob'), returnValue.get('cronExp'), new  SchedulableJobsInCase(mn, caseMap));
  }

}

public static void schedulableJobexecute(Map<Id, Case> caseMap, String mn){
   if(caseMap == null || caseMap.size() == 0){
    return;
  }
  else {
        Datetime executeDate =  caseMap.values()[0].LastModifiedDate;
        Map<String, String> returnValue = new Map<String, String>();
        Datetime dt ;
        dt = executeDate.addMinutes(2);
        System.debug(' ************** dt after 30 **** ' + dt);

        String cronExp = CGMWSUtils_1_0.formatedDatimeToStringSchedulable(dt);
        String namejob = 'cronExp'+cronExp+'-schedule_Ds-' + caseMap.values()[0].Id;
        System.debug('******** cronExp ' + cronExp);
        returnValue.put('namejob', namejob);
        returnValue.put('cronExp', cronExp);
        abordJob(caseMap.values()[0].Id);
        System.schedule(returnValue.get('namejob'), returnValue.get('cronExp'), new  SchedulableJobsInCase(mn, caseMap));
  }
}

public static void sendInvioDemAndSMS(Map<Id, Case> caseMap, String templateName,  String DEM, String templateSMS, String subject, String fromAddress, String param){
      if(caseMap == null || caseMap.size() == 0){
           return;
      }
      else {
              Id idAccount ;
              String nameCampaign;
              String vechoCell ;
              for(Id idCase : caseMap.keySet()){
              if(caseMap.get(idCase).AccountId != null ){
                  idAccount = caseMap.get(idCase).AccountId;
                  nameCampaign ='DEM'+caseMap.get(idCase).Product__r.DEMAnomalie__c;
                  vechoCell = caseMap.get(idCase).Account.Phone;
                  break;
              }
         }
        // ************** Call sms *************************** 
        List<XCS_Template__c> templateTesto = [SELECT Body__c FROM XCS_Template__c Where Name = : templateSMS];

        System.debug(' *********** templateTesto[0].Body__c  '+templateTesto[0].Body__c);
        OCSInviaSMSInvoker.inviaSMS('', vechoCell,'','',templateTesto[0].Body__c);  
        //** ***************** call invio DEM*************** 
        CaseDomain.mailDem(DEM, caseMap.values()[0].Id, subject, fromAddress, param);
  }
}

//method to check if date2 is within the next 30 days of date1
public static Boolean DatetimeWithin30mn(Datetime date1, Datetime date2) {
      //check for date2 being in the past
      System.debug('************ date1 '+date1);
      System.debug('************ date2 '+date2);
      Datetime date30mn = date1.addMinutes(2)  ; //create a date 30 days away from date1
      System.debug('************ Datetime  '+date30mn);
      System.debug('************ date2 time30__c  '+date2);
      if(date2  >= date30mn ) { return true; }
      else { return false; }
}

public static void dividendoElimina(String dateString , String importoString){
        String importom = importoString.remove('-');
        Integer montant = Integer.valueOf(importom);
        importoString = String.valueOf(montant);
        Datetime df= CGMWSUtils_1_0.formatStringToDatetime(dateString);
        String deteformat = 'dd/MM/yyyy';
        String ds = df.format(deteformat);
        dateString = ds;
  }

  /**
    *@author Madicke BALDE
    *@date 2019/07/29
    *@description check movementi is in last 30 day
    *@param RecuperaMovAutViaggiantiResponse.MovimentoViaggianteDTO mv
    *@return Boolean
   **/
  public static Boolean checkIfMovementIsInLast30days (String stringDate){
        System.debug('*************** running   checkIfMovementIsInLast30days   ');
        Boolean inLast30Days = false;
        Date dateOperationLast30days = (Date.today()).addDays(-30);
        Date dateOperation = CGMWSUtils_1_0.formatStringToDate(stringDate);
        System.debug('************dateOperation '+dateOperation);
        if(dateOperationLast30days > dateOperation ){
            inLast30Days = true;
        }
        System.debug('************ inLast30Days'+inLast30Days);
        return !inLast30Days;
  }

/**********************************************************************
  *@Author Madicke BALDE
  *@description
  *@date
  *@param Time
  *@return String
 **************************************************************************/
public static  String convertTimeToString(Time t){
      String h =  (t.hour()< 10 )?0+''+String.valueOf(t.hour()):String.valueOf(t.hour());
      String m = (t.minute() < 10)?0+''+String.valueOf(t.minute()):String.valueOf(t.minute());
      String chaine = h+':'+m;
      return chaine;
}

public static Map<String, CronTrigger> getBatchJob(){
      Map<String, CronTrigger> mapJobs = new Map<String, CronTrigger>();
      List<CronTrigger> jobs = [Select Id, CronJobDetail.Name, State, NextFireTime From CronTrigger WHERE State !='DELETED'];
      for(CronTrigger job  : jobs){
          if( (job.CronJobDetail.Name).contains('schedule_Ds') ){
              String idJob = (job.CronJobDetail.Name).substringAfter('schedule_Ds-');
              mapJobs.put(idJob, job);
          }
      }
      System.debug('########### map JOB'+mapJobs);
      return  mapJobs;
}

public static  void abordJob (Id idCase){
      System.debug('################# running  abordJob');
      Map<String, CronTrigger>  mapJobs = getBatchJob();
      String caseId = (String) idCase;
      if(mapJobs.containsKey(caseId)){
      System.debug('############# cronjob '+mapJobs.get(caseId));
      System.debug('########## id job'+mapJobs.get(caseId).Id);
      System.debug('############### after abord job '+mapJobs.get(caseId).State);
      // System.abortJob(mapJobs.get(caseId).Id);
      System.debug('###############  abord job '+mapJobs.get(caseId).CronJobDetail.Name);
      System.debug('############### after abord job '+mapJobs.get(caseId).State);
      }
}

public static void createNote(String nameDEM,  Case c){
  String email = c.Account.PersonEmail;
  String anomalies ;
 /* if(c.isdiscordanzaCell){
    for(Anomalie_Doc__c ano : c.Anomalie_Doc__r ){
      anomalies = String.join(arg0, arg1)
    }
  } */
  String body = 'a:'+email+'\n'+
                'Link Bozza :'+c.RO_Link_Bozza__c+'\n'+
                'Anomalie DOC:'+c.Anomalie_Doc__r;
  CaseDomain.createFeeditem(nameDEM,body,c.Id );

}

}