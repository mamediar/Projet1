public class EventVsfController {
	 public Event data { get; set; } {data = (Event)JSON.deserialize(ApexPages.currentPage().getParameters().get('data'), Event.class);}
     public String message {get;set;} {message = ApexPages.currentPage().getParameters().get('message');}
}