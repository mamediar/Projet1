//----------------------------------------------------------------------
//-- - Author       : SANA BADJI
//-- - Date         : 02/08/2019
//-- - Description  : Handle SchedulableQueueableDS
//----------------------------------------------------------------------
public  class SchedulableQueueableDS implements Queueable, Database.AllowsCallouts {
    public Set<Id> setIdcase;
	public String controlHours;
	public List<Case> listCaseToUpdate;
	public String cronAfterFiveDays;

    public  SchedulableQueueableDS(Set<Id> setIdcase, String controlHours,String cronAfterFiveDays){
		System.debug(' ************** getScheduleAnomalieDocId SchedulableQueueableDS DS '+ setIdcase);
		this.setIdcase = setIdcase;
		this.controlHours=controlHours;
		this.cronAfterFiveDays=cronAfterFiveDays;
	}
    public void execute(QueueableContext context) {
         switch on controlHours {
			when 'afterThreeHours' {
				System.debug('************* afterThreeHours ');
				AnomalieDocProductDS.checkAnoPreSicPPAfterThreeHours(setIdcase);
				AnomalieDocProductDS.checkAnoPostSicPPAfterThreeHours(setIdcase);
			}
			when 'afterThirtyMinutes' {
				System.debug('************* afterThirtyMinutes ');
				AnomalieDocProductDS.checkCodaSolContrattoAfterThirtyMinutes(setIdcase);
				AnomalieDocProductDS.executeSheduleFiveDays(cronAfterFiveDays,setIdcase);
			}
		
			when 'afterFiveDays'{
				AnomalieDocProductDS.checkCodaSolContrattoAfterFiveDays(setIdcase);
			}
			
		}

    }
}