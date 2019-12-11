/**
    *@author Mame Diarra    
    *@date 2019/07/05
    *@description web service Appuntamento
    */
   
    public with sharing class EventService {
     /*
    * @description get list Event by date appuntamento
    * @param dateAppuntamento : Date appuntamento
    * @return  the Event[]
    */
    public static List<Event> getEventsByDate(date dateAppuntamento){
        date dateNow=date.today();
        List<Event> event= new List<Event>();
        try{
            event = [Select Id,Esito__c,Desk__r.Branch__c,,Desk__r.Branch__r.Name, Stato_Azione__c, Prodotto__c, Product__r.Name,Product__r.RSS_External_Id__c,Product__r.Parent__c, Product__r.Parent__r.RSS_External_Id__c, Tipo_Occupazione__c,Customer__c,
                     		Customer__r.LastName, Note__c, Telefono_Cellulare__c, Customer__r.Provincia_Nascita__pc, Type,
                     		Customer__r.Sesso__pc,Customer__r.Type,ActivityDate,ActivityDateTime,Customer__r.FirstName,
                     		Customer__r.PersonEmail,Customer__r.Phone,DurationInMinutes,Customer__r.Codice_Fiscale__c
                                    FROM Event where ActivityDate =: dateAppuntamento  
                                    AND Customer__c!=null
                                     AND Stato_Azione__c !='Non presentato/Annullato'];
        }
        catch(Exception e){
                System.debug('errorMessage getEventsByDate '+ e.getMessage() );
        }
        return event;
    }

    public static Event createNewEvent(Event newEvent){
        
        try {
                insert newEvent;
            
        } catch (Exception e) {
            System.debug('Error insert ');
            return null;
        }
        return newEvent;
    }

    public static Event updateEvent(Event newEvent){
        try {
            update newEvent;
            System.debug('##################### update Event ##################""');
        } catch (Exception e) {
            System.debug('****************  errorMessage '+e.getMessage());
             System.debug('****************  errorMessage '+e.getStackTraceString() );
           System.debug('Error update');
        }
        return newEvent;
    }
   
    /**
    *@author Mame Diarra    
    *@date 2019/08/06
    * @description get list Event by cliente
    * @param idCliente : Id Client
    * @return  the Event[]
    */
    public static List<Event> getEventsByCliente(String cfCliente, String personalEmail){
        date dateNow=date.today();
        List<Event> event= new List<Event>();
        try{
            event = [Select Id,Esito__c, Stato_Azione__c, Prodotto__c, Product__r.Name,Tipo_Occupazione__c,Customer__c, Type,
                     		Customer__r.LastName, Note__c, Telefono_Cellulare__c, Customer__r.Provincia_Nascita__pc, 
                     		Customer__r.Sesso__pc,Customer__r.Type,ActivityDate,ActivityDateTime,Customer__r.FirstName,
                     		Customer__r.PersonEmail,Customer__r.Phone,DurationInMinutes,Customer__r.Codice_Fiscale__c
                                    FROM Event where (Customer__r.Codice_Fiscale__c =: cfCliente or Customer__r.PersonEmail =: personalEmail)
                     					AND ActivityDate >:dateNow
                                        AND Customer__c!=null
                    					AND Stato_Azione__c !='Non presentato/Annullato'];
        }
        catch(Exception e){
                System.debug('errorMessage getEventsByCliente'+ e.getMessage() );
        }
        return event;
    }

	/**
    * @author Mame Diarra    
    * @date 2019/08/21
    * @description get list Event by desk and date activity
    * @param idDesk : Id xcs desk
    * @param dateActivity : activity date
    * @param dateTimeActivity : activity dateTime
    * @return  the Event[]
    */
    public static List<Event> getEventsByDeskAndActivityDate(String idDesk, Date dateActivity, Datetime dateTimeActivity){
        date dateNow=date.today();
        List<Event> event= new List<Event>();
        try{
            event = [Select Id,Esito__c, Stato_Azione__c, Prodotto__c, Product__r.Name,Tipo_Occupazione__c,Customer__c, Type,
                     		Customer__r.LastName, Note__c, Telefono_Cellulare__c, Customer__r.Provincia_Nascita__pc, 
                     		Customer__r.Sesso__pc,Customer__r.Type,ActivityDate,ActivityDateTime,Customer__r.FirstName,
                     		Customer__r.PersonEmail,Customer__r.Phone,DurationInMinutes
                                    FROM Event where Desk__c =: idDesk
                     					 AND ActivityDate =: dateActivity
                     					 AND ActivityDateTime !=: dateTimeActivity
                    					 AND Stato_Azione__c !='Non presentato/Annullato'];
        }
        catch(Exception e){
                System.debug('errorMessage getEventsByCliente'+ e.getMessage() );
        }
        return event;
    }
        
}