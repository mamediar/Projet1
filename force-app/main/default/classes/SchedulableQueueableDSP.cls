//----------------------------------------------------------------------
//-- - Author       : SANA BADJI
//-- - Date         : 02/08/2019
//-- - Description  : Handle SchedulableQueueableDSP
//----------------------------------------------------------------------
public  class SchedulableQueueableDSP  implements Queueable, Database.AllowsCallouts{
    public Set<Id> setIdcase;
	public String controlHours;
	public List<Case> listCaseToUpdate;
	public String cronAfterFiveDays;

    public  SchedulableQueueableDSP(Set<Id> setIdcase, String controlHours,String cronAfterFiveDays){
		System.debug(' ************** getScheduleAnomalieDocId SchedulableQueueableDSP '+ setIdcase);
		this.setIdcase = setIdcase;
		this.controlHours=controlHours;
		this.cronAfterFiveDays=cronAfterFiveDays;
	}
    public void execute(QueueableContext context) {
        switch on controlHours {
			when 'afterThreeHours' {
				System.debug('************* afterThreeHours ');
				AnomalieDocProductDSP.checkAnoPPPartnersThreeHours(setIdcase);
			}
			when 'afterThirtyMinutes' {
				System.debug('************* afterThirtyMinutes ');
				AnomalieDocProductDSP.checkCodaSolContraPPPartnersAfterThirtyMinutes(setIdcase);
				AnomalieDocProductDSP.executeSheduleFiveDays(cronAfterFiveDays,setIdcase);
			}
			when 'afterFiveDays'{
				System.debug('************* afterFiveDays ');
				AnomalieDocProductDSP.checkCodaSolContraPPPartnersAfterFiveDays(setIdcase);
			}
			
		}
    }
}