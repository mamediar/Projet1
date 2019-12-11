/**
  * @Author Madicke BALDE
  * @description 
  * @File name : EventDomaine.cls
  * @date 2019/08/05
  * @
 */

public  class EventDomaine {
   static final Map<Id, List<XCS_DeskItem__c>> mapData = new Map<Id, List<XCS_DeskItem__c>>();

   /**
     * @Author Madicke BALDE
     * @description get  Active Event  list for a client
     * @param idClient : Id Account
     * @param List<Event> 
    */
   public static List<Event> getEventActiveByCLientId(String idClient){
       List<Event> eventList = new List<Event>();
        try {
            eventList = [Select Id,Esito__c, Stato_Azione__c, Prodotto__c, Product__r.Name,Tipo_Occupazione__c,Customer__c,
                     		Customer__r.LastName, Note__c, Telefono_Cellulare__c, Customer__r.Provincia_Nascita__pc, 
                     		Customer__r.Sesso__pc,Customer__r.Type,ActivityDate,ActivityDateTime,Customer__r.FirstName,
                     		Customer__r.PersonEmail,Customer__r.Phone,DurationInMinutes
                            FROM Event where Account.Id =: idClient AND Stato_Azione__c !='Non presentato/Annullato'];
           } 
           catch (Exception e) {
            System.debug(' ****************** errorMessage '+e.getMessage());
            System.debug(' ****************** errorMessage '+e.getStackTraceString());
        }
        return eventList;
   }
   /**
     * @Author Madicke BALDE
     * @Description
     * @date
     * @param day
     * @param deskId
     * @return Boolean
    */
   /*public static Map<String,Object> isWorkingDay(String day, XCS_DeskItem__c xcsDeskItem){
       Map<String, Object> returnValue = new Map<String, Object>();
       returnValue.put('error',false);
       Boolean isWorkDay = false;
     //  Id idDesk = deskId;
       String query;
       try {
              switch on day {
           when  'Monday' {
            
                isWorkDay =  getBooleanFieldValue (xcsDeskItem ,'Monday__c');

           }
           when 'Tuesday' {
               
                isWorkDay =  getBooleanFieldValue( xcsDeskItem,'Tuesday__c');
           }
            when 'Wednesday' {
              
                isWorkDay =  getBooleanFieldValue(xcsDeskItem ,'Wednesday__c');
           }
           
            when 'Thursday' {
               
                isWorkDay =  getBooleanFieldValue(xcsDeskItem ,'Wednesday__c');
           }
            when 'Friday' {
          
                
                 isWorkDay =  getBooleanFieldValue(xcsDeskItem ,'Friday__c');
           }
            when 'Saturday' {
                // query = 'SELECT Saturday__c FROM  XCS_DeskItem__c WHERE Desk__c = :idDesk';
              //   XCS_DeskItem__c xcsDeskItem = Database.query(query);
               //  isWorkDay =  getBooleanFieldValue(xcsDeskItem, 'Saturday__c');
           }
            when else {
              
                 isWorkDay = getBooleanFieldValue(xcsDeskItem , 'Sunday__c');
           }
       }

           
          } catch (Exception e) {
            returnValue.put('error',true);
           System.debug('************ errorMessage '+e.getMessage());
         }
            returnValue.put('isWorkDay',isWorkDay);

            return returnValue;
   } */

 /*  public static Boolean getBooleanFieldValue(XCS_DeskItem__c xcs, String fieldName){
       return (Boolean) xcs.get(fieldName);      
   } */

