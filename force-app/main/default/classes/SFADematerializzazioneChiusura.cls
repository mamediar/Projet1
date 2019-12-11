global class SFADematerializzazioneChiusura implements Database.AllowsCallouts,  Database.Batchable<SObject>, Database.Stateful, Schedulable {


    global Integer countProcessed = 0;

    // è presente anche un batch giornaliero che chiude in automatico tutte le attività che hanno ricevuto l’esito da OCS da più di 5gg
    global Database.QueryLocator  start(Database.BatchableContext bc){
        Date date5 = date.today().adddays(-5);     
        String sDate5 = String.valueof(date5);    
        String query = 'SELECT ID, Status, Data_Ricezione__c FROM Case  WHERE Status = \'New\' AND Data_Ricezione__c != null AND Data_Ricezione__c < '+sDate5+' AND Categoria_Riferimento__c = \''+SFADematerializzazioneHelper.categoriaDematerializzazione.id+'\'';
          System.debug('SFADematerializzazioneChiusura start query:'+query);
        return Database.getQueryLocator(query);
    }


   global void finish(Database.BatchableContext bc){
         System.debug('SFADematerializzazioneChiusura finish');
         System.debug('Records processed:'+countProcessed);
   }


    global void execute(SchedulableContext sc) {
        SFADematerializzazioneChiusura b = new SFADematerializzazioneChiusura(); 
        Database.executebatch(b);
    }     

    global void execute(Database.BatchableContext bc,List<Case> listDematerializzazione) {
        System.debug('SFADematerializzazioneChiusura executing');
        if (listDematerializzazione!=null) {
            for (case dem:listDematerializzazione) {
                dem.Status = 'Closed';
                countProcessed++;
            }
        }
        update listDematerializzazione;
     }   
}