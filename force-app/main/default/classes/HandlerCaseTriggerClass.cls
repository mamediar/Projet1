public  class HandlerCaseTriggerClass {
   public static Boolean  afterThirtyMinutes = true;
   public static Boolean  afterSeventyTwoHours = false;
   public static Boolean  afterTwentyFourHours = false;
   public static String cronExpTwentyFourHoursAfter;
   public static String cronExpSeventyTwoHoursAfter;
   public static  Map<Id, Case> casesMap ;
   public static final String AFTER_THIRTY_MINUTES = 'afterThirtyMinutes';
   public static final String AFTER_SEVENTY_TWO_HOURS = 'afterSeventyTwoHours';
   public static final String AFTER_TWENTY_FOUR_HOURS = 'afterTwentyFourHours';
   public static Map<Id,Case> mapCases = new Map<Id,Case>();

   public static void contattiInFaseDiCaricoDSPrimoInvio (List<Case> casesList){
      System.debug(' *********** running contattiInFaseDiCaricoDSPrimoInvio  ');
      casesMap = new Map<Id, Case>(casesList);
      System.debug('***************** casesList[0].Time30__c '+casesList[0].Time30__c);
      String cronExp = CGMWSUtils_1_0.formatedDatimeToStringSchedulable(casesList[0].Time30__c );
      System.debug('cronExp  '+cronExp);
      String namejob = 'schedule_Ds-'+ cronExp;
 }

public static void aggiornamentoHandler(List<Case> caseList){
   Map<Id, Case> mapCases = new Map<Id, Case>();
   for(Case c : caseList){
      if(!mapCases.containsKey(c.Id)){
         mapCases.put(c.Id, c);
      }
   }
   executeJobAfterThirtyMinutes(mapCases);
     /* Map<Id,Case> returnCase =  caseHandlerDispatcher(caseList);
      System.debug('################ returnCase test test '+returnCase);
      schedulableJobs(returnCase); */
}

public static Map<Id,Case>  caseHandlerDispatcher(List<Case> caseList){
   System.debug('**************** caseHandlerDispatcher ************ ');
   Map<Id,Case> returnCase = new Map<Id,Case>();
   Map<String, List<Case>> caseMapList = DsEcomDSPaggiornamento(caseList);
   System.debug('############  caseMapList '+caseMapList);
   AggiornamentoPraticeDS.aggiornamentoDS(caseMapList.get('DS'),returnCase);
   AggiornamentoPraticeDSP.aggiornamentoDSP(caseMapList.get('DSP'), returnCase);
   return returnCase;
}

 public static Map<String, List<Case>> DsEcomDSPaggiornamento(List<Case> caseList){
            Map<String, List<Case>> mapCases = new Map<String, List<Case>>();
         try {
            List<Case> listCaseWithProductFamily = [SELECT Id,
                                                           Product__c,
                                                           Product__r.DEMAnomalie__c,
                                                           RO_Vecchio_Cellulare__c,
                                                           RO_Link_Bozza__c,
                                                           RO_Engine_channel__c,
                                                           Account.getCodice_Cliente__c,
                                                           Time30__c,
                                                           Richiesta_appuntamento__c,
                                                           RO_Current_Step__c,
                                                           AccountId,
                                                           Account.PersonEmail,
                                                           (SELECT Id, descrizione_Documento__c FROM Anomalie_Doc__r),
                                                           RO_fea__c,
                                                           Account.Phone,
                                                           Tipo_Prodotto__c,
                                                           LastModifiedDate,
                                                           Product__r.Family,
                                                           (SELECT Id,RO_CRMModalita_richiesta__c FROM Rich_online_steplogs__r)
                                                           FROM Case  WHERE Id IN : caseList];
            System.debug('************ Liste Case size '+listCaseWithProductFamily.size());
            for(Case c : listCaseWithProductFamily){
               // System.debug('Case Id '+c.Id + ' Family '+c.Product__r.Family);
               switch on c.Product__r.Family {
                  when 'PP_ONLINE_COMPASS_DS' {
                        if(!mapCases.containsKey ('DS') ){
                           mapCases.put('DS',new List<Case>{c});
                        }
                        else {
                           List<Case> cases =  mapCases.get('DS');
                           cases.add(c);
                           mapCases.put('DS',cases);
                              //mapCases.get('DS').add(c);
                        }
                        System.debug('######################## DS test '+mapCases);
                  }
                  when 'PP_ONLINE_PARTNER_DS' {
                        if(!mapCases.containsKey ('DSP') ){
                           mapCases.put('DSP', new List<Case>{c} );
                        }
                        else {
                           List<Case> cases =  mapCases.get('DSP');
                           cases.add(c);
                           mapCases.put('DSP',cases);
                           //mapCases.get('DSP').add(c);
                        }
                  }
                  when  'PF_ECOMMERCE_STANDARD'  {
                        if(!mapCases.containsKey ('ECOM') ){
                              mapCases.put('ECOM',new List<Case>{c});
                        }
                        else {
                           List<Case> cases =  mapCases.get('ECOM');
                           cases.add(c);
                           mapCases.put('ECOM',cases);
                           //  mapCases.get('ECOM').add(c);
                        }
                     
                  }
               }
            }
            System.debug('Map'+mapCases);
            System.debug('Map Size '+mapCases.keySet().size());
         } 
         catch (Exception e) {
            System.debug(' *************** errorMessage aggiornamentoHandler '+e.getMessage());
            System.debug(' *************** errorMessage aggiornamentoHandler '+e.getStackTraceString());
         }
         return mapCases;
 }
 
public static void schedulableJobs(Map<Id,Case> caseMap){
   System.debug('*********** executing  schedulableJobs ******'); 
   System.debug('*********** executing  schedulableJobs ******'+caseMap); 
     System.debug('*********** executing  schedulableJobs  ******'+caseMap.size()); 
   if(caseMap == null || caseMap.size() == 0){
      return;
   }
   else {
       System.debug('*********** shedulable job tses ttest  schedulableJobs '); 
       System.debug('*********** taille du Map '+caseMap.keySet().size());
       CGMWSUtils_1_0.schedulableJob(caseMap, AFTER_TWENTY_FOUR_HOURS, 24);
      // System.schedule(jobName, cronExp, schedulable);
   }
}

public static void executeJobAfterSeventyTwoHours(Map<Id,Case> caseMap){
if(caseMap == null || caseMap.size() == 0){
   return;
}
else {
    System.debug('************* executeJobAfterSeventyTwoHours' + caseMap.keySet().size());
    CGMWSUtils_1_0.schedulableJob(caseMap, AFTER_SEVENTY_TWO_HOURS, 72);
}
}

public static void executeJobAfterThirtyMinutes(Map<Id,Case> caseMap){
   if(caseMap == null || caseMap.size() == 0){
   return;
}
else {
    System.debug('************* executeJobAfterThirtyMinutes' + caseMap.keySet().size());
    CGMWSUtils_1_0.schedulableJobexecute(caseMap, AFTER_THIRTY_MINUTES);
}
}
}