public  class CreaAppuntamentoController {

    @AuraEnabled(cacheable=true)
    public static Map<String ,Object>  getAllProductInteressato(){
        Map<String ,Object> returnValue = new  Map<String ,Object>();
        returnValue.put('erreur', false);
        try {
               List<Product2> products= ProdottoService.getProduct2(0,'');
               returnValue.put('products', products);
            
        } catch (Exception e) {
            System.debug('errorMessage CreaAppuntamentoController getAllProductDettaglio '+e.getMessage());
             returnValue.put('erreur', true);
        }
     
        return returnValue;
    }

    @AuraEnabled(cacheable=true)
    public static Map<String ,Object>  getAllProductDettaglio(String idParent){
        Map<String ,Object> returnValue = new  Map<String ,Object>();
        returnValue.put('erreur', false);
        try {
               List<Product2> products= ProdottoService.getProduct2(1,idParent);
               returnValue.put('products', products);
            
        } catch (Exception e) {
            System.debug('errorMessage CreaAppuntamentoController getAllProduct '+e.getMessage());
             returnValue.put('erreur', true);
        }
     
        return returnValue;
    }
    
    @AuraEnabled
    public static Map<String ,Object> getProvince(){
        
       Map<String ,Object> returnValue = new  Map<String ,Object>();
       returnValue.put('erreur', false);
       try {
       	List<AggregateResult> provinces = [select Provincia_Desc__c FROM XCS_Town__c 
                                        WHERE Catastale__c!=null GROUP BY Provincia_Desc__c];
		
        returnValue.put('xCSTown', provinces);
        } catch (Exception e) {
        System.debug('errorMessage CreaAppuntamentoController getProvinceCommune '+e.getMessage());
            returnValue.put('erreur', true);
        }
        return returnValue;
    }

    @AuraEnabled
    public static Map<String ,Object> getCommuneByProvince(String province){
        
       Map<String ,Object> returnValue = new  Map<String ,Object>();
       returnValue.put('erreur', false);
       try {
       	List<XCS_Town__c> comunes = [select Catastale__c,Comune__c FROM XCS_Town__c 
                                        WHERE Catastale__c!=null AND Provincia_Desc__c=:province];
		
        returnValue.put('comunes', comunes);
        } catch (Exception e) {
            System.debug('errorMessage CreaAppuntamentoController getProvinceCommune '+e.getMessage());
            returnValue.put('erreur', true);
        }
         return returnValue;
    }    
    
    @AuraEnabled
    public static Map<String ,Object> controlleDateEvent(date activityDate){
         Map<String ,Object> returnValue = new  Map<String ,Object>();
        returnValue.put('erreur', false);
        returnValue.put('existDate', false);
        try {
               List<Event> events= EventService.getEventsByDate(activityDate);
               returnValue.put('events', events);
                if (events.size()>0){
                returnValue.put('existDate', true);
                }
        } catch (Exception e) {
            System.debug('errorMessage CreaAppuntamentoController '+e.getMessage());
             returnValue.put('erreur', true);
        }
        return returnValue;
    }

