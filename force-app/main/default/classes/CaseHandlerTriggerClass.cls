/* 
* Autheur : Sana Badji 
* description Class created for handle Method to call on Trigger
* @date  16/05/2019
*/
 
public  class CaseHandlerTriggerClass { 
     public static String cronAfterThreeHours;
     public static String cronAfterThirtyMinutes;
     public static String cronAfterTwoHours;
     public static String cronAfterFiveDays;
     public static final String AFTER_THIRTY_MINUTES = 'afterThirtyMinutes';
     public static final String AFTER_THREE_THREE_HOURS = 'afterThreeHours';
     public static final String AFTER_TWO_TWO_HOURS = 'afterTwoHours';
     public static List<Case> caseProductDS = new List<Case>();
     public static List<Case> caseProductDSP = new List<Case>();
     public static List<Case> caseProductEcommerce = new List<Case>();

     public static void  caseHandlerDispatcher(List<Case> caseList, Set<Id> idsToProcess){
     for(Case c : caseList)
     {
          cronAfterThreeHours= createCronExpressionFromDateTimeThreeHours(c.LastModifiedDate); 
          cronAfterThirtyMinutes= createCronExpressionFromDateTimeThirtyMinutes(c.LastModifiedDate);
          cronAfterFiveDays=createCronExpressionFromDateTimeFiveDays(c.LastModifiedDate);
          cronAfterTwoHours=createCronExpressionFromDateTimeTwoHours(c.LastModifiedDate); 
     }
          caseProductDS= CaseSelector.getPropuitFamily(idsToProcess,'PP_ONLINE_COMPASS_DS'); 
          caseProductDSP= CaseSelector.getPropuitFamily(idsToProcess,'PP_ONLINE_PARTNER_DS');
          caseProductEcommerce= CaseSelector.getPropuitFamily(idsToProcess,'PF_ECOMMERCE_STANDARD');
     if(caseProductDS.size() > 0){     
          afterUpdateDEMAnomalieDocumentaliDS(caseList);
          afterUpdateDEMAccountReassuranceDS(caseList);
          Set<String> checkStatoOcsExist = AnomalieDocProductDS.anomaliePreSicPP(idsToProcess); 
          if(checkStatoOcsExist.size()==0){
          System.debug('************ checkStatoOcsExist '+checkStatoOcsExist);
          SchedulableDS anoSchedulDAfterThreeHoursDS = new SchedulableDS(idsToProcess,AFTER_THREE_THREE_HOURS,'');  
          String jobIDAfterThreeHoursDS = System.schedule('anoSchedul_DS_afterThreeHours_'+cronAfterThreeHours, cronAfterThreeHours, anoSchedulDAfterThreeHoursDS);
          SchedulableDS anoSchedulAfterThirtyMinutesDS = new SchedulableDS(idsToProcess,AFTER_THIRTY_MINUTES,cronAfterFiveDays);  
          String jobIDAfterThirtyMinutesDS = System.schedule('anoSchedul_DS_afterThirtyMinutes_'+cronAfterThirtyMinutes, cronAfterThirtyMinutes, anoSchedulAfterThirtyMinutesDS);
               }
     }
     if(caseProductDSP.size() > 0){
          afterUpdateDEMAnomalieDocumentaliDSP(caseList);
          afterUpdateDEMAccountReassuranceDSP(caseList);
          Set<String> checkStatoOcsExist = AnomalieDocProductDS.anomaliePostSicPP(idsToProcess); 
          if(checkStatoOcsExist.size()==0){
          SchedulableDSP anoSchedulAfterThreeHoursDSP = new SchedulableDSP(idsToProcess,AFTER_THREE_THREE_HOURS,'');
          String jobIDAfterThreeHoursDSP = System.schedule('anoSchedul_DSP_afterThreeHours_'+cronAfterThreeHours, cronAfterThreeHours, anoSchedulAfterThreeHoursDSP);
          SchedulableDSP anoSchedulAfterThirtyMinutesDSP = new SchedulableDSP(idsToProcess,AFTER_THIRTY_MINUTES,cronAfterFiveDays);
          String jobIDAfterThirtyMinutesDSP = System.schedule('anoSchedul_DSP_afterThirtyMinutesDSP_'+cronAfterThirtyMinutes, cronAfterThirtyMinutes, anoSchedulAfterThirtyMinutesDSP);
          }    
     }
     if (caseProductEcommerce.size() > 0){
          SchedulableEcommerce anoSchedulEcomAfterThirtyMinutes = new SchedulableEcommerce(idsToProcess,AFTER_THIRTY_MINUTES);
          String jobIDDSP = System.schedule('anoSchedul_Ecom_AfterThirtyMinutes_'+cronAfterThirtyMinutes, cronAfterThirtyMinutes, anoSchedulEcomAfterThirtyMinutes);
     }


}
/*  
* Autheur : Sana Badji 
* @param idsetCases
* @description method created for handle Cron Expression FromDateTime for 3hour
* @param Date Time
* @date  20/06/2019
*/
public static String createCronExpressionFromDateTimeThreeHours(DateTime fireTime) {
          List<String> timeParts = new List<String>();
          String hourAdded= String.valueOf(fireTime.addHours(3).format('HH'));
          String hour= String.valueOf(fireTime.format('HH'));
          String min= String.valueOf(fireTime.format('mm'));
          String minAdded= String.valueOf(fireTime.addMinutes(2).format('mm'));
          String sec= String.valueOf(fireTime.format('ss'));
          //String hourComplet=  sec+' '+min+' '+hourWithout+' ';
          //String sc1 = hourComplet+'* * ? *';
          timeParts.add(String.valueof(sec));
         // timeParts.add(String.valueof(minAdded));
          timeParts.add(String.valueof(min));
          timeParts.add(String.valueof(hourAdded));
         // timeParts.add(String.valueof(sec));
          timeParts.add('*');
          timeParts.add('*');
          timeParts.add('?');
          timeParts.add('*');
          System.debug('############## timeParts'+timeParts);
          return String.join(timeParts, ' ');
     }


/*  
* Autheur : Sana Badji 
* @param idsetCases
* @description method created for handle Cron Expression FromDateTime for 30min
* @param Date Time
* @date  20/06/2019
*/
public static String createCronExpressionFromDateTimeThirtyMinutes(DateTime fireTime) {
          List<String> timeParts = new List<String>();
          //String hourAdded= String.valueOf(fireTime.addHours(3).format('HH'));
          String hour= String.valueOf(fireTime.format('HH'));
          //String min= String.valueOf(fireTime.addMinutes(2).format('mm'));
          String minAddedthirtyminute= String.valueOf(fireTime.addMinutes(30).format('mm'));
          String sec= String.valueOf(fireTime.format('ss'));
          //String hourComplet=  sec+' '+min+' '+hour+' ';
          //String sc1 = hourComplet+'* * ? *';
          timeParts.add(String.valueof(sec));
          timeParts.add(String.valueof(minAddedthirtyminute));
          timeParts.add(String.valueof(hour));
          timeParts.add('*');
          timeParts.add('*');
          timeParts.add('?');
          timeParts.add('*');
          return String.join(timeParts, ' ');
     }


/*  
* Autheur : Sana Badji 
* @param idsetCases
* @description method created for handle Cron Expression FromDateTime for 2hour
* @param Date Time
* @date  20/06/2019
*/
public static String createCronExpressionFromDateTimeTwoHours(DateTime fireTime) {
          List<String> timeParts = new List<String>();
          String hour= String.valueOf(fireTime.addHours(2).format('HH'));
          //String hourWithout= String.valueOf(fireTime.format('HH'));
          //String min= String.valueOf(fireTime.addMinutes(4).format('mm'));
          String min= String.valueOf(fireTime.format('mm'));
          String sec= String.valueOf(fireTime.format('ss'));
          //String hourComplet=  sec+' '+min+' '+hourWithout+' ';
          //String sc1 = hourComplet+'* * ? *';
          timeParts.add(String.valueof(sec));
          timeParts.add(String.valueof(min));
          timeParts.add(String.valueof(hour));
          timeParts.add('*');
          timeParts.add('*');
          timeParts.add('?');
          timeParts.add('*');
          return String.join(timeParts, ' ');
     }

public static String createCronExpressionFromDateTimeFiveDays(DateTime fireTime) {
          List<String> timeParts = new List<String>();
          String daysAdded= String.valueOf(fireTime.addDays(5).format('dd'));
          String hour= String.valueOf(fireTime.format('HH'));
          //String min= String.valueOf(fireTime.addMinutes(3).format('mm'));
          String min= String.valueOf(fireTime.format('mm'));
          String sec= String.valueOf(fireTime.format('ss'));
          //String hourComplet=  sec+' '+min+' '+hour+' ';
          // Seconds Minutes Hours Day_of_month Month Day_of_week optional_year
          //String sc1 = hourComplet+'* * ? *';
          timeParts.add(String.valueof(sec));
          timeParts.add(String.valueof(min));
          timeParts.add(String.valueof(hour));
          timeParts.add(String.valueof(daysAdded));
          //timeParts.add('*');
          timeParts.add('*');
          timeParts.add('?');
          timeParts.add('*');
          return String.join(timeParts, ' ');
     }
/*  
* Autheur : Sana Badji 
* @description method execute after update 
     call method DEMAnomalieDocumentaliDS[Product Family DS] for sent Mail and Sms 
* @param ListCase after update
* @date  01/06/2019
*/
public static void afterUpdateDEMAnomalieDocumentaliDS(List<Case> listCase)
     {
          Set<Id> caseIds = new Set<Id>();
          Id idAccount;
          String nameOfCampaign;
          for (Case cas : listCase) { 
          caseIds.add(cas.Id);
          }
          System.debug('********CaseIds'+ caseIds);
          if(caseIds.size() > 0){
          List<Case>  listcasProd =
               [SELECT Product__r.DEMAnomalie__c , Product__r.Family,AccountId FROM 
               Case WHERE  Id IN :caseIds ];
               for (Case casProd : listcasProd){
               idAccount = casProd.AccountId;
               System.debug('********casprod.Product__r.Family '+ casProd.Product__r.Family);
               }
               System.debug('********idAccount '+ idAccount);                 
          if(idAccount!=null){
          AnomalieDocProductDS.dEMAnomalieDocumentaliDS(idAccount,caseIds);
          }
}
}

/*  
* Autheur : Sana Badji 
* @description method execute after update 
     call method dEMAccountReassuranceDS[Product Family DS] 
     for sent Mail and Sms 
* @param ListCase after update
* @date  01/06/2019
*/

public static void afterUpdateDEMAccountReassuranceDS(List<Case> listCase)
     {
          Set<Id> caseIds = new Set<Id>();
          Id idAccount;
          String nameOfCampaign;
          for (Case cas : listCase) { 
          caseIds.add(cas.Id);
          }
          System.debug('********CaseIds'+ CaseIds);
          if(caseIds.size() > 0){
          List<Case>  listcasProd =
               [SELECT Product__r.DEMAnomalie__c , Product__r.Family,AccountId FROM 
               Case WHERE  Id IN :caseIds ];
               for (Case casProd : listcasProd){
               System.debug('********casprod.Product__r.Family '+ casProd.Product__r.Family);
               idAccount = casProd.AccountId;
               }
          System.debug('********idAccount '+ idAccount);                  
          if(idAccount!=null){
          System.debug('********idAccount '+ idAccount);
          AnomalieDocProductDS.dEMAccountReassuranceDS(idAccount, caseIds);  
          }       
     }
}

/*  
* Autheur : Sana Badji 
* @description method execute after update 
     call method DEMAnomalieDocumentaliDSP[Product Family DSP] 
     for sent Mail and Sms 
* @param ListCase after update
* @date  01/06/2019
*/

public static void afterUpdateDEMAnomalieDocumentaliDSP(List<Case> listCase)
     {
          Set<Id> caseIds = new Set<Id>();
          Id idAccount;
          String nameOfCampaign;
          for (Case cas : listCase) { 
          caseIds.add(cas.Id);
          }
          System.debug('********CaseIds'+ CaseIds);
          if(caseIds.size() > 0){
          List<Case>  listcasProd =
               [SELECT Product__r.DEMAnomalie__c , Product__r.Family,AccountId FROM 
               Case WHERE  Id IN :caseIds ];
               for (Case casProd : listcasProd){
               System.debug('********casprod.Product__r.Family '+ casProd.Product__r.Family);
               idAccount = casProd.AccountId;
               }
          System.debug('********idAccount '+ idAccount);                 
          if(idAccount!=null ){
          AnomalieDocProductDSP.dEMAnomalieDocumentaliDSP(idAccount,CaseIds);
          }
}
}


/*  
* Autheur : Sana Badji 
* @description method execute after update 
     call method DEMAnomalieDocumentaliDSP[Product Family DSP] 
     for sent Mail and Sms 
* @param ListCase after update
* @date  01/06/2019
*/

public static void afterUpdateDEMAccountReassuranceDSP(List<Case> listCase)
     {
          Set<Id> caseIds = new Set<Id>();
          Id idAccount;
          String nameOfCampaign;
          for (Case cas : listCase) { 
          caseIds.add(cas.Id);
          }
          System.debug('********CaseIds'+ CaseIds);
          if(caseIds.size() > 0){
          List<Case>  listcasProd =
               [SELECT Product__r.DEMAnomalie__c , Product__r.Family,AccountId FROM 
               Case WHERE  Id IN :caseIds ];
               for (Case casProd : listcasProd){
               nameOfCampaign = 'DEM'+casProd.Product__r.DEMAnomalie__c;
               idAccount = casProd.AccountId;
               System.debug('********casprod.Product__r.Family '+ casProd.Product__r.Family);
               }
               System.debug('********nameOfCampaign '+ nameOfCampaign);
               System.debug('********idAccount '+ idAccount);                 
          if(idAccount!=null ){
          AnomalieDocProductDSP.dEMAccountReassuranceDSP(idAccount,CaseIds);
          }
}
}


}