   /**--------------------------------------------------------------------------------------------
     * @Auhtor Madicke BALDE
     * @description
     * @date
     * @param  Event
     * @param codeFiliale
     * @Map<String,Object>
    *-----------------------------------------------------------------------------------------------*/
   public static void appuntamentaCerca(Event event, String codFiliale, Map<String,Object> mapValue){
       mapValue.put('isOk', false);

     try {
           if(PermissionUtils.isBranch(event.OwnerId) && isSameFiliale(event.Desk__r.Branch__c, codFiliale)){
                //update
                mapValue.put('isOk', true);
                System.debug('********************* isSameFiliale');
            }
            else if (PermissionUtils.isBranch(event.OwnerId) && !isSameFiliale(event.Desk__r.Branch__c, codFiliale)) {
                    AppuntamentoError.hasError = true;
                    System.debug('********************* not isSameFiliale');
                    String dateformat ='dd/MM/yyyy';
                  //  String dateString = CGMWSUtils_1_0.ToString(event.ActivityDate);
                    String dateString = formatingDateString(event.ActivityDate);
                    Datetime dt = event.ActivityDateTime;
                  //  String timeString = CGMWSUtils_1_0.ToString(dt.time());
                    String timeString = formatingTime(dt);
                    String errorMessage = 'the customer already has an appointment on '+dateString+ ' at '+timeString+ 'at the file of the NAMEFILIAL';
                    System.debug(' ******** errorMessage '+errorMessage);
                     AppuntamentoError.errorMessage = errorMessage;
                   // mapValue.put('isOk', false);
                    mapValue.put('errorMessage', errorMessage);
                    System.debug('the customer already has an appointment on xx / xx / xxxx at xx: xx at the file of the NAMEFILIAL');
                  }
            else {
                  mapValue.put('isOk', true);
                   //Update Event
            }
       
        } catch (Exception e) {
          System.debug(' ********* errorMessage '+e.getMessage());
          System.debug(' ********* errorMessage '+e.getStackTraceString() );
     }
   }

 /**
   * @Author Madicke BALDE
   * @description
   * @param idFilialeFount : id Filiale
   * @param codeFilialeNewAppuntamento : Code Filiale
  */
  public static Boolean isSameFiliale(Id idFilialeFound, String codeFilialeNewAppuntamento){
        Boolean isTheSame = false;
       try {
           Account a = AppuntomentoQuery.getFilialeByCodeFiliale(codeFilialeNewAppuntamento);
           if(idFilialeFound.equals(a.Id)){
               isTheSame = true;
           }
          
           
         } catch (Exception e) {
           System.debug(' ****************** errorMessage '+e.getMessage());
           System.debug('************* errorMessage '+e.getStackTraceString());
          }
        return isTheSame;
  }

  
  
  /**
    *@Author Madicke BALDE
    *@description
    *@Date
    *@param
    *@return
   */
  public static Map<String, Object> appuntomentoDisponibilitaCompleta(String codeFiliale, String appuntamentoDate){
    Set<Time> slotList = new Set<Time>();
    Map<String, Object> mapReturnValue = new Map<String, Object>();
    mapReturnValue.put('isAvalable', true);
    try {
      String dayOfWeek = CGMWSUtils_1_0.getDayOfWeek(appuntamentoDate);
      System.debug('************ dayOfWeek '+dayOfWeek);
      Account filiale = AppuntomentoQuery.getFilialeByCodeFiliale(codeFiliale);
      List<XCS_Desk__c> deskList = filiale.XCS_Desk__r;
      Map<Id, Object> returnValue = maxAppuntamentoByDeskForDay(deskList, dayOfWeek);   
      System.debug('********** returnValue '+ returnValue);  
      //Slots_N_Appuntamento
     if(returnValue != null && returnValue.values().size() > 0){
         List<Slots_N_Appuntamento> sl = (List<Slots_N_Appuntamento>) returnValue.values();
        for(Slots_N_Appuntamento s: sl){
          for (Slot st : s.slots) {
              slotList.add(st.startTime);
              slotList.add(st.endTime);
          }
       }
       mapReturnValue.put('slots',slotList);
       mapReturnValue.put('deskMap', returnValue);
     }
     else{
         mapReturnValue.put('isAvalable', false);
         mapReturnValue.put('errorMessage', 'Branch not avalable at '+appuntamentoDate);
     }
     } catch (Exception e) {
        System.debug(' ********** errorcode appuntomentoDisponibilitaCompleta'+ AppuntomentoDisponibilitaWService.errorCode);
      System.debug('********************** errorMessage '+e.getMessage());
      System.debug('********************** errorMessage '+e.getStackTraceString() );
      
    }
    return mapReturnValue;
  }
  
  
 
  
  /**
    *@Author Madicke BALDE
    *@description
    *@date
    *@param
   */
  public static String formatingDateString(Datetime dt){
    String formatString = 'dd/MM/yyyy';
    String dateString = dt.format(formatString);
    return dateString;
  }
  /**
    *@Author Madicke BALDE
    *@date
    *@description
    *@param
    *@return
   */
   public static String formatingTime(Datetime dt){
     String formatString = 'dd/MM/yyyy HH:mm:ss';
     String datetimeFormat = dt.format(formatString);
     return datetimeFormat.substringAfter(' ');
   }
   
