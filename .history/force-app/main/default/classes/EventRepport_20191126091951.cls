public with sharing class EventRepport {
    public String PDFData {get; set;} 
    public String Title {get; set;} 
    public String mes {get; set;}
    public Map<String,String> ParamMessages {get; set;} 
    public Event data { get; set; } {data = (Event)JSON.deserialize(ApexPages.currentPage().getParameters().get('data'), Event.class);}
    public String message {get;set;} {message = ApexPages.currentPage().getParameters().get('message');}
    public String fotocopieAllegare {get;set;} {fotocopieAllegare = ApexPages.currentPage().getParameters().get('fotocopieAllegare');}
    
    public EventRepport() {
         PDFData = '';
         Title='Riepilogo Appuntamento';
    }
    
}