    @AuraEnabled
    public static Map<String ,Object> createEvent(Event event,Account account,String filialeName,String timeEvent,  Map<Id ,Object> slotMap){
      //  System.debug(' ########################## runninf createEvent ############ ');
      	// DESK_SLOT_MAP

      	System.debug(' ########################## runninf createEvent AppuntamentoSlotDesk.DESK_SLOT ############ '+AppuntamentoSlotDesk.DESK_SLOT);
        Map<String ,Object> returnValue = new  Map<String ,Object>();
        List<Event> events= new List<Event>();
        List<XCS_Desk__c> desks= new List<XCS_Desk__c>();
        String[] strtime =timeEvent.split(':');
        Integer houre = integer.valueOf(strtime[0]);
   		Integer minutes = integer.valueOf(strtime[1]);
		System.debug('timeEvent '+timeEvent +'  ///// '+ strtime+' / '+houre);
        Datetime dtEvent=Datetime.newInstance(event.ActivityDate.year(), event.ActivityDate.month(), event.ActivityDate.day(), houre, minutes, 0);
        Datetime endtime=dtEvent.addMinutes(30);
        event.ActivityDateTime=dtEvent;
        event.StartDateTime=dtEvent;
        event.EndDateTime=endtime;
        event.DurationInMinutes=30;
        event.Type='Appuntamento';
        event.Subject='Appuntamento';   
        
        Account filiale = [SELECT Id,Name, LastName, FirstName,Phone,CittaSede__pc,getCodice_Cliente__c,Region_Name__c ,
                    			Sesso__pc,Provincia_Nascita__pc,Luogo_Nascita__pc,BillingAddress,ShippingStreet,
                           		ShippingCity,OCS_External_Id__c, ShippingState, ShippingPostalCode
                           		FROM Account WHERE RecordType.Name='Branch'
                                AND Name=:filialeName limit 1];
    	returnValue.put('disponibilita', true);
        returnValue.put('erreur', true);
        returnValue.put('rvFuture', false);
        returnValue.put('existCLiente', false);
        returnValue.put('calenarExist', false);
        returnValue.put('calenarName', '');
        try {
            if(account.Id==null){
                Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
                account.RecordTypeId = recordTypeId;
                Map<Account, Account> accountMap = new Map<Account, Account>();
				accountMap.put(account, null);
                XCSGestioneAnagrafica.execute(accountMap,true,false);
                account = accountMap.get(account);
                System.debug('account map '+account);
                event.Customer__c =account.Id;
                event.WhatId = account.Id;
            }else{
                update account;
                event.Customer__c =account.Id;
                event.WhatId = account.Id;
            }
             //WhatId, Subject
             //Integer durationInMinutes = Integer.ValueOf(event.DurationInMinutes);
             event.DurationInMinutes=30;
             String dateString=''+event.ActivityDateTime;
             DateTime activityDateTime = DateTime.ValueofGmt(dateString.replace('T', ' ')); 
             event.ActivityDateTime=activityDateTime;
            
            
            //check Account
            //events=EventService.getEventsByCliente(''+account.Codice_Fiscale__pc,''+account.PersonEmail); 
            date dateNow=date.today();
            events=[Select Id,Esito__c, Stato_Azione__c, Prodotto__c, Product__r.Name,Tipo_Occupazione__c,Customer__c, Type,
                     		Customer__r.LastName, Note__c, Telefono_Cellulare__c, Customer__r.Provincia_Nascita__pc, Desk__r.DeskName__c,Product__r.Parent__r.RSS_External_Id__c,
                     		Customer__r.Sesso__pc,Customer__r.Type,ActivityDate,ActivityDateTime,Customer__r.FirstName,Product__r.RSS_External_Id__c,
                     		Customer__r.PersonEmail,Customer__r.Phone,DurationInMinutes,Customer__r.Codice_Fiscale__pc,Desk__r.Branch__c,Customer__r.PersonMobilePhone
                                    FROM Event where ActivityDate >:dateNow
                                        AND Customer__c=:account.Id
                                        AND Customer__c!=null
                    					AND Stato_Azione__c !='Non presentato/Annullato'];
            System.debug('events '+events);
            if(events.size()==0){

                //check disponibiliy dateTime
                desks = XCSDeskService.getListDesk(''+filiale.Id);
                
                System.debug('test desks '+desks);
                String deskId = deskIsDisponility(desks, event.ActivityDate, event.ActivityDateTime,filiale.OCS_External_Id__c);
                if(deskId!=null){
                    event.Desk__c=deskId;
                    XCS_Desk__c myDesk= [select Id, DeskName__c  from XCS_Desk__c where Id=:deskId];
                    String nameClrd='F'+filiale.getCodice_Cliente__c;
                    
                    //assignedto
            		Calendar cldar =AppuntomentoQuery.getCalendarAppuntamento(nameClrd,'Public');
                    System.debug('################# myDesk.DeskName__c '+myDesk.DeskName__c);
                    Calendar cldarResource =AppuntomentoQuery.getCalendarAppuntamento(nameClrd+'-'+myDesk.DeskName__c,'Resource');
            		returnValue.put('calenarName',nameClrd);
                    if(cldar.Id!=null){
                        returnValue.put('calenarExist', true);
                		event.OwnerId= cldar.Id;
                        insert event;
                        Map<String ,Object> resultMail= mailDem(event.Id, filiale.ShippingStreet,filiale.ShippingCity,filiale.ShippingPostalCode,filiale.Phone);
                        Map<String ,Object> resultsms =smsDem(event.ActivityDateTime ,event.Customer__r.Phone,filiale.ShippingPostalCode);
                        System.debug('resultsms '+resultsms);
                        returnValue.put('erreur', false);
                        if(resultMail.get('erreur')==true){
                            System.debug('error to send mail');
                        }else {
                            System.debug('mail send to cliente');
                        }
            		}else {
                        returnValue.put('calenarExist', false);
                        //returnValue.put('erreur', true);
                        returnValue.put('calenarName',nameClrd);
                		System.debug('############### calendar is null');
            		}
                    
                }else {
                    returnValue.put('disponibilita', false);
                    //returnValue.put('erreur', true);
                }
                returnValue.put('newEvent', event);
                returnValue.put('existCLiente', false);
            }else {
                returnValue.put('existCLiente', true);
                //returnValue.put('erreur', true);
            }
            returnValue.put('newEvent', event);
        } catch (Exception e) {
            System.debug('errorMessage CreaAppuntamentoController createEvent '+e.getMessage()+' '+e.getLineNumber());
            returnValue.put('erreur', true);
            returnValue.put('message', e.getMessage()+' '+e.getStackTraceString()+' '+e.getLineNumber());
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
    
    @AuraEnabled
    public static Map<String, Object> controlDateNascitaCliente(Date dateNascita){
        Map<String ,Object> returnValue = new  Map<String ,Object>();
        returnValue.put('erreur', false);
        returnValue.put('validDate', false);
        Date today = Date.today();
        try{
			Date min = Date.newInstance(today.year()-90, today.month(), today.day());
            Date max = Date.newInstance(today.year()-18, today.month(), today.day());
            if(min<=dateNascita && dateNascita<=max){
                returnValue.put('validDate', true);
            }
        } catch (Exception e) {
            System.debug('errorMessage CreaAppuntamentoController '+e.getMessage());
             returnValue.put('erreur', true);
        }
        return returnValue;
    }
    
    @AuraEnabled
    public static Map<String ,Object> calcolaCodiceFiscale(Account cliente, String catastale){
        System.debug('cliente '+cliente);
        String Nome = cliente.FirstName;
        String Cognome = cliente.LastName;
        Boolean maschio = (cliente.Sesso__pc=='M')?true:false;
        Date dataNascita = cliente.Data_Nascita__c;
        String Comune = catastale;
        Map<String ,Object> returnValue = new  Map<String ,Object>();
        Set<String> alfabeto = new Set<String>{'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'};
        String[] alfabetoList = new String[]{'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'};
        Set<String> vocali = new Set<String>{'A','E','I','O','U'};
        List<String> mesi = new String[]{'A','B','C','D','E','H','L','M','P','R','S','T'};
        
        try {
        returnValue.put('error', 'false');
        Nome = (Nome==null)?'':Nome;
        Cognome = (Cognome==null)?'':Cognome;
        maschio = (maschio==null)?false:maschio;
        Comune = (Comune==null)?'':Comune;
        dataNascita = (dataNascita==null)?System.today():dataNascita;

        System.debug('cliente '+Nome +' '+Cognome+' /'+maschio+'/'+'/'+Comune+'/'+dataNascita);
        Integer Giorno=dataNascita.day();
        //Integer AnnoSecolo = Integer.valueOf(String.valueOf(dataNascita.year()).subString(0,2));
        String annoDecennio=String.valueOf(dataNascita.year()).subString(2,4);
        //String AnnoUnita=String.valueOf(dataNascita.year()).subString(3,4);
        String Mese = mesi[dataNascita.month()-1];
        Integer Sesso = (maschio)?0:1;

        String strCodFis='';
        String strcognome='';
        String strnome='';
        String strgiornosex='';
        String chrcontrollo='';
        Integer gs=0;
        Integer somma=0;
        // Processa il cognome
        //----------------------------------------------------------------
        for (Integer i=0; i<Cognome.length(); i++){
            String c = Cognome.substring(i,i+1).toUpperCase();
            if(vocali.contains(c)==false){
                if(alfabeto.contains(c)) strcognome = strcognome + c;
            }
        }

        if (strcognome.length() < 3){
            for (Integer i=0; i<Cognome.length(); i++){
                String c = Cognome.substring(i,i+1).toUpperCase();
                if(vocali.contains(c)) strcognome = strcognome + c;
            }
        }
        if (strcognome.length() < 3) for (Integer i=strcognome.length(); i<=3; i++){
            strcognome = strcognome + 'X';
        } 

        strcognome = strcognome.substring(0,3);

        //------------------------------------------------------------

        // Processa il nome
        //----------------------------------------------------------------
        for (Integer i=0; i<Nome.length(); i++){
            String c = Nome.substring(i,i+1).toUpperCase();
            if(vocali.contains(c)==false){
                if(alfabeto.contains(c)) strnome = strnome + c;
            }
        }

        if (strnome.length() > 3){
            strnome = strnome.substring(0,1) + strnome.substring(2,4);
        }else{
            if (strnome.length() < 3){
                for (Integer i=0; i<Nome.length(); i++){
                    String c = Nome.substring(i,i+1).toUpperCase();
                    if(vocali.contains(c)) strnome = strnome + c;
                }
            }
            if (strnome.length() < 3) for (Integer i=strnome.length(); i<=3; i++) strnome = strnome + 'X';
        }

        strnome = strnome.substring(0,3);
        //------------------------------------------------------------


        // processa giorno e sesso
        //--------------------------------------------
        gs = Giorno + (40 * Sesso);
        if(gs<10) strgiornosex = '0' + gs;
        else strgiornosex =  ''+gs;
        //--------------------------------------------
        strCodFis = strcognome + strnome + annoDecennio + Mese + strgiornosex + Comune;
        System.debug(strcognome +'/'+ strnome +'/'+ annoDecennio +'/'+ Mese +'/'+ strgiornosex +'/'+ Comune);
        System.debug('strCodFis '+strCodFis);
        // calcola la cifra di controllo
        //--------------------------------------------
        for (Integer i=0; i<15; i++){
            String c = strCodFis.substring(i,i+1);
            if ( Math.mod((i+1),2) != 0){ //caratteri dispari
                if(c=='0' || c == 'A') somma+=1;
                else if(c=='1' || c == 'B') somma+=0;
                else if(c=='2' || c == 'C') somma+=5;
                else if(c=='3' || c == 'D') somma+=7;
                else if(c=='4' || c == 'E') somma+=9;
                else if(c=='5' || c == 'F') somma+=13;
                else if(c=='6' || c == 'G') somma+=15;
                else if(c=='7' || c == 'H') somma+=17;
                else if(c=='8' || c == 'I') somma+=19;
                else if(c=='9' || c == 'J') somma+=21;
                else if(c == 'K') somma+=2;
                else if(c == 'L') somma+=4;
                else if(c == 'M') somma+=18;
                else if(c == 'N') somma+=20;
                else if(c == 'O') somma+=11;
                else if(c == 'P') somma+=3;
                else if(c == 'Q') somma+=6;
                else if(c == 'R') somma+=8;
                else if(c == 'S') somma+=12;
                else if(c == 'T') somma+=14;
                else if(c == 'U') somma+=16;
                else if(c == 'V') somma+=10;
                else if(c == 'W') somma+=22;
                else if(c == 'X') somma+=25;
                else if(c == 'Y') somma+=24;
                else if(c == 'Z') somma+=23;
            }   else //caratteri pari
            {
                if(c=='0' || c == 'A') somma+=0;
                else if(c=='1' || c == 'B') somma+=1;
                else if(c=='2' || c == 'C') somma+=2;
                else if(c=='3' || c == 'D') somma+=3;
                else if(c=='4' || c == 'E') somma+=4;
                else if(c=='5' || c == 'F') somma+=5;
                else if(c=='6' || c == 'G') somma+=6;
                else if(c=='7' || c == 'H') somma+=7;
                else if(c=='8' || c == 'I') somma+=8;
                else if(c=='9' || c == 'J') somma+=9;
                else if(c == 'K') somma+=10;
                else if(c == 'L') somma+=11;
                else if(c == 'M') somma+=12;
                else if(c == 'N') somma+=13;
                else if(c == 'O') somma+=14;
                else if(c == 'P') somma+=15;
                else if(c == 'Q') somma+=16;
                else if(c == 'R') somma+=17;
                else if(c == 'S') somma+=18;
                else if(c == 'T') somma+=19;
                else if(c == 'U') somma+=20;
                else if(c == 'V') somma+=21;
                else if(c == 'W') somma+=22;
                else if(c == 'X') somma+=23;
                else if(c == 'Y') somma+=24;
                else if(c == 'Z') somma+=25;
            }
        }
        somma = Math.mod(somma,26);
        chrcontrollo = alfabetoList[somma];
        //--------------------------------------------

        strCodFis = strCodFis + chrcontrollo;
		returnValue.put('strCodFis', strCodFis);
        }catch (Exception e) {
            returnValue.put('error', 'true');
            returnValue.put('message', e.getMessage()+' / '+e.getStackTraceString()+' / '+e.getLineNumber());
        }
        return returnValue;
    }
    
    @AuraEnabled
    public static Map<String ,Object> getAccountByIdCliente(String idAccount){
          Map<String ,Object> returnValue = new  Map<String ,Object>();
       returnValue.put('erreur', false);
       try {
       		Account account = AccountService.getAccountById(idAccount) ;
            returnValue.put('account', account);
        } catch (Exception e) {
            System.debug('errorMessage CreaAppuntamentoController getProvinceCommune '+e.getMessage());
            returnValue.put('erreur', true);
        }
     
        return returnValue;
        
    }
	
    @AuraEnabled
    public static String deskIsDisponility(List<XCS_Desk__c> desks, Date activityDate, Datetime dt,String filialeOCSExternal){
        Map<Id,Object> listoDeskSlot = new  Map<Id,Object>();
        String dAppunt=CGMWSUtils_1_0.ToString(activityDate);
        Set<Time> listHour = AppuntamentoDomainWS.appuntamentoDisponilitaCompleta(filialeOCSExternal, dAppunt);
        
        listoDeskSlot=AppuntamentoDomainWS.DESK_SLOT_MAP;
        System.debug('##################### DESK_SLOT_MAP test  '+listoDeskSlot);
         Map<String,Object>  eventMap = AppuntamentoDomainWS.oraDisponibilita(dt.time(), listHour,activityDate,false); 
         System.debug('###############  eventMap ++++++++++ '+eventMap);
         Event ev  = (Event) eventMap.get('event');
        return ev.Desk__c;
}
    

    @AuraEnabled
    public static Map<String ,Object> getFiliales( String  societa,String  utenteEsterno,String  utenteInterno, String prodotoName){
       AppuntamentoListaFilialiService service= new AppuntamentoListaFilialiService();
       Map<String ,Object> returnValue = new  Map<String ,Object>();
       returnValue.put('erreur', false);
       System.debug(societa+'/'+utenteEsterno+'/'+utenteInterno+'/'+prodotoName);
       try {
       		AppuntamentoListaFilialiResponse response = service.buildAppuntamentoListaFiliali(societa, utenteEsterno, utenteInterno, prodotoName);
           // System.debug(' ************ respose ********'+JSON.stringify(response));
           System.debug('################## response  getFiliales '+ response);
            System.debug('################## response  getFiliales '+ response.xml.result.Filiali);
         List<dataLocator> dataLos= getDataLocation(response.xml.result);
           returnValue.put('listFiliale', response.xml.result.Filiali);  
            returnValue.put('result', dataLos);
        } catch (Exception e) {
            System.debug('errorMessage CreaAppuntamentoController getFiliales '+e.getMessage());
             returnValue.put('message', e.getMessage()+' '+e.getCause()+' '+e.getLineNumber());
             returnValue.put('erreur', true);
        }
     
        return returnValue;
    }
  
    @AuraEnabled
    public static Map<String ,Object> getFilialeById( String  idFiliale){
       Map<String ,Object> returnValue = new  Map<String ,Object>();
       returnValue.put('erreur', false);
       try {
       		Account filiale = [SELECT Id,Name, LastName, FirstName,Phone,CittaSede__pc,getCodice_Cliente__c,
                    			Provincia_Nascita__pc,Luogo_Nascita__pc,BillingAddress,ShippingStreet, 
                               	ShippingCity, ShippingState, ShippingPostalCode
                           		FROM Account WHERE RecordType.Name='Branch'
                                AND id=:idFiliale limit 1];
            returnValue.put('result', filiale);
        } catch (Exception e) {
            System.debug('errorMessage CreaAppuntamentoController getFilialeById '+e.getMessage());
             returnValue.put('message', e.getMessage()+' '+e.getCause()+' '+e.getLineNumber());
             returnValue.put('erreur', true);
        }
        return returnValue;
    }
  
    @AuraEnabled
    public static Map<String ,Object> checkOperator(String idClient){
        Map<String ,Object> returnValue = new  Map<String ,Object>();
        Event eventEx= new Event();
        date dateNow=date.today();
        returnValue.put('erreur', false);
        returnValue.put('filialeOperator','');
        returnValue.put('modificaEvent', false);
        returnValue.put('eventToModifi', '');
        returnValue.put('eventClientExist',false);
        try {
            String use= UserInfo.getUserId();
            Boolean isbranch =PermissionUtils.isBranch(use);
            if(isbranch){
                
                returnValue.put('isbranch', true);
                User useOperator=[select id,name,profile.name,UserRole.Name from User where id=:use and profile.name in (:PermissionUtils.BRANCH_MANAGER, :PermissionUtils.BRANCH_EMPLOYEE)];
                String roleName = useOperator.UserRole.Name;
                roleName=roleName.replace(' ', '_');
                Account filiale = [SELECT Id,Name,CittaSede__pc,getCodice_Cliente__c,Provincia_Nascita__pc,Luogo_Nascita__pc,BillingAddress,ShippingStreet, 
                               	ShippingCity, ShippingState, ShippingPostalCode FROM Account WHERE RecordType.Name='Branch'
                                                                                AND NameRoleReference__c =:roleName limit 1];
                if(filiale.Id!=null){
                    returnValue.put('filialeOperator', filiale.Id);
                    //checkDisponiblita
                    if(idClient!=null){
                        List<Event> events=[Select Id,Esito__c, Stato_Azione__c, Prodotto__c, Product__r.Name,Tipo_Occupazione__c,Customer__c, Type,Product__r.RSS_External_Id__c,
                     		Customer__r.LastName, Note__c, Telefono_Cellulare__c, Customer__r.Provincia_Nascita__pc, Desk__r.DeskName__c,Product__r.Parent__r.RSS_External_Id__c,
                     		Customer__r.Sesso__pc,Customer__r.Type,ActivityDate,ActivityDateTime,Customer__r.FirstName,Desk__r.Branch__r.RSS_External_Id__c,Customer__r.PersonMobilePhone,
                     		Customer__r.PersonEmail,Customer__r.Phone,DurationInMinutes,Customer__r.Codice_Fiscale__pc,Desk__r.Branch__c
                                    FROM Event where ActivityDate >:dateNow
                                        AND Customer__c=:idClient
                                        AND Customer__c!=null
                    					AND Stato_Azione__c !='Non presentato/Annullato'];
                        if(events.size()>0){
                            returnValue.put('eventClientExist',true);
                            eventEx=events[0];
                            if(events[0].Desk__r.Branch__c==filiale.Id){
                                returnValue.put('modificaEvent', true);
                                returnValue.put('eventToModifi', eventEx);
                            }else {
                                returnValue.put('modificaEvent', false);
                                Account fale = [SELECT Id,Name,RSS_External_Id__c FROM Account WHERE RecordType.Name='Branch' AND Id=:eventEx.Desk__r.Branch__c];
                                returnValue.put('messageExistClient', 'il cliente ha già un appuntamento il giorno '+' '+eventEx.ActivityDateTime.date().format() +' alle ore '+ eventEx.ActivityDateTime.time() +' presso la filaile di '+ fale.Name+''); 
                            }
                        }
                    }
                }
                                                                                
            }else {
                returnValue.put('isbranch', false);
            }    
        } catch (Exception e) {
            System.debug('errorMessage CreaAppuntamentoController checkOperator '+e.getMessage());
            returnValue.put('message', e.getMessage()+' '+e.getCause()+' '+e.getLineNumber());
        }
        return returnValue;
    }

    @AuraEnabled
    public static  Map<String ,Object> chekDisponibleDeskByFiliale(String filialeName,String idclient){
        Map<String ,Object> returnValue = new  Map<String ,Object>();
        returnValue.put('erreur', false);
        returnValue.put('deskDisponible', false);
        returnValue.put('modificaEvent', false);
        returnValue.put('eventToModifi', '');
        returnValue.put('eventClientExist',false);
        date dateNow=date.today();
        List<Event> events=[Select Id,Esito__c, Stato_Azione__c, Prodotto__c, Product__r.Name,Tipo_Occupazione__c,Customer__c, Type,Product__r.RSS_External_Id__c,
                     		Customer__r.LastName, Note__c, Telefono_Cellulare__c, Customer__r.Provincia_Nascita__pc, Desk__r.DeskName__c,Product__r.Parent__r.RSS_External_Id__c,
                     		Customer__r.Sesso__pc,Customer__r.Type,ActivityDate,ActivityDateTime,Customer__r.FirstName,Desk__r.Branch__r.RSS_External_Id__c,
                     		Customer__r.PersonEmail,Customer__r.Phone,DurationInMinutes,Customer__r.Codice_Fiscale__pc,Desk__r.Branch__c,Customer__r.PersonMobilePhone
                                    FROM Event where ActivityDate >:dateNow
                                        AND Customer__c=:idclient
                                        AND Customer__c!=null
                    					AND Stato_Azione__c !='Non presentato/Annullato'];
        try{
			Map<String ,Object> valueisActiveDesk= AppuntomentoQuery.chekDisponibleDeskByFiliale(filialeName);
            if(valueisActiveDesk.get('DeskActive')==true){
                returnValue.put('deskDisponible', true);
                
                if(events.size()>0){
                    returnValue.put('eventClientExist',true);
                    Event eventEx= new Event();
                    String use= UserInfo.getUserId();
                    Boolean isbranch =PermissionUtils.isBranch(use);
                    eventEx=events[0];
                    if(isbranch){
                        User useOperator=[select id,name,profile.name,UserRole.Name from User where id=:use and profile.name in (:PermissionUtils.BRANCH_MANAGER, :PermissionUtils.BRANCH_EMPLOYEE)];
                        String roleName = useOperator.UserRole.Name;
                        roleName=roleName.replace(' ', '_');
                        Account filiale = [SELECT Id,Name,CittaSede__pc,getCodice_Cliente__c,Provincia_Nascita__pc,Luogo_Nascita__pc,BillingAddress,ShippingStreet, 
                                        ShippingCity, ShippingState, ShippingPostalCode FROM Account WHERE RecordType.Name='Branch'
                                                                                        AND NameRoleReference__c =:roleName limit 1];

                        Boolean evenFiliale=false;
                        for(Integer index=0; index < events.size() ; index++){
                            if(events[index].Desk__r.Branch__c==filiale.Id){
                                evenFiliale=true;
                                eventEx=events[index];
                                break;
                            }
                        }
                        if(evenFiliale){
                            returnValue.put('modificaEvent', true);
                            returnValue.put('eventToModifi', eventEx);
                        }else{
                            returnValue.put('modificaEvent', false);
                            Account fale = [SELECT Id,Name,RSS_External_Id__c FROM Account WHERE RecordType.Name='Branch' AND Id=:eventEx.Desk__r.Branch__c];
                            returnValue.put('messageExistClient', 'il cliente ha già un appuntamento il giorno '+' '+eventEx.ActivityDateTime.date().format() +' alle ore '+ eventEx.ActivityDateTime.time() +' presso la filaile di '+ fale.Name+''); 

                        }
                    }else {
                        returnValue.put('modificaEvent', true);
                        returnValue.put('eventToModifi', eventEx);
                    }
                }
            }else {
                returnValue.put('deskDisponible', false);
            }
        } catch (Exception e) {
            System.debug('errorMessage CreaAppuntamentoController chekDisponibleDeskByFiliale'+e.getMessage());
            returnValue.put('erreur', true);
        }
        return returnValue;
    }

    @AuraEnabled
    public static Map<String ,Object> mailDem( Id idEvent,String indirizzo,String citta, String cap, String telefone){
        Map<String ,Object> returnValue = new  Map<String ,Object>();
        returnValue.put('erreur', false);
        Event event= [select Id,Customer__r.PersonEmail, Customer__r.Name, ActivityDateTime,ActivityDate from Event where Id=:idEvent];
        String nameTemplate = 'DEM575';
        EmailTemplate template = [SELECT Id, HtmlValue, Body  FROM EmailTemplate WHERE Name =:nameTemplate];
        List<Messaging.SingleEmailMessage> allMsg = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setReplyTo('richiesta@compass.it');
        mail.setToAddresses(new String[] {''+event.Customer__r.PersonEmail});//+event.Customer__r.PersonEmail
        mail.setTemplateID(template.Id);
        mail.setSaveAsActivity(true);
        mail.setSubject(event.Customer__r.Name+', il tuo appuntamento in filiale è stato fissato!');
        mail.setSenderDisplayName('Compass Banca S.p.A.');
        String htmlBody = template.HtmlValue;
        String plainBody = template.Body;
        
        htmlBody = htmlBody.replace('{!Contact.Name}',''+event.Customer__r.Name);
        htmlBody = htmlBody.replace('{!Event.ActivityDate}',''+event.ActivityDate);
        htmlBody = htmlBody.replace('{!Event.StartDateTime}',''+event.ActivityDateTime.time());
        htmlBody = htmlBody.replace('{!AccountRichiesteDEM__c.DEM_Param_6__c}',indirizzo);
        htmlBody = htmlBody.replace('{!XCS_Desk__r.Branch__r.ShippingAddress}',indirizzo);
        htmlBody = htmlBody.replace('{!AccountRichiesteDEM__c.DEM_Param_7__c}',citta);
        htmlBody = htmlBody.replace('{!Contact.codice_Lista__c}',cap);
        htmlBody = htmlBody.replace('{!Contact.DEM_Param_10__c}',telefone);

        
        //send mail
        mail.setHtmlBody(htmlBody);
        allMsg.add(mail);
        try {
            List<Messaging.SendEmailResult> results = Messaging.sendEmail(allMsg);
             returnValue.put('erreur', false);
        } catch (EmailException e) {
             returnValue.put('erreur', true);
            System.debug('sendTemplatedEmail error. ' + e.getMessage());
        }
        return returnValue;
    }

    @AuraEnabled
    public static Map<String ,Object> smsDem(Datetime dt,String telefone,String indirizzo){
        Map<String ,Object> returnValue = new  Map<String ,Object>();
        returnValue.put('erreur', false);
        List<XCS_Template__c> templateTesto = [SELECT Body__c FROM XCS_Template__c Where Name='SMSFISSAPT – Conferma'];
        String htmlBody = templateTesto[0].Body__c;
        htmlBody = htmlBody.replace('{0}',indirizzo);
        htmlBody = htmlBody.replace('{1}',telefone);
        htmlBody = htmlBody.replace('{2}',''+dt.date()) ;
        htmlBody = htmlBody.replace('{3}',''+dt.time());
        try {
            OCSInviaSMSInvoker.inviaSMS('WEB2', telefone, '','',htmlBody);
            returnValue.put('erreur', false);
        } catch (EmailException e) {
            returnValue.put('erreur', true);
            System.debug('sendTemplatedSMS error. ' + e.getMessage());
        }
        return returnValue;
    }

    @AuraEnabled
    public static List<dataLocator> getDataLocation(AppuntamentoListaFilialiResponse.Result result){
        List<dataLocator> dataLos= new List<dataLocator>();
       
        Integer index=0;
        System.debug('############## result '+ result.puntoRicercato);
        System.debug('############## result '+ result.Filiali);
        /* Location location = new  Location();
        List<String>  coordinates =  result.puntoRicercato.coordinates.split(',');
        String longitude;
        String latitude;
        if(coordinates.size() != 0){
         longitude = coordinates[0];
         latitude = coordinates[1];
        } */
         if(result.Filiali!=null){
            for(index=0; index < result.Filiali.size() ; index++) {
                System.debug('cdata//ele_text '+result.Filiali[index].ele_text);
                Location location = new  Location();
                dataLocator dataLo= new dataLocator();
                dataLo.title = result.Filiali[index].indirizzo;
                dataLo.description = result.Filiali[index].area;
                location.Latitude = result.Filiali[index].latitudine;
                location.Longitude = result.Filiali[index].longitudine;

                dataLo.location=location;
                dataLos.add(dataLo);
            }
        } 
       // dataLocator dataLo= new dataLocator();
       // dataLo.location=location;
       // dataLos.add(dataLos);  
        return dataLos;
    }

    public class dataLocator{
        @AuraEnabled
        public  String title {get;set;}
        @AuraEnabled
        public  String description {get;set;}
        @AuraEnabled
        public  Location location {get;set;}
    }

    public class Location{
        @AuraEnabled
        public  String Latitude {get;set;}
        @AuraEnabled
        public  String Longitude {get;set;}
    }
}