   public static String appuntamentoOccupazionniFiliale(String dateIni, String dateEnd, String codeFiliale){
         String resp ;
     try {
            List<Date> listData = new List<Date>(); 
            Map<String, Object> objectMap = new Map<String, Object>();
            List<String> dateLists = new List<String>();

            Map<String,Date> mapDataString = getListDateString(dateIni, dateEnd);
            for(String key : mapDataString.keySet()){
                   dateLists.add(key);
            }
            
    Map<Date, Integer> returnValue = maxNumberAppuntamentoByDay(codeFiliale, dateLists, mapDataString);
    for(Date key : returnValue.keySet()){
       if(returnValue.get(key) == 0 ){
         String chaine = DateToString(key);
         objectMap.put(chaine, 0); 
         returnValue.remove(key);
       }
       else {
         listData.add(key);
       }
     }
     System.debug('*************  retrunValue test '+returnValue);
     Map<Date,List<Event>> mapEvent =  numberOfOccupiedSlot(listData);
     for (Date key : mapEvent.keySet() ) {
          System.debug('** mapEvent.get(key).size()' +mapEvent.get(key).size() +'returnValue.get(key) '+returnValue.get(key));
          if(mapEvent.get(key).size() >= returnValue.get(key)){
             String chaine = DateToString(key);
             objectMap.put(chaine, 0);
          }
          else {
            String chaine = DateToString(key);
            Double pourcentage = ( Double.valueOf(mapEvent.get(key).size())/ Double.valueOf(returnValue.get(key))) *100;
            System.debug('*********** pourcentage '+ pourcentage );
            objectMap.put(chaine, pourcentage.intValue());
          }
       
     }
      System.debug('*************  retrunValue objectMap '+objectMap);
       resp = parseResponse(objectMap);
      System.debug('*************  response  '+resp);

     } catch (Exception e) {
       System.debug('*************** errorMessage '+e.getMessage());
       System.debug('*************** errorMessage '+e.getStackTraceString() );
     }
     return resp;

   }

   public static String occupazionniFiliale(String dateIni, String dateEnd, Account filiale){
        String resp ;
     try {
            List<Date> listData = new List<Date>(); 
            Map<String, Object> objectMap = new Map<String, Object>();
            List<String> dateLists = new List<String>();

            Map<String,Date> mapDataString = getListDateString(dateIni, dateEnd);
            for(String key : mapDataString.keySet()){
                   dateLists.add(key);
            }
             Map<Date, Integer> returnValue = appuntamentoByDate(filiale.XCS_Desk__r, dateLists, mapDataString );
             System.debug('#########################  occupazionniFiliale '+returnValue);
            
     }
     catch(Exception e){
         System.debug('############## error Message occupazionniFiliale ');
     }
     return resp;
   }

