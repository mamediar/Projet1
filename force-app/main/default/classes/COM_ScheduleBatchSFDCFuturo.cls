/**
    * @description: 
    * @date::28/06/2019
    * @author:Aminata GUEYE
    * @modification: NONE
    */
global class COM_ScheduleBatchSFDCFuturo implements Schedulable {
    global void execute(SchedulableContext SC) {

         COM_BatchSFDCFuturo BatchIstance = new COM_BatchSFDCFuturo();
         Database.executeBatch( BatchIstance, 40 );
    }
}