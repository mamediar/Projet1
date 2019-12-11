public abstract class XCSDispositionAction 
{
	private sObject obj;
    private XCS_Disposition__c disposition;
    
    public SObject getSObject(){return obj;}
    public void setSObject(SObject obj){this.obj = obj;}
    public XCS_Disposition__c getDisposition(){return disposition;}
    public void setDisposition(XCS_Disposition__c disposition){this.disposition = disposition;}
    
    public virtual XCSDispositionResult execute(){return null;}
}