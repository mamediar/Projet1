public without sharing class CRMReclamiGestioneContainerController{
    @AuraEnabled 
    public static InitCustomDataDTO loadCustomDataApex(Case c, Account a, Account_Futuro_MBCS__c f){
        InitCustomDataDTO res=new InitCustomDataDTO();
         
        //OCSCliente 
        if(c.Referenced_Company__c.equals(XCSCompassConstants.COMPASS) && String.isNotEmpty(a.OCS_External_Id__c)){
            System.debug('a.OCS_External_Id__c = ' + a.OCS_External_Id__c);
            System.debug('Check 1');
            res.cliente=getOCSClienteById(a.getCodice_Cliente__c,c.Referenced_Company__c);
            System.debug(res.cliente.dataNascita);
        }
        else if(c.Referenced_Company__c.equals(XCSCompassConstants.FUTURO) && String.isNotEmpty(f.External_Id__c)){
            System.debug('Check 2');
            res.cliente=getOCSClienteById(f.External_Id__c.substring(1),c.Referenced_Company__c);
             System.debug(res.cliente);
        }
        else{ 
            Map<String,String> praticaMap=new Map<String,String>();
            praticaMap.put('numPratica',c.NumeroPratica__c);
            praticaMap.put('pan',c.PAN__c);
            //praticaMap.put('cedCom',); cedente/committente
            if(c.Referenced_Company__c.equals(XCSCompassConstants.COMPASS)){
                res.cliente=getOCSClienteByAccount(a,praticaMap);
            }else{
                res.cliente=getOCSClienteByAccountFuturoMBCS(f,praticaMap);
            }
             System.debug('Check 3');
             System.debug(res.cliente);
        }
       
        //Categoria
         res.categoria=[select Id,Name,Parent__c,Livello__c,External_Id__c
                       from XCS_Categoria__c
                       where Id In (Select Categoria_Riferimento__c From Case Where id =:c.id)];
        
        //Tipo
        String area=c.Referenced_Company__c;
        try{
            if(area.equals(XCSCompassConstants.COMPASS) || area.equals(XCSCompassConstants.FUTURO)){
                res.tipo=[select Id,Area__c from CRM_RCL_Tipologia_Reclamo__mdt where External_Id__c=:c.Tipo_Reclamo__c and Area__c=:area];
            }
            else{
                res.tipo=[select Id,Area__c from CRM_RCL_Tipologia_Reclamo__mdt where External_Id__c=:c.Tipo_Reclamo__c];
            }
        }
        catch(Exception e){
            System.debug('Exception');
            System.debug(e);
        }
        
        //pratica
        if(c.Referenced_Company__c.equals(XCSCompassConstants.COMPASS)){
            res.pratica=makePraticaCompass(makePraticaMap(c,a.getCodice_Cliente__c));
        }
        else if(c.Referenced_Company__c.equals(XCSCompassConstants.FUTURO)){
            res.praticaFuturo=makePraticaFuturo(makePraticaMap(c,'Stub'));
        }
        
        //coda mdt
        res.codaSelezionata=getCodaMdt(c.OwnerId);
        
        //Mittenti
        res.mittenti=[select Autorita__c,Citta__c,Codice_Postale__c,Email__c,External_Id__c,Incident_Id__c,Name__c,
                      Predefinito__c,Principale__c,Provincia__c,Salutation__c,Tipologia__c,Via__c,Name
                      from XCS_Mittente__c
                      where Case__c=:c.Id];
        
      

        res.allegati = XCSReclamiUtils.documentToAttachment(c.Id);
        //MS_ATTACHMENT************************************************


        System.debug('CRMReclamiGestioneContainerController loadCustomDataApex res: '+res);
        
        //recupero modalita invio 
        Schema.DescribeFieldResult fieldResult = Case.Modalita_Invio__c.getDescribe();
        System.debug('FIELD RESULT');
        System.debug(fieldResult);
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
         System.debug('PLE');
         System.debug(ple);
        for(Schema.PicklistEntry pickListVal : ple){
            System.debug('Picklist: '+pickListVal.getValue() + ' Modalita invio '+c.Modalita_Invio__c);
            if(pickListVal.getValue().equals(c.Modalita_Invio__c)){
                res.modalitaInvio=pickListVal.getLabel();
            }
        }
        System.debug('/****************'+res.modalitaInvio);
        //recupero stage inadempimento (!!!!!!!!!!!!!!!!!!!!!!!!!!!!!TO DELETE!!!!!!!!!!!!!!!!!!!!!!!!!!! se non va bene)
        Schema.DescribeFieldResult fieldResultInad = Case.Stage_Inadempimento__c.getDescribe();
        List<Schema.PicklistEntry> pleInad = fieldResultInad.getPicklistValues();
        for(Schema.PicklistEntry pickListVal : pleInad){
            if(pickListVal.getValue().equals(c.Stage_Inadempimento__c)){
                res.stageInadempimento=pickListVal.getLabel();
            }
        }
        
        /*Boris Registro l'evento open by account*/
        Case cas = [Select id, assegnatario__c, isEscalated From Case Where id =:c.Id];
        Id utente = UserInfo.getUserId();
        if(cas.IsEscalated && utente == cas.Assegnatario__c){
            insert XCSReclamiUtils.createFeedItem(c.id, System.now(), 'open by account', UserInfo.getName(), true);
            cas.isEscalated=false;
            update cas; 
        }        

        return res;
    }
    
    public class NoPermissionException extends Exception{}
    
    @AuraEnabled
    public static Case getCase(Id recordId){
        return [Select status From Case Where id= :recordId];
    }
    
    @AuraEnabled
    public static void salvaReclamoApex(String inputJson, String societa, List<Attachment> fileList, Case reclamoSelezionato, Boolean isQueueChanged, Case currentC, String recordId){ 

        XCSReclamiInput data = XCSReclamiUtils.getInputObj(inputJson, societa);
        
        // hasIDMResponse(data, fileList , societa); da DECOMMENTARE per attivare la Risposta ad IDM 
        
        System.debug('CRMReclamiGestioneContainerController salvaReclamoApex INPUTJSON deserialized' + data);
        System.debug('CRMReclamiGestioneContainerController salvaReclamoApex isGRAVE' + data.dettagliOutputObj.headerOutput.isGrave);
        
        //handleInadempimento( XCSReclamiUtils.getGrave(data.dettagliOutputObj.headerOutput.categoriaDettagli), recordId, societa);
        // reclamoSelezionato.stage_inadempimento__c='4165'; Va messa in inserimento
        XCSReclamiUtils.salvaReclamo(data, societa, fileList, reclamoSelezionato, isQueueChanged, recordId);
        
        	}
		        
    
    @AuraEnabled
    public static boolean isInadempimentoChangeStatusCTRL(String recordId, String stageInadempimento){
        Case c = [Select id,Stage_Inadempimento__c from Case where id =:recordId];
        String status = null;
        System.debug('Prima '+stageInadempimento);
        System.debug('Dopo '+c.Stage_Inadempimento__c);
	
        if(stageInadempimento == '4166' && c.Stage_Inadempimento__c =='4165'){
            status = 'F&T Sent';
        }
        if(status != null){
            c.status = status;
            update c;
            return true;
        }
        return false;
    }


    @AuraEnabled
    public static Id getListViewId(){
         return [SELECT Id FROM ListView WHERE SobjectType = 'Case' and DeveloperName = 'AllCases'].Id;
    }
    
        @AuraEnabled
    public static boolean isFrodeCTRL(String categoria, String societa, String recordId){
       Case c = [Select id, is_frode__c from Case where id=:recordId];
       if(XCSReclamiUtils.isFrode(categoria, societa) && !c.is_frode__c){
           c.Status = 'F&T Sent';
           c.is_frode__c = true;
           update c;
           return true;
       }
       else if(!XCSReclamiUtils.isFrode(categoria, societa) && c.is_frode__c){
           c.is_frode__c = false;
           update c;
           return false;
       }
       return null;
   }
    
    @AuraEnabled
    public static boolean hasEditAccess(Id caseId){
        return WithSharingUtils.hasEditAccess(caseId);
    }
        
    
    @AuraEnabled
    public static Map<String,Double> hasIDMResponse(Boolean isIDMSelected, List<Attachment> allegatiSelezionati, String societa, String recordId){
        Map<String,Double> res = new  Map<String,Double>();
        List<Attachment> attachmentCaseChild = new List<Attachment>();
        
        if(isIDMSelected){
            Case caseSi = [SELECT Id,Status FROM Case WHERE Id = : recordId];
            caseSi.Status = 'STAMPA IDM';
            update caseSi;
            Case caseChild = new Case (ParentId = caseSi.Id );
            Group g = findIDMQueue(societa);
            if(g != null)
                caseChild.OwnerId = g.Id;
            
            Insert caseChild;
            
            XCSReclamiUtils.createFile(allegatiSelezionati, caseChild.Id);
            
            
        } else {
            
            Case caseNo = [SELECT Id,Status FROM Case WHERE Id = : recordId];
            caseNo.Status = 'Gestito'; 
            Update caseNo;
            
        }
        
        
        res.put('CaseIdm',0);
        res.put('AttachmentIdm',0);
        return res;
        
    }
   
    
    @TestVisible
    private static Group findIDMQueue(String societa){
        Group queue = new Group();
        if (societa.equalsIgnoreCase(XCSCompassConstants.COMPASS)){
            queue = [SELECT Id, Type, Email, Name, DeveloperName FROM Group 
                     WHERE Type = 'Queue' 
                     AND DeveloperName = 'Q251' LIMIT 1];
            // return queue;
        }
        else{
            if (societa.equalsIgnoreCase(XCSCompassConstants.FUTURO)){
                queue = [SELECT Id, Type, Email, Name, DeveloperName FROM Group 
                         WHERE Type = 'Queue' 
                         AND DeveloperName = 'Q299' LIMIT 1];
                // return queue;
            }
            else {
                if (societa.equalsIgnoreCase(XCSCompassConstants.MBC)){
                    queue = [SELECT Id, Type, Email, Name, DeveloperName FROM Group 
                             WHERE Type = 'Queue' 
                             AND DeveloperName = 'Q344' LIMIT 1];
                    //   return queue;
                }
            }
        }
        return queue;
        //return null; //TODO se per qualche motivo dovesse aggiungersi qualche altro valore a "societa", in questo punto si dovrebbe implementare la logica
    }
    
    
    private static OCSCliente getOCSClienteById(String OCSId,String societa){
        OCSCliente res=new OCSCliente();
        if(societa.equals(XCSCompassConstants.COMPASS)){
            List<OCSCliente> lista=OCSObjectsFactory.makeClienti(OCSRecuperaDatiPostvenditaInvoker.callRecDatiPV(OCSId));
            if(lista != null && lista.size() > 0) return lista[0];
            return res;
        }
        else{
            List<OCSCliente> lista= OCSObjectsFactory.makeClienti(OCSRecuperaDatiFuturoInvoker.callRecDatiFuturo(OCSId));
          
            
        }
        System.debug('CRMReclamiGestioneContainerController getOCSClienteById res: '+res);
        return res;
    }
    
    private static OCSCliente getOCSClienteByAccount(Account acc,Map<String,String> praticaMap){
        System.debug('CRMReclamiGestioneContainerController getOCSClienteByAccount input: \nacc: '+acc);
        OCSCliente res=new OCSCliente();
        res=OCSObjectsFactory.makeCliente(acc);
        if(praticaMap!=null){
            res.pratiche.add(OCSObjectsFactory.makePratica(praticaMap));
        }
        System.debug('CRMReclamiGestioneContainerController getOCSClienteByAccount res: '+res);
        return res;
    }
    
    private static OCSCliente getOCSClienteByAccountFuturoMBCS(Account_Futuro_MBCS__c acc,Map<String,String> praticaMap){
        System.debug('CRMReclamiGestioneContainerController getOCSClienteByAccount input: \nacc: '+acc);
        OCSCliente res=new OCSCliente();
        res=OCSObjectsFactory.makeClienteFuturoMBCS(acc);
        if(praticaMap!=null){
            res.pratiche.add(OCSObjectsFactory.makePratica(praticaMap));
        }
        System.debug('CRMReclamiGestioneContainerController getOCSClienteByAccount res: '+res);
        return res;
    }
    
    private static Map<String,String> makePraticaMap(Case c, String cod){
        Map<String,String> res=new Map<String,String>();
        //Campi compass e comuni
        res.put('numPratica',c.NumeroPratica__c);
        //res.put('abi',c.NumeroPratica__c);
        res.put('codCliente',cod);
        //res.put('cab',c.NumeroPratica__c);
        //res.put('numConto',c.NumeroPratica__c);
        //res.put('iban',c.NumeroPratica__c);
        //res.put('statoPratica',c.NumeroPratica__c);
        //res.put('tipoPagamento',c.NumeroPratica__c);
        res.put('prodotto',c.Tipo_Prodotto__c);
        res.put('filiale',c.Branch__c); /////////////////////////////////////////////////////////////Lookup, sistemare
        //res.put('dataEstinzione',c.NumeroPratica__c);
        res.put('tipoPratica',c.Tipo_Pratica__c);
        //res.put('dataCaricamento',c.NumeroPratica__c);
        res.put('pan',c.Pan__c);
        res.put('convenzionato',c.NumeroPratica__c);
        res.put('puntoVendita',c.NumeroPratica__c);
        res.put('venditore',c.NumeroPratica__c);
        res.put('agente',c.NumeroPratica__c);
        res.put('subAgente',c.NumeroPratica__c);
        res.put('flagRecupero',c.Has_Recupero__c+'');
        res.put('classifRecupero',c.NumeroPratica__c);
        res.put('societa',c.NumeroPratica__c);
        res.put('codStatoPratica',c.NumeroPratica__c);
        res.put('codAttributoPratica',c.Pratica_Codice_Attributo_PM__c);
        res.put('desStatoPratica',c.NumeroPratica__c);
        res.put('desAttributoPratica',c.Pratica_Descrizione_Attributo_PM__c);
        res.put('codRecuperatore',c.Codice_Recuperatore__c);
        res.put('desRecuperatore',c.Descrizione_Recuperatore__c);
        res.put('canale',c.NumeroPratica__c);
        //Campi futuro
        // res.put('dataContratto',c.F_Data_Contratto__c+'');
        // res.put('dataEstinzioneAnticipata',c.F_Data_Estinzione__c+'');
        res.put('aziendaCod',c.F_Codice_OCS_Azienda__c);
        res.put('aziendaRagSoc',c.F_Ragione_Sociale_Azienda__c);
        res.put('aziendaIndirizzo',c.F_Indirizzo_Azienda__c);
        //res.put('aziendaCap',c.);
        //res.put('aziendaLocalita',c.);
        //res.put('aziendaProv',c.);
        //res.put('aziendaSedeCod',c.);
        //res.put('aziendaSedeRagSoc',c.);
        //res.put('aziendaSedeIndirizzo',c.);
        //res.put('aziendaSedeCap',c.);
        //res.put('aziendaSedeLocalita',c.);
        //res.put('aziendaSedeProv',c.);
        res.put('agenteCod',c.F_Codice_OCS_Agente__c);
        res.put('agenteRagSoc',c.F_Ragione_Sociale_Agente__c);
        res.put('subAgenteCod',c.F_Codice_OCS_SubAgente__c);
        res.put('subAgenteRagSoc',c.F_Ragione_Sociale_SubAgente__c);
        res.put('bancaCod',c.F_Codice_OCS_Banca__c);
        res.put('bancaRagSoc',c.F_Ragione_Sociale_Banca__c);
        res.put('filBancaCod',c.F_Codice_OCS_Filiale__c);
        res.put('filBancaRagSoc',c.F_Ragione_Sociale_Filiale__c);
        //res.put('assicVitaCod',c.F_Assic_Vita__c);
        //res.put('assicVitaRagSoc',c.);
        //res.put('assicImpiegoCod',c.);
        //res.put('assicImpiegoRagSoc',c.);
        return res;
    }
    
    private static OCSPratica makePraticaCompass(Map<String,String> data){
        return OCSObjectsFactory.makePratica(data);
    }
    
    private static OCSPraticaFuturo makePraticaFuturo(Map<String,String> data){
        return OCSObjectsFactory.makePraticaFuturo(data);
    }
  
    private static CodaXSocieta__mdt getCodaMdt(String codaId){
        System.debug('coda id ===================== ' + codaId);
        List<CodaXSocieta__mdt> codSoc = new List<CodaXSocieta__mdt>();        
        List<Group> labelCoda = [Select name, developerName from Group 
                                 where id =: codaId and type='Queue'];
		String developerName = labelCoda[0].developerName.replace('Q','DN_');
        System.debug(developerName);
        
        if(labelCoda.size() > 0){
            codSoc = [SELECT Id, DeveloperName, Label, Societa__c, Firma__c, Email__c 
                      FROM CodaXSocieta__mdt where DeveloperName =:developerName];
        }
        else
            codSoc.add(new CodaXSocieta__mdt());
        
        System.debug('CodaXSocieta__mdt recuperata = ' + codSoc);
        return codSoc[0];
    }


    
    /* public static void ForwardAndTracking per frode
* publuc static void ForwardAndTracking per Inadempimento
* 
* in fase di salvataggio devo inviare le email, direi che questà è la classe
* giusta in cui inserire la logica in quanto la struttura prevede l invio di 
* email solo in caso di salvataggio e in questa classe il case viene salvato
* 
* */

/*
    @AuraEnabled
    public static void deleteAttachment(String id){
        List<Attachment> lista = [Select id from Attachment where id =:id];
        if(lista !=null && lista.size()>0)delete lista;
    }*/

    @AuraEnabled
    public static void deleteAttachment(String idFile, String idParent){

        system.debug('idFile : '+idFile);
        system.debug('idParent : '+idParent);

        List<String> lst = new List<String>();
        for(String spl : idFile.split('=')){
            lst.add(spl);
        }
        system.debug('----lst-0-----| '+lst.get(0));
        system.debug('----lst-1-----| '+lst.get(1));

        List<ContentDocumentLink> fileToDelete = [
            SELECT ContentDocument.Title,Id,LinkedEntityId 
            FROM ContentDocumentLink 
            WHERE LinkedEntityId = :idParent
            AND ContentDocumentId =: lst.get(0)
        ];
        system.debug('deleteAttachment: '+fileToDelete);

        if(!fileToDelete.isEmpty()){
            delete fileToDelete;
            delete [SELECT Id FROM ContentDocument WHERE id =: lst.get(0)];
        }
    }
    
    @AuraEnabled
    public static Case getReclamo(String recordId){
        System.debug('--------------- record Id = ' + recordId + '-------------------------');
        Case c = [Select id, subject from case where id =: recordId];
        return c;
    }

    // NON USATA, SPOSTATA LOGICA NELLA CLASSE CRMRECLAMIGesInadContainerCtrl    
    @AuraEnabled
    public static void sendEmailForwardAndTrackInadempimento(Case myCase){
        String fAndTbaseUrl = [SELECT Id, Value__c FROM XCS_CompassParameters__c WHERE Name = 'forwardandtrack.baseurl'][0].Value__c;
        String urlFAndTOscuro = fAndTbaseUrl+'?token='+SitesTokenUtil.generateToken(myCase.Id,datetime.now().addMinutes(400),'c:CRMReclamiInadempimentoForwardAndTrack','c:CRMReclamiInadempimentoForwardAndTrackApp', 'Oscuro');

        
        List<String> indirizzi = new List<String>();
        List<String> indirizzicc = new List<String>();
        String to = [SELECT Id, Value__c FROM XCS_CompassParameters__c WHERE name = 'reclami.inadempimento.oscuraPresenzaTO'].Value__c;	
       	String cc =  [SELECT Id, Value__c FROM XCS_CompassParameters__c WHERE name = 'reclami.inadempimento.oscuraPresenzaCC'].Value__c;
        EmailTemplate oscura = [SELECT Id, Name, Subject, body, DeveloperName FROM EmailTemplate Where DeveloperName='Aggiornamento_oscura_presenza'];
        if(to.contains(';')) indirizzi.addAll(to.split(';'));
        else    indirizzi.add(to);
        if(cc.contains(';')) indirizzicc.addAll(cc.split(';'));
        else    indirizzicc.add(cc);
        
         //to : reclami.out@compass.it // cc : monitoraggio.dealer@compass.it 
        //Case c = [SELECT Id, Numero_Reclamo__c FROM Case where id =: recordId];
        
        oscura.Subject = oscura.Subject.replace('{!numeroReclamo}', myCase.Numero_Reclamo__c);
        oscura.body = oscura.body.replace('{!link}', urlFAndTOscuro);
        
        Messaging.SingleEmailMessage email1 = new Messaging.SingleEmailMessage();       
        email1.setToAddresses(indirizzi);
        email1.setCcAddresses(indirizzicc);
        email1.setPlainTextBody(oscura.body);
        email1.setSubject(oscura.Subject);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email1});
        linkEmailToCase(email1, myCase.Id);
      
         
        
        // to : CentroRecuperoHome@compass.it cc : monitoraggio.dealer@compass.it 
        
    
        
        //EmailUtils.sendEmail(EmailUtils.generateEmailReclamiFandT(indirizzi, body_One, subject_One));
        //EmailUtils.sendEmail(EmailUtils.generateEmailReclamiFandT(indirizzi, body_Two, subject_Two));
        
        String urlFAndTSospeso = fAndTbaseUrl+'?token='+SitesTokenUtil.generateToken(myCase.Id,datetime.now().addMinutes(400),'c:CRMReclamiInadempimentoForwardAndTrack','c:CRMReclamiInadempimentoForwardAndTrackApp', 'Sospeso');

        EmailTemplate sospendere = [SELECT Id, Name, Subject, body, DeveloperName FROM EmailTemplate Where DeveloperName='Aggiornamento_Sospendere_Attivita'];
		sospendere.Subject = sospendere.Subject.replace('{!numeroReclamo}',myCase.Numero_Reclamo__c);
        sospendere.body = sospendere.body.replace('{!link}',urlFAndTSospeso);
        
        List<String> indirizzi2to = new List<String>();    
        List<String> indirizzi2cc = new List<String>();
        String to2 = [SELECT Id, Value__c FROM XCS_CompassParameters__c WHERE name = 'reclami.inadempimento.sospesoTO'].Value__c;	
        String cc2 =  [SELECT Id, Value__c FROM XCS_CompassParameters__c WHERE name = 'reclami.inadempimento.sospesoCC'].Value__c;
        
        if(to2.contains(';')) indirizzi2to.addAll(to2.split(';'));
        else    indirizzi2to.add(to2);
        if(cc2.contains(';')) indirizzi2cc.addAll(cc2.split(';'));
        else    indirizzi2cc.add(cc2);
        
        Messaging.SingleEmailMessage email2 = new Messaging.SingleEmailMessage();       
        email2.setToAddresses(indirizzi2to);
        email2.setCcAddresses(indirizzi2cc);
        email2.setPlainTextBody(sospendere.body);
        email2.setSubject(sospendere.Subject);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email2});
        linkEmailToCase(email2, myCase.Id);
        
        
        
    }
    // NON USATA, SPOSTATA LOGICA NELLA CLASSE CRMRECLAMIGesInadContainerCtrl
    @AuraEnabled
    public static void sendEmailForwardAndTrackInadempimentoWaiting(Case myCase){
        String fAndTbaseUrl = [SELECT Id, Value__c FROM XCS_CompassParameters__c WHERE Name = 'forwardandtrack.baseurl'][0].Value__c;
        String urlFAndT = fAndTbaseUrl+'?token='+SitesTokenUtil.generateToken(myCase.Id,datetime.now().addMinutes(400),'c:CRMReclamiInadempimentoForwardAndTrack','c:CRMReclamiInadempimentoForwardAndTrackApp');
        
        System.debug('urlFAndT = '+urlFAndT);
        
        List<String> indirizzi = new List<String>();
        String emailProva = 'daniele.segoloni@lynxspa.com';  //to : reclami.out@compass.it // cc : monitoraggio.dealer@compass.it 
        indirizzi.add(emailProva);
        //Case c = [SELECT Id, Numero_Reclamo__c FROM Case where id =: recordId];
        String subject_One = 'Reclamo '+myCase.Numero_Reclamo__c+' Procedere a cancellazione BD';
        String body_One = 'Cancellare dalle SIC le segnalazioni relative alla seguente pratica di finanziamento per la quale si è verificato un reclamo di inadempimento.'  
            + '\n' + 'Cliccare qui sotto per i dettagli e per confermare di aver gestito l attività.'
            + '\n' + urlFAndT;
        
        // to : CentroRecuperoHome@compass.it cc : monitoraggio.dealer@compass.it 
        String subject_Two = 'Reclamo '+myCase.Numero_Reclamo__c+' Bloccare definitivamente recupero';
        String body_Two = 'Bloccare definitivamente le azioni di recupero per la seguente pratica di finanziamento per la quale si è verificato un inadempimento.'
            + '\n' + 'Cliccare qui sotto per i dettagli e per confermare di aver gestito l attività.'
            + '\n' + urlFAndT;
        
        //EmailUtils.sendEmail(EmailUtils.generateEmailReclamiFandT(indirizzi, body_One, subject_One));
        //EmailUtils.sendEmail(EmailUtils.generateEmailReclamiFandT(indirizzi, body_Two, subject_Two));

        Messaging.SingleEmailMessage email1 = new Messaging.SingleEmailMessage();       
        email1.setToAddresses(indirizzi);
        email1.setPlainTextBody(body_One);
        email1.setSubject(subject_One);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email1});
        linkEmailToCase(email1, myCase.Id);

        Messaging.SingleEmailMessage email2 = new Messaging.SingleEmailMessage();       
        email2.setToAddresses(indirizzi);
        email2.setPlainTextBody(body_Two);
        email2.setSubject(subject_Two);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email2});
        linkEmailToCase(email1, myCase.Id);
        
    }

    public static void linkEmailToCase(Messaging.SingleEmailMessage email, Id caseId) {
        EmailMessage emailMsg = new EmailMessage(); // Created a EmailMessage and copy all details from above.
        emailMsg.ToAddress=(email.getToAddresses())[0];
        emailMsg.Subject=email.getSubject();
        emailMsg.HtmlBody=email.getHtmlBody();
        emailMsg.TextBody=email.getPlainTextBody();
        emailMsg.ParentId = caseId; //Attach with the case
        emailMsg.MessageDate = system.now();
        emailMsg.Status = '3'; // 3 = Sent
        insert emailMsg;
    }
    
    //Metodo che posta sul chatter quando c'è un cambiamento di gravità
    @AuraEnabled
    public static void cambiamentoGravitaChatterFandT (String recordId, Boolean isGraveToNonGrave, String inadempimentoStage, String societa){        
        if (inadempimentoStage == '4166'){ // L'unico scenario di cambiamento ce l'abbiamo se al primo passaggio (Step 1 - Start) selezionano "Grave" e poi al secondo cambiano idea e vanno su "Non Grave", pag. 4 Nota
            
            if( isGraveToNonGrave ){
                String fAndTbaseUrl = [SELECT Id, Value__c FROM XCS_CompassParameters__c WHERE Name = 'forwardandtrack.baseurl'][0].Value__c;
                String urlFAndT = fAndTbaseUrl+'?token='+SitesTokenUtil.generateToken(Id.valueOf(recordId),datetime.now().addMinutes(400),'c:CRMReclamiInadempimentoForwardAndTrack','c:CRMReclamiInadempimentoForwardAndTrackApp');
                String subject_NG = 'Aggiornamento inadempimento scritto';
                String bodyNonGrave = 'Il seguente reclamo è stato reimpostato da GRAVE a NON GRAVE'  
                    + '\n' + 'Dati Reclamo presenti all\' url: '
                    + '\n' + urlFAndT + '  \n';
                XCSChatterUtils.postMessageWithMention('Monitoraggio Dealer', recordId, subject_NG + '\n' + bodyNonGrave, true);
                //TODO postare il messaggio anche per la filiale di riferimento, che però non ho capito se è la coda selezionata
                //oppure la filiale associata alla pratica del cliente (in ogni caso si può inviare alla filiale associata alla pratica?)
                /*
                Case c = [SELECT Id FROM Case WHERE Id = : recordId];
                
                if(XCSCompassConstants.COMPASS.equals(societa))
                    c.OwnerId = [Select id from Group where developerName = 'Q52'].id;
                else if (XCSCompassConstants.FUTURO.equals(societa))
                    c.OwnerId = [Select id from Group where developerName = 'Q300'].id;
                else if (XCSCompassConstants.MBC.equals(societa))
                    c.OwnerId = [Select id from Group where developerName = 'Q343'].id;*/
                
            }
            else{
                String fAndTbaseUrl = [SELECT Id, Value__c FROM XCS_CompassParameters__c WHERE Name = 'forwardandtrack.baseurl'][0].Value__c;
                String urlFAndT = fAndTbaseUrl+'?token='+SitesTokenUtil.generateToken(Id.valueOf(recordId),datetime.now().addMinutes(400),'c:CRMReclamiInadempimentoForwardAndTrack','c:CRMReclamiInadempimentoForwardAndTrackApp');
                String subject_G = 'Aggiornamento inadempimento scritto';
                String bodyGrave = 'Il seguente reclamo è stato reimpostato da NON GRAVE a GRAVE'  
                    + '\n' + 'Dati Reclamo presenti all\' url: '
                    + '\n' + urlFAndT + '  \n';
                XCSChatterUtils.postMessageWithMention('Monitoraggio Dealer', recordId, subject_G + '\n' + bodyGrave, true);
                
            }
        }
    }

    //metodo che posta sul chatter al Terzo step di inadempimento, al termine del processo
    @AuraEnabled
    public static void postToChatterWithSubject(String recordId, String subject) {
        String fAndTbaseUrl = [SELECT Id, Value__c FROM XCS_CompassParameters__c WHERE Name = 'forwardandtrack.baseurl'][0].Value__c;
        String urlFAndT = fAndTbaseUrl+'?token='+SitesTokenUtil.generateToken(Id.valueOf(recordId),datetime.now().addMinutes(400),'c:CRMReclamiInadempimentoForwardAndTrack','c:CRMReclamiInadempimentoForwardAndTrackApp');
        String bodyNonGrave = 'Il seguente reclamo è stato reimpostato da GRAVE a NON GRAVE'  
            + '\n' + 'Dati Reclamo presenti all\' url: '
            + '\n' + urlFAndT + '  \n';
        XCSChatterUtils.postMessageWithMention('Monitoraggio Dealer', recordId, subject + '\n' + bodyNonGrave, true);
        //TODO postare il messaggio anche per la filiale di riferimento, che però non ho capito se è la coda selezionata
        //oppure la filiale associata alla pratica del cliente (in ogni caso si può inviare alla filiale associata alla pratica?)
    }
    
    @AuraEnabled
    public static void handleInadempimento(String recordId){
        
        Case c = [
                    SELECT Id,Numero_Reclamo__c,Stage_Inadempimento__c,Inadempimento_Grave__c,Referenced_Company__c,F_T_Sent_Count__c,Branch__c 
                    FROM case
                    WHERE id =: recordId
                ];
        
        
        
        //LA macro decisione si basa sul fatto che l inadempimento sia grave o no
        if(c.Inadempimento_Grave__c){
            //bisogna controllare a che punto dello stage inadempimento si è arrivati
            
            //La prima volta che si apre il case  (in inserimento lio )
            
            if(c.Stage_Inadempimento__c == '4164'){ //Step 0 – Start
                
            }
            else if(c.Stage_Inadempimento__c == '4165'){ //Step 0 – End
                
            }
            else if(c.Stage_Inadempimento__c == '4166'){ //Step 1 – Start
                sendEmailForwardAndTrackInadempimento(c); 
                c.F_T_Sent_Count__c = c.F_T_Sent_Count__c != null ? c.F_T_Sent_Count__c+2 : 2;
                c.Status='F&T Sent';
                Group filialeVerifica = [SELECT Type,DeveloperName FROM GROUP WHERE Type='Queue' AND DeveloperName = 'Q72']; // Q72 = 'INADEMPIMENTO VERIFICA FILIALI'
                c.OwnerId = filialeVerifica.Id;
                
            }
            else if(c.Stage_Inadempimento__c == '4167'){ //Step 1 – End
                
            }
            else if(c.Stage_Inadempimento__c == '4168'){ //Step 2 – Start
                
            }
            else if(c.Stage_Inadempimento__c == '6000'){ //Step 2 – F&T Sent
                
            }
            else if(c.Stage_Inadempimento__c == '4170'){ //Step 2 – F&T Updated
                
            }
            else if(c.Stage_Inadempimento__c == '4169'){ //Step 2 – F&T Waiting
                sendEmailForwardAndTrackInadempimentoWaiting(c); 
                c.Status='F&T Sent';
                c.F_T_Sent_Count__c = c.F_T_Sent_Count__c != null ? c.F_T_Sent_Count__c+2 : 2;

                //TODO: aggiungere creazione incidents, quando sarà chiarita la questione riguardante la filiale
            }
            else if(c.Stage_Inadempimento__c == '4171'){ //End
                Group idmResponseStaff = [SELECT Type,DeveloperName FROM GROUP WHERE Type='Queue' AND DeveloperName = 'Q52']; // Reclami - IDM Response Staff 
                c.OwnerId = idmResponseStaff.Id;
                c.Inadempimento_Grave__c = false;
                c.Status = 'Gestito';
                //String message = 'Chiusura Reclamo non Grave';
                //CollaborationGroup chatterGroup = [SELECT Id,Name FROM CollaborationGroup
			    //                               WHERE Name = 'Monitoraggio Dealer'
			    //                                            LIMIT 1];
                //metodo che invia un chatter feed a filiale e monitoraggio dealer
                //sendChatterMessWithTwoMentions(c.Id, c.Branch__c, chatterGroup.Id, message);
            }
            
            
        }
        //inadempimento non grave
        else{
            c.Stage_Inadempimento__c = '4171'; //End
            
            if(XCSCompassConstants.COMPASS.equals(c.Referenced_Company__c))
                c.OwnerId = [Select id from Group where developerName = 'Q52'].id;
            else if (XCSCompassConstants.FUTURO.equals(c.Referenced_Company__c))
                c.OwnerId = [Select id from Group where developerName = 'Q300'].id;
            else if (XCSCompassConstants.MBC.equals(c.Referenced_Company__c))
                c.OwnerId = [Select id from Group where developerName = 'Q343'].id;
            
        }
        
        update c;
        
    }

    //metodo per creare chatter feed con due mentions (verificare se spostarlo tra le Utils). 
    //Da utilizzare quando si saprà come menzionare la filiale di riferimento
    public static void sendChatterMessWithTwoMentions(Id recordId, Id firstMentionId, Id secondMentionId, String message) {
        ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
		ConnectApi.MentionSegmentInput mentionSegmentInput1 = new ConnectApi.MentionSegmentInput();
        ConnectApi.MentionSegmentInput mentionSegmentInput2 = new ConnectApi.MentionSegmentInput();
		ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
		ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();

		messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();

		textSegmentInput.text = message;
		messageBodyInput.messageSegments.add(textSegmentInput);

		mentionSegmentInput1.id = firstMentionId;
		messageBodyInput.messageSegments.add(mentionSegmentInput1);

        mentionSegmentInput2.id = secondMentionId;
		messageBodyInput.messageSegments.add(mentionSegmentInput2);


		feedItemInput.body = messageBodyInput;
		feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
		feedItemInput.subjectId = recordId;

		ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(null, feedItemInput);
    }
    
    @AuraEnabled
    public static void salvaPlusApex(String recordId, String utenteGruppoAssegnato){
        System.debug('utente gruppo assegnato = ' + utenteGruppoAssegnato);
         System.debug('salvaPlusApex');
        
        String[] nomeECognome;
        nomeECognome = utenteGruppoAssegnato.split(' ');  
        
        List<User> utenteList = [Select id from user where FirstName =:nomeECognome[0] and LastName = : nomeECognome[1]];
        
        if(utenteList.size() > 0){
            Case c = new Case(Id = recordId, Assegnatario__c = utenteList[0].id);
            Case temp = [Select id, Assegnatario__c from Case Where id =:recordId];
            if(temp.Assegnatario__c != c.Assegnatario__c)   update c;
        }
    }
    
    @AuraEnabled
    public static void salvaDettagliApex(String recordId, String dataComunicazione, String dataRicezione, String dataRicezioneIDM,
                                         String standAloneSelection, String rimborsoSelection, String abbuonoSelection, String risarcimentoSelection,
                                         String modalitaInvioDettagli, Double rimborsoValue, Double abbuonoValue, Double risarcimentoValue){
                                             System.debug('salvaDettagliApex');
                                             Boolean standAloneSelectionB;
                                             Boolean rimborsoSelectionB;
                                             Boolean abbuonoSelectionB;
                                             Boolean risarcimentoSelectionB;
                                             
                                             if('Si'.equalsIgnoreCase(standAloneSelection))
                                                 standAloneSelectionB = true;
                                             else
                                                 standAloneSelectionB = false;
                                             
                                             if('Si'.equalsIgnoreCase(rimborsoSelection))
                                                 rimborsoSelectionB = true;
                                             else
                                                 rimborsoSelectionB = false;
                                             
                                             if('Si'.equalsIgnoreCase(abbuonoSelection))
                                                 abbuonoSelectionB = true;
                                             else
                                                 abbuonoSelectionB = false;
                                             
                                             if('Si'.equalsIgnoreCase(risarcimentoSelection))
                                                 risarcimentoSelectionB = true;
                                             else
                                                 risarcimentoSelectionB = false;
                                             
                                             Schema.DescribeFieldResult fieldResultDecisione=Case.Modalita_Invio__c.getDescribe();
                                             List<Schema.PicklistEntry> pleDec=fieldResultDecisione.getPicklistValues();  
                                             for(Schema.PicklistEntry pickListVal:pleDec){
                                                 if(pickListVal.getLabel().equalsIgnoreCase(modalitaInvioDettagli))
                                                     modalitaInvioDettagli = pickListVal.getValue();
                                             }
                                             
                                             Case c = new Case(Id = recordId,
                                                               Data_Ricezione_IDM__c =  Date.valueOf(dataRicezioneIDM),
                                                               Data_Ricezione__c  = Date.valueOf(dataRicezione),
                                                               DataSegnalazione__c = Date.valueOf(dataComunicazione),
                                                               Importo_Abbuono_Richiesta__c = abbuonoValue,
                                                               Abbuono_Richiesta__c = abbuonoSelectionB,
                                                               Compensazione__c = risarcimentoSelectionB,
                                                               Importo_Compensazione__c = risarcimentoValue,
                                                               Importo_Rimborso__c = rimborsoValue,
                                                               Has_Rimborso__c = rimborsoSelectionB,
                                                               Stand_Alone__c = standAloneSelectionB,
                                                               Modalita_Invio__c = modalitaInvioDettagli
                                                              );
                                             update c;
                                             
                                         }
    
    //mmm 
    @AuraEnabled
    public static Boolean checkTipoReclamo(String recordId){
        Boolean res = false;
        Case c = [Select Tipo_Reclamo__c, Referenced_Company__c from Case where id =: recordId];
        
        List<CRM_RCL_Tipologia_Reclamo__mdt> tr = [Select Descrizione__c FROM CRM_RCL_Tipologia_Reclamo__mdt
                                                   where External_Id__c =: c.Tipo_Reclamo__c And Area__c =: c.Referenced_Company__c];
        
        if(tr.size() > 0){
            if('ass'.equalsIgnoreCase((tr[0].descrizione__c).substring(0,3)))
                res = true;
        }
        
        return res;
    }



 	@AuraEnabled
    public static Case salvaReclamoTotale(String recordId, Map<String,String> caseHeader, Map<String,String> cChiusura,
                                                        Map<String,Double> cChiusuraDouble, Map<String,String> caseDettagli, Map<String,Double> caseDettagliDouble,
                                                        Map<String,String> cAggiuntivi,List<Attachment> fileList, List<XCS_Mittente__c> mittentiList, OCSCliente cCliente,
                                                        Boolean isInadempimento, String stageInadempimento)
    {
		if(recordId!=null && recordId.length() >0 && !hasEditAccess(recordId)) throw new NoPermissionException('Non puoi salvare il reclamo');
        //START - Modifica per AccountId    
        
      
    

        String codaDevName;
        Case c = [Select id, OwnerId, Referenced_Company__c from case where id =: recordId];
        
        if(c.Referenced_Company__c!=null){

            if(c.Referenced_Company__c.equalsIgnoreCase('Compass')){
                c.AccountId = cCliente.SFId;
            }else{
                c.Account_Futuro_MBCS__c = cCliente.SFId;
            }
        }
        
        //END - Modifica per AccountId


        if(caseHeader.keySet().size() > 0){
          
            c.OwnerId = caseHeader.get('coda');
            c.Categoria_Riferimento__c = caseHeader.get('categoria');
            c.Reclamo_Completo__c  = 'Si'.equalsIgnoreCase(caseHeader.get('reclamoCompleto'));
            c.Delega_Presente__c = 'Si'.equalsIgnoreCase(caseHeader.get('delegaPresente'));
            c.Has_Acceso_Dati__c = 'Si'.equalsIgnoreCase(caseHeader.get('accessoDati'));
            c.status = caseHeader.get('status');
            c.Tipo_Reclamo__c = caseHeader.get('tipo');

            //DATA_DECISIONE
            if(String.isNotBlank(caseHeader.get('dataDecisione')) && caseHeader.get('dataDecisione').contains('-')){
                List<String> spl = caseHeader.get('dataDecisione').split('-');
                
                c.Data_Decisione__c = Date.newInstance(Integer.valueOf(spl.get(0)),Integer.valueOf(spl.get(1)),Integer.valueOf(spl.get(2).split('T').get(0)));
            }

            //ASSEGNATO
            c.Owner_User__c = caseHeader.get('assegnato') != null ? caseHeader.get('assegnato') : null;
        }
        
        
        if(cChiusuraDouble.keySet().size() > 0){
            c.Importo_Abbouno_Chiusura__c =cChiusuraDouble.get('abbuonoImporto');
            c.Rimborso_Accordato_Importo__c = cChiusuraDouble.get('rimborsoImporto');
            c.F_Rimborso_Commissioni_Importo_Out__c = cChiusuraDouble.get('rimborsoImportoComm');
            c.F_Rimborso_Provvigioni_Importo_Out__c = cChiusuraDouble.get('rimborsoImportoProv');
            c.Risarcimento_Accordato_Importo__c = cChiusuraDouble.get('risarcimentoImportoValue');
            c.F_Rimborso_Spese_Legali_Importo_Out__c = cChiusuraDouble.get('rimborsoImportoLeg');
            c.F_Rimborso_Assicurativo_Importo_Out__c = cChiusuraDouble.get('rimborsoImportoPrem');
            c.F_Rimborso_Varie_Importo_Out__c = cChiusuraDouble.get('rimborsoImportoVar');
        }

        //cChiusura != null non funziona perchè vuoto non è null
        if(cChiusura.keySet().size() > 0){
            c.Abbuono_Chiusura__c  = 'true'.equalsIgnoreCase(cChiusura.get('isAbbuono'));
            c.Has_Rimborso_Accordato__c =  'true'.equalsIgnoreCase(cChiusura.get('isRimborso'));                 
            c.F_Has_Rimborso_Commissioni_Out__c =  'true'.equalsIgnoreCase(cChiusura.get('isRimborsoComm'));       
            c.F_Has_Rimborso_Provvigioni_Out__c =  'true'.equalsIgnoreCase(cChiusura.get('isRimborsoProv'));         
            c.F_Has_Rimborso_Assicurativo_Out__c =  'true'.equalsIgnoreCase(cChiusura.get('isRimborsoPrem'));        
            c.F_Has_Rimborso_Varie_Out__c =  'true'.equalsIgnoreCase(cChiusura.get('isRimborsoVar'));        
            c.F_Has_Rimborso_Spese_Legali_Out__c = 'true'.equalsIgnoreCase(cChiusura.get('isRimborsoLeg'));       
            c.Has_Risarcimento_accordato__c =  'true'.equalsIgnoreCase(cChiusura.get('isRisarcimento'));        
            c.Has_Fondato__c =  'true'.equalsIgnoreCase(cChiusura.get('isFondato'));
            c.Accolto__c = cChiusura.get('accolto');
            c.Has_Allegati_Completi__c = 'true'.equalsIgnoreCase(cChiusura.get('isAllegatiCompleti'));
            c.Has_SIC__c =  'true'.equalsIgnoreCase(cChiusura.get('isSic'));
            c.SIC__c = cChiusura.get('sic');
            c.Has_Assicurative__c = 'true'.equalsIgnoreCase(cChiusura.get('isSocAss'));
            c.Societa_Assicurative__c = cChiusura.get('socAss');
            c.Has_Recupero__c = 'true'.equalsIgnoreCase(cChiusura.get('isSocRec'));
            c.Societa_di_Recupero__c = cChiusura.get('socRec');
            c.Has_Invio_Risposta_IDM__c =  'true'.equalsIgnoreCase(cChiusura.get('isIdm'));
            c.Attesa_Riscontro_Cliente__c  =  'true'.equalsIgnoreCase(cChiusura.get('isRiscontro'));
            c.Attesa_Assegno__c = 'true'.equalsIgnoreCase(cChiusura.get('isAssegno'));
            c.Decisione__c = cChiusura.get('decisione');
            c.Intervento_Autorita__c = cChiusura.get('autorita');                                      
        }
        
        if(caseDettagli.keySet().size() > 0){
            if(caseDettagli.get('dataRicezioneIDM') != null)
                c.Data_Ricezione_IDM__c =  Date.valueOf(caseDettagli.get('dataRicezioneIDM'));
            if(caseDettagli.get('dataRicezione') != null)
                c.Data_Ricezione__c  = Date.valueOf(caseDettagli.get('dataRicezione'));
            if(caseDettagli.get('dataComunicazione') != null)
                c.DataSegnalazione__c = Date.valueOf(caseDettagli.get('dataComunicazione'));
            c.Importo_Abbuono_Richiesta__c = caseDettagliDouble.get('abbuonoValue');
            c.Abbuono_Richiesta__c = 'Si'.equalsIgnoreCase(caseDettagli.get('abbuonoSelection'));
            c.Compensazione__c = 'Si'.equalsIgnoreCase(caseDettagli.get('risarcimentoSelection'));
            c.Importo_Compensazione__c = caseDettagliDouble.get('risarcimentoValue');
            c.Importo_Rimborso__c = caseDettagliDouble.get('rimborsoValue');
            c.Has_Rimborso__c = 'Si'.equalsIgnoreCase(caseDettagli.get('rimborsoSelection'));
            c.Stand_Alone__c = 'Si'.equalsIgnoreCase(caseDettagli.get('standAloneSelection'));

            String modalitaInvioDettagli = '';
            Schema.DescribeFieldResult fieldResultDecisione=Case.Modalita_Invio__c.getDescribe();
            List<Schema.PicklistEntry> pleDec=fieldResultDecisione.getPicklistValues();  
            for(Schema.PicklistEntry pickListVal:pleDec){
                if(pickListVal.getLabel().equalsIgnoreCase((caseDettagli.get('modalitaInvioDettagli'))))
                    modalitaInvioDettagli = pickListVal.getValue();
            }
            
            //if(cInadempimento.keySet().size() > 0){
                //c.Stage_Inadempimento__c = cInadempimento.get('stageInadempimento');
                //c.F_T_Sent_Count__c = Decimal.valueOf(cInadempimento.get('FTSent'));
                //c.F_T_Received_Count__c = Decimal.valueOf(cInadempimento.get('FTReceived'));
            //}
            
            c.Modalita_Invio__c = modalitaInvioDettagli;
            
            String[] nomeECognome;
            String assegnatario = 'x';
            // Boris Gestione ItemFeed Inizio evento [assigned to queue]	
              Case cas = [Select id, assegnatario__c, assegnatario__r.Alias, OwnerId From Case Where id =:c.Id];
            	if(c.OwnerId != cas.OwnerId && (c.OwnerId+'').startsWith('00G'))insert XCSReclamiUtils.createFeedItem(c.id, System.now(), 'assigned to queue', UserInfo.getName(), true);
            //Boris Fine
            
            if(caseDettagli.get('utenteGruppoAssegnato') != null){
                nomeECognome = caseDettagli.get('utenteGruppoAssegnato').split(' ');  
                List<User> utenteList = new List<User>();
                
                if(nomeECognome != null){
                    if(nomeEcognome.size() == 2){
                        if(nomeECognome[0] != null && nomeECognome[1] != null)
                            utenteList = [Select id, Alias from user where FirstName =:nomeECognome[0] and LastName = : nomeECognome[1]];
                    }
                }
                if(utenteList.size() > 0){
                    //Boris Inizio
                  
                    Id utente = utenteList[0].id;
                    if(utente != cas.Assegnatario__c && utenteList[0]!=null ){
                        if(utenteList[0].Alias!= null)insert XCSReclamiUtils.createFeedItem(c.id, System.now(), 'assigned to account ['+utenteList[0].Alias+']', UserInfo.getName(), true);
                    }        
                    //Boris Fine
                    
                     c.Assegnatario__c = utenteList[0].id;
                }
            }
            
        }
        
        if(cAggiuntivi.keySet().size() > 0){
            c.Tipo_Prodotto_Vita__c = cAggiuntivi.get('tipoProdottoVita');
            c.Tipo_Prodotto_Danni__c =  cAggiuntivi.get('tipoProdottoDanni');
            c.Tipo_Proponente__c =  cAggiuntivi.get('tipoProponente');
            c.Area_Geo_Proponente__c =  cAggiuntivi.get('areaGeograficaProponente');
            c.Tipo_Reclamante__c =  cAggiuntivi.get('tipoReclamante');   
            c.Trattabile__c ='Trattabile'.equalsIgnoreCase(cAggiuntivi.get('trattabile'));
            c.Area_Aziendale__c = cAggiuntivi.get('areaAziendale');
            
            
        }
        
        Double x = 0;
        Id codaTemp = c.OwnerId;
        c.OwnerId = UserInfo.getUserId();
        update c;

        Map<String,Double> res = new Map<String,Double>(); 
        res.put('Case',x);
        
        Map<String,Double> fAt = saveFilesAndMittenti(recordId,fileList,mittentiList); 
        res.putAll(fAt);
        //if(true)throw new DebugException('IS Inadempimento '+isInadempimento);
        /*if (isInadempimento) {
            handleInadempimento(recordId);
            Case c2 = [Select id,toLabel(Stage_Inadempimento__c), OwnerId from case where id =: recordId];
			
            boolean isFTSend = false;
            if(stageInadempimento == '4166' && c2.Stage_Inadempimento__c =='4165'){
                caseHeader.put('status','F&T Sent');
                c2.status='F&T Sent';
                update c2;
            }
            
            
        }
        */
        System.debug('Finisco SalvaTotale');
        c.OwnerId = codaTemp;
        update c;
        

        if(c.Status=='Gestito'){
            List<Reclami_Timestamp__c> lista = new List<Reclami_Timestamp__c>();
            lista.add(XCSReclamiUtils.createFeedItem(c.Id, c.DataSegnalazione__c, 'complaint dated',  UserInfo.getName(), false));
            insert lista;
        
            XCSReclamiUtils.writeXCSMessaggio(c);
        }

      	return [Select id, status from Case Where id=:c.Id];
        
    } 

    public class DebugException extends Exception{}
    
      @AuraEnabled
    public static List<Attachment> refreshAllegatiCtrl(Id recordId){
        return XCSReclamiUtils.documentToAttachment(recordId);
    }
    
  
    @AuraEnabled
    public static Map<String,Double> saveFilesAndMittenti(String recordId, List<Attachment> fileList, List<XCS_Mittente__c> mittentiList){
        Map<String,Double> res = new Map<String,Double>();
        system.debug('@@@ XCSReclamiUtils.createFile(fileList,recordId)');
        system.debug('@@@ fileList: '+fileList);
        XCSReclamiUtils.createFile(fileList,recordId);
        /*
        List<Attachment> AttachmentToInsert = new List<Attachment>();
        for(Attachment a:fileList){
            if(!(a.id !=null)){
                a.Body = EncodingUtil.base64Decode(a.Body + '');        
                a.ParentId = recordId; 
                AttachmentToInsert.add(a);
                
            }
        }

        //List<ContentVersion> AttachmentToInsert = new List<ContentVersion>();
        //for(Attachment a:fileList){
        //    if(!(a.id !=null)){
        //        ContentVersion cv = new ContentVersion();
        //        cv.ContentLocation = 'S';
        //        cv.VersionData = EncodingUtil.base64Decode(a.Body + '');
        //        AttachmentToInsert.add(cv);
        //        
        //    }
        //}
        
        
            insert AttachmentToInsert;
*/
 

        //List<Id> contentDocIdList = new List<Id>();
        //for (ContentVersion cv : AttachmentToInsert) {
        //    contentDocIdList.add(cv.ContentDocumentId);
        //}
        //List<ContentDocumentLink> cdlList = new List<ContentDocumentLink>();
        //for (Id cdId : contentDocIdList) {
        //    ContentDocumentLink cdl = new ContentDocumentLink();
        //    cdl.ContentDocumentId = cdId;
        //    cdl.LinkedEntityId = recordId;
        //    cdl.ShareType = 'V';
        //    cdlList.add(cdl);
        //}
        //insert cdlList;
        
        List<XCS_Mittente__c> mittentiToUpsert = new List<XCS_Mittente__c>();

        
        List<XCS_Mittente__c> mittenti = [SELECT Id FROM XCS_Mittente__c WHERE Case__c =: recordId];

        for(XCS_Mittente__c m : mittentiList){
            if(m.id == null){
                XCS_Mittente__c mit = new XCS_Mittente__c();
                mit = m;
                mit.Case__c = recordId;
                mittentiToUpsert.add(mit);
            }
            else
                mittentiToUpsert.add(m);   
            
        }
       for(XCS_Mittente__c m : mittentiToUpsert)  System.debug(m);
        
            upsert mittentiToUpsert;
        
           
             
        res.put('Attachment',0);
        res.put('Mittenti',0);
        
      
        return res;
    }
