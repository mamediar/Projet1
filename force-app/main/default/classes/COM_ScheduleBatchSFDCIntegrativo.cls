/**
    * @description: 
    * @date::28/06/2019
    * @author:Aminata GUEYE
    * @modification: NONE
    */
global class COM_ScheduleBatchSFDCIntegrativo implements Schedulable{

    global void execute(SchedulableContext sc) {
        COM_BatchSFDCIntervisteIntegrativo batchIstance = new COM_BatchSFDCIntervisteIntegrativo();
        Database.executeBatch( batchIstance, 200 ); 
    }
}