public with sharing class ModificaAppuntamentoController {
    @AuraEnabled
    public static Map<String ,Object>  getEventByDateActivity(date activityDate){
        Map<String ,Object> returnValue = new  Map<String ,Object>();
        returnValue.put('erreur', false);
        try {
               List<Event> events= EventService.getEventsByDate(activityDate);
               returnValue.put('events', events);
            
        } catch (Exception e) {
            System.debug('errorMessage ModificaAppuntamentoController '+e.getMessage());
             returnValue.put('erreur', true);
             returnValue.put('messageError', e.getMessage()+' '+e.getLineNumber()+' '+e.getCause());
        }
     
        return returnValue;
    }

    @AuraEnabled
    public static Map<String ,Object> getDateTime(Event event,String timeEvent){
        Map<String ,Object> returnValue = new  Map<String ,Object>();
        returnValue.put('erreur', false);
        try {
                String[] strtime =timeEvent.split(':');
                Integer houre = integer.valueOf(strtime[0]);
   		        Integer minutes = integer.valueOf(strtime[1]);
		        System.debug('timeEvent '+timeEvent +'  ///// '+ strtime+' / '+houre);
                Datetime dtEvent=Datetime.newInstance(event.ActivityDate.year(), event.ActivityDate.month(), event.ActivityDate.day(), houre, minutes, 0);
                returnValue.put('data', dtEvent);
        } catch (Exception e) {
            returnValue.put('erreur', true);
        }
        return returnValue;
    }
    
    @AuraEnabled
    public static Map<String ,Object> updateEvent(Event event, String timeEvent){
        Map<String ,Object> returnValue = new  Map<String ,Object>();
        returnValue.put('erreur', false);
        try {
            
             Integer durationInMinutes = Integer.ValueOf(event.DurationInMinutes);
             event.DurationInMinutes=durationInMinutes;
             String dateString=''+event.ActivityDateTime;
             DateTime activityDateTime = DateTime.ValueofGmt(dateString.replace('T', ' ')); 
             event.ActivityDateTime=activityDateTime;
             System.debug('update event'+event);
             update event;
             returnValue.put('detailEvent', event);
        } catch (Exception e) {
             System.debug('errorMessage CreaAppuntamentoController updateEvent '+e.getMessage());
             returnValue.put('erreur', true);
             returnValue.put('message', e.getMessage()+' '+e.getStackTraceString()+' '+e.getLineNumber());
        }
     
        return returnValue;
    } 

    @AuraEnabled
    public static Map<String ,Object> annulaEvent(Event event){
        Map<String ,Object> returnValue = new  Map<String ,Object>();
        returnValue.put('erreur', false);
        try {
             event.DurationInMinutes=60;
             String dateString=''+event.ActivityDateTime;
             DateTime activityDateTime = DateTime.ValueofGmt(dateString.replace('T', ' ')); 
             event.ActivityDateTime=activityDateTime;
             //event.OwnerId=null;
             event.Stato_Azione__c ='Non presentato/Annullato';
             update event;
             returnValue.put('detailEvent', event);
        } catch (Exception e) {
             System.debug('errorMessage CreaAppuntamentoController annulaEvent '+e.getMessage());
             returnValue.put('erreur', true);
             returnValue.put('message', e.getMessage()+' '+e.getStackTraceString()+' '+e.getLineNumber());
        }
     
        return returnValue;
    }
    
    @AuraEnabled
    public static Map<String ,Object> getDisposition(String codeExternal){
        Map<String ,Object> returnValue = new  Map<String ,Object>();
        XCS_Disposition__c disposition;
        returnValue.put('erreur', false);
       try {
           codeExternal = '%AP'+codeExternal+'%';
       	   disposition = [SELECT Id FROM XCS_Disposition__c WHERE External_Id__c like :codeExternal  LIMIT 1];
            returnValue.put('disposition', disposition);
        } catch (Exception e) {
            System.debug('errorMessage CreaAppuntamentoController getDisposition '+e.getMessage());
            returnValue.put('erreur', true);
            returnValue.put('messageError', e.getMessage()+' '+e.getLineNumber()+' '+e.getCause());

        }
     
        return returnValue;
        
    }

    @AuraEnabled
    public static Map<String ,Object> getAccountById(String idAccount){
       Map<String ,Object> returnValue = new  Map<String ,Object>();
       returnValue.put('erreur', false);
       try {
       		Account account = AccountService.getFilialeById(idAccount) ;
            returnValue.put('account', account);
        } catch (Exception e) {
            System.debug('errorMessage CreaAppuntamentoController getProvinceCommune '+e.getMessage());
            returnValue.put('erreur', true);
        }
     
        return returnValue;
        
    }
    
    @AuraEnabled
    public static Map<String ,Object> getProduct(String IdProdotto){
        Map<String ,Object> returnValue = new  Map<String ,Object>();
        returnValue.put('erreur', false);
        try {
               Product2 product= ProdottoService.getProdottoById(IdProdotto);
               returnValue.put('product', product);
        } catch (Exception e) {
            System.debug('errorMessage CreaAppuntamentoController getProduct '+e.getMessage());
             returnValue.put('erreur', true);
        }
        return returnValue;
    }

    @AuraEnabled
    public static Map<String ,Object> controleDateEvent(Date dateAppuntamento, String filialeName){
        String dAppunt=CGMWSUtils_1_0.ToString(dateAppuntamento);
        System.debug('dAppunt '+dAppunt);
        Map<String ,Object> returnValue = new  Map<String ,Object>();
        returnValue.put('erreur', false);
        try {
            System.debug('filialeName '+filialeName);
            Account filiale = AccountService.getFilialeByName(filialeName);     
            System.debug('filiale '+filiale);
            Set<Time> listHour = AppuntamentoDomainWS.appuntamentoDisponilitaCompleta(filiale.OCS_External_Id__c, dAppunt);
            System.debug('##################### DESK_SLOT_MAP test  '+AppuntamentoDomainWS.DESK_SLOT_MAP);
             returnValue.put('slotDesk', AppuntamentoDomainWS.DESK_SLOT_MAP);
            System.debug('test listHour '+listHour);
            List<Time> lt= new List<Time>();
            for(Time t :listHour){
                lt.add(t);
            }
            System.debug(' ################# Ora '+lt);
			returnValue.put('data', lt);            
        } catch (Exception e) {
            System.debug('errorMessage CreaAppuntamentoController '+e.getMessage());
             returnValue.put('erreur', true);
        }
        return returnValue;
    }
    

}