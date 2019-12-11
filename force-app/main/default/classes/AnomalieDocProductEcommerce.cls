/*
* Autheur : Sana Badji
* description Class created for handle  Anomalie by Family: Ecommerce
* @date  27/06/2019
*/

public with sharing class AnomalieDocProductEcommerce {
   public static final String AFTER_TWO_TWO_HOURS = 'afterTwoHours';
   public static  List<String> errorFields = new List<String>();

    public AnomalieDocProductEcommerce() {

    }

/*
* Autheur : Sana Badji
* @param idsetCases
* @description
    Method execute After 30 minutes of inactivity of the client
    the DEM mail "Abandonment E-commerce" will be sent
(last modified date> 30mn)
* @param idCases
* @date  24/06/2019
     */
      public static void  abbandonoPostCaricoOCSAfterThirtyMinutes(Set<Id> idCases){

          List<RO_CRMRich_online_steplog__c> steplogByCase = CaseSelector.SelectorRichOnlineStepLog(idCases);
          Date dateNow = Date.today();
          Id idAccount;
          String body;
          Id caseId=checkAbbandonoPostCaricoOCS(steplogByCase);
          Account getAccount;
          if(caseId==null ){
            System.debug('************ steplogByCase is empty: '+ steplogByCase);
          }
          else{
              CaseDomain.mailDem('2070', caseId,  'Ripresa Bozza E-commerce!',  
                    'noreply@compass.it', 'Compass Banca S.p.A ');
              CaseDomain.createFeeditem('DEMAbbandonoEcommerce',body,  caseId);
              System.debug('************ Abbandono E-commerce sended successfully');
          }

  }

/*
* Autheur : Sana Badji
* @param idCases
* @param idAccount
* @param nameOfCampaign
* @description
    Method execute After 2 hours, if the customer has not carried out any operation,
    The request will be entered into "Abandonment E-commerce" queue managed by RTC (Lastmodified Date> 2 hours)
* @date  24/06/2019
     */
      public static void  abbandonoPostCaricoOCSAfterTwoHours(Set<Id> idCases){
          List<RO_CRMRich_online_steplog__c> steplogByCase = CaseSelector.selectorRichOnlineStepLog(idCases);
          if(checkAbbandonoPostCaricoOCS(steplogByCase)== null ){
            System.debug('************ steplogByCase is empty: '+ steplogByCase);
          }
          else{
              System.debug('************ steplogByCase '+ steplogByCase);
              CallWebService.addToQueuAfterCallWebservice(idCases,'Q336','PF_ECOMMERCE_STANDARD');           
  }
}

    public static Id checkAbbandonoPostCaricoOCS(List<RO_CRMRich_online_steplog__c> steplogByCase){
          Set<Id> idCase= new Set<Id>();
          Id idAccount;
          Id caseId ;
          Account getAccount;
          for(RO_CRMRich_online_steplog__c steplog: steplogByCase){
                idAccount = steplog.RO_CRMRichiesta_Online__r.AccountId;
                getAccount=AnomalieSelector.getAccount(idAccount);
                  if(getAccount.getCodice_Cliente__c != null &&
                    (steplog.RO_CRMStep__c!='Step 5 - Upload Document' ||
                    steplog.RO_CRMStep__c!='Step 8 - Scelta Firma')  ){
                    caseId=steplog.RO_CRMRichiesta_Online__c;
                    }
                     else{
                          errorFields.add(steplog.RO_CRMRichiesta_Online__r.NumeroPratica__c);
                          errorFields.add(steplog.RO_CRMStep__c);
                          String errorCode ='[KO-CREQ0007]';
                          String errorMessage = String.join(errorFields, ', ');
                          throw new CGMWSUtils_1_0.CGMWSRException('[KO-CREQ0007]', errorMessage);
                      }
                  }
         return caseId;
}

/*
* Autheur : Sana Badji
* @descriptiion this method execute the Shedule  after 5 hours
    For Product Family : Ecommerce
* @param  idCase
* @date  01/07/2019
 */
      public static void executeSheduleTwoHours(Set<Id> idCase){
        String crOnTwodays;
        for (Case c : CaseSelector.getPropuitFamily(idCase,'PF_ECOMMERCE_STANDARD')) {
        crOnTwodays= CaseHandlerTriggerClass.createCronExpressionFromDateTimeTwoHours(c.LastModifiedDate);
        System.debug('************  ' + crOnTwodays);
        idCase.add(c.Id);
        }
        SchedulableEcommerce anoSchedul = new SchedulableEcommerce(idCase,AFTER_TWO_TWO_HOURS);
        String jobID = System.schedule('anoSchedul_Ecommerce_AfterTwoHours_'+crOnTwodays, crOnTwodays, anoSchedul);
        System.debug('************  jobID' + jobID);
      }
}