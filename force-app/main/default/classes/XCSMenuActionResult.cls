public class XCSMenuActionResult {
    
    //CONSTANT
    public FINAL String CASEAPINAME = 'Case';
    public FINAL String VIEWACTION = 'view';
   	public FINAL String STANDARDPAGETYPE = 'standard__recordPage';
        
    
    
    // ATTRIBUTES FOR LIGHTNING COMPONENT, RECORD PAGE
    public class Attributes{
        @AuraEnabled private Boolean isOK {get; set;}
        @AuraEnabled private String errorMessage {get; set;}
        @AuraEnabled private String recordId {get; set;} 
        @AuraEnabled private String objectApiName {get; set;} 
        @AuraEnabled private String actionName {get; set;} 
        @AuraEnabled private String componentName {get; set;}
        //@AuraEnabled private DatiConvenzionamento datiConvenzionamento {get; set;} 
        
        // ==================== GETTER & SETTER ===========================
        public Boolean getIsOk(){return isOk;}
        public void setIsOk(Boolean isOk){this.isOk = isOK;}
        public String getErrorMessage(){return errorMessage;}
        public void setErrorMessage(String errorMessage){this.errorMessage = errorMessage;}
        public String getRecordId(){return recordId;}
        public void setRecordId(String recordId){this.recordId = recordId;}
        public String getObjectApiName(){return objectApiName;}
        public void setObjectApiName(String objectApiName){this.objectApiName = objectApiName;}
        public String getActionName(){return actionName;}
        public void setActionName(String actionName){this.actionName = actionName;}
        public String getComponentName(){return componentName;}
        public void setComponentName(String componentName){this.componentName = componentName;}
        //public DatiConvenzionamento getDatiConvenzionamento(){return datiConvenzionamento;}
        //public void setDatiConvenzionamento(DatiConvenzionamento datiConvenzionamento){this.datiConvenzionamento = datiConvenzionamento;}
    }

    /*public class DatiConvenzionamento {
        @AuraEnabled
		public String errorCode {get; set;}
		@AuraEnabled
		public String nuovoCaseId {get; set;}
		@AuraEnabled
		public Dossier__c dossier {get; set;}
		@AuraEnabled
		public String tipoChecklist {get; set;}
		@AuraEnabled
		public String dealerId {get; set;}
    }*/
    
    @AuraEnabled private String type {get; set;} 
    @AuraEnabled private Attributes attributes {get; set;}
    @AuraEnabled private Map<String,Object> state {get; set;}
    
    public XCSMenuActionResult(){
        this.attributes = new Attributes();
        this.attributes.setIsOK(true);
        this.state=new Map<String,Object>();
    }
    public XCSMenuActionResult(String type){
        this.attributes = new Attributes();
        this.attributes.setIsOK(true);
        this.type = type;
        this.state=new Map<String,Object>();
    }
	    
    public String getType(){return type;}
    public void setType(String type){this.type = type;}  
    public Attributes getAttributes(){return attributes;}
    public Map<String,Object> getState(){return state;}
    public void setState(Map<String,Object> state){this.state = state;}
}