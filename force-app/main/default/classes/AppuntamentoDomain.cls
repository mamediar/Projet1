/**###############################################################################################
  *@Author Madicke BALDE
  *@description
  *@date
 *#################################################################################################*/
public  class AppuntamentoDomain {
   
    
    public static  Map<String, Object> createAppuntamento (AppuntamentoService.AppuntamentoWrapper appuntamento){
        Map<String, Object> returnValue = new Map<String, Object>();
        returnValue.put('error',false);
        Event ev = new Event();
        Event appuntomentoActive;
        try {
          Account account = createAccountData(appuntamento.datiCliente);
          Account filiale = ckeckFilialeExistence(appuntamento.codFiliale);
           Product2 prodotto = new  Product2();
         // Product2 prodotto = ProdottoService.getProdottoByProdottoLVL(appuntamento.prodottoLvl1);
          appuntomentoActive = AppuntomentoQuery.appuntomentoCercaActive(account.Codice_Fiscale__c);
       
        if(appuntomentoActive.Id != null ){
              EventDomaine.appuntamentaCerca(appuntomentoActive, appuntamento.codFiliale, returnValue);
              System.debug(' ********* returnValue balde ***** '+returnValue);
              if(returnValue.get('isOk') == true){
               Map<String, Object>  mapReturnValue =   updateAppuntamento(appuntomentoActive, appuntamento, prodotto);
               System.debug(' ###############  ttttttttt '+ mapReturnValue);
               getEvent(mapReturnValue, returnValue );
              }
              else {
                returnValue.put('error', true);
              }
              
        }
        else {
             System.debug('****************  Create Appuntamento');
             Map<String,Object> mapData = createAppuntamento(appuntamento.data, appuntamento.ora, appuntamento.codFiliale);
             if((Boolean) mapData.get('iscreated')){
               Event eCreated = (Event) mapData.get('event');
               makeDataEvent(eCreated, appuntamento);
               eCreated.Product__c = prodotto.Id;
               eCreated.Customer__c = account.Id; 
               Event e = EventService.createNewEvent(eCreated);
               returnValue.put('event',e);
             }
             else {
                 returnValue.put('error',true);
                 returnValue.put('errorMessage', mapData.get('errorMessage') );
             }     
        }

        } catch (Exception e) {
             returnValue.put('error',true);
             if(String.isNotBlank(AppuntamentoService.errorCode)){
               String msg = CGMWSUtils_1_0.ERROR_MESSAGE_MAP.get(AppuntamentoService.errorCode);
              returnValue.put('errorMessage', msg );
             }
             System.debug('************ errorMessage '+e.getMessage());
             System.debug('************ errorMessage '+e.getStackTraceString());  
        }
        System.debug('********  returnValue after wservice '+ returnValue);
        return returnValue;
    }

    /**---------------------------------------------------------------------------------
      *@Author Madicke BALDE
      *@date 2019/08/26
      *@description
      *@param Map<String, Object>
      *@param Event
      *
     *--------------------------------------------------------------------------------*/
    public static void getEvent(Map<String, Object>  mapReturnValue , Map<String, Object>  returnValue){
      System.debug(' #################### running getEvent ');
      if(mapReturnValue == null || mapReturnValue.get('error') == true ){
         returnValue.put('error', true);
         returnValue.put('errorMessage', mapReturnValue.get('errorMessage'));
        return;
      }
      else {
        returnValue.put('error', false);
        returnValue.put('event', mapReturnValue.get('event'));
      }
    }
  
   // 77 509 75 20

