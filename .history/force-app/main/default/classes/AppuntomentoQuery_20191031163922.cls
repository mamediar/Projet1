public  class AppuntomentoQuery {
   private static  String SELECT_FIELDS = 'StartTime__c ,EndTime__c, Desk__c' ;

   static  String fieldName;
   
   private static final String BASE_QUERY = 'SELECT ' + SELECT_FIELDS + ' FROM XCS_DeskItem__c WHERE '+ fieldName +'=true AND '  +'Desk__r.Branch__r.OCS_ExternalId__c ';
  /**
    *@Author Madicke BALDE
    *@description Get information about Filiale
    *@param codeFiliale
    *@return XCS_DeskItem__c
   */
  public static List<XCS_DeskItem__c> getFilialeInfornationByCodeFiliale(String codefiliale){
      List<XCS_DeskItem__c> items = new List<XCS_DeskItem__c>();
    //  XCS_DeskItem__c items = new XCS_DeskItem__c();
      try {
           items = [SELECT Id,  Desk__c, EndTime__c, 
                                Monday__c, Tuesday__c,
                                Wednesday__c, Thursday__c,
                                Friday__c,Saturday__c, StartTime__c,
                                Sunday__c FROM XCS_DeskItem__c WHERE  Desk__r.Branch__r.OCS_External_Id__c =: codefiliale ];
          
        } catch (Exception e) {
            System.debug(' ************ errorMessage '+e.getMessage());
            System.debug(' ************ errorMessage '+e.getStackTraceString() );
      }
      return items;
  }

  /*public static List<XCS_DeskItem__c> getFilialeInfornationByCodeFilialeDay(String codefiliale, String fieldName){
    List<XCS_DeskItem__c> items = new List<XCS_DeskItem__c>();
    try{
           items = [SELECT Id,  Desk__c, EndTime__c, 
                                Monday__c, Tuesday__c,
                                Wednesday__c, Thursday__c,
                                Friday__c,Saturday__c,
                                Sunday__c FROM XCS_DeskItem__c WHERE  Desk__r.Branch__r.OCS_External_Id__c =: codefiliale ];

    }
    catch(Exception e ){
      System.debug(' ********** errorMessage **** '+e.getMessage());
      System.debug(' ********** errorMessage **** '+e.getStackTraceString());
    }
    return items;
  } */

    /**
      * @Author Madicke BALDE
      * @description get appuntamento of client
      * @param codiceClient :
      * @return Liste Appuntamento
     */
    public static List<Event> appuntomentoCerca(String codiceFiscale){
        List<Event> listEvent = new List<Event>();
        try {
          System.debug(' ################ ruuning  appuntomentoCerca '+codiceFiscale);
          listEvent = [Select Id,Esito__c, Nome__c,Sesso__c, Stato_Azione__c, Prodotto__c, Product__r.Name,Tipo_Occupazione__c,Customer__c,
                     		Customer__r.LastName, Note__c, Telefono_Cellulare__c, Customer__r.Provincia_Nascita__pc, 
                     		Customer__r.Sesso__pc,Customer__r.Type,ActivityDate,ActivityDateTime,Customer__r.FirstName,
                     		Customer__r.PersonEmail,Customer__r.Phone,DurationInMinutes, Desk__c, Desk__r.Branch__r.Name,Desk__r.Branch__r.OCS_External_Id__c
                        FROM Event where Customer__r.Codice_Fiscale__c =: codiceFiscale];
                            
                            //AND Stato_Azione__c !='Non presentato/Annullato'
            
         } 
         catch (Exception e) {
            System.debug(' ************** cercaAppuntomento errorMessage '+e.getMessage());
            System.debug(' ************** cercaAppuntomento errorMessage '+e.getStackTraceString() ); 
        }
        System.debug(' ################ appuntomentoCerca '+listEvent);
        return listEvent;
    }
    /**---------------------------------------------------------------------
      *@Author Madicke BALDE
      *@description search Event by codice Ocs or Codice Fiscale
      *@param fields : set contains Ocs or Codice Fiscale
      *@return List<Event>
     *-----------------------------------------------------------------------------*/
    public static List<Event> appuntamentoCercaByOcsFiscale(Set<String> fields){
        List<Event> listEvent = new List<Event>();
        try {
          System.debug(' ################ ruuning  appuntomentoCerca '+fields);
         //  List<Event> ev = Database.query(req);
        //  System.debug(' ######################## appuntamentoCercaByOcsFiscale ev '+ev);
          String query =    'Select Id, Esito__c, Nome__c,Sesso__c,Customer__r.OtherService__pc, Stato_Azione__c, Prodotto__c, Product__r.Name,Tipo_Occupazione__c,Customer__c,\n'+
                        	 'Customer__r.LastName, Customer__r.Privacy_Profilazione__pc, Note__c, Telefono_Cellulare__c, Customer__r.Provincia_Nascita__pc,\n'+ 
                     	     'Customer__r.Sesso__pc, Customer__r.PersonContactId, Customer__r.Birthprovince__c ,Customer__r.Extcommoffer__pc,Customer__r.Type,ActivityDate,ActivityDateTime,Customer__r.FirstName,\n'+
                     	     'Customer__r.PersonEmail,Customer__r.Phone,Customer__r.Interncommoffer__pc, DurationInMinutes, Desk__c, Desk__r.Branch__r.Name,Desk__r.Branch__r.OCS_External_Id__c\n'+
                           'FROM Event WHERE Customer__r.Codice_Fiscale__c IN : fields OR Customer__r.Codice_Cliente__c  IN : fields ';
                       
         listEvent = Database.query(query);             
                            //AND Stato_Azione__c !='Non presentato/Annullato'
            
         } 
         catch (Exception e) {
            System.debug(' ************** cercaAppuntomento errorMessage '+e.getMessage());
            System.debug(' ************** cercaAppuntomento errorMessage '+e.getStackTraceString() ); 
        }
        System.debug(' ################ appuntomentoCerca '+listEvent);
        return listEvent;
    }
   /**
     * @Author Madicke BALDE
     * @description
     * @date
     * @param codiceFiscale
     * @return Event
    */
   public static Event appuntomentoCercaActive(String codiceFiscale){
       Event event = new Event();
       try {
          System.debug(' ****************appuntomentoCercaActive codiceFiscale '+ codiceFiscale);
        event  = [Select Id,Esito__c, OwnerId, Desk__r.Branch__c, Stato_Azione__c, Prodotto__c, Product__r.Name,Tipo_Occupazione__c,Customer__c,
                     		Customer__r.LastName, Note__c, Telefono_Cellulare__c, Customer__r.Provincia_Nascita__pc, 
                     		Customer__r.Sesso__pc,Customer__r.Type,ActivityDate,ActivityDateTime,Customer__r.FirstName,
                     		Customer__r.PersonEmail,Customer__r.Phone,DurationInMinutes
                        FROM Event where Type='Appuntamento' AND Customer__r.Codice_Fiscale__c =: codiceFiscale AND Stato_Azione__c !='Non presentato/Annullato' LIMIT 1];
            
         } catch (Exception e) {
             System.debug(' **************** errorMessage '+e.getMessage());
             System.debug(' **************** errorMessage '+e.getStackTraceString() );  
       }
       System.debug(' ############ event appuntomentoCercaActive '+event);
       return event;
   }

   /**
     *@Author Madicke BALDE
     *@description 
     *@date
     *@param codiceFiscale
     *@return Account With RecordType = Branch;
    */
   public static Account getFilialeByCodeFiliale(String codeFiliale){
     Account a  = new Account();
     try {
         a = [SELECT Id, Name,FirstName, LastName,
                         RecordTypeId, getCodice_Cliente__c,
                         OCS_External_Id__c, Partita_IVA__c,
                         (SELECT Id, Branch__r.OCS_External_Id__c  FROM XCS_Desk__r WHERE isActive__c=true )
                         FROM Account where recordtype.name = 'Branch'
                         AND OCS_External_Id__c = : codeFiliale];
       
     }  catch (Exception e) {
         System.debug(' **************** errorMessage '+e.getMessage());
         System.debug(' **************** errorMessage '+e.getStackTraceString() );
         AppuntamentoError.hasError = true;
         AppuntamentoError.errorMessage = 'Filiale Not Found with '+codeFiliale;
         AppuntamentoError.codeErreor = '[KO-FILIALE001]';
      //   AppuntomentoDisponibilitaWService.errorCode = '[KO-FILIALE001]';
        // AppuntamentoService.errorCode = '[KO-FILIALE001]';
       //  throw new CGMWSUtils_1_0.CGMWSRException('[KO-FILIALE001]');
     }
     return a;
   }

   /**
     *@Author Madicke BALDE
     *@Description
     *@date
     *@param idDesk : Id Desk
     *@param field
     *@return List XCS_DeskItem__c
    */
   public static List<XCS_DeskItem__c> getDeskItemByIdDesk(String codiceFiliale, List<String>  fields){
     List<XCS_DeskItem__c> listXCSDeskItems = new List<XCS_DeskItem__c>();
     try {
    
          String whereClause= '(' ;
          Integer compteur = 0;
          for(String field : fields){
          SELECT_FIELDS += ' ,'+field;
          whereClause += field +' = true';
          if(compteur < fields.size() - 1 ){
             whereClause += ' OR ';
          }
            compteur++;
          }
        String query = 'SELECT ' + SELECT_FIELDS + ' FROM XCS_DeskItem__c WHERE '+ whereClause +') AND '  +'Desk__r.Branch__r.OCS_External_Id__c =: codiceFiliale';
        System.debug('**************** query '+query);
        listXCSDeskItems = Database.query(query);
        System.debug('**************** items '+listXCSDeskItems);
       
     } catch (Exception e) {
       System.debug('***************** errorMessage '+e.getMessage());
       System.debug('****************  errorsMessage '+e.getStackTraceString());
     }
     return listXCSDeskItems;
   }

   public static List<XCS_DeskItem__c> getDeskByDates(List<XCS_Desk__c> desks, List<String> fields){
     List<XCS_DeskItem__c> listXCSDeskItems = new List<XCS_DeskItem__c>();
     System.debug('################# desks getDeskByDates '+desks);
     try {
          String whereClause= '(' ;
          Integer compteur = 0;
          for(String field : fields){
          SELECT_FIELDS += ' ,'+field;
          whereClause += field +' = true';
          if(compteur < fields.size() - 1 ){
             whereClause += ' OR ';
          }
            compteur++;
          }
        String query = 'SELECT ' + SELECT_FIELDS + ' FROM XCS_DeskItem__c WHERE '+ whereClause +') AND Desk__c IN : desks ' ;
        System.debug('**************** query '+query);
        listXCSDeskItems = Database.query(query);
        System.debug('**************** items '+listXCSDeskItems);
       
     } catch (Exception e) {
       System.debug('***************** errorMessage '+e.getMessage());
       System.debug('****************  errorsMessage '+e.getStackTraceString());
     }
     return listXCSDeskItems;
   }
   

   public static List<Event> getEventCodeFilialeDate(String codeFiliale, List<Date> dateList){
        List<Event> eventList = new List<Event>();
     try {
         if(dateList.size() > 0 ){
              eventList = [SELECT Id, ActivityDate, Desk__c, StartDateTime,
                                  EndDateTime, Type, IsAllDayEvent FROM Event WHERE ActivityDate IN : dateList 
                                  AND Desk__r.Branch__r.OCS_External_Id__c =: codeFiliale AND Customer__c = null];
         }
         else {
           eventList = null;
         }
       
     } catch (Exception e) {
           System.debug(' ############## errorMessage getEventCodeFilialeDate '+e.getMessage());
           System.debug(' ############## errorMessage getEventCodeFilialeDate '+e.getStackTraceString() );
     }
     return eventList;
   }

   /**
     *@Author Madicke BALDE
     *@Description
     *@date
     *@param dateList
     *@return List<Event>
    */
   public static List<Event> getEventByDate(List<Date> dateList){
     List<Event> eventList = new List<Event>();
     try {
         if(dateList.size() > 0 ){
              eventList = [SELECT Id, ActivityDate, Desk__c, StartDateTime, EndDateTime FROM Event WHERE ActivityDate IN : dateList ];
         }
         else {
           eventList = null;
         }
          
        
     } catch (Exception e) {
       System.debug('***************  errorMessage '+e.getMessage());
       System.debug('***************  errorMessage '+e.getStackTraceString() );
     }
     return eventList;
   }

   public static List<XCS_DeskItem__c> getXCSDeskItemByIdDesk(List<XCS_Desk__c> deskList){
     List<XCS_DeskItem__c> listxdeskItems = new List<XCS_DeskItem__c>();
     try {
         listxdeskItems = [SELECT Id, Desk__c, Desk__r.Id, StartTime__c,
                                  EndTime__c, Monday__c, Tuesday__c, 
                                  Wednesday__c, Thursday__c, Friday__c, 
                                  Saturday__c, Sunday__c FROM XCS_DeskItem__c WHERE Desk__c IN : deskList ];
       
     } catch (Exception e) {
       System.debug('*****************  e'+e.getMessage() );
       System.debug('****************** e '+e.getStackTraceString());
     }
     System.debug('******************* listxdeskItems '+listxdeskItems);
     return listxdeskItems;
   }
   /**------------------------------------------------------------------------------------
     *@Author Madicke BALDE
     *@description search Event by Date and Time
     *@param Date appuntamento
     *@param Datetime ora appuntamento
     *@return Event
    *-------------------------------------------------------------------------------------*/
   public static Event getEventByDate(Date d, Datetime t, Id deskId){
     System.debug('******************  running getEventByDate');
        System.debug('****** Date '+d);
        System.debug('****** Datetime '+t);
        System.debug('****** deskId '+deskId);
     Event event = new Event();
     try {
        event = [SELECT Id FROM Event WHERE ActivityDate =: d AND
                                            StartDateTime= :t AND Desk__c =: deskId ];
       
     } catch (Exception e) {
       System.debug(' ********* errorMessage '+e.getMessage());
       System.debug(' ********* errorMessage '+e.getStackTraceString() );
     }
     return event;
   }
  /**-------------------------------------------------------------------------------------
    *@Author Madicke BALDE
    *@description get Customer by codice Fiscale
    *@date 2019/08/27
    *@param codeFiscale : Codice Fiscale
    *@return Account
   *-------------------------------------------------------------------------------------*/
  public static Account getClientByCodeFiscale(String codeFiscale){
     Account customer = new Account();
     try {
       //  if(String.isNotBlank(codeFiscale)){
           customer = [SELECT Id, LastName, Codice_Fiscale__c FROM Account WHERE RecordType.name ='Person Account' AND 
                                                                       Codice_Fiscale__c =: codeFiscale];
       //  }
        return customer;
     } catch (Exception e) {
       System.debug('*********** errorMessage '+e.getMessage());
       System.debug('*********** errorMessage '+e.getStackTraceString() );
       AppuntamentoError.codeErreor = '[KO-ACC0000001]';
       AppuntamentoError.hasError = true;
       AppuntamentoService.errorCode = '[KO-ACC0000001]';
       throw new CGMWSUtils_1_0.CGMWSRException('[KO-ACC0000001]');

     }
   //  return customer;
   }
  
  /**-------------------------------------------------------------------------------------
    *@Author Madicke BALDE
    *@description get Event by Id
    *@param idEvent : Id Event
    *@return Event
    *@date 2019/08/26
   *--------------------------------------------------------------------------------------*/
  public static Event getEventById(String idEvent){
    System.debug(' ###################  getEventById running');
    Event ev = new Event();
    System.debug('*************  idEvent '+idEvent);
    try {
       ev = [Select Id,Esito__c, Nome__c,Sesso__c, Type,  Stato_Azione__c, Prodotto__c, Product__r.Name,Tipo_Occupazione__c,Customer__c,
                     		Customer__r.LastName, Note__c, Telefono_Cellulare__c, Customer__r.Provincia_Nascita__pc, 
                     		Customer__r.Sesso__pc,Customer__r.Type,ActivityDate,ActivityDateTime,Customer__r.FirstName,
                     		Customer__r.PersonEmail,Customer__r.Phone,DurationInMinutes, Desk__c, StartDateTime, EndDateTime FROM Event WHERE Id=: idEvent];
    } catch (Exception e) {
      AppuntamentoError.hasError = false;
      AppuntamentoError.errorMessage = 'Appuntamento Not Found With Id'+idEvent;
      System.debug(' *************** errorMessage '+e.getMessage());
      System.debug(' ************ errorMessage '+e.getStackTraceString());
      AppuntamentoError.codeErreor = '[KO-APP0001]';
      System.debug(' ################## AppuntamentoError.codeErreor getEventById '+AppuntamentoError.codeErreor);
      //throw new CGMWSUtils_1_0.CGMWSRException('[KO-APP0001]');

    }
    return ev;
  }
  
  public static   Account getPersonContactId(Id accountId){
    Account acc = new Account();
    try {
        acc = [SELECT Id, PersonContactId FROM Account WHERE Id =: accountId];
      
    } catch (Exception e) {
      System.debug(' ########## errorMessage '+e.getMessage());
      System.debug(' ########## errorMessage '+e.getStackTraceString() );
    }
    return acc;
  }
  /**--------------------------------------------------------------------------------------
    *@Author Madicke BALDE
    *@date 2019/09/03
    *@description check disponibilita Filiale 
    *@param codeFiliale : Code Filiale
    *@param appuntamentoDate : Date appuntamento
    *@return Event
   *--------------------------------------------------------------------------------------*/
 /* public static Event checkDisponibilitaFiliale(String codeFiliale, Date appuntamentoDate){
    Event ev = new Event();
   try {
          ev = [SELECT Id, ActivityDate, Type FROM Event WHERE  ActivityDate =: appuntamentoDate];
   } catch (Exception e) {
        System.debug(' ################## errorMessage '+e.getMessage());
        System.debug(' ################## errorMessage '+e.getStackTraceString() );
   }
   return ev;
  } */
 /**--------- -------------------------------------------------------------------------------
   *@Author Madicke BALDE
   *@date 2019/09/04
   *@description  search la disponibilita d'un Filiale pour une date données
   @param  deskList List Desk__c of a Filiale
   @param appuntamentoDate : Date appuntamento
   @return List<Event>
  *----------------------------------------------------------------------------------------*/
 public static List<Event> getEventByDeskDate(List<XCS_Desk__c> deskList, Date appuntamentoDate){
   System.debug( ' ########## getEventByDeskDate running  '+appuntamentoDate);
   List<Event> events = new List<Event>();
   try {
     if(deskList.size() > 0){
       events = [SELECT Id, ActivityDate, 
                        Type, StartDateTime,
                        EndDateTime, Desk__c,
                        Desk__r.Id,
                        Desk__r.Branch__r.OCS_External_Id__c
                        FROM Event
                        WHERE Desk__c IN : deskList AND 
                        ActivityDate =: appuntamentoDate AND
                        (Type='Appuntamento' OR (Type='Indisponibilità' AND IsAllDayEvent=false)) AND Customer__c = null];
     }
     
   } catch (Exception e) {
     System.debug(' ############## errorMessage '+e.getMessage());
     System.debug(' ############## errorMessage '+e.getStackTraceString() );
   }
   return events;
 }

 public static List<Event> getDeskIndisponibla(List<XCS_Desk__c> deskList, List<Date> appuntamentoDates){
   System.debug( ' ########## getDeskIndisponibla running  '+appuntamentoDates);
   List<Event> events = new List<Event>();
   try {
     if(deskList.size() > 0){
       events = [SELECT Id, ActivityDate, 
                        Type, StartDateTime,
                        EndDateTime, Desk__c,
                        Desk__r.Id,
                        Desk__r.Branch__r.OCS_External_Id__c
                        FROM Event
                        WHERE Desk__c IN : deskList AND  
                         ActivityDate IN : appuntamentoDates AND
                        (Type='Indisponibilità' OR Type='Festività')  AND Customer__c = null];
                       //  (Type='Indisponibilità' AND IsAllDayEvent=false)  AND Customer__c = null];
     }
     
   } catch (Exception e) {
     System.debug(' ############## errorMessage '+e.getMessage());
     System.debug(' ############## errorMessage '+e.getStackTraceString() );
   }
   return events;
 }

 public static List<Event> getDeskIndispo(Set<Id> deskList, List<Date> appuntamentoDates){
   System.debug( ' ########## getDeskIndisponibla running  '+appuntamentoDates);
   List<Event> events = new List<Event>();
   try {
     if(deskList.size() > 0){
       events = [SELECT Id, ActivityDate, 
                        Type, StartDateTime,
                        EndDateTime, Desk__c,
                        Desk__r.Id,
                        Desk__r.Branch__r.OCS_External_Id__c
                        FROM Event
                        WHERE Desk__c IN : deskList AND  
                         ActivityDate IN : appuntamentoDates AND
                        (Type='Indisponibilità' OR Type='Festività')  AND Customer__c = null];
                       //  (Type='Indisponibilità' AND IsAllDayEvent=false)  AND Customer__c = null];
     }
     
   } catch (Exception e) {
     System.debug(' ############## errorMessage '+e.getMessage());
     System.debug(' ############## errorMessage '+e.getStackTraceString() );
   }
   return events;
 }


 public static List<Event> getDeskByIds( Set<Id> idDesk, Date appuntamentoDate){
   List<Event> listEvent= new List<Event>();
   try {
     listEvent =[SELECT Id, Type,ActivityDateTime,ActivityDate, StartDateTime, EndDateTime, Desk__c FROM Event WHERE ActivityDate =: appuntamentoDate AND Type='Appuntamento' AND Desk__c IN : idDesk];

   } catch (Exception e) {
     System.debug(' ################ errorMessage '+e.getMessage());
     System.debug(' ################ errorMessage '+e.getStackTraceString() );
   }
   return listEvent;
 }
 
 /**------------------------------------------------------------------------------------
   *@Author Madicke BALDE
   *@Description search Event List for Filiale
   *@param codeFiliale 
   *@param appuntamentoDate
   *@return List<Event>
  *-------------------------------------------------------------------------------------*/
 public static List<Event> getSlotOccupatoQuery(String codeFiliale, Date appuntamentoDate){
      List<Event> events = new List<Event>();
      System.debug(' ################ getSlotOccupatoQuery codeFiliale '+codeFiliale);
       System.debug(' ################ getSlotOccupatoQuery Date '+appuntamentoDate);

   try {
        events = [SELECT Id, ActivityDate,
                          Desk__c, StartDateTime,
                          EndDateTime, Type FROM Event
                          WHERE ActivityDate =: appuntamentoDate 
                          AND Desk__r.Branch__r.OCS_External_Id__c =: codeFiliale
                          AND (Type='Appuntamento' AND Customer__c != null)   
                         ]; 
                         // AND Stato_Azione__c = 'Non presentato/Annullato'
                         //OR (Type='indisponibilita' AND Customer__c = null AND IsAllDayEvent = false)
     
   } catch (Exception e) {
     System.debug(' ############# errorMessage '+e.getMessage());
     System.debug(' ############# errorMessage '+e.getStackTraceString() );
   }
   return events;
 }

 /**--------------------------------------------------------------------------------------
   *@Author Madicke BALDE
   *@description get Customer by Codice Cliente Or Codice Fiscale
   *@param fields
   *@return Account
  *----------------------------------------------------------------------------------------*/
 public static Account getCustomer(Set<String> fields){
 
    Account acc = new Account();

    try {
      System.debug(' ################### fields '+ fields);
      //RecordType.Name = \'PersonAccount\' AND (
      String query = 'SELECT Id, LastName FROM Account WHERE ( Codice_Fiscale__c IN : fields OR Codice_Cliente__c IN : fields ) AND RecordType.name= \'Person Account\' ';
      System.debug(' ############ query '+query);
      acc = Database.query(query);
      
    } catch (Exception e) {
      AppuntamentoError.hasError = true;
      AppuntamentoError.errorMessage = 'No Customer Found ';
      System.debug(' ##################### errorMessage '+e.getMessage());
      System.debug(' ##################### errorMessage '+e.getStackTraceString() );
    }
    return acc;
 } 

 public static Calendar getCalendar(String codiceFiliale){
    Calendar calendar = new Calendar();
    try {
        calendar = [select Id, Name from Calendar where  Name =: codiceFiliale AND IsActive=true];
        System.debug('calendar '+calendar);
    } catch (Exception e) {
            System.debug('errorMessage CreaAppuntamentoController getCalendar '+e.getMessage());
    }
    return calendar;
 }

    public static Calendar getCalendarAppuntamento(String codiceFiliale, String typecalendar){
    Calendar calendar = new Calendar();
    try {
        calendar = [select Id, Name from Calendar where  Name =: codiceFiliale and Type=:typecalendar and IsActive=true];
        System.debug('calendar '+calendar);
    } catch (Exception e) {
            System.debug('errorMessage CreaAppuntamentoController getCalendar '+e.getMessage());
    }
    return calendar;
 }
    
    
public static EventRelation getEventRelationAppuntamento(String nameRelation){
    EventRelation eventRel = new EventRelation();
    try {
        eventRel = [select Id, RelationId, EventId from EventRelation where  Relation.Name=:nameRelation];
        System.debug('eventRel '+eventRel);
    } catch (Exception e) {
            System.debug('errorMessage CreaAppuntamentoController getEventRelationAppuntamento '+e.getMessage());
    }
    return eventRel;
 }
 public static List<Event> getOccupatoSlotFiliale(String codeFiliale, List<Date> appuntamentoDateList){
  List<Event> events = new List<Event>();
      System.debug(' ################ getSlotOccupatoQuery codeFiliale '+codeFiliale);
   try {
        events = [SELECT Id, ActivityDate,
                          Desk__c, StartDateTime,
                          EndDateTime, Type FROM Event
                          WHERE ActivityDate IN : appuntamentoDateList 
                          AND Desk__r.Branch__r.OCS_External_Id__c =: codeFiliale
                          AND (Type='Appuntamento' AND Customer__c != null)   
                         ]; 
                         // AND Stato_Azione__c = 'Non presentato/Annullato'
                         //OR (Type='indisponibilita' AND Customer__c = null AND IsAllDayEvent = false)
     
   } catch (Exception e) {
     System.debug(' ############# errorMessage '+e.getMessage());
     System.debug(' ############# errorMessage '+e.getStackTraceString() );
   }
   return events;
 }
  
    public static  Boolean chekDisponibleDeskByFiliale(String filialeName){
        Account filiale = [SELECT Id,Name,(select id FROM XCS_Desk__r where isActive__c=true) FROM Account WHERE RecordType.Name='Branch'
                                AND Name=:filialeName limit 1];
        try{
			List<XCS_Desk__c> desksFilialesActive =filiale.XCS_Desk__r;
            if(desksFilialesActive.size()>0){
              //check disponible desk
            }else {
                return false;
            }
        } catch (Exception e) {
            System.debug('errorMessage AppuntamentoQuery chekDisponibleDeskByFiliale'+e.getMessage());
        }
        return false;
    }
  
}