global class ScheduleBatchAnomalieDoc implements Schedulable {
     global Set<Id> setId;
     public  ScheduleBatchAnomalieDoc(Set<Id> setId){
         System.debug(' ************** ScheduleBatchAnomalieDoc '+ setId);
         this.setId = setId;
     }
    global void execute(SchedulableContext ctx ){
      Id idjob =  Database.executeBatch(new Check_Anomalie_Existe_Batch(setId) );

    }
}