   public static Map<Date, Integer> appuntamentoByDate(List<XCS_Desk__c> desks, List<String> dateLists,Map<String,Date> mapDataString ){
         Map<Date, Integer> returnValue = new Map<Date, Integer>();
           Map<String, List<Event>> mapDeskEvent = new Map<String, List<Event>>();
           Map<Id, Object> mapDeskSlot = new Map<Id, Object> ();
     try {
       List<XCS_DeskItem__c> items = AppuntomentoQuery.getDeskByDates(desks, dateLists);
       System.debug('################### appuntamentoByDate '+items);
       if(items.size() == 0 ){
         AppuntamentoError.hasError = true;
         AppuntamentoError.codeErreor = '[ERRAP001]';
       }
       else {
            List<Date> datesLists = new List<Date>(mapDataString.values());
            List<Event> events = AppuntomentoQuery.getDeskIndisponibla(desks,datesLists);
            AppuntamentoDomainWS.groupEventByType(events, mapDeskEvent);
            System.debug('################# events appuntamentoByDate '+events);
            System.debug('################  mapDeskEvent  '+mapDeskEvent);
           // AppuntamentoDomainWS.getSlotDeskInDisponibilita(mapDeskEvent, mapDeskSlot);
           //  System.debug('################  mapDeskSlot  '+mapDeskSlot);
       }
       
     } catch (Exception e) {
        System.debug('################ error appuntamentoByDate ');
        System.debug('################ error Message  '+e.getStackTraceString());
     }
    return returnValue;
   }
   /**
     *@Author Madicke  Madicke
     *@description
     *@param returnValue
     *@return String
    */
   public static String parseResponse(Map<String,Object>  returnValue ){
     String chaine = '';
     if(returnValue != null && returnValue.keySet().size() > 0 ){
       for (String key :  returnValue.keySet()) {
            chaine += returnValue.get(key)+'|';
       }
     }
     System.debug(' ############## chaine before remove ####### '+chaine);
     return chaine.removeEnd('|');
   }
  
  
   public  static  Map<String, Date> getListDateString(String dateIni, String dateEnd){
     Map<String, Date> mapStringDate = new Map<String, Date>();
        List<String> listDate= new List<String>();
        Date dIni = Date.parse(dateIni);

        Date dEnd = Date.parse(dateEnd);
        Date dOfWeek =   dIni.addDays(1);
        for(Integer i = dIni.day(); i<=dEnd.day() ;i++  ){
          
        Datetime dt = Datetime.newInstance(dIni.year(), dIni.month(), dIni.day());
        String dayeOfWeek = dt.format('EEEE')+'__c';
           mapStringDate.put(dayeOfWeek,dIni);
           listDate.add(dayeOfWeek);
           dIni =  dIni.addDays(1);
        }
        System.debug('***** mapData ** '+mapStringDate);
        return mapStringDate;

   }
   
   public static  Map<Date, Integer> maxNumberAppuntamentoByDay(String codeFiliale, List<String> days, Map<String, Date> dateMapString){
      System.debug(' ************** running maxNumberAppuntamentoByDay ');
      Map<String, Integer> returnValue = new Map<String, Integer>();
      Map<Date, Integer> mapR = new Map<Date, Integer>();
      Integer maxAppuntamento = 0;
      try {
            List<XCS_DeskItem__c> items = AppuntomentoQuery.getDeskItemByIdDesk(codeFiliale, days);
            System.debug(' **************items.size() '+items.size());
            System.debug( 'item test'+items[0].get('Saturday__c'));
            for(String day: days){
            Integer compteur = 0;
            for(XCS_DeskItem__c item : items){
                    if(item.get(day) == true ){
                      Integer hs = item.StartTime__c.hour()*60 + item.StartTime__c.minute();
                      System.debug(' ************** hs '+hs);
                      System.debug(' ************** item.EndTime__c.hour() '+item.EndTime__c.hour());
                      Integer he = item.EndTime__c.hour()*60 + item.EndTime__c.minute();
                      compteur += (he - hs)/30;
                  }
            }

            returnValue.put(day, compteur);
            }
            System.debug('**************** dateMapString '+dateMapString);
            System.debug('**************** returnValue '+returnValue);
            for(Integer na : returnValue.values()){
              maxAppuntamento += na;
            }
            System.debug('**************** maxAppuntamento '+maxAppuntamento);
            
            for(String key : dateMapString.keySet() ){
              mapR.put(dateMapString.get(key), returnValue.get(key));
            }
            System.debug('**************** mapR '+mapR);
      }
      catch (Exception e) {
        System.debug(' ************* errorMessage '+e.getMessage());
        System.debug(' ************* errorMessage '+e.getStackTraceString() );
      }
      return mapR;
     // return maxAppuntamento;

   }
   /**
     * @Author Madicke BALDE
     * @description
     * @date
     * @param Map<String,Integer>
     * @return
    */
   public static  Map<Date, List<Event>> numberOfOccupiedSlot(List<Date> listData){
     Map<String, Object> returnValue = new Map<String, Object>();
     Map<Date, List<Event>> mapEvent = new Map<Date, List<Event>>();
    
    // List<Date> listData = new List<Date>(); 
     try {
        List<Event> eventList = AppuntomentoQuery.getEventByDate(listData);
        if( eventList != null && eventList.size() > 0 ){
          for( Event e : eventList){
             if(!mapEvent.containsKey(e.ActivityDate) ){
               mapEvent.put(e.ActivityDate, new List<Event>{e});
             }
             else{
               mapEvent.put(e.ActivityDate, (List<Event>) mapEvent.get(e.ActivityDate).add(e));
             }
          }
        
        }
     System.debug('************* mapEvent'+mapEvent);
     } catch (Exception e) {
        System.debug('********** errorMessage '+e.getMessage());
        System.debug('********** errorMessage '+e.getStackTraceString() );
     }
     return mapEvent;
   }
   
