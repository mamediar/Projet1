public without sharing class CRMReclamiInadempimentoFAndTCtrl {
    
    @AuraEnabled
    public static Case getReclamo(String reclamoId){
        return [SELECT id, subject, caseNumber, Numero_Reclamo__c, NumeroPratica__c, 
                CreatedDate, LastModifiedDate, Status, Codice_Cliente__c, AccountId, Categoria_Riferimento__c
                FROM CASE WHERE id =: reclamoId];       
    }
    
    @AuraEnabled
    public static XCS_Sites_Token__c  tokenCTRL(String tokenId){
        return [Select id, name from XCS_Sites_Token__c  where token__c = :tokenId limit 1];
    }
    
    @AuraEnabled
    public static Account getCliente(String accountId){
        return [SELECT id, FirstName, LastName,  
                getCodice_Cliente__c , OCS_external_id__c 
                FROM Account WHERE id =: accountId];       
    }  
    
    @AuraEnabled
    public static String getCategoria(String categoriaId){
        String name = [select Name from XCS_Categoria__c where id =: categoriaId].Name;
        return name;
    }
    @AuraEnabled
    public static String makeMessage(String testo, String firma){
        String underscores = '--------------------------------------------';
        String intestazione = 'Risposta tramite Forward and Track da: ' + firma + '\n';
        String res = 'Messaggio: ' + testo;
        String totale = intestazione + '\n' + underscores + '\n' + res + '\n' + underscores;
        System.debug('feed item body: '+totale);
        return totale;
    }
    
    @AuraEnabled
    public static void updateCount(String recordId, String messaggio, List<Attachment> allegati, String firma, XCS_Sites_Token__c token){ 
	    Case c = [Select status, F_T_Received_Count__c, F_T_Sent_Count__c from case where id =: recordId];
        List<Id> listaDocumentId = new List<Id>();
        if(allegati.size() > 0){ 
            system.debug('@@@finalConfirm');
            listaDocumentId = XCSReclamiUtils.createFile(allegati, recordId);
        }
        List<String> documentIdList = new List<String>();
        System.debug('@@@@@@@' + allegati);
       	 for(Attachment attach : allegati){ 
                if(attach.Description != null){
                    String documentId = attach.Description.split('=').get(0);
                    if(!documentIdList.contains(documentId)){
                        documentIdList.add(documentId);             
                    }
                }
            }
        System.debug('');
        String concatDocumentId = String.join(listaDocumentId,',');
        String nota = makeMessage(firma,messaggio);
       	c.F_T_Received_Count__c = (c.F_T_Received_Count__c != null && c.F_T_Received_Count__c != 0) ? c.F_T_Received_Count__c+1 : 1;
        if((c.F_T_Received_Count__c == c.F_T_Sent_Count__c && c.F_T_Sent_Count__c == 2)){
            c.Status = 'F&T Updated';
            c.Stage_Inadempimento__c = '4167';
        }
        else if((c.F_T_Received_Count__c == c.F_T_Sent_Count__c && c.F_T_Sent_Count__c == 4)){
             c.Status = 'F&T Updated';
            // MODIFICHE CHIUSURA
        }
        Create_Feed_Item__e myEvent = new Create_Feed_Item__e(
            UtenteId__c = UserInfo.getUserId(),
            Messaggio__c = nota,
            Title__c = 'Corrispondenza',
        	recordId__c = recordId,
            Lista_File__c = concatDocumentId
        	);
        Database.SaveResult sr = EventBus.publish(myEvent);
        
        if(sr.isSuccess()){
            System.debug('Successfully published event.');
            update c; 
            
            //TODO: bruciare token
            // SitesTokenUtil.burnToken(myCase.Id);
         
      
        }else{
            for(Database.Error err : sr.getErrors()) {
                System.debug('Error returned: ' +
                             err.getStatusCode() +
                             ' - ' +
                             err.getMessage());
            }
            
        }
           
        /* ContentNote cn = new ContentNote();
        cn.Title = 'Corrispondenza';
            cn.Content = Blob.valueOf(body.escapeHTML4());
        insert(cn);
        */
       /* if(c.F_T_Received_Count__c == c.F_T_Sent_Count__c)
            c.Status = 'F&T Updated';
        
        Integer allegatiOriginaliSize = getFiles(recordId).size();
          List<Attachment> attList = new List<Attachment>();
        if(allegati.size() > 0){ 
                    
            for(Attachment a : allegati){
                if(a.ParentId == null){
                    a.Body = EncodingUtil.base64Decode(a.Body + '');
                    a.ParentId = c.Id;
                    attList.add(a);    
                }
            }
            */
           
     //   }
        /* 
//l'assegnazione a idm avviene quando lo stage diventa End, nella classe CRMReclamiGestioneContainerController nel metodo handleInadempimento
if(c.F_T_Received_Count__c == 4){ 
// il controllo è sul == 4 perché solo al terzo step si cambierà la coda di gestione del case, e 
// per sapere che ci troviamo al terzo step del processo lo verifichiamo con il ReceivedCount che
// sicuramente sarà = 4, in quanto saranno 4 le risposte inviate dal form di F&T da parte del filialista
Group g = [SELECT DeveloperName, Type, Name FROM Group WHERE Type = 'Queue' AND DeveloperName ='Q52' ]; //IDM RESPONSE STAFF
c.OwnerId = g.Id;
String subject = 'Chiusura Reclamo non Grave';
CRMReclamiGestioneContainerController.postToChatterWithSubject(recordId, subject);
//Si dovrà inoltre postare sul chatter un messaggio di avviso alla filiale di riferimento
//e all'ufficio monitoraggio dealer

}*//*
        if(c.F_T_Received_Count__c == c.F_T_Sent_Count__c && c.F_T_Sent_Count__c==2){
           Group g = [Select id, name, developername from Group where DeveloperName = 'q72'];
            c.OwnerId = g.id;
			c.Stage_Inadempimento__c = '4167';
            
            Case res = [Select id,branch__c,Disposition__c, branch__r.Ocs_external_id__c, numero_progressivo_reclamo__c, AccountId, Tipo_Pratica__c, categoria_riferimento__c, tipo_reclamo__c,
                       Numero_reclamo__c,Numeropratica__c, data_ricezione__c, recordtypeid, Referenced_Company__c From Case Where id = :recordId];
            Group codaFiliale= null;
            if(res.branch__c != null && res.branch__r.Ocs_external_id__c != null){
                codaFiliale = [Select id from Group Where developerName =: res.branch__r.Ocs_external_id__c];
            }
            Case primoCase = new Case();
            
            primoCase.Subject = 'Verifica Richiesta';
            primoCase.Disposition__c = res.Disposition__c;
            primoCase.Numero_Progressivo_Reclamo__c = res.Numero_Progressivo_Reclamo__c;
            primoCase.AccountId	= res.AccountId;
            primoCase.Tipo_Pratica__c = res.Tipo_Pratica__c;
            primoCase.categoria_riferimento__c  = res.categoria_riferimento__c ;
            primoCase.tipo_reclamo__c = res.tipo_reclamo__c;
            primoCase.Inadempimento_Grave__c = true;
            primoCase.tipo_pratica__c = res.Tipo_Pratica__c;
            primoCase.Numero_reclamo__c = res.Numero_reclamo__c;
            primoCase.NumeroPratica__c = res.NumeroPratica__c;
            primoCase.Data_Ricezione__c = res.data_ricezione__c;
            primoCase.Status = 'Ricevuto';
            
            primoCase.recordtypeid=res.recordtypeid;
            primoCase.Referenced_Company__c = res.Referenced_Company__c;
            primoCase.ownerId = codaFiliale.id; 
            primoCase.parentId = res.id;
            Case secondo = primoCase.clone();
            insert primoCase;
            insert secondo;
            
            
            if(token!=null){
                List<XCS_Sites_Token__c> lista = new List<XCS_Sites_Token__c>();
                lista.add(token);
               // SitesTokenUtil.burnToken(lista);
            }
        }
        
        update c;
        
       // messaggio += '\n risposta inviata da: ' + firma;
        
      // XCSReclamiUtils.creaCorrispondenza(c, messaggio, attList);
       //XCSChatterUtils.postFromSite(c.Id, messaggio, 'Postato dal F&T'); */
    }
    
    @AuraEnabled
    public static List<Attachment> getFiles(String recordId){        
        List<Attachment> allegati = [Select id, name, body, ParentId from Attachment where ParentId =: recordId];
      
        return allegati;
    }
}