    public static Account createAccountData(AppuntamentoService.DatiCliente cliente){
       Id recordTypeId = CGMWSUtils_1_0.getRecordTypeId('Account', 'Customer');
        Account acc = new Account();
        System.debug('************  recordTypeId '+recordTypeId);
        Map<Account, Account> accountMap = new Map<Account, Account>();
        acc.LastName = cliente.cognome;
       // acc.RecordTypeId = recordTypeId;
        acc.FirstName = cliente.nome;
        acc.PersonEmail = cliente.email;
        acc.Codice_Fiscale__c = cliente.codiceFiscale;
        acc.PersonHomePhone = cliente.cellulare;
        accountMap.put(acc, null);
        XCSGestioneAnagrafica.deduplica(accountMap, true);

         /*    Account a =  [SELECT Id, Codice_Fiscale__c FROM Account WHERE Id =: accountMap.get(acc).Id ] ;
        a.RecordTypeID = recordTypeId;
        update a; */
        System.debug('**************** Account Id ****** '+ accountMap.get(acc).Id);
        return  accountMap.get(acc);
    }
    /**
      *@Author Madicke BALDE
      *@description method to update Event
      *@param eventToUpdate : Event to Update
      *@param data : new date appuntamento
      *@param ora  : new time appuntamento
      *@param codeFiliale : codice Filiale
      *@return Map<String, Object>
     */
    public static Map<String, Object> updateAppuntamento(Event eventToUpdate, AppuntamentoService.AppuntamentoWrapper appuntamento , Product2 prodotto ){
         Map<String, Object> returnValue = new Map<String, Object>();
         returnValue.put('error', false);
     try {
         Map<String, Object> mapValue = EventDomaine.appuntomentoDisponibilitaCompleta(appuntamento.codFiliale, appuntamento.data);
         System.debug('********* isAvalable '+ mapValue.get('isAvalable'));
         Datetime d =  EventDomaine.convertStringToDatetime(appuntamento.data, appuntamento.ora);
         System.debug('****************  Datetime ****** '+d);
         Event event = AppuntomentoQuery.getEventByDate(d.date(), d, eventToUpdate.Desk__c );
         System.debug('*****************  event '+event);
         System.debug('*****************  slot '+  mapValue.get('slots'));
         if( (Boolean) mapValue.get('isAvalable') == true  &&  ((Set<Time>) mapValue.get('slots')).contains(d.time()) ){
           System.debug(' ###################### event is OK  ');
           System.debug(' ###################### ActivityDate  '+eventToUpdate.ActivityDate);
           if(checkifdataValide(d.date(), eventToUpdate.ActivityDate)){
             makeDataEvent(eventToUpdate, appuntamento);
              eventToUpdate.ActivityDate = d.date();
              eventToUpdate.ActivityDateTime = d;
              //  eventToUpdate.Duration = 
              eventToUpdate.StartDateTime = d;
              eventToUpdate.DurationInMinutes = d.addMinutes(30).minute();
              eventToUpdate.EndDateTime = d.addMinutes(30);
              eventToUpdate.Product__c = prodotto.Id;
              Event ev = EventService.updateEvent(eventToUpdate);
              returnValue.put('event', ev);
           }
           else {
                returnValue.put('error', true);
                returnValue.put('errorMessage', 'La nuova data appuntamento deve essere futura e non passata ');
           }
         } 
         else if((Boolean) mapValue.get('isAvalable') == true) {
            returnValue.put('error', true);
            returnValue.put('errorMessage', 'Filiale Not Avalable at '+appuntamento.ora);
         }
         else {
              returnValue.put('error', true);
              returnValue.put('errorMessage', 'Filiale Not Avalable at '+appuntamento.data);
         }
    
        
       
     } catch (Exception e) {
       returnValue.put('error', true);
       System.debug(' **********************  updateAppuntamento '+e.getMessage());
       System.debug(' *************  errorMessage '+e.getStackTraceString());
     }
     return returnValue;
    }
    
    /**------------------------------------------------------------------------------
      *@Author Madicke BALDE
      *@description method to create Appuntamento
      *@date  2019/08/26
      *@param data : Appuntamento data
      *@param ora  : Appuntamento ora
      *@param codeFiliale : code Filiale 
     *------------------------------------------------------------------------------**/
    public static  Map<String,Object> createAppuntamento(String data, String ora, String codeFiliale){
      System.debug('********************** createAppuntamento running *************** ');
      Map<String,Object> returnValue = new Map<String,Object>();
      returnValue.put('iscreated', false);
      Event ev = new Event();
      try {
        //   Date d = CGMWSUtils_1_0.formatStringToDate(data);
           Datetime dt =  EventDomaine.convertStringToDatetime(data, ora);
           Map<String, Object> mapValue = EventDomaine.appuntomentoDisponibilitaCompleta(codeFiliale, data);
           System.debug('***************  mapValue test '+mapValue);
           Map<Id, List<Event>> eventMap =  EventDomaine.getEventGroupByDeskId(dt.date());
            System.debug('***************  eventMap  test 2'+eventMap);
             System.debug('***************  isAvalable  ######### '+mapValue.get('isAvalable'));
          if(mapValue.get('isAvalable') == true  && ((Set<Time>) mapValue.get('slots')).contains(dt.time()) ) {
            System.debug(' ################### Condition ik ');
             Map<Id,Object> mapDeskEvent = ( Map<Id,Object>) mapValue.get('deskMap');
             for(Id idDesk : mapDeskEvent.keySet()){
                EventDomaine.Slots_N_Appuntamento sl= (EventDomaine.Slots_N_Appuntamento) mapDeskEvent.get(idDesk);
                if( (eventMap.keySet().size() == 0 || eventMap.get(idDesk).size()<= sl.numberAppuntomento) ){
                     ev.ActivityDate = dt.date();
                     ev.StartDateTime = dt;
                     ev.EndDateTime = dt.addMinutes(30);
                     ev.Desk__c = idDesk;
                     returnValue.put('iscreated', true);
                    returnValue.put('event', ev);

                     }
                    break;
             }
          }
          else if(mapValue.get('isAvalable') == true ) {
         //   System.debug('********* mapValue '+mapValue.get('errorMessage'));
            returnValue.put('errorMessage', 'Branch not Avable at '+ora);
          }
          else {
               returnValue.put('errorMessage', (String) mapValue.get('errorMessage'));
          }
 
      } catch (Exception e) {
        System.debug('************  errorMessage '+e.getMessage());
        System.debug('************  errorMessage '+e.getStackTraceString() );
        
      }
      return returnValue;
    }