   /**
     *@Author Madicke BALDE
     *@description
     *@date
     *@param
     *@return Sting
    **/
   public static String DateToString(Date d){
    Integer yyyy = d.year();
    Integer mm = d.month();
    Integer dd = d.day();
    String chaine = dd+'/'+mm+'/'+yyyy;
    return chaine;
   }
   /**--------------------------------------------------------------------
     *@Author Madicke BALDE
     *@description
     *@date
     *@param
     *@param
     *@retiurn
    *--------------------------------------------------------------------------*/
   public static  Map<Id, Object> maxAppuntamentoByDeskForDay(List<XCS_Desk__c> deskList, String day){
      Map<XCS_Desk__c, Integer> deskMap = new Map<XCS_Desk__c, Integer>();
      Map<Id, Integer> m = new Map<Id, Integer>();
      Map<String, Object> mapName = new Map<String, Object>();
      Map<Id, Object> listSlotByDesk;
      
     try {
        
         List<XCS_DeskItem__c> deskDisponible = new List<XCS_DeskItem__c>(); 
         List<XCS_DeskItem__c> items = AppuntomentoQuery.getXCSDeskItemByIdDesk(deskList);
         if(items.size() > 0 ){

           for(XCS_DeskItem__c item : items){
                  m.put(item.Desk__r.Id, 0);
                  System.debug(' **************** item.get(day) '+item.get(day));
                  if(item.get(day) == true ){
                    deskDisponible.add(item);
                  }
           }
           System.debug(' ************ deskDisponible'+deskDisponible);
          if(deskDisponible.size() > 0 ){
                listSlotByDesk = getSlotListByDesk(deskDisponible);
            // System.debug(' **************** returnValue '+returnValue); 
           //    Map<Id, Object> nbSlotByDesk = maxSlotByDesk(deskDisponible);
          //     System.debug(' **************** nbSlotByDesk '+nbSlotByDesk);
               System.debug(' **************** listSlotByDesk '+listSlotByDesk);
          }  
         } 
     } catch (Exception e) {
       System.debug('*************** errorMessage '+e.getMessage());
       System.debug('****************  '+e.getStackTraceString());
     }
     return listSlotByDesk;
   }

   /******************************--------------------------------------------
     *@Author Madicke BALDE
     *@description
     *@param
     *@return 
    *------------------------------------------------------------------------------*/
   public static Map<Id , Object> getSlotListByDesk(List<XCS_DeskItem__c> itemsDesk){
     Map<Id, Slots_N_Appuntamento> returnValue = new Map<Id, Slots_N_Appuntamento>();
     Time startTime , endTime, t ;
     
    try {
      for (XCS_DeskItem__c item : itemsDesk ) {
         List<Slot> slotList = new List<Slot>();
        
             startTime = item.StartTime__c;
              endTime = item.EndTime__c;
                System.debug(' **************** startttttttttt '+startTime);
                  System.debug(' **************** endddddddd '+endTime);
               t = startTime.addMinutes(30);
               Integer cp = 0;
         while (t <= endTime) {
           cp++;
           slotList.add(new Slot(startTime,t) );
           System.debug(' **************** startTime'+startTime);
            System.debug(' **************** t'+t);
           startTime = t;

          t = t.addMinutes(30);
           System.debug(' **************** cp'+cp);
         } 
         System.debug(' **************** cp'+cp);
        returnValue.put(item.Desk__r.Id, new Slots_N_Appuntamento(slotList.size(), slotList) );
      }
      
    } catch (Exception e) {
      System.debug('*****************  errorMessage '+e.getMessage());
      System.debug('*****************  errorMessage '+e.getStackTraceString() );
    }
    return returnValue;
   }
   /**-------------------------------------------------------------------------------
     *@Author Madicke BALDE
     *@date
     *@description 
     *@param
     *@return 
    *------------------------------------------------------------------------------------*/
   public static Map<Id, Integer> maxSlotByDesk(List<XCS_DeskItem__c> itemsDesk){
     Map<Id, Integer> returnValue = new Map<Id, Integer>();
     try {
        Integer compteur = 0;
            for(XCS_DeskItem__c item : itemsDesk){
                     
                      Integer hs = item.StartTime__c.hour()*60 + item.StartTime__c.minute();
                      System.debug(' ************** hs '+hs);
                      System.debug(' ************** item.EndTime__c.hour() '+item.EndTime__c.hour());
                      Integer he = item.EndTime__c.hour()*60 + item.EndTime__c.minute();
                      compteur += (he - hs)/30;
                      returnValue.put(item.Desk__r.Id, compteur);
            }

       
     } catch (Exception e) {
       System.debug('******************* errorMessage '+e.getMessage());
       System.debug('******************* errorMessage '+e.getStackTraceString() );
     }
     return returnValue;
   }
   
