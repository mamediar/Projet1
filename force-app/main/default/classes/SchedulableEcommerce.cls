global class SchedulableEcommerce implements Schedulable {

     global Set<Id> setIdcase;
     List<Case> cases;
     public  String controlHours;
     global RecuperaStatiAttributiPrtRequest  recuperaRequest;
     public  SchedulableEcommerce(Set<Id> setIdcase, String controlHours){
         System.debug(' ************** getScheduleAnomalieDocId Ecom '+ setIdcase);
        // System.debug(' ************** List<Case> cases '+ cases);
         this.setIdcase = setIdcase;
         this.controlHours=controlHours;
      //  this.cases= cases;
     }

/*
* Author: Sana BADJI
* Method  execute shedule :
* @Param SchedulableContext
*/
     global void execute(SchedulableContext ctx) {
          System.enqueueJob(new SchedulableQueueableEcommerce(setIdcase,controlHours));
    }
    
}