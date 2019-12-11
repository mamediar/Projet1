global class COM_ScheduleBatchSFDCIntervisteFiliali implements Schedulable {
    global void execute(SchedulableContext SC) {
           COM_BatchSFDCIntervisteFiliali BatchIstance = new COM_BatchSFDCIntervisteFiliali();
           Database.executeBatch( BatchIstance, 40 );
    }
}