/**
  * @Author  Madicke BALDE
  * @description 
  * @date
  * @File name :
  * 
 */
global  class SchedulableJobsInCase implements Schedulable {
  String controlValue;
   Map<Id, Case> caseMap = new Map<Id, Case>();
   public SchedulableJobsInCase(String controlValue,  Map<Id, Case> caseMap ){
    this.controlValue = controlValue;
    this.caseMap = caseMap;
   }
global  void execute(SchedulableContext ctx){
    System.debug('***************** test caseMap.size()****  '+ caseMap.keySet().size());
    List<Case>  caseList = [SELECT Id,
                                    Product__c,
                                    RO_Link_Bozza__c,
                                    RO_Engine_channel__c,
                                    Account.getCodice_Cliente__c,
                                    Time30__c
                                    FROM Case WHERE Id IN: caseMap.keySet()];
      switch on controlValue {
               when 'afterTwentyFourHours'{
                System.debug('************* afterTwentyFourHours shedulable ');
                Map<Id,Case> returnCase  = HandlerCaseTriggerClass.caseHandlerDispatcher(caseList);
                System.debug('*************** check returnValue after schedulable '+ returnCase);
                HandlerCaseTriggerClass.executeJobAfterSeventyTwoHours(returnCase);

               }
               when 'afterSeventyTwoHours'{
                    Map<Id,Case> returnCase  = HandlerCaseTriggerClass.caseHandlerDispatcher(caseList);
               }
               when 'afterThirtyMinutes'{
                  Map<Id,Case> returnCase  = HandlerCaseTriggerClass.caseHandlerDispatcher(caseList);
                  HandlerCaseTriggerClass.schedulableJobs(returnCase);
               }
               when else {
                     System.debug('************* else shedulable ');
                     
                  //  AggiornamentoPraticeDS.checkPrimoInvioInDsForSeventyTwoHoursPrimaDelSecci(caseMap);
               }
         }
}
}