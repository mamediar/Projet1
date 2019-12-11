//----------------------------------------------------------------------
//-- - Author       : SANA BADJI
//-- - Date         : 10/06/2019
//-- - Description  : Handle AnomalieDocSchedulableDSP
//----------------------------------------------------------------------

global  class SchedulableDSP implements Schedulable {

	global Set<Id> setIdcase;
	global String controlHours;
	String cronAfterFiveDays;

	public  SchedulableDSP(Set<Id> setIdcase , String controlHours,String cronAfterFiveDays){
		System.debug(' ************** getScheduleAnomalieDocId DSP '+ setIdcase);
	// System.debug(' ************** List<Case> cases '+ cases);
		this.setIdcase = setIdcase;
		this.controlHours= controlHours;
		this.cronAfterFiveDays=cronAfterFiveDays;
	}

/*
* Author: Sana BADJI
* Method  execute shedule :
* @Param SchedulableContext
*/
global void execute(SchedulableContext ctx) { 
System.enqueueJob(new SchedulableQueueableDSP(setIdcase,controlHours,cronAfterFiveDays));
}

}