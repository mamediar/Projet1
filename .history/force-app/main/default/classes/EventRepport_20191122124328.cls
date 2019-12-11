public with sharing class EventRepport {
    public String PDFData {get; set;} 
    public String Title {get; set;} 
    public String mes {get; set;}
    public Map<String,String> ParamMessages {get; set;} 

    public EventRepport() {
         PDFData = 'ok';
         Title='Riepilogo Appuntamento';
    }
    public PageReference  init(){
        System.PageReference pageRef = new System.PageReference('/apex/RiepilogoAppuntamento');
        ParamMessages =pageRef.getParameters();
        mes = ParamMessages.get('message');
        pageRef.getHeaders().put('content-disposition', 'attachment; filename=AppuntamentoPDF.pdf');
     
        return pageRef;
    }
}
