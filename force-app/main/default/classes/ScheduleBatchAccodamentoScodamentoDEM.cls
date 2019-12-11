global class ScheduleBatchAccodamentoScodamentoDEM implements Schedulable {
    global void execute(SchedulableContext ctx) {
         Id idjob =  Database.executeBatch(new batchAccodamentoScodamentoDEM() );
    }
}