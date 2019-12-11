global with sharing class CRMBatDailyDeleteIVR implements Database.AllowsCallouts, Database.Batchable<SObject>, Database.Stateful, Schedulable{

    global Integer count = 0;
   
    global Database.QueryLocator start(Database.BatchableContext bc){
        String query = 'SELECT Id FROM IVR_CTI_Collector__c WHERE Stato__c = \'2\'';
        return Database.getQueryLocator(query);
    }

    global void finish(Database.BatchableContext bc){
         System.debug('CRMBatDailyDeleteIVR finish DELETED '+count+' IVR_CTI_Collector__c');

//        CRMBatDailyDeleteIVR bDelete = new CRMBatDailyDeleteIVR();
        
//        String hour = String.valueOf(Datetime.now().hour());
//        String min = String.valueOf(Datetime.now().minute()+15);
//        String ss = String.valueOf(Datetime.now().second());

//		String nextTime = '0 0 0 1,16 * ?';    
        
//		String jobID = System.schedule('DeleteIVR', nextTime, bDelete);
    }
    
    global void execute(SchedulableContext sc) {
        CRMBatDailyDeleteIVR b = new CRMBatDailyDeleteIVR(); 
        Database.executebatch(b);
    }    

    global void execute(Database.BatchableContext bc,List<IVR_CTI_Collector__c> listCTICollectors) {
         System.debug('CRMBatDailyDeleteIVR executing');
         if (listCTICollectors!=null) {
            count = listCTICollectors.size();
            delete listCTICollectors;
         }
    }


}