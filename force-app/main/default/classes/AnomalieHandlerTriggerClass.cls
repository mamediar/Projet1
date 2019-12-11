/* Autheur : Sana Badji 
   @date  16/05/2019
 */

public with sharing class AnomalieHandlerTriggerClass {
    public Static boolean Compute = true;
       /**
       * @author Madicke BALDE
       *@description methode execute after insert
       *@param Anomalies List
       */
       public static void AfterInsertAnomalieDoc(List<Anomalie_Doc__c> list_anomalies){
        if(compute)
        {
             System.debug('############################## list anomalie '+list_anomalies);
             Case c = [SELECT Id,Is_Discordanza_Cellulare__c FROM Case WHERE Id =: list_anomalies[0].CaseId__c ];
             System.debug('####################################### in trigger c.Is_Discordanza_Cellulare__c '+c.Is_Discordanza_Cellulare__c);
            if(!c.Is_Discordanza_Cellulare__c){
                 return;
            }
             String name ='ScheduleBatchAnomalieDoc'+ String.valueOfGmt(list_anomalies[0].CreatedDate);
            
            //***** retrieve CreatedDate for Anomalie_Doc__c
            Datetime createdDate = list_anomalies[0].CreatedDate;

            XCS_CompassParameters__c cp =  XCS_CompassParameters__c.getValues('Number_of_hours');
            System.debug('####################### cp '+cp);
            String executionDate = CGMWSUtils_1_0.formatDate( createdDate , (Integer) cp.Number_of_hours__c);
            System.debug('*********** test ******** '+executionDate);
           
            System.debug('*********** test 2 ******** ');
            //**** schedulable the batch
             AnomalieDocService.shedulableAnomalieBatch(list_anomalies, name, executionDate);
        
    
        }

       }
}