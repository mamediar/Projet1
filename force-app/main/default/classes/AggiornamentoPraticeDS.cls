public class AggiornamentoPraticeDS {
   
public static Map<Id, Case> caseMaps;
public static Map<Id, Case> caseMapsPrimoDs = new Map<Id, Case>();
public static Map<Id, Case> caseMapsPostSecciDs = new Map<Id, Case>();
public static Map<Id, Case> caseMapsnonForzosoCheAbbandonaDs = new Map<Id, Case>();
public static Map<Id, Case> caseMaps_Ricontatto_ClienteForzoso_FilialeDS = new Map<Id, Case>();
public static Map<Id, Case> caseMaps_Ricontatto_ClienteCheSceglieDS = new Map<Id, Case>();
public static final String AFTER_TWENTY_FOUR_HOURS = 'afterTwentyFourHours';
public static final String AFTER_SEVENTY_TWO_HOURS = 'afterSeventyTwoHours';

public static final String AFTER_TWENTY_FOUR_HOURS_POST_SECCI = 'afterTwentyFourHoursPostSecci';
public static final String AFTER_SEVENTY_TWO_HOURS_POST_SECCI = 'afterSeventyTwoHoursPostSecci';
public static   Map<Id, Case> caseMapFS = new Map<Id, Case>();

public static final String   AFTER_TWENTY_FOUR_HOURS_NON_FORZOSO_CHE_ABBANDONA ='afterTwentyFourHoursnonForzosoCheAbbandona';
public static final String   AFTER_SEVENTY_TWO_HOURS_NON_FORZOSO_CHE_ABBANDONA ='afterSeventyTwoHoursnonForzoso';

public static final String AFTER_TWENTY_FOUR_HOURS_FORZOSO_FILIALEDS  = 'afterTwentyFourHoursForzosoFiliale';
public static final String AFTER_SEVENTY_TWO_HOURS_FORZOSO_FILIALEDS  = 'afterSeventyTwoHoursForzosoFiliale';
public static final  Datetime dateTimeNow = Datetime.now();
public static void aggiornamentoDS(List<Case> caseList, Map<Id,Case> casesR){
    System.debug('******************* running aggiornamentoDS  ');
    if( caseList == null || caseList.size() == 0 ){
         return;
    }
    else 
    {
        System.debug('******************* running aggiornamentoDS else ');
        Recursion.isBeforeTriggerExcecuting = true;
        caseMaps =  new Map<Id, Case>(caseList);
        System.debug('******************* caseMaps aggiornamentoDS  '+caseMaps.keySet().size());
        abbandonaPrimaDelSecci(caseMaps, casesR);
        abbandonaPostSecci(caseMaps,casesR); 
        nonForzosoCheAbbandona(caseMaps,casesR);
        ricontattoClienteForzosoFilialeDS(caseMaps,casesR); 
        System.debug('************** Case Map at the finish *********** '+ caseMaps);
        System.debug('************** caseMapFS ****  '+caseMapFS.keySet().size());
        
    }
}

public static void  abbandonaPrimaDelSecci(Map<Id, Case> caseMap, Map<Id,Case> casesR){
    System.debug('************** running abbandonaPrimaDelSecci  dateTimeNow' +dateTimeNow);
    try {
        if(caseMap == null || caseMap.size() == 0 ){
            return;
        }
        else {
            System.debug('************** map size before '+ caseMap.keySet().size());
            for(Id key : caseMap.keySet()){
                if((caseMap.get(key)).RO_Link_Bozza__c == null && 
                   (caseMap.get(key)).RO_Engine_channel__c == 'W' &&
                    CGMWSUtils_1_0.DatetimeWithin30mn((caseMap.get(key)).LastModifiedDate, dateTimeNow)){
                        System.debug('************** running abbandonaPrimaDelSecci  if yes ');
                        caseMapsPrimoDs.put(key,caseMap.get(key));
                        // caseMapFS.put(key,  caseMap.get(key) ); */
                        casesR.put(key, caseMap.get(key));
                        HandlerCaseTriggerClass.mapCases.put(key, caseMap.get(key));
                        caseMap.remove(key);
                } 
            }
        }
        // launch batch 24
        System.debug('************** map size  after '+ caseMap.keySet().size());
        System.debug('************** caseMapsPrimoDs size '+caseMapsPrimoDs.size());
        inviiSuccessivi24hPrimaDelSecci(caseMapsPrimoDs);
    } 
    catch (Exception e) {
        System.debug('*************** errorMessage abbandonaPrimaDelSecci '+e.getMessage());
        System.debug('*********** abbandonaPrimaDelSecci '+e.getStackTraceString());
        
    }

}

public static void inviiSuccessivi24hPrimaDelSecci(Map<Id,Case> caseMap){
    System.debug('************** running inviiSuccessivi24h ');
 try {
     if(caseMap == null || caseMap.keySet().size() == 0){
         System.debug('************** running inviiSuccessivi24h  Nooooooooo');
         return;
     }
     else {
         // Call invio DEM
          CGMWSUtils_1_0.sendInvioDemAndSMS(caseMap, 'DEMAbbandonoWEBPreSecci', '2059', 'SMSAbbandonoWEBPreSecci', 'richiedi il tuo Prestito Online Compass!', 'richiesta@compass.it', 'Compass Banca S.p.A ');
        // sendInvioDemSMS(caseMap, 'SMSAbbandonoWEBPreSecci');
       // String body = 'a:'
         CGMWSUtils_1_0.createNote('Invia Mail:DEMAbbandonoWEBPreSecci(2059)',caseMap.values()[0] );
         // Call SMS
         System.debug('************** running inviiSuccessivi24h else  ');
      //   Map<String, String> returnValue =  CaseService.parseNameJobAndCronExp(caseMap,24);
       //  System.debug('************* ')
        // Id idjob = System.schedule(returnValue.get('namejob'), '34 39 03 05 07  ? 2019', new Schedulable_Case(AggiornamentoPraticeDS.AFTER_TWENTY_FOUR_HOURS, caseMap));
     }
     
 }
  catch (Exception e) {
     System.debug(' ************ errorMessage nviiSuccessivi24h  '+e.getMessage());
     System.debug(' ************ errorMessage nviiSuccessivi24h  '+e.getStackTraceString());
   }
}

/*public static void sendInvioDemSMS(Map<Id,Case> caseMap, String templateName){
 try {
     if(caseMap == null || caseMap.size() == 0 ){
         return ;
     }
     
     else {
         try {
               System.debug(' ********** sendInvioDemSMS send invio DEM and SMS');
      
                Id accountId;
                String nameCampaign;
                String cell ;
                for(Id idCase : caseMap.keySet()){
                accountId = caseMap.get(idCase).AccountId;
                nameCampaign ='DEM'+caseMap.get(idCase).Product__r.DEMAnomalie__c;
                cell = caseMap.get(idCase).Account.Phone;
                break;
                }

                List<XCS_Template__c> templateTesto = [SELECT Body__c FROM XCS_Template__c Where Name = : templateName];
                System.debug('****** templateTesto[0].Body__c ******* '+templateTesto[0].Body__c);
                if(templateTesto.size() > 0 ){
                OCSInviaSMSInvoker.inviaSMS('', cell,'','',templateTesto[0].Body__c);  
               
                }
         Date d = Date.today();
         InvioDEM.check(accountId, nameCampaign, '', '', '', '', '', d);
         } catch (Exception e) {
            System.debug('************* error Messahe '+e.getMessage());
            System.debug('************* error Messahe '+e.getStackTraceString() );
         }
        

     }
     
 } 
   catch (Exception e) {
     System.debug('**************** errorMessage '+e.getMessage() );
     System.debug('***************** errorMessage '+e.getStackTraceString() );
     
 }
} */

public static void abbandonaPostSecci(Map<Id, Case> caseMap, Map<Id, Case> casesR){
    System.debug('************************* running  abbandonaPostSecci '+caseMap.keySet().size())  ;
        if(caseMap == null || caseMap.size() == 0 ){
            return;
        }    
        else {
            for(Id idCase : caseMap.keySet()){
                System.debug('************ Id'+ (caseMap.get(idCase)).Id );
            }
             getCaseAbbandonaPostSecci(caseMap,casesR);
        }
        System.debug('**************** Post Secci DS '+caseMapsPostSecciDs.size());
        abbandonaPostSecciAzioni(caseMapsPostSecciDs);
}

public static void  getCaseAbbandonaPostSecci(Map<Id, Case> caseMap, Map<Id, Case> casesR ){
         Map<Id, Case> mapCases = new Map<Id, Case>();
       try {
          if(caseMap == null || caseMap.size() == 0){
              return;
          }
          else {
              for(Id key : caseMap.keySet()){
                  if( String.isNotEmpty((caseMap.get(key)).RO_Link_Bozza__c) && 
                   (caseMap.get(key)).RO_Engine_channel__c == 'W' &&
                    (caseMap.get(key)).Account.getCodice_Cliente__c == null &&
                    CGMWSUtils_1_0.DatetimeWithin30mn((caseMap.get(key)).LastModifiedDate, dateTimeNow)){
                    System.debug('************** running abbandonaPrimaDelSecci  if yes ');
                    caseMapsPostSecciDs.put(key,caseMap.get(key));
                     casesR.put(key, caseMap.get(key));
                   HandlerCaseTriggerClass.mapCases.put(key, caseMap.get(key));
                    caseMap.remove(key);
                 } 
              }
          }
           
       } catch (Exception e) {
           System.debug('**************** errorMessage getCaseAbbandonaPostSecci '+ e.getMessage());
           System.debug('**************** errorMessage getCaseAbbandonaPostSecci '+ e.getStackTraceString() );
       }
}
/*
*@author Madicke BALDE
*@description 
*@param Map Case
*
*/
public static void abbandonaPostSecciAzioni(Map<Id, Case> caseMap ){
    if(caseMap == null || caseMap.size() == 0){
        return;
    }
    else {
        Group g = CaseService.getQueue('Q330');
        if(g != null ) {
            for(Id idcase : caseMap.keySet() ){
               (caseMap.get(idcase)).OwnerId = g.Id;
            }
             Recursion.isBeforeTriggerExcecuting = true;
             update caseMap.values();
        }
         CGMWSUtils_1_0.sendInvioDemAndSMS(caseMap, 'SMSAbbandonoWEBPostSecci', '2060','SMSAbbandonoWEBPostSecci', 'riprendi la tua richiesta di Prestito Online Compass!', 'richiesta@compass.it', 'Compass Banca S.p.A ');
         CGMWSUtils_1_0.createNote('Invia Mail:SMSAbbandonoWEBPostSecci(2060)',caseMap.values()[0] );
        //sendInvioDemSMS(caseMap,'SMSAbbandonoWEBPostSecci');
       // abbandonaPostSecciAzioni(caseMap,AFTER_TWENTY_FOUR_HOURS_POST_SECCI,24 );
    }
}

public static void addCaseToQueue(List<Case> casesList, String code){
        Group gr;
    try {
        if(casesList == null || casesList.size() == 0){
            return;
        }
        else {
                gr = [SELECT  Id FROM Group WHERE Type = 'Queue' AND DeveloperName =: code];
                for(Case c : casesList){
                    c.OwnerId = gr.Id;
                }
        }
        
    } catch (Exception e) {
        System.debug('***************** errorMessage **************** '+e.getMessage());
        System.debug('**************** errorStackTrace ************* '+e.getStackTraceString());
        
    }
}


/**  *********************   Cliente non forzoso che abbandona ***********************************  ****/
public static void nonForzosoCheAbbandona(Map<Id, Case> caseMap, Map<Id, Case> casesR ){
  if(caseMap == null || caseMap.size() == 0 ){
    return;
  }
  else {
       for(Id idCase : caseMap.keySet()){
        if( (caseMap.get(idCase)).RO_Engine_channel__c == 'Non forzoso Filiale' &&
             (caseMap.get(idCase)).Account.getCodice_Cliente__c == null &&
             (caseMap.get(idCase)).RO_Current_Step__c != 'Step 2 - Scelta cliente' &&
             (caseMap.get(idCase)).Richiesta_appuntamento__c == false &&
              CGMWSUtils_1_0.DatetimeWithin30mn((caseMap.get(idCase)).LastModifiedDate, dateTimeNow) &&
              RichOnlineSteplogService.seracrModalitaRichesta( (caseMap.get(idCase)).Rich_online_steplogs__r)){
              caseMapsnonForzosoCheAbbandonaDs.put(idCase, caseMap.get(idCase));
             // caseMapFS.put(idCase,  caseMap.get(idCase) );
              casesR.put(idCase, caseMap.get(idCase));
              HandlerCaseTriggerClass.mapCases.put(idCase, caseMap.get(idCase));
              caseMap.remove(idCase);

             }
    }
    System.debug('*****************  caseMapsnonForzosoCheAbbandonaDs '+caseMapsnonForzosoCheAbbandonaDs.keySet().size());
    //sendInvioDemSMS(caseMapsnonForzosoCheAbbandonaDs);
    forzosoCheAbbandonaDsAzioni(caseMapsnonForzosoCheAbbandonaDs);
  }
}
public static void forzosoCheAbbandonaDsAzioni(Map<Id, Case> caseMap){
    if(caseMap == null || caseMap.size() == 0){
        return;
    }
    else {
         Group g = CaseService.getQueue('Q331');
        if(g != null ) {
            for(Id idcase : caseMap.keySet() ){
               (caseMap.get(idcase)).OwnerId = g.Id;
            }
        }
        CGMWSUtils_1_0.sendInvioDemAndSMS(caseMap, 'DEMAbbandonoNONForzPreSecci', '2061','SMSAbbandonoNONForzPreSecci', 'fissa un appuntamento per il tuo Prestito Compass!', 'richiesta@compass.it', 'Compass Banca S.p.A ');
        //sendInvioDemSMS(caseMap,'SMSAbbandonoNONForzPreSecci');
     //   abbandonaPostSecciAzioni(caseMap, AFTER_TWENTY_FOUR_HOURS_NON_FORZOSO_CHE_ABBANDONA,24);
        
    }
}



/** *********************  Ricontatto cliente forzoso filiale *************************** */
public static void ricontattoClienteForzosoFilialeDS(Map<Id, Case> caseMap, Map<Id, Case> casesR){
    System.debug('**************** running ************ ricontattoClienteForzosoFilialeDS ');
    if(caseMap == null || caseMap.size()== 0 ){
             return;
    }
    else 
    {
            for(Id idCase : caseMap.keySet() ){
            if( caseMap.get(idCase).RO_Engine_channel__c == 'Forzoso Filiale' &&
                caseMap.get(idCase).Account.getCodice_Cliente__c == null &&
                caseMap.get(idCase).Richiesta_appuntamento__c == false &&
                CGMWSUtils_1_0.DatetimeWithin30mn((caseMap.get(idCase)).LastModifiedDate, dateTimeNow)){

                    caseMaps_Ricontatto_ClienteForzoso_FilialeDS.put(idCase, caseMap.get(idCase));
                    casesR.put(idCase, caseMap.get(idCase));
                    HandlerCaseTriggerClass.mapCases.put(idCase, caseMap.get(idCase));
                    caseMap.remove(idCase);  
           }
    }
    System.debug('**************** ricontattoClienteForzosoFilialeDS size '+caseMaps_Ricontatto_ClienteForzoso_FilialeDS.keySet().size());
    ricontattoClienteForzosoFilialeDSAzioni(caseMaps_Ricontatto_ClienteForzoso_FilialeDS);
  }
}
public static void ricontattoClienteForzosoFilialeDSAzioni(Map<Id, Case> caseMap){
    if(caseMap == null  || caseMap.size() == 0 ){
        return ;
    }
    else {
          Group g = CaseService.getQueue('Q332');
        if(g != null ) {
            for(Id idcase : caseMap.keySet() ){
               (caseMap.get(idcase)).OwnerId = g.Id;
            }
        }
         CGMWSUtils_1_0.sendInvioDemAndSMS(caseMap, 'DEMAbbandonoForz', '2062','SMSAbbandonoForz', ' vieni in Filiale per il tuo Prestito Compass!', 'richiesta@compass.it', 'Compass Banca S.p.A ');
       // sendInvioDemSMS(caseMap,'SMSAbbandonoForz');
        //abbandonaPostSecciAzioni(caseMap,AFTER_TWENTY_FOUR_HOURS_FORZOSO_FILIALEDS, 24);
    }
}


public static void ricontattoClienteCheSceglie(Map<Id, Case> caseMap, Map<Id, Case> casesR){
    if(caseMap == null || caseMap.size() == 0){
        return;
    }
    else {
        for(Id idCase: caseMap.keySet()){
           if(caseMap.get(idCase).RO_Current_Step__c == 'Step 2 - Scelta cliente' &&
             RichOnlineSteplogService.seracrModalitaRichesta((caseMap.get(idCase)).Rich_online_steplogs__r)){
              caseMaps_Ricontatto_ClienteCheSceglieDS.put(idCase,(caseMap.get(idCase)));
              caseMap.remove(idCase);
           }
        }
    }
    inserimentoInCoda(caseMaps_Ricontatto_ClienteCheSceglieDS);
}
public static void inserimentoInCoda(Map<Id, Case> caseMap){
 if(caseMap == null || caseMap.size() == 0 ){
     return;
 }
 else {
       Group g = CaseService.getQueue('Q333');
        if(g != null ) {
            for(Id idcase : caseMap.keySet() ){
               (caseMap.get(idcase)).OwnerId = g.Id;
            }
        }
 }

}
}