/*

    @AuraEnabled
    public static Map<String,Double> saveFilesAndMittenti(String recordId, List<ContentDocument> fileList, List<XCS_Mittente__c> mittentiList){
        Map<String,Double> res = new Map<String,Double>();
        system.debug('@@@ XCSReclamiUtils.createFile(fileList,recordId)');
        system.debug('@@@ fileList: '+fileList);
        XCSReclamiUtils.createFile(fileList,recordId);
        
        List<XCS_Mittente__c> mittentiToUpsert = new List<XCS_Mittente__c>();

        List<XCS_Mittente__c> mittenti = [SELECT Id FROM XCS_Mittente__c WHERE Case__c =: recordId];
        
        Double p = 0;
        for(XCS_Mittente__c m : mittentiList){
            if(m.id == null){
                XCS_Mittente__c mit = new XCS_Mittente__c();
                mit = m;
                mit.Case__c = recordId;
                mittentiToUpsert.add(mit);
            }
            else
                mittentiToUpsert.add(m);            
        }
       
        upsert mittentiToUpsert;
        
        res.put('Attachment',0);
        res.put('Mittenti',0);
        
      
        return res;
    }*/


    @AuraEnabled
    public static Boolean checkRecordCloned(Id caseId){
        Case c = [SELECT Id, subject, OwnerId FROM Case WHERE Id =: caseId];
        Group g = [SELECT Id, DeveloperName FROM Group WHERE Id =: c.OwnerId];
        System.debug('Boris '+c.subject.equals('Reclamo - Stampa IDM'));
        return c.subject.equals('Reclamo - Stampa IDM');
            
      
    }

    @AuraEnabled
    public static List<Attachment> getFile(Id caseId){
        //Case c = [SELECT Id, ParentId FROM Case WHERE Id =: caseId];
        return XCSReclamiUtils.documentToAttachment(caseId);
    }

    @AuraEnabled
    public static List<Attachment> getFileIDM(Id caseId){
        Case c = [SELECT Id, ParentId FROM Case WHERE Id =: caseId];
        return XCSReclamiUtils.documentToAttachment(c.ParentId);
    }

    @AuraEnabled
    public static String getUrlForDownloadFile(Id fileToDownloadId){
        return XCSReclamiUtils.getUrlForDownloadFile(fileToDownloadId);
    }

    @AuraEnabled
    public static Boolean salvaReclamoComeGestito(Id caseId){

        Boolean valueToReturn = false;
        List<Reclami_Timestamp__c> lista = new List<Reclami_Timestamp__c>();
        Case child = [SELECT Id, ParentId, Status FROM Case WHERE Id =: caseId];
        Case parent = [SELECT Id, ParentId, Status FROM Case WHERE Id =: child.ParentId];

        parent.Status = 'Gestito';
        child.Status = 'Gestito';

        try{
            system.debug('@@@ TRY salvaReclamoComeGestito');
            update parent;
            update child;
            lista.add(XCSReclamiUtils.createFeedItem(child.Id, System.now(), 'Reclamo salvato come gestito',  UserInfo.getName(), false));
            lista.add(XCSReclamiUtils.createFeedItem(parent.Id, System.now(), 'Reclamo salvato come gestito',  UserInfo.getName(), false));
            insert lista;
            valueToReturn = true;
            XCSReclamiUtils.writeXCSMessaggio(parent);
            XCSReclamiUtils.writeXCSMessaggio(child);

        }catch(Exception e){
            system.debug('@@@ CATCH salvaReclamoComeGestito');
            valueToReturn = false;
        }
        system.debug('@@@ valueToReturn salvaReclamoComeGestito: '+valueToReturn);
        return valueToReturn;
    }

    @AuraEnabled
    public static Boolean isReclamoReadOnly(Id caseId){
        return XCSReclamiUtils.isReclamoReadOnly(caseId);
    }
    

    public class InitCustomDataDTO{
        @AuraEnabled
        public OCSCliente cliente;
        @AuraEnabled
        public OCSPratica pratica;
        @AuraEnabled
        public OCSPraticaFuturo praticaFuturo;
        @AuraEnabled
        public XCS_Categoria__c categoria;
        @AuraEnabled
        public CodaXSocieta__mdt codaSelezionata;
        @AuraEnabled
        public CRM_RCL_Tipologia_Reclamo__mdt tipo;
        @AuraEnabled
        public List<XCS_Mittente__c> mittenti;
        @AuraEnabled
        public List<Attachment> allegati;
        @AuraEnabled
        public String modalitaInvio;
        @AuraEnabled
        public String stageInadempimento;
    }
  

    

}