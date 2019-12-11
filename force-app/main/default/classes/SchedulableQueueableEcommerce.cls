public  class SchedulableQueueableEcommerce implements Queueable, Database.AllowsCallouts{
    
    public Set<Id> setIdcase;
	public String controlHours;
	public List<Case> listCaseToUpdate;

    public  SchedulableQueueableEcommerce(Set<Id> setIdcase, String controlHours){
		System.debug(' ************** getScheduleAnomalieDocId  SchedulableQueueableEcommerce'+ setIdcase);
		this.setIdcase = setIdcase;
		this.controlHours=controlHours;
	}
    public void execute(QueueableContext context) {
        switch on controlHours {
        when 'afterThirtyMinutes' {
                System.debug('************* afterThirtyMinutes ');
                AnomalieDocProductEcommerce.abbandonoPostCaricoOCSAfterThirtyMinutes(setIdcase);
                AnomalieDocProductEcommerce.executeSheduleTwoHours(setIdcase);
        }
        when 'afterTwoHours'{
                System.debug('************* afterTwoHours ');
                AnomalieDocProductEcommerce.abbandonoPostCaricoOCSAfterTwoHours(setIdcase);
        }
        
    }
}
}