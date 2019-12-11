//----------------------------------------------------------------------
//-- - Author       : SANA BADJI
//-- - Date         : 10/06/2019
//-- - Description  : Handle AnomalieDocSchedulableDS
//----------------------------------------------------------------------
global  class SchedulableDS implements Schedulable {

	global Set<Id> setIdcase;
	global String controlHours;
	global List<Case> listCaseToUpdate;
	String cronAfterFiveDays;
/*
* Author: Sana BADJI
* Constructor with :
* @Param Set<Id> setIdcase
* @Param String controlHours
*/
	public  SchedulableDS(Set<Id> setIdcase, String controlHours,String cronAfterFiveDays){
		System.debug(' ************** getScheduleAnomalieDocId DS '+ setIdcase);
		this.setIdcase = setIdcase;
		this.controlHours=controlHours;
		this.cronAfterFiveDays=cronAfterFiveDays;
   
	}

   
/*
* Author: Sana BADJI
* Method  execute shedule :
* @Param SchedulableContext
*/
	global void execute(SchedulableContext ctx) {  
		System.enqueueJob(new SchedulableQueueableDS(setIdcase,controlHours,cronAfterFiveDays));
	}
}