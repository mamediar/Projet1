public with sharing class TicketingCreazioneController {
    
    /* Chiamata per il recupero del Dealer, cerco prima in SF e poi in OCS */
    @AuraEnabled
    public static List<Account> getDealer(String CodDealer) {
        String dealString='Dealer';
		List<Account> DealerComp = new List<Account>();
        List<Account> Dealer = new List<Account>();
        String QueryAccount = 'SELECT Id, Name FROM Account WHERE RecordType.Name =:dealString AND Dealership_Code__c = '+CodDealer+' LIMIT 1';
        Dealer = Database.query(queryAccount);
        
        if(Dealer.size()>0 && !Dealer.isEmpty()){
            for(Account acc: Dealer){
                system.debug('DP Dealer.Name: '+acc.Name+' - Dealer.Id: '+acc.Id);               
				DealerComp.add(acc);
            }
            return DealerComp;
        }else{
            Account acc = XCSGestioneAnagraficaDealer.ricercaOCS(CodDealer);
            Map<Account, DealerAccount> accountMap = new Map<Account, DealerAccount>();
            if(acc!=null){             
            	accountMap.put(acc, null);
                XCSGestioneAnagraficaDealer.execute(accountMap,true);
                DealerAccount dealerAcc = accountMap.get(acc);
                if(dealerAcc!=null){
                    acc.Id = dealerAcc.account.Id;
					DealerComp.add(acc);
                }               
            }else{
                return null;
            }                        
            return DealerComp;
        }
	}
    
    /* Chiamata al modulo anagrafica per la ricerca del Cliente */
    @AuraEnabled
    public static Account getCliente(String CodCliente) {       
        Account acc = XCSGestioneAnagrafica.ricercaOCSUpdateCRM(CodCliente);
        if(acc!=null){
           return acc; 
        }else{
           return null;  
        }
    }

    /* Chiamata al servizio per il recupero della Pratica e del Cliente */
    @AuraEnabled
    public static List<OCSCliente> getPratica(String numeroPratica, String tipoDoc) { 
        system.debug('DP numeroPratica: '+numeroPratica);
        OCSRecuperaDatiPostvenditaResponse Resp = OCSRecuperaDatiPostvenditaInvoker.callRecDatiPVPratica(numeroPratica,tipoDoc);
        //OCSRecuperaDatiPostvenditaResponse Resp = OCSRecuperaDatiPostvenditaInvoker.callRecDatiPVPratica(numeroPratica,'CA'); Tipo Doc cablato per Test
        system.debug('DP RespPratica da OCSRecuperaDatiPostvenditaResponse: '+Resp);

        List<OCSCliente> tempClientList = OCSObjectsFactory.makeClienti(Resp);
        system.debug('DP tempClientList da OCSObjectsFactory.makeClienti(List<OCSCliente>): '+tempClientList);    
        
        return tempClientList;
    }
    
    /* Chiamata al servizio per il recupero della Data di Ultima Delibera */
    @AuraEnabled
    public static OCSRecuperaDataApprovazioneResponse getDataDelibera(String numeroPratica, String tipoDoc) { 
        system.debug('DP numeroPratica: '+numeroPratica);
        OCSRecuperaDataApprovazioneResponse Resp = OCSRecuperaDataApprovazioneInvoker.invoke(tipoDoc,numeroPratica);
        system.debug('DP RespPratica: '+Resp);
        //List<OCSCliente> tempClientList = OCSObjectsFactory.makeClienti(Resp);
        //system.debug('DP tempClientList: '+tempClientList);        
        
        return Resp;
    }
    
    /* Chiamata al servizio per il recupero Livello Firma */
    @AuraEnabled
    public static OCSGenericRecuperaDatiInvoker.GenericRecuperaDatiResponseDTO recuperaLivelloFirma(String tipoDoc,String numeroPratica){
        OCSGenericRecuperaDatiInvoker.Response res = OCSGenericRecuperaDatiInvoker.invoke('recuperaLivelloFirma', tipoDoc, numeroPratica, null, null, null);
        return res.genericRecuperaDatiResponseDTO[0];
    }
    
    /* Recupero il tipo di ufficio */
    @AuraEnabled
    public static String Ufficio(String CatExternalId) {
        System.debug('Cerco Ufficio. ');
        
        XCS_Categoria__c XCSCat = XCS_CategoriaUtil.findCategoryByExternalID(CatExternalId);
        String TipoUfficio = XCSCat.TKTOfficeType__c;
        return TipoUfficio;
    }
    
    /* Recupero la Cateogoria per popolare la lookup su case */
    @AuraEnabled
    public static String CatSFid(String CatExternalId) {       
        XCS_Categoria__c XCSCat = XCS_CategoriaUtil.findCategoryByExternalID(CatExternalId);
        String CatSFid = XCSCat.Id;
        return CatSFid;
    }
    
    /* Recupero Codici Filiali */
    @AuraEnabled
    public static Account getCodiciFiliale() {
        final String userId = System.UserInfo.getUserId();
        final Group gruppo = UserUtils.getFilialeUtenteById(userId);
        if(gruppo!=null){
            return AccountUtils.getFilialeAccount(gruppo.DeveloperName);
        }
        return null;
    }


    @AuraEnabled
    public static XCS_Categoria__c getCategoria(String catId) {
        XCS_Categoria__c cat = XCS_CategoriaUtil.findCategoryByExternalID(catId);
        System.debug('CATEGORIA:' + cat);
        return cat;
    }
    
    /* Controllo che lo User sia di tipo Filiale */
    /*@auraenabled
    public static Boolean isProfileFiliale() {
        String profileId = userinfo.getProfileId();
        List<Profile> profileList = [SELECT Name FROM Profile WHERE id=:profileId LIMIT 1];
        List<String> ProfiliFiliale = new List<String> {'Branch Employee', 'Branch Manager', 'Area Manager'
            ,'Region Manager', 'Agenti Borg', 'Trainer'};
        String profileName = (profileList == null ? '' : String.valueof(profileList[0].Name));

        if(ProfiliFiliale.contains(profileName)){
            return true;
        }else{
            return false;
        }
        
    }*/
    
    /* Recupero le info dal metadata in base al Category Id */
    @AuraEnabled
    public static list<TKTCreateFormConfiguration__mdt> getTKTForm(String CatId) {
        
        TKTCreateFormConfiguration__mdt[] TKTForms = [SELECT MasterLabel, 
                                                      FormType__c, 
                                                      IdCategoria__c ,
                                                      ErrorMessage__c,
                                                      Script__c,
                                                      DocType__c
                                                      FROM TKTCreateFormConfiguration__mdt
                                                      WHERE IdCategoria__c=:CatId 
                                                      AND IsActive__c = true];
        
        if(TKTForms.size()!=null){
            return TKTForms;
        }else{
            return null;
        }
        
    }
    
    /* Metodo per la creazione del caso con inserimento di Post e Allegati */
    @AuraEnabled
    public static void createRecord (Case Ticket, Map<String,String> MapFiles, String catIdS){
               
    //    try{
            System.debug('Ticket inizio Try'+Ticket);            
            list<ContentVersion> contVers = new list<ContentVersion>();
            list<ContentDocumentLink> cdlCont = new list<ContentDocumentLink>();         
    //        if(Ticket != null){
                Database.DMLOptions dmlOpts = new Database.DMLOptions();
   				dmlOpts.assignmentRuleHeader.useDefaultRule= true;
                Ticket.setOptions(dmlOpts);
                insert Ticket;                
                               
                FeedItem post = new FeedItem(); 
                post.ParentId = Ticket.Id; 
                post.Body = Ticket.Description; 
                
                insert post;
                
                if(MapFiles <> null && MapFiles.size()>0){                  
                    for(String mp: MapFiles.keySet()){     
                        contVers.add(new ContentVersion(Title = mp,
                                                        PathOnClient = mp,
                                                        ContentLocation = 'S',                                                        
                                                        VersionData = EncodingUtil.base64Decode(MapFiles.get(mp))));
                    }                    
                }
                
                insert contVers;
                
                for(ContentVersion ctv: contVers){                                        
                    ContentDocumentLink cdl = new ContentDocumentLink();
                    cdl.ContentDocumentId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: ctv.Id].ContentDocumentId;
                    cdl.LinkedEntityId = Ticket.Id;
                    cdl.ShareType = 'V';
                    cdlCont.add(cdl);                   
                }
                
                insert cdlCont;
                
    //        }else{
    //            System.debug('Ticket VUOTO!');
    //        }                       
    //    } catch (Exception ex){
    //        System.debug('Error: '+ex.getMessage());
    //    }        
    }
    
    /* Recupero RecordTypeId di Ticketing */
    @AuraEnabled
    public static String getRecordType() {
        String TKT_RECORDTYPE_ID = RecordTypeUtil.getCaseRecordType('Ticketing');
        return TKT_RECORDTYPE_ID;
    }
}