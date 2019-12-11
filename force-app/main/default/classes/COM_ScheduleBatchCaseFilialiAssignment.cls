global class COM_ScheduleBatchCaseFilialiAssignment implements Schedulable{
    global void execute(SchedulableContext SC){
        COM_BatchCaseFilialiAssignment BatchIstance = new COM_BatchCaseFilialiAssignment();
        Database.executeBatch( BatchIstance, 40 );    
    }
}