   public class Slots_N_Appuntamento {
      public Integer numberAppuntomento {get;set;}
      public List<Slot> slots {get;set;}
      public Slots_N_Appuntamento(Integer numberAppuntomento,  List<Slot> slots ){
       this.numberAppuntomento = numberAppuntomento;
       this.slots = slots;
     }
   }
   public class Slot {
    public Time startTime {get;set;}
    public Time endTime {get;set;}
    public Slot(Time st, Time endT){
       this.endTime = endT;
      this.startTime = st;
     
    }
   }

   /**--------------------------------------------------------------------------------------
     *@Author Madicke BALDE
     *@description convert String to Time
     *@date 25/08/2019
     *@param time string
     *@return Time
    *--------------------------------------------------------------------------------------*/
   public static Time convertStringToTime(String timeString){
     Time t;
     try {
        
         Integer h = Integer.valueOf( timeString.substringBefore(':'));
         Integer  m = Integer.valueOf(timeString.substringAfter(':'));
          t = Time.newInstance(h,m,0,0);
     } 
      catch (Exception e) {
       System.debug('***************** errorMessage '+e.getMessage());
       System.debug('***************** errorMessage '+e.getStackTraceString() );
     }
     return t;
   }

   /**---------------------------------------------------------------------------------------
     *@Author Madicke BALDE
     *@date
     *@description
     *@
    *--------------------------------------------------------------------------------------*/
   public static Datetime convertStringToDatetime(String data, String timeString){
     Datetime d;
     try {
        Integer h = Integer.valueOf( timeString.substringBefore(':'));
        Integer  m = Integer.valueOf(timeString.substringAfter(':'));

      String years = data.substring(0,4);
      String month = data.substring(4,6);
      String day   =  data.substring(6,8);
      d = Datetime.newInstance(Integer.valueOf(years) , Integer.valueOf(month), Integer.valueOf(day), h, m, 0);

       
     } catch (Exception e) {
       System.debug('*************** errorMessage '+e.getMessage());
        System.debug('*************** errorMessage '+e.getStackTraceString() );
     }
     return d;
   }
   /**--------------------------------------------------------------------------------------
     *@Auhtor Madicke BALDE
     *@description get list of Event grouped by Desk Id
     *@date 2019/08/26
     *@param Date appuntamento
     *@return Map<Id, List<Event>>
    *--------------------------------------------------------------------------------------*/
   public static Map<Id, List<Event>> getEventGroupByDeskId(Date d){
     Map<Id, List<Event>> returnValue = new Map<Id, List<Event>>();
     try {

        List<Event> events = AppuntomentoQuery.getEventByDate(new List<Date>{d});
        if( events != null && events.size() > 0 ){
          for (Event e : events){
               if(!returnValue.containsKey(e.Desk__c) ){
                 returnValue.put(e.Desk__c, new List<Event>{e});
               }
               else {
                  returnValue.put(e.Desk__c, (List<Event>) returnValue.get(e.Desk__c).add(e));
               }
          }
        } 
     } catch (Exception e) {
       System.debug(' *************  errorMessage '+e.getMessage());
       System.debug(' *************  errorMessage '+e.getStackTraceString()  );
     }
     return returnValue;
   }

