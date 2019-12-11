public with sharing class EventRepport {
    public EventRepport() {

    }
    public void init(){
        System.PageReference pageRef = new System.PageReference('/apex/RiepilogoAppuntamento');
    
        pageRef.getHeaders().put('content-disposition', 'attachment; filename=AppuntamentoPDF.pdf');
     
        return pageRef;
    }
}
