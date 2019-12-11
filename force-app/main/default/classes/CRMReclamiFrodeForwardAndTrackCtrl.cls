public without sharing class CRMReclamiFrodeForwardAndTrackCtrl {        
    
    @AuraEnabled
    public static Case getReclamo(String reclamoId){
        return [SELECT id, subject, caseNumber, Numero_Reclamo__c, NumeroPratica__c, Referenced_Company__c,
                CreatedDate, LastModifiedDate, Status, Codice_Cliente__c, AccountId, Categoria_Riferimento__c 
                FROM CASE WHERE id =: reclamoId];       
    }     
    
    @AuraEnabled
    public static Account getCliente(String accountId){
        Account acc =  [SELECT id, FirstName, LastName,  
                getCodice_Cliente__c , OCS_External_Id__c
                FROM Account WHERE id =: accountId];       
         acc.OCS_External_Id__c = acc.OCS_External_Id__c.replace('C','');
        return acc;
    }     
    
    @AuraEnabled
    public static XCS_Categoria__c getCategoria(String categoriaId){
        XCS_Categoria__c categoria = [select Name, External_Id__c from XCS_Categoria__c where id =: categoriaId];
        return categoria;
    }
    
    //Non serve
    public static List<Attachment> getFiles(String recordId){        
        List<Attachment> allegati = XCSReclamiUtils.documentToAttachment(recordId);
        String sfdcURL = URL.getSalesforceBaseUrl().toExternalForm();
        return allegati;
    }
    
    @AuraEnabled
    public static String makeMessage(String frode, String testoStandard, String testoStandardValue, String firma){
        String underscores = '--------------------------------------------';
        String intestazione = 'Risposta tramite Forward and Track da: ' + firma + '\n';
        String res = 'Frode: ' + frode + '\n' + 'Testo standard: ' + testoStandard + '\n' + 'Testo selezionato: ' + testoStandardValue;
        String totale = intestazione + '\n' + underscores + '\n' + res + '\n' + underscores;
        System.debug('feed item body: '+totale);
        return totale;
    }
    

    @AuraEnabled
    public static List<CRMReclamiGestioneRispostaLetteraCtrl.ComboBox> loadTesti(XCS_Categoria__c categoria, String societa){
        List<CRMReclamiGestioneRispostaLetteraCtrl.ComboBox> cmbx = CRMReclamiGestioneRispostaLetteraCtrl.loadStdtexts(categoria.External_Id__c,societa);
        return cmbx;      
    } 
    
    @AuraEnabled
    public static String getMessageStandard(String idTesto, Id caseId){
        return CRMReclamiGestioneRispostaLetteraCtrl.getMessageStandard(idTesto, caseId);
    }
    
    
    
    @AuraEnabled
    public static void fileUpload(Case myCase, List<Attachment> allegati){
        XCSReclamiUtils.createFile(allegati, myCase.Id);
    }
    
    @AuraEnabled
    public static String  finalConfirm(Case myCase, String frode, String testoStandard, String testoStandardValue, String firma, 
                                    List<Attachment> allegati, Integer allegatiOriginali, String messaggio)
    {   
        List<Id> listaDocumentId = new List<Id>();
        if(allegati.size() > 0){ 
            system.debug('@@@finalConfirm');
            listaDocumentId = XCSReclamiUtils.createFile(allegati, myCase.Id);
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
        String testo = makeMessage(frode,testoStandard,testoStandardValue, firma);   
        myCase.status='F&T Updated';
       XCSReclamiUtils.Corrispondenza corr = new XCSReclamiUtils.Corrispondenza(myCase, testo, listaDocumentId);
      
        Create_Feed_Item__e myEvent = new Create_Feed_Item__e(
            UtenteId__c = UserInfo.getUserId(),
            Messaggio__c = testo+'\n'+messaggio,
            Title__c = 'Corrispondenza',
        	recordId__c = myCase.id,
            Lista_File__c = concatDocumentId
        	);

        Database.SaveResult sr = EventBus.publish(myEvent);
        
        System.debug('feed item publish result: '+sr.isSuccess());
      

        if (sr.isSuccess()) {
            System.debug('Successfully published event.');
            update myCase; 
            
            //TODO: bruciare token
             SitesTokenUtil.burnToken(myCase.Id);
         
      
        } else {
            for(Database.Error err : sr.getErrors()) {
                System.debug('Error returned: ' +
                             err.getStatusCode() +
                             ' - ' +
                             err.getMessage());
            }
            //throw new ErrorException('Errore Salvataggio');
        }
        //postANote(frode, testoStandard, testoStandardValue, firma, myCase, messaggio);
      
      

                    
        //TODO: bruciare token
       SitesTokenUtil.burnToken(myCase.Id);
         // String testo = makeMessage(frode,testoStandard,testoStandardValue, firma);   
        //  XCSReclamiUtils.creaCorrispondenza(myCase,testo,allegati ); 
       return JSON.serialize(corr)+' '+sr.isSuccess();
    } 
    
    public class ErrorException extends Exception{}
    
    @AuraEnabled
    public static string getUserName(){
        return Userinfo.getName();
    }  
    
    //metodo chiamato dal process builder "Send Frode Email", quando un Case è identificato come frode
    @InvocableMethod(label='Send frode mail')   
    public static void sendFrodeMail(List<Case> caseList) {
        Case myCase = caseList[0];
        List<XCS_CompassParameters__c> siteUrlList = [SELECT Id, Value__c FROM XCS_CompassParameters__c WHERE Name = 'forwardandtrack.baseurl'];
        List<XCS_CompassParameters__c> toAddressList = [SELECT Id, Value__c FROM XCS_CompassParameters__c WHERE Name = 'ufficiofrodi.mail'];
        List<EmailTemplate> templateList = [SELECT Id, Subject, HtmlValue FROM EmailTemplate WHERE DeveloperName='Frode'];
        String crmUrl, siteUrl;
        if (templateList.size() > 0 && siteUrlList.size() > 0 && toAddressList.size() > 0) {
            crmUrl = URL.getSalesforceBaseUrl().toExternalForm() + '/lightning/cmp/c__CRMReclamiFrodeForwardAndTrack?c__objectid=' + myCase.Id;
            siteUrl = siteUrlList[0].Value__c+'?token='+SitesTokenUtil.generateToken(myCase.Id,datetime.now().addMinutes(400),'c:CRMReclamiFrodeForwardAndTrack','c:CRMReclamiFrodeForwardAndTrackApp');
            System.debug('crmUrl: '+crmUrl);
            System.debug('siteUrl: '+siteUrl);
            
            String templateSubject = templateList[0].Subject;
            System.debug('templateSubject before replace: '+templateSubject);
            templateSubject = templateSubject.replace('{!Case.Numero_Reclamo__c}', myCase.Numero_Reclamo__c);
            System.debug('templateSubject after replace: '+templateSubject);
            
            String templateBody = templateList[0].HtmlValue;
            System.debug('templateBody before replace: '+templateBody);
            templateBody = templateBody.replace('{!crmUrl}', crmUrl);
            templateBody = templateBody.replace('{!siteUrl}', siteUrl);
            System.debug('templateBody after replace: '+templateBody);
            
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setSenderDisplayName('Salesforce');
            email.setSubject(templateSubject);
            email.setHtmlBody(templateBody);
            email.setToAddresses(new List<String> {toAddressList[0].Value__c}); 
            System.debug('emailToSend: '+email);
            List<Messaging.SendEmailResult>   results =  Messaging.sendEmail(new List<Messaging.SingleEmailMessage> {email});
            System.debug(results);
            CaseUtils.changeStatus(myCase.Id, 'F&T Sent');
        }else{
            System.debug('ERROR: impossibile inviare l\'email F&T');
        }
        
    }
}