  public static void getSlotDesk(List<XCS_Desk__c> desks, Map<Id, Object> mapDesk, String dayOfWeek){
        System.debug(' ############### running EventDomaine getSlotDesk  dayOfWeek '+dayOfWeek);
         String query = 'SELECT Id, Desk__c, StartTime__c, EndTime__c FROM XCS_DeskItem__c WHERE '+dayOfWeek +'= true AND Desk__c IN :desks' ;
        List<XCS_DeskItem__c> items = Database.query(query);
        System.debug('################# getSlotDesk '+items);
        if(items.size() == 0 ){
            AppuntamentoError.hasError = true;
            AppuntamentoError.errorMessage = 'Appuntamento not Available at '+dayOfWeek;
            return;
        }
        else {
            List<Slot> listSlots = new List<Slot>();
            Set<Time> listTimeSlot = new Set<Time>();
            for(XCS_DeskItem__c item : items){
                Time startTime = item.StartTime__c;
                Time endTm = item.EndTime__c;
              //  Integer cp = 0;
                Time  t = startTime.addMinutes(30);
                while(  t <= endTm){
                      //  listSlots.add(new Slot(startTime, t));
                       listTimeSlot.add(startTime);
                       listTimeSlot.add(t);
                        startTime = t;
                        t = t.addMinutes(30);
                }
              
            mapDesk.put(item.Desk__c, listTimeSlot);
            System.debug('###########  getSlotDesk mapDesk '+mapDesk);
            }
        }
    }
   
   /**
     *@Author Madicke BALDE
     *@description get Event by Date

    */
   public static Map<Id, List<Event>> getEventByDaye(Date activitiDate){
     System.debug(' ############### running  getEventByDaye');
     Map<Id, List<Event>> mapEventDesk = new Map<Id, List<Event>>();
    try {
       List<Event> events = AppuntomentoQuery.getEventByDate(new List<Date>{activitiDate});
          System.debug(' ############### running  getEventByDaye events '+events);
       if (events != null && events.size() > 0 ) {
          for(Event ev : events){
            if(!mapEventDesk.containsKey(ev.Desk__c)){
              mapEventDesk.put(ev.Desk__c, new List<Event>{ev});
            }
            else {
              mapEventDesk.put(ev.Desk__c,(List<Event>) mapEventDesk.get(ev.Desk__c).add(ev));
            }
          }
         
       }
      
    } catch (Exception e) {
      System.debug(' ############### errorMessage  '+e.getMessage());
      System.debug(' ############### errorMessage  '+e.getStackTraceString() );
    }
     return mapEventDesk;
   }
   /**------------------------------------------------------------------------------------
     *@Madicke BALDE
     *@description
     *@param
     *@param
     *@return
    *---------------------------------------------------------------------------------------*/
   public static Map<Id,List<Event>> getEventByIDesk(Set<Id> idDesk, Date appuntamentoDate){
      System.debug(' ############## getEventByIDesk ####### ruuning   ');
      Map<Id, List<Event>> mapEventDesk = new Map<Id, List<Event>>();
      try {
            List<Event> events = AppuntomentoQuery.getDeskByIds(idDesk, appuntamentoDate);
            System.debug(' ############## events ####### events   '+events);
            if (events != null && events.size() > 0 ) {
            for(Event ev : events){
                System.debug(' ############## ev.Desk__c  '+ev.Desk__c);
              if(!mapEventDesk.containsKey(ev.Desk__c)){
                    System.debug(' ############## test map  ');
                    mapEventDesk.put(ev.Desk__c, new List<Event>{ev});
              }
              else {
                    // mapEventDesk.put(ev.Desk__c,(List<Event>) mapEventDesk.get(ev.Desk__c).add(ev));
                    System.debug(' ############## test map else  ');
                    mapEventDesk.get(ev.Desk__c).add(ev);
              }
      }

      }

      } catch (Exception e) {
      System.debug(' ############### errorMessage  '+e.getMessage());
      System.debug(' ############### errorMessage  '+e.getStackTraceString() );
      }
      System.debug(' ############## mapEventDesk ####### mapEventDesk   '+mapEventDesk.values());
      System.debug(' ############## mapEventDesk ####### mapEventDesk   '+mapEventDesk.keySet().size());
      return mapEventDesk;

   }


/* public static void getSlotDeskInDisponibilita(List<Event> events, Map<Id, Object> mapDeskSlot){
   if(mapDeskEvent == null || events == null || events.size() == 0 ){
     return;
   }
   else {
     
   }
 }*/
   
   

}