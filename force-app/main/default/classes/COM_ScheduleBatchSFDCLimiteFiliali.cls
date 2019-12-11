global class COM_ScheduleBatchSFDCLimiteFiliali implements Schedulable{
    global void execute(SchedulableContext SC){
        COM_BatchSFDCLimiteFiliali BatchIstance = new COM_BatchSFDCLimiteFiliali();
        Database.executeBatch( BatchIstance, 40 );    
    }
}