    public static Map<String,Object> appuntamentoModifica(AppuntamentoService.AppuntamentoModifica appuntamento){
      Map<String, Object> returnValue = new Map<String, Object>();
      Account filiale = AppuntomentoQuery.getFilialeByCodeFiliale(appuntamento.codFiliale);
      Account customer = AppuntomentoQuery.getClientByCodeFiscale(appuntamento.codiceFiscale); 
      Event ev = checkAppuntamentoExistence(appuntamento.oppID);
       Date dt = CGMWSUtils_1_0.formatStringToDate(appuntamento.data);
      if(checkifdataValide(dt, ev.ActivityDate )){
       checkDisponibilita(appuntamento.data, appuntamento.codFiliale, appuntamento.ora, returnValue);
      }
      else {
        System.debug(' ** ******** No match ' );
        returnValue.put('error', true);
        returnValue.put('errorMessage', 'The new appointment date must be future and not passed');
      }

      if(returnValue.get('error') == false && (Event) returnValue.get('event')!= null ){
        Event event = (Event) returnValue.get('event');
        event.Id = appuntamento.oppID;
        event =  EventService.updateEvent(event);
        returnValue.put('event', event);
      }
      return returnValue;
    }

    /**---------------------------------------------------------------------------------
      * @Author Madicke BALDE
      * @description 
      * @date 
      * @param 
     *-----------------------------------------------------------------------------------*/
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
    /**-------------------------------------------------------------------------------------
      *@Author Madicke BALDE
      *@description check  Filiale existence
      *@param code Filiale
      *@return Account
      *@date 2019/08/27
     *---------------------------------------------------------------------------------------*/
    public static Account ckeckFilialeExistence (String codeFiliale){
      Account account;
      if(String.isNotBlank(codeFiliale) ){
        account = AppuntomentoQuery.getFilialeByCodeFiliale(codeFiliale);
        return account;
      }
      else {
        return null;
      }
    }
    
    /**---------------------------------------------------------------------------------------
      *@Author Madicke BALDE
      *@description check appuntamento 
      *@date 2019/08/27
      *@param oppID : ID appuntamento
      *@return Event
     *---------------------------------------------------------------------------------------*/
    public static Event checkAppuntamentoExistence(String oppID){
      if(String.isNotBlank(oppID)){
        Event ev = AppuntomentoQuery.getEventById(oppID);
        return ev;
      }
      else {
        return null;
      }

    }
    /**-------------------------------------------------------------------------------
      *@Author Madicke BALDE
      *@description
      *@date 
      *@param dataString : appuntamento date
      *@param codeFiliale : codice Filiale
      *@param ora : appuntamento ora
     *---------------------------------------------------------------------------------*/
    public static void checkDisponibilita(String dataString, String codeFiliale, String ora,  Map<String,Object> returnValue ){
        System.debug('******************  running ***************** checkDisponibilita');
       returnValue.put('error', false);
      // returnValue.put('event', null);
        Map<String, Object>   returnMap = EventDomaine.appuntomentoDisponibilitaCompleta(codeFiliale, dataString);
      
      Datetime dt =  EventDomaine.convertStringToDatetime(dataString, ora);
      System.debug('*************** Datetime '+dt);
      Event ev = new Event();
      Map<Id, List<Event>> eventMap =  EventDomaine.getEventGroupByDeskId(dt.date());
      if(returnMap.get('isAvalable') == true  && ((Set<Time>) returnMap.get('slots')).contains(dt.time()) ) {
          Map<Id,Object> mapDeskEvent = ( Map<Id,Object>) returnMap.get('deskMap');
              for(Id idDesk : mapDeskEvent.keySet()){
              EventDomaine.Slots_N_Appuntamento sl= (EventDomaine.Slots_N_Appuntamento) mapDeskEvent.get(idDesk);
                if(eventMap.keySet().size() == 0  || (eventMap.get(idDesk).size() <= sl.numberAppuntomento) ){
                     ev.ActivityDate = dt.date();
                     ev.StartDateTime = dt;
                     ev.EndDateTime = dt.addMinutes(30);
                     ev.Desk__c = idDesk;
                     returnValue.put('event', ev);
                     }
                  break;
             }
      }
      else  if (returnMap.get('isAvalable') == true) {
                returnValue.put('error', true);
                returnValue.put('errorMessage', ora + 'is not Available');
      }
      else if (returnMap.get('isAvalable') == false) {
                returnValue.put('error', true);
                returnValue.put('errorMessage', dataString + ' is not Available');
      }
    }
    
