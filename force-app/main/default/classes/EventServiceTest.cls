/**
   *@author Mame Diarra    
   *@date 2019/08/14
   * @description test EventService Class
   */
@isTest
public class EventServiceTest {
    
	@TestSetup
    static void setup(){
        Date myDate = Date.newInstance(1960, 2, 17);
        Account acct= new Account(FirstName='mame', LastName='kane', Sesso__pc='F', Data_Nascita__c=myDate);
        insert acct;
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName()
                  .get('Branch').getRecordTypeId();
        Account acct2= new Account(Name='test', RecordTypeId = recordTypeId);
        insert acct2;
        
        Product2 product1= new Product2(Name='test');
        insert product1;
        
        String inpputString='2019-07-01T11:25:00.000Z';
        DateTime resultDateTime = DateTime.ValueofGmt(inpputString.replace('T', ' ')); 
        XCS_Town__c town = new XCS_Town__c(Provincia_Desc__c='dakar',Catastale__c='A003',Comune__c='dakar plateau');
        Event event= new Event(Telefono_Cellulare__c='0238323',Product__c=product1.Id,
                               Tipo_Occupazione__c='Autonomo',DurationInMinutes=30,
                              ActivityDateTime=resultDateTime);
        insert event;
    }
    
    @isTest
    public static void testGetEventsByDate(){
        Event event=[select Id,ActivityDate from Event limit 1];
        List<Event> events =EventService.getEventsByDate(event.ActivityDate);
    }
    
    @isTest
    public static void testCreateEvent(){
        Product2 product=[select Id from Product2 limit 1];
        String inpputString='2019-07-01T11:25:00.000Z';
        DateTime resultDateTime = DateTime.ValueofGmt(inpputString.replace('T', ' ')); 
        Event event= new Event(Telefono_Cellulare__c='0238323',Product__c=product.Id,
                               Tipo_Occupazione__c='Autonomo',DurationInMinutes=30,
                              ActivityDateTime=resultDateTime);
        Event newEvent =EventService.createNewEvent(event);
    }
    
    @isTest
    public static void testUpdateEvent(){
        Event event=[select Id,ActivityDate,Telefono_Cellulare__c from Event limit 1];
        event.Telefono_Cellulare__c='01585698';
        Event eventtoModif =EventService.updateEvent(event);
    }
    
    @isTest
    public static void testGetEventsByCliente(){
        Event event=[select Id,Customer__c,ActivityDate from Event limit 1];
        List<Event> events =EventService.getEventsByCliente(''+event.Customer__c,'');
    }
    //    public static List<Event> getEventsByDeskAndActivityDate(String idDesk, Date dateActivity, Datetime dateTimeActivity){
	@isTest
    public static void testGetEventsByDeskAndActivityDate(){
        Event event=[select Id,Customer__c,ActivityDate, ActivityDateTime from Event limit 1];
        List<Event> events =EventService.getEventsByDeskAndActivityDate('',event.ActivityDate, event.ActivityDateTime);
    }
}