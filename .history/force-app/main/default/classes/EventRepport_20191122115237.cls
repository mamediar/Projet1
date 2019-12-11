public with sharing class EventRepport {
    public Event data {get; set;} 
    public EventRepport() {
         //data = 
    }
    public PageReference  init(){
        System.PageReference pageRef = new System.PageReference('/apex/RiepilogoAppuntamento');
    
        pageRef.getHeaders().put('content-disposition', 'attachment; filename=AppuntamentoPDF.pdf');
     
        return pageRef;
    }
}
