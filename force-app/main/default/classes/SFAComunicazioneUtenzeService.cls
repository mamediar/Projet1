@RestResource(urlMapping='/sfa_comunicazione_utenze/*')
global with sharing class SFAComunicazioneUtenzeService {


    private final static String DATI_NON_COMPLETI = '4';
    private final static String DEALER_NON_TROVATO = '1';
    private final static String ERRORE_ATTIVITA = '2';
    private final static String ERRORE_ITEM = '3';
    private final static String OK = '0';
    private final static Map<String, String> errorMessage = new Map<String, String>{DATI_NON_COMPLETI => 'DATI NON COMPLETI',
                                                               DEALER_NON_TROVATO => 'DEALER NON TROVATO IN BASE DATI',
                                                               ERRORE_ATTIVITA => 'ERRORE NELLA CREAZIONE ATTIVITA',
                                                               ERRORE_ITEM=>'ERRORE NELLA CREAZIONE ITEM' ,
                                                               OK => 'OK'};

    private static List<String> listEmailAddress = EmailUtils.listEmailAdmin();

    global final static String EMAIL_DELEAR_NON_TROVATO = 'sfa_comunicazione_dealer_non_trov';
    global final static String EMAIL_FILIALE_NON_CORR = 'sfa_comunicazione_filiale_non_corr';
    global final static String EMAIL_CREAZ_ATTIVITA = 'sfa_comunicazione_crea_attivita';
    global final static String EMAIL_CREAZ_ITEM = 'sfa_comunicazione_crea_item_attiv';

    private final static XCS_Categoria__c categoriaComunicazione;
    static {
        categoriaComunicazione = [SELECT ID FROM XCS_Categoria__c WHERE External_Id__c = 'AT0114' LIMIT 1];
    }

    global class SFAComunicazioneUtenzeRequest {
        global String utnom;
        global String ocs_code;
        global String coll_lastname;
        global String filiale;
        global String tipo_utenza;
        global String data_creazione;
        global String canale;
        global String coll_name;
        global String ocs_col;
        global String desc_err_utenza;
        global SFAComunicazioneUtenzeRequest(String utnom, String ocs_code,String coll_lastname,String filiale,String tipo_utenza,String data_creazione,String canale,String coll_name,String ocs_col,String desc_err_utenza){
            this.utnom = utnom;
            this.ocs_code = ocs_code;
            this.coll_lastname = coll_lastname;
            this.filiale = filiale;
            this.tipo_utenza = tipo_utenza;
            this.data_creazione = data_creazione;
            this.canale = canale;
            this.coll_name = coll_name;
            this.ocs_col = ocs_col;
            this.desc_err_utenza = desc_err_utenza;
        }
    }

    global class SFAComunicazioneUtenzeResponse {
        global String cod_err;
        global String message;
        global SFAComunicazioneUtenzeResponse(String cod_err,String message) {
            this.cod_err = cod_err;
            this.message = message;
        }
    }


    private static Boolean isValidRequest(SFAComunicazioneUtenzeRequest request) {
        if (request==null) { return false; }
        if (request.utnom==null || String.isBlank(request.utnom)) { return false; }
        if (request.ocs_code==null || String.isBlank(request.ocs_code)) { return false; }
        if (request.coll_lastname==null || String.isBlank(request.coll_lastname)) { return false;  }
        if (request.filiale==null || String.isBlank(request.filiale)) { return false;  }
        if (request.tipo_utenza==null || String.isBlank(request.tipo_utenza)) { return false;}
        if (request.data_creazione==null || String.isBlank(request.data_creazione)) {return false;}
        // check data creazione format 
        if (request.data_creazione.length()!=8 && !Pattern.matches('^[0-9]{8}$', request.data_creazione)){
            System.debug('isValidRequest ERROR data creazione FORMATTATA MALE:'+request.data_creazione);
            return false;
        }
        if (request.canale==null || String.isBlank(request.canale)) {return false;}        
        return true;
    }
  
    

    private static Case creaAttivitaUtnom(SFAComunicazioneUtenzeRequest request,Account dealer, Account filiale){
        Case attivita = new Case();
        attivita.AccountId = dealer.id;
        attivita.Priority = 'Low';
        attivita.Categoria_Riferimento__c = categoriaComunicazione.id;
        if (filiale!=null) {
            attivita.Branch__c = filiale.id;
        }
        attivita.Subject = 'Comunicazione Utenze';
        attivita.Status = 'New';
        attivita = CaseUtils.assignToFilialeQueueByDealer(attivita,dealer.OCS_External_Id__c);
        attivita.RecordTypeId =RecordTypeUtil.getCaseRecordType('Comunicazione_Utenze');
        insert attivita;
        return attivita;
    }


    private static void creaItemAttivita(SFAComunicazioneUtenzeRequest request,Account dealer,Account filiale,Case attivita){
        Comunicazione_Utenze__c utenzaNominale = new Comunicazione_Utenze__c();
        utenzaNominale.Utenza__c = request.utnom;
        utenzaNominale.First_Name__c = request.coll_name;
        utenzaNominale.Last_Name__c = request.coll_lastname;
        utenzaNominale.Note__c = request.desc_err_utenza;
        if (filiale!=null) {
           utenzaNominale.Branch__c = filiale.id;
        }
        utenzaNominale.Data_Creazione__c = request.data_creazione;
        utenzaNominale.Canale__c = request.canale;
        utenzaNominale.Tipo_Utenza__c = request.tipo_utenza;
        utenzaNominale.OCS_Code_Intermediario__c = dealer.id;
        utenzaNominale.OCS_Code_Delegato__c = request.ocs_col;
        utenzaNominale.CaseAttivit_di_Riferimento__c = attivita.id;
        insert utenzaNominale;
    }

   //   same method to generate email dealer non trovato, errore creazione attivita, errore creazione item
   //
   private static Messaging.SingleEmailMessage generateEmail(List<String> emailAddresses,String emailTemplateName, String ocs_code) {       
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        String defaultContactId = [SELECT Id FROM Contact WHERE Account.OCS_External_Id__c = 'N00000'][0].Id;
        String q = 'SELECT Id, Name, DeveloperName, Subject, Body FROM EmailTemplate WHERE DeveloperName = \''+emailTemplateName+'\'';
        EmailTemplate emailTemplate = (EmailTemplate)Database.query(q)[0];
        String body = emailTemplate.Body;
        body = body.replace('{ocs_code}', ocs_code);
        email.setSubject(emailTemplate.Subject);
        email.setTargetObjectId(defaultContactId);
        email.setTemplateId(emailTemplate.Id);
        email.setTreatTargetObjectAsRecipient(false);
        email.setToAddresses(emailAddresses);
        email.setPlainTextBody(body);
        email.setSenderDisplayName('COMPASS');
        email.saveAsActivity = false;       
        return email;
    }   

   private static Messaging.SingleEmailMessage generateEmailFilialeNonCorrispondente(List<String> emailAddresses,String ocs_code,String filiale_su_crm,String filiale) {       
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        String defaultContactId = [SELECT Id FROM Contact WHERE Account.OCS_External_Id__c = 'N00000'][0].Id;
        String q = 'SELECT Id, Name, DeveloperName, Subject, Body FROM EmailTemplate WHERE DeveloperName = \''+EMAIL_FILIALE_NON_CORR+'\'';
        EmailTemplate emailTemplate = (EmailTemplate)Database.query(q)[0];
        String body = emailTemplate.Body;
        body = body.replace('{ocs_code}', ocs_code);
        body = body.replace('{filiale_su_crm}', filiale_su_crm);
        body = body.replace('{filiale}', filiale);
        email.setSubject(emailTemplate.Subject);
        email.setTargetObjectId(defaultContactId);
        email.setTemplateId(emailTemplate.Id);
        email.setTreatTargetObjectAsRecipient(false);
        email.setToAddresses(emailAddresses);
        email.setPlainTextBody(body);
        email.setSenderDisplayName('COMPASS');
        email.saveAsActivity = false;       
        return email;
    }   


    //  ricerca del dealer usando modulo già esistente
    private static Account ricercaDealerPerOCS(String ocsCode){
        System.debug('Starting ricercaOCS per ocsCode ' + ocsCode);
        ocsCode='D'+ocsCode;
        Account accRicerca = new Account(
            OCS_External_Id__c = ocsCode
        );
        final Map<Account, DealerAccount> accountMap = new Map<Account, DealerAccount>();
        accountMap.put(accRicerca, null);
        XCSRicercaAnagraficaDealer.ricercaPerOcsID(accountMap);

        DealerAccount outDelaer = accountMap.get(accRicerca);
        System.debug('outDelaer trovato su CRM: ' + outDelaer);
        if (outDelaer <> null) {
            return outDelaer.account;
        }
        return null;
    }


    private static SFAComunicazioneUtenzeResponse comunicazioneUtenze(SFAComunicazioneUtenzeRequest request) {
         SFAComunicazioneUtenzeResponse response = new SFAComunicazioneUtenzeResponse(OK,errorMessage.get(OK));
        // 1.	Se tutti i parametri non sono stati valorizzati
        if (!isValidRequest(request)) {
            return new SFAComunicazioneUtenzeResponse(DATI_NON_COMPLETI,errorMessage.get(DATI_NON_COMPLETI));
        }
        //2.	Ricerca sul CRM il convenzionato in base all’ocs_code fornito come input
        Account dealerFound = ricercaDealerPerOCS(request.ocs_code);
        if (dealerFound==null) {
            //	se non trova il dealer
            Messaging.SingleEmailMessage email = generateEmail(listEmailAddress,EMAIL_DELEAR_NON_TROVATO,request.ocs_code);
            EmailUtils.sendEmail(email);
            return new SFAComunicazioneUtenzeResponse(DEALER_NON_TROVATO,errorMessage.get(DEALER_NON_TROVATO));
        }
        // 3.	Se dealer presente, verifica che la filiale di riferimento presente sul CRM relativa a quel dealer 
        // sia uguale a quella passata nel parametro filiale
        Account dealerBranch  = [SELECT Id, Branch__c FROM Account WHERE Id=:dealerFound.id LIMIT 1];
        Account filialeFound = null;
        if (dealerBranch!=null && dealerBranch.Branch__c!=null) {
            filialeFound  = [SELECT Id, Name, OCS_External_Id__c FROM Account WHERE Id =:dealerBranch.Branch__c LIMIT 1];
        }
        String codFilialeFound = '';
        if (filialeFound!=null && filialeFound.OCS_External_Id__c!=null && String.isNotEmpty(filialeFound.OCS_External_Id__c)) {
            codFilialeFound = filialeFound.OCS_External_Id__c.substring(1);
        }
        if (filialeFound==null || !request.filiale.equals(codFilialeFound)) {
            //a.	Se non corrispondono invia una mail agli amministratori
            Messaging.SingleEmailMessage email = generateEmailFilialeNonCorrispondente(listEmailAddress,request.ocs_code,codFilialeFound,request.filiale);
            EmailUtils.sendEmail(email);              
        }


        // 4.	Se tutto OK, allora verifica se esiste già una attività su SFA di tipo “utnom” in stato aperto
        //  per quel dealer
        Case attivita = null;
        List<Case> attivitaUtnom = [SELECT ID FROM Case WHERE Status = 'New' AND AccountId =:dealerFound.id AND Categoria_Riferimento__c =:categoriaComunicazione.id];
        if (attivitaUtnom!=null && attivitaUtnom.size()>0) {
            //	Se esiste recupera l’id dell’attività
            attivita = attivitaUtnom[0];
        } else {
            try {
                  attivita = creaAttivitaUtnom(request,dealerFound,filialeFound);
            } catch (Exception ex) {
                 // 5.	Se la creazione dell’attività non va a buon fine:
                  System.debug('ERROR creaAttivitaUtnom:'+ex.getMessage());
                  Messaging.SingleEmailMessage email = generateEmail(listEmailAddress,EMAIL_CREAZ_ATTIVITA,request.ocs_code);
                  EmailUtils.sendEmail(email);              
                  return new SFAComunicazioneUtenzeResponse(ERRORE_ATTIVITA,errorMessage.get(ERRORE_ATTIVITA));
           }
        }
        //  6.	Aggiunge un item all’attività per la  nuova utenza con tutti i dati passati in input
        try {
            creaItemAttivita(request,dealerFound,filialeFound,attivita);
        } catch (Exception ex) {
           // 	Se la creazione dell'item dell attività non va a buon fine:
            System.debug('ERROR creaAttivitaUtnom:'+ex.getMessage());
            Messaging.SingleEmailMessage email = generateEmail(listEmailAddress,EMAIL_CREAZ_ITEM,request.ocs_code);
            EmailUtils.sendEmail(email);              
            return new SFAComunicazioneUtenzeResponse(ERRORE_ITEM,errorMessage.get(ERRORE_ITEM));
        }              
        return response;
    }

    @HttpPost
    global static void doPost(String utnom, String ocs_code,String coll_lastname,String filiale,String tipo_utenza,String data_creazione,String canale,String coll_name,String ocs_col,String desc_err_utenza) {
        SFAComunicazioneUtenzeRequest request = new SFAComunicazioneUtenzeRequest(utnom,ocs_code,coll_lastname,filiale,tipo_utenza,data_creazione,canale,coll_name,ocs_col,desc_err_utenza);
        SFAComunicazioneUtenzeResponse response = comunicazioneUtenze(request);
        ApiUtils.serializeResponse(RestContext.response,RestContext.request,response);
    }

}