    /**
      *@Author Madicke BALDE
      *@description check if new Date is grater than the old Date
      *@param newDate : new Date
      *@param dateToUpdate : old date
      *@return Booleqn
     */
    public static Boolean checkifdataValide(Date newDate, Date dateToUpdate){
      System.debug(' *********** newDate '+newDate);
      System.debug(' *********** dateToUpdate '+dateToUpdate);
      if(newDate < dateToUpdate ){
        System.debug(' ************* checkifdataValide false ');
          return false;
      }
      else {
        System.debug(' ************* checkifdataValide true ');
        return true;
      }
    }

    public static void setDateFields(Event ev, String fieldName, String fieldValue){
      if(fieldValue == null) return;
      if(fieldValue.trim().equals('')) ev.put(fieldName, null);
      else ev.put(fieldName, CGMWSUtils_1_0.formatStringToDate(fieldValue));
   }

/**
  * @Author Madicke BALDE
  * @description  
  * @date
 **/  
public static void setStringField(Event ev , String fieldName, String fieldValue){
    System.debug('************* runnginh  setStringField ******* ');
    if(fieldValue == null) return;
    if(fieldValue.trim().equals('')) ev.put(fieldName, null);
    else ev.put(fieldName, fieldValue);
       
}
/**
  *@Author Madicke BALDE
  *@description
  @date 2019/08/29
  *@param
  *@param
  @param 
 */
public static void setOccupazione(Event ev, String fieldName, String fieldValue){
  if(fieldValue == null) return;
  if(fieldValue.trim().equals('')) ev.put(fieldName, null);
  else {
   List<SelectOption> listSelect = AppuntamentoDomain.getOccupazioneValue();
    for(SelectOption sele : listSelect){
            System.debug('############# getValue ###### '+sele.getValue());
            if(sele.getValue() == fieldValue.substringBefore(';')){
              System.debug(' ############### '+sele);
              ev.put(fieldName, sele.getLabel());
               break;
            }
        }
   
  }
}
public static void setIntegerField(Event ev, String fieldName, String fieldValue){
  if(fieldValue == null) return;
  if(fieldValue.trim().equals('')) ev.put(fieldName, null);
  else {
    Integer nbre = Integer.valueOf(fieldValue);
    ev.put(fieldName, fieldValue);
  }
}

/**--------------------------------------------------------------------------------------
  *@Author Madicke BALDE
  *@description
  *@date
  *@param
  *@param
 *----------------------------------------------------------------------------------------*/
public static void  makeDataEvent( Event eCreated, AppuntamentoService.AppuntamentoWrapper appuntamento){
               setStringField(eCreated, 'Cognome__c', appuntamento.datiCliente.cognome);
               setStringField(eCreated, 'Nome__c', appuntamento.datiCliente.nome);
               setStringField(eCreated, 'Telefono_Cellulare__c', appuntamento.datiCliente.cellulare);
               setStringField(eCreated, 'Comune_nascita__c', appuntamento.datiCliente.provinciaNascita);
               setStringField(eCreated, 'utm_medium__c', appuntamento.datiMediaUTM.utmMedium);
               setStringField(eCreated, 'utm_campaign__c', appuntamento.datiMediaUTM.utmCampaign);
               setStringField(eCreated, 'utm_content__c', appuntamento.datiMediaUTM.utmContent);
               setStringField(eCreated, 'utm_history__c', appuntamento.datiMediaUTM.utmHistory);
               setStringField(eCreated, 'utm_source__c', appuntamento.datiMediaUTM.utmSource);
               setStringField(eCreated, 'utm_term__c', appuntamento.datiMediaUTM.utmTerm);
               setDateFields(eCreated, 'utm_date__c', appuntamento.datiMediaUTM.utmDate);
               setOccupazione(eCreated, 'Tipo_Occupazione__c', appuntamento.datiCliente.tipoOccupazione);
               setIntegerField(eCreated, 'mediacodeInt__c', appuntamento.datiMediaUTM.mediacodeInt);
               setIntegerField(eCreated, 'mediacode__c', appuntamento.datiMediaUTM.mediacode);
}
  
/**-----------------------------------------------------------------------------------
  *@Author Madicke BALDE
  *@description
  *@date
  *@
 *----------------------------------------------------------------------------------*/
public static List<SelectOption> getOccupazioneValue(){
         List<SelectOption> options = new List<SelectOption>();
            try {
                    Schema.DescribeFieldResult fieldResult =  Event.Tipo_Occupazione__c.getDescribe();
                    List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
                     for( Schema.PicklistEntry f : ple)   {
                          options.add(new SelectOption(f.getLabel(), f.getValue()));
                        }       
                
               } 
            catch (Exception e) {
                System.debug(' ********** errorMessage '+e.getMessage());
            }
            return   options;
}

public static void gestitoAppuntamento(AppuntamentoWService.AppuntamentoWrapper appuntamento){
  try {
       Account filiale = ckeckFilialeExistence(appuntamento.codFiliale);
        Product2 prodotto = new  Product2();
      // Product2 prodotto = ProdottoService.getProdottoByProdottoLVL(appuntamento.prodottoLvl1);
       Map<Id, Object> returnMap = new Map<Id, Object>();
       cercaDisponibilitaFiliale(filiale, appuntamento.data, returnMap);
       System.debug(' #############  AppuntamentoError.errorMessage  ### '+ AppuntamentoError.errorMessage);
       System.debug(' #############  AppuntamentoError.hasError  ### '+ AppuntamentoError.hasError);
       System.debug(' #############  returnMap  ### '+ returnMap);
       Date activiDate = CGMWSUtils_1_0.formatStringToDate(appuntamento.data);
       Map<String,Object> mpData = checkDisponilitaOra(appuntamento.ora, returnMap, 
                                                       activiDate, AppuntamentoError.hasError);
       System.debug(' ############## map Event '+mpData);

   } catch (Exception e) {
    System.debug(' #################### errorMessage '+e.getMessage());
    System.debug(' ############# errorMessage '+e.getStackTraceString());

  }
}

public static void cercaDisponibilitaFiliale( Account filiale, String appuntamentoDate,Map<Id, Object> returnMap){
       
        String dayOfWeek = CGMWSUtils_1_0.getDayOfWeek(appuntamentoDate);
        if(filiale.XCS_Desk__r != null){
            List<XCS_Desk__c> desks = filiale.XCS_Desk__r;
            EventDomaine.getSlotDesk(desks, returnMap, dayOfWeek);
             
        }
}

