global class GD_SchBtchDealerIsvapCoursesSendAlert implements Schedulable{
    global void execute(SchedulableContext SC){
        GD_Batch_Dealer_Isvap_Courses_Send_Alert BatchIstance = new GD_Batch_Dealer_Isvap_Courses_Send_Alert();
        Database.executeBatch(BatchIstance, 40);    
    }
}