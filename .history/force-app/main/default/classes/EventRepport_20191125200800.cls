public with sharing class EventRepport {
    public String PDFData {get; set;} 
    public String Title {get; set;} 
    public String mes {get; set;}
    public Map<String,String> ParamMessages {get; set;} 

    public EventRepport() {
         PDFData = '';
         Title='Riepilogo Appuntamento';
    }
    public PageReference  init(){
        Blob body;
        System.PageReference pageRef = new System.PageReference('/apex/RiepilogoAppuntamento');

        body = pageRef.getContent();

        System.debug('pageRef '+pageRef);
        //ParamMessages =pageRef.getParameters();
        System.debug('ParamMessages '+body);
        //mes = ParamMessages.get('message');
        pageRef.getHeaders().put('content-disposition', 'attachment; filename=AppuntamentoPDF.pdf');
     
        return pageRef;
    }
}
