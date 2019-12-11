global class Schedulable_Di_Allineamento_Stato_OCS_Pr implements Schedulable {
    public String query;
    global Schedulable_Di_Allineamento_Stato_OCS_Pr() {
        System.debug('***************** running Schedulable_Di_Allineamento_Stato_OCS_Pr');
     query = 'SELECT Id, Status FROM Case WHERE Product__r.Family= \'PP_ONLINE_COMPASS_DS\'  AND Status!=\'Gestito\'';
    
    }

    global void execute(SchedulableContext ct){
        System.debug('***************** execute Schedulable_Di_Allineamento_Stato_OCS_Pr');
        Id idjob = Database.executeBatch(new Batch_Di_Allineamento_Stato_OCS_Pr_DS(query) );
    }
}