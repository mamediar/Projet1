public with sharing class EventRepport {
    public String PDFData {get; set;} 
    public String Title {get; set;} 
    public String mes {get; set;}
    public Event data { get; set; } {data = (Event)JSON.deserialize(ApexPages.currentPage().getParameters().get('data'), Event.class);}
    public String message {get;set;} {message = ApexPages.currentPage().getParameters().get('message');}
    public String fotocopieAllegare {get;set;} {fotocopieAllegare = ApexPages.currentPage().getParameters().get('fotocopieAllegare');}
    public Account filialeEvent {get;set;} {filialeEvent = (Account)JSON.deserialize(ApexPages.currentPage().getParameters().get('filialeEvent'),Account.class);}
    public Product2 DataglioProductValues {get;set;} {DataglioProductValues = (Product2)JSON.deserialize(ApexPages.currentPage().getParameters().get('DataglioProductValues'),Product2.class);}

    public EventRepport() {
         PDFData = '';
         Title='Riepilogo Appuntamento';
    }
    
}
