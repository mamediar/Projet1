/*
*@author Madicke BALDE
*
*@ Trigger after insert Anomalie
*
*/
trigger CheckdiscordaCellulareTrigger on Anomalie_Doc__c (after insert) {
    System.debug(' ************ Running trigger ***************** ');
  /*  List<Anomalie_Doc__c> anomalies = new   List<Anomalie_Doc__c>();
     // Get List Anomalie containing discorda cellulare
     System.debug('list anomalie '+ Trigger.new);
     Map<String,Object> returnValue  =  AnomalieDocService.discordaCellulare(Trigger.new);
     
     //check List not Empty
     List<Anomalie_Doc__c> tailles = (List<Anomalie_Doc__c>) returnValue.get('anomalies');
      System.debug('********* Anomalies List not empty '+ tailles.size());
     if(((List<Anomalie_Doc__c>) returnValue.get('anomalies')).size() > 0){
         System.debug('********* Anomalies List not empty');
         System.debug('********** created Date ******** '+ (Datetime) returnValue.get('createdDay') );
         String executionDate = CGMWSUtils_1_0.formatDate((Datetime) returnValue.get('createdDay'), 2);
         System.debug('******** executionDate '+executionDate);
         CGMWSUtils_1_0.sendEmailByInvioDEM(anomalies);
         AnomalieDocService.shedulableAnomalieBatch((List<Anomalie_Doc__c>) returnValue.get('anomalies')
                                                    ,(String) returnValue.get('namejob'),executionDate);
     }   */
       if(trigger.isAfter)
    {
         System.debug('******** isInsert trigger');
          AnomalieHandlerTriggerClass.AfterInsertAnomalieDoc(trigger.new);
        
    }
     
    
}