 /**-------------------------------------------------------------------------------
      *@Author Madicke BALDE
      *@description get Desk and Slot
  *--------------------------------------------------------------------------------*/
   
public static  Map<String,Object> checkDisponilitaOra(String ora, Map<Id, Object> mapDesk, Date activiDate, Boolean hasError ){
        System.debug(' ################ running checkDisponilitaOra ############# ');
        Map<String,Object> eventMap = new Map<String, Object>();
        
        eventMap.put('isAvailable', false);
        Event event = new Event();
        if(hasError){
            return null;
        }
        else {
           Map<Id, List<Event>> mp = EventDomaine.getEventByDaye(activiDate);
           Time t = EventDomaine.convertStringToTime(ora);
           System.debug(' ############# t'+t);
          System.debug(' ############### mp  ####### '+mp);
           for(Id idDesk : mapDesk.keySet()){
               
               if( (mp.keySet().size() == 0 && ( (Set<Time>) mapDesk.get(idDesk)).contains(t)) ||
                 ( (mp.keySet().size() > 0 ) &&  (mp.get(idDesk).size() < ((Set<Time>) mapDesk.get(idDesk)).size() ) && ((Set<Time>)mapDesk.get(idDesk)).contains(t) ) ){
                       System.debug(' ############### test Ok  ####### ');
                        event.ActivityDate = activiDate;
                     //   event.StartDateTime = '';
                        event.Desk__c = idDesk;
                     //   event.EndDateTime = '';
                        eventMap.put('event', event);
                } 
                break;
             }
             if(eventMap.get('event') == null ){
               AppuntamentoError.hasError = true;
               AppuntamentoError.errorMessage = 'the Filiale is Not Available at '+ora;
             }
             return eventMap;
     }
}


 
}