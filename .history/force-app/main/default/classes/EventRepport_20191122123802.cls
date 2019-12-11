public with sharing class EventRepport {
    public String PDFData {get; set;} 
    public String Title {get; set;} 
    public String message {get; set;} 
    public EventRepport() {
         PDFData = 'ok';
         Title='Riepilogo Appuntamento';
    }
    public PageReference  init(){
        System.PageReference pageRef = new System.PageReference('/apex/RiepilogoAppuntamento');
        message =pageRef.getParameters('messgage');
        pageRef.getHeaders().put('content-disposition', 'attachment; filename=AppuntamentoPDF.pdf');
     
        return pageRef;
    }
}
