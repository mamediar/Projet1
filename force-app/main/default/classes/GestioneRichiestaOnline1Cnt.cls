/**
 * ***********************************************************************************
 *     * @author abdoulaye.diop@compass.com.dev
 *     * @date  16/05/2019
 *     * @description Wizard Controller for GestioneRichiestaOnline1 Aura Component
 * ************************************************************************************
 **/
public with sharing class GestioneRichiestaOnline1Cnt { 

    public static List<String> queuesNotShowLinkEvo = new List<String>{'Q340','Q377','Q525','Q336'};
    public static final List<String> codesQueue = new List<String>{'Q330', 'Q331', 'Q332'};

    /**
     * @Author AD
     * @date  16/05/2019
     * @description Method to get a Case related to Anomalie_Doc__c
     * @param String idCase the Id of the case to search
     **/
    @AuraEnabled
    public static Map<String, Object> getCase(String idCase){
        Map<String, Object> response = new Map<String, Object>();
        try {
            Case caseObject = [SELECT Id, Is_Discordanza_Cellulare__c, TentativoNonRicorda__c,RO_Link_Bozza__c, stato_ocs__c, OwnerId, RO_fea__c, NumeroPratica__c,
             Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c, Tentativo__c, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family,
              RO_Vecchio_Cellulare__c, (SELECT Id, codice_Anomalia__c, Descrizione_Anomalia_Op__c, Codice_Documento__c, 
                descrizione_Documento__c FROM Anomalie_Doc__r) FROM Case WHERE Id= :idCase];
                System.debug('##### gestione stato '+ caseObject.stato_ocs__c);
                Group gr = [SELECT Id, Name, DeveloperName FROM Group WHERE Type = 'Queue' AND Id = :caseObject.OwnerId];     
                
            /*if (CaseService.checkCaseInQueue(caseObject.OwnerId)) {
                //Group gr = [SELECT Id, Name, DeveloperName FROM Group WHERE Type = 'Queue' AND Id = :caseObject.OwnerId];            
                response.put('isInQueue', true);
                
                if (codesQueue.indexOf(gr.DeveloperName) != -1) {
                    if (CaseService.checkEventByCFAndCreateDate(idCase) || CaseService.checkLastModificationDate(idCase) || CaseService.checkCodiceOcs(caseObject.AccountId)) {
                        caseObject.Note__c = '-SELF-';
                        CaseService.addCasesToQueue(new List<Case> {caseObject}, 'Q525');
                        response.put('developerName', 'Q525');
                        response.put('messaggio', 'Il cliente sta proseguendo la richiesta online. Non contattare.');
                    } else {
                        response.put('developerName', gr.DeveloperName);
                        response.put('messaggio', '');
                    }
                } else if (gr.DeveloperName == 'Q375') {
                    if (CaseService.checkCodiceOcs(caseObject.AccountId) || CaseService.checkLastModificationDate(idCase)) {
                        caseObject.Note__c = '-SELF-';
                        CaseService.addCasesToQueue(new List<Case> {caseObject}, 'Q525');
                        response.put('developerName', 'Q525');
                        response.put('messaggio', 'Il cliente sta proseguendo la richiesta online. Non contattare.');
                    } else {
                        response.put('developerName', gr.DeveloperName);
                        response.put('messaggio', '');
                    }
                } else {
                    response.put('developerName', gr.DeveloperName);
                    response.put('messaggio', '');
                }
                  
                response.put('developerName', gr.DeveloperName);
                response.put('messaggio', '');          
            } else {
                response.put('isInQueue', false);
                response.put('developerName', '');
                response.put('messaggio', '');
            }*/
            response.put('developerName', gr.DeveloperName);
            response.put('case', caseObject);
            response.put('error', false);
        } catch (Exception e) {
            response.put('message', e.getCause() + ' ' + e.getMessage()+ ' '+ e.getStackTraceString());
            response.put('error', true);
            response.put('isInQueue', false);
            response.put('messaggio', '');
        }
        return response;
    }

    /**
     * @Author AD
     * @date  17/05/2019
     * @description Method to update a Case 
     * @param Case case an instance of case
     **/
    @AuraEnabled
    public static Map<String, Object> updateCase(Case caseObject, String code , String firstLevel, String secondLevel, 
                                                    String thirdLevel, Boolean showLinkEvo){
        
        Map<String, Object> response = new Map<String, Object>();
        response.put('linkevo', false);
        response.put('isOpenDomanda', false);
        try {

            Decimal cmpt = caseObject.Tentativo__c;
            System.debug('********* case Object '+cmpt);
            if (cmpt == null) {
                cmpt = 1;
            } else {
                cmpt++;
            }
            caseObject.Tentativo__c = cmpt;
            CaseDomain.Assembly assembly = new CaseDomain.Assembly(caseObject, code, firstLevel, secondLevel, 
                thirdLevel, showLinkEvo);

            String developerName = CaseService.getGroupByOwner(caseObject.OwnerId);
            System.debug('#l developerName '+ developerName);
            String state = assembly.getEtat(developerName);
            System.debug('#l state '+ state);
            switch on state {
                when '100' {
                    String dev = 'Q524';
                    if (developerName == 'Q338') {
                        dev = 'Q525';
                        showLinkEvo = true;
                    }
                    CaseDomain.CaseContext context = new CaseDomain.CaseContext(caseObject, dev, showLinkEvo);
                    context.setState(new CaseDomain.ContattoNonEseguitoContext1());
                    response = context.action();
                } when '102' {
                    CaseDomain.CaseContext context = new CaseDomain.CaseContext(caseObject, 'Q524',  true);
                    context.setState(new CaseDomain.ContattoNonEseguitoContext2());
                    response = context.action();
                } when '103' {                    
                    Boolean showLink = true;
                    if ((developerName == 'Q339' && caseObject.RO_Vecchio_Cellulare__c == null) || developerName == 'Q336' || developerName == 'Q340' || developerName == 'Q377' || developerName == 'Q525' || developerName == 'Q341') {
                        showLink = false;
                    }
                    CaseDomain.CaseContext context = new CaseDomain.CaseContext(caseObject, 'Q525',  showLink);
                    context.setState(new CaseDomain.ContattoNonEseguitoContext3());
                    response = context.action();
                    CaseDomain.sendEmailDem(developerName, caseObject.Id, state);
                    
                } when '104' {
                    Boolean showLink = false;
                    if ((developerName == 'Q339' || developerName == 'Q376' || developerName == 'Q338') && caseObject.RO_Vecchio_Cellulare__c != null) {
                        showLink = true;
                    } else if(developerName == 'Q337'){
                        showLink = true;
                    }
                    CaseDomain.CaseContext context = new CaseDomain.CaseContext(caseObject, 'Q525',  showLink);
                    context.setState(new CaseDomain.ContattoNonEseguitoContext4());
                    response = context.action();
                } when '105' {
                    CaseDomain.CaseContext context = new CaseDomain.CaseContext(caseObject, 'Q524', true);
                    context.setState(new CaseDomain.ContattoNonEseguitoContext1());
                    response = context.action();
                    if (developerName == 'Q338') {
                        GestioneRichiestaOnline1Cnt.sendEmailToCompassAffari('ufficio.frodi@compass.it');
                    }
                } when '106' {
                    Boolean showLink = true;
                    if (queuesNotShowLinkEvo.indexOf(developerName) != -1 || developerName == 'Q336') {
                        showLink = false;
                    }
                    CaseDomain.CaseContext context = new CaseDomain.CaseContext(caseObject, 'Q524', showLink);
                    context.setState(new CaseDomain.ContattoNonEseguitoContext6());
                    response = context.action();
                    GestioneRichiestaOnline1Cnt.sendEmailToCompassAffari('compassaffari@compass.it');
                } when '107' {
                    CaseDomain.CaseContext context = new CaseDomain.CaseContext(caseObject, 'Q524', false);
                    context.setState(new CaseDomain.ContattoNonEseguitoContext1());
                    response = context.action();
                    if (developerName == 'Q339' && caseObject.RO_Vecchio_Cellulare__c == null ) {
                        GestioneRichiestaOnline1Cnt.sendEmailToCompassAffari('compassaffari@compass.it');
                    }
                } when '108' {
                    if (developerName == 'Q336') {
                        CaseDomain.tentativo = 5;
                        if (cmpt == 5) {
                            CaseDomain.sendEmailDem(developerName, caseObject.Id, state);
                        }
                    } else if (developerName == 'Q338') {
                        CaseDomain.tentativo = 2;
                    }
                    CaseDomain.CaseContext context = new CaseDomain.CaseContext(caseObject, 'Q525', false);
                    context.setState(new CaseDomain.ContattoNonEseguitoContext7());
                    response = context.action();
                } when '109' {
                    CaseDomain.CaseContext context = new CaseDomain.CaseContext(caseObject, 'Q524',  false);
                    context.setState(new CaseDomain.ContattoNonEseguitoContext3());
                    response = context.action();     
                    CaseDomain.sendEmailDem(developerName, caseObject.Id, state);               
                } when '110' {
                    CaseDomain.CaseContext context = new CaseDomain.CaseContext(caseObject, 'Q525',  false);
                    context.setState(new CaseDomain.ContattoNonEseguitoContext4());
                    response = context.action();
                } when '111' {
                    response.put('case', caseObject);
                } when '112' {
                    if (developerName == 'Q339' || developerName == 'Q340' || developerName == 'Q376') {
                        CaseDomain.tentativo = 3;
                    } else if (developerName == 'Q377') {
                        CaseDomain.tentativo = 10;
                    }
                    CaseDomain.CaseContext context = new CaseDomain.CaseContext(caseObject, 'Q525', false);
                    context.setState(new CaseDomain.ContattoNonEseguitoContext2());
                    response = context.action();
                } when '113' {
                    CaseDomain.CaseContext context = new CaseDomain.CaseContext(caseObject, 'Q525', false);
                    context.setState(new CaseDomain.ContattoNonEseguitoContext9());
                    response = context.action();
                    Set<Id> ids = new Set<Id>();
                    ids.add(caseObject.Id);
                    CaseDomain.ricicliEsiti(ids, developerName);
                } when '114' {
                    CaseDomain.sendEmailDem(developerName, caseObject.Id, state);
                } when '119' {
                    String dev = 'Q525';
                    switch on developerName {
                        when 'Q339' {
                            if (cmpt < 1) {
                                XCS_Template__c template = [SELECT Name, Body__c FROM XCS_Template__c LIMIT 1];
                                OCSInviaSMSInvoker.inviaSMS('', caseObject.RO_Nuovo_Cellulare__c,'','', template.Body__c);
                            } else if (cmpt == 3) {
                                CaseDomain.sendEmailDem(developerName, caseObject.Id, state);
                            }
                        }
                        when 'Q340' {
                            if (thirdLevel.toUpperCase() == 'CLIENTE NON TROVATO') {
                                if (cmpt == 3) {
                                    CaseDomain.sendEmailDem(developerName, caseObject.Id, state);
                                }
                            } else {
                                CaseDomain.sendEmailDem(developerName, caseObject.Id, state);
                            }
                        }
                        when  'Q377' {
                            CaseDomain.tentativo = 12;
                            if (cmpt < 1) {
                                XCS_Template__c template = [SELECT Name, Body__c FROM XCS_Template__c LIMIT 1];
                                OCSInviaSMSInvoker.inviaSMS('', caseObject.RO_Nuovo_Cellulare__c,'','', template.Body__c);
                            }
                            else if (cmpt == 3) {
                                CaseDomain.sendEmailDem(developerName, caseObject.Id, state);
                            }
                        }
                        when 'Q376' {
                            dev = 'Q524';
                            if (cmpt == 3) {
                                CaseDomain.sendEmailDem(developerName, caseObject.Id, state);
                                if (caseObject.RO_Vecchio_Cellulare__c == null) {
                                    XCS_Template__c template = [SELECT Name, Body__c FROM XCS_Template__c LIMIT 1];
                                    OCSInviaSMSInvoker.inviaSMS('', caseObject.RO_Nuovo_Cellulare__c,'','', template.Body__c);
                                }
                            }
                        }
                        when 'Q341' {
                            if (cmpt == 3) {
                                CaseDomain.sendEmailDem(developerName, caseObject.Id, state);
                            }
                        }
                        when else {
                            System.debug('"#l developerName ' + developerName);
                        }
                    }
                    CaseDomain.CaseContext context = new CaseDomain.CaseContext(caseObject, dev, false);
                    context.setState(new CaseDomain.ContattoNonEseguitoContext8());
                    response = context.action();
                    System.debug('#l case in response '+ response.get('case'));
                } when '120' {
                    CaseDomain.CaseContext context = new CaseDomain.CaseContext(caseObject, '',  false);
                    context.setState(new CaseDomain.ContattoNonEseguitoContext5());                    
                    response = context.action();
                    response.put('isOpenDomanda', true);
                } when else {
                    response.put('case', caseObject);
                    System.debug('#l else ');
                }
            }

            caseObject = (Case) response.get('case');            
            if(!String.isEmpty(code)){
                XCS_Disposition__c xcsDisposition = [SELECT Id FROM XCS_Disposition__c WHERE External_Id__c = :code];
                if(xcsDisposition != null){
                    caseObject.Disposition__c = xcsDisposition.Id;
                }
            }
            if (CaseDomain.isResolved) {
                caseObject.Is_Discordanza_Cellulare__c = false;
            }
            Recursion.isTriggerExecuting = true;
            update caseObject;
            String title = 'Numero Blu - '+' ';
            String body =  firstLevel +' '+  secondLevel + ' '+ thirdLevel + '\n' + caseObject.Tentativo__c;
            CaseDomain.createFeeditem(title, body, caseObject.Id);

            response.put('case', caseObject);
            response.put('error', false);
            response.put('etat', state);
            response.put('code', code);
        } catch (Exception e) {
            response.put('message', e.getCause() + ' ' + e.getMessage()+ ' '+ e.getStackTraceString() + e.getLineNumber());
            response.put('error', true);
            response.put('linkevo', false);
        }
        return response;
    }

    /**
     * @Author AD
     * @date 27/07/2019
     * @description
     * @param
     **/
    @AuraEnabled
    public static Map<String, Object> sendDomanda(Case caseObject, Object questionManagement){
        
        Map<String, Object> response = new Map<String, Object>();
        System.debug('#### questionManagement ' + questionManagement);
        try {
            String questionManagementJson = JSON.serialize(questionManagement);    
            QuestionManagement questionManagementParsed = (QuestionManagement) JSON.deserialize(questionManagementJson, QuestionManagement.class);
            Map <String, Object> data = RecuperaDatiPostvenditaService.recuperaDatiPostvenditaControl(caseObject.Id, questionManagementParsed);
            System.debug('#### data ####'+ JSON.serialize(data));
            if (data.get('error') == true) {
                response.put('error', true); 
                response.put('message', data.get('errorMessage'));
            } else {
                response.put('error', false); 
                response.put('data', data);
            }
        } catch (Exception e) {
            response.put('message', e.getCause() + ' ' + e.getMessage()+ ' '+ e.getStackTraceString() + e.getLineNumber());
            response.put('error', true);            
        }
        return response;
    }

    /**
     * @author ADIOP
     * @date 25/06/2019
     **/
    @future
    public static void sendEmailToCompassAffari(String email){
        EmailTemplate template = [SELECT Id FROM EmailTemplate WHERE Name = 'Compass Affari Email Template'];
        List<Messaging.SingleEmailMessage> allMsg = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        mail.setToAddresses(new String[] {email});
        mail.setSubject('test');
        mail.setTemplateID(template.Id); 
        mail.setSaveAsActivity(true);
        allMsg.add(mail);

        try {
            //Messaging.sendEmail(allMsg, false);
            //send the email
            List<Messaging.SendEmailResult> results = Messaging.sendEmail(allMsg);            
            // we can then check for success            
        } catch (EmailException e) {
            System.debug('sendTemplatedEmail error. ' + e.getMessage());
        }
    }

    /**
     * @author ADIOP
     * @date 05/07/2019
     */
    public static List<Anomalie_Doc__c> getAnomaliesByCase(String idCase){
        List<Anomalie_Doc__c> anomalies  = [SELECT Id FROM Anomalie_Doc__c  WHERE CaseId__c =:idCase];
        return anomalies;
    }

    /**
     * @Author AD
     * @date  30/07/2019
     * @description Method to update a Case 
     * @param Case case an instance of case
     **/
    @AuraEnabled
    public static Map<String, Object> updateNoteCase(Case caseObject, String developerName, Boolean sendEmail){
        Map<String, Object> response = new Map<String, Object>();
        response.put('linkevo', true);
        try {
            Recursion.isTriggerExecuting = true;
            Decimal cmpt = caseObject.TentativoNonRicorda__c;
            System.debug('********* case Object '+cmpt);
            if (cmpt == null) {
                cmpt = 1;
            } else {
                cmpt++;
            }
            caseObject.TentativoNonRicorda__c = cmpt;
            if (developerName != '') {
                Group gr = CaseService.getQueue(developerName);
                if (gr != null) {
                    caseObject.OwnerId = gr.Id;
                }
                if (developerName == 'Q524') {
                    caseObject.Status = 'Closed';
                }
            }            
            update caseObject;
            response.put('case', caseObject);
            response.put('error', false);
            if (cmpt == 2 && developerName == 'Q338') {
                GestioneRichiestaOnline1Cnt.sendEmailToCompassAffari('ufficio.frodi@compass.it');//
            }
        } catch (Exception e) {
            response.put('message', e.getCause() + ' ' + e.getMessage()+ ' '+ e.getStackTraceString() + e.getLineNumber());
            response.put('error', true);
            response.put('linkevo', false);
        }
        return response;
    }

    /**
     * @Author AD
     * @date  06/08/2019
     * @description getRichiamiLimiteTemporel
     * @param String developerName
     **/
    @AuraEnabled
    public static Map<String, Object> getRichiamiLimiteTemporel(String developerName){
        Map<String, Object> response = new Map<String, Object>();
        developerName = developerName.toLowerCase();
        try {
            //RichiamiLimiteTemporel__c richiamiTempLimit = [SELECT Name, Limit__c FROM RichiamiLimiteTemporel__c WHERE Name = :developerName LIMIT 1];
            XCS_CompassParameters__c richiamiTempLimit = [SELECT Name, Limit__c FROM XCS_CompassParameters__c WHERE Name = :developerName LIMIT 1];
            response.put('error', false);
            response.put('richiamiTempLimit', richiamiTempLimit);
        } catch (Exception e) {
            response.put('error', true);
            response.put('message', e.getCause() + ' ' + e.getMessage()+ ' '+ e.getStackTraceString());
        }
        return response;
    }

    /**
     * @author ADIOP
     * @date  23/07/2019
     * @description 
     * @param 
     **/
    public class QuestionManagement {
        @AuraEnabled public List<QuestionObject> questions {get;set;}
        @AuraEnabled public List<ProductObject> products {get;set;}
    }

    /**
     * @author ADIOP
     * @date  23/07/2019
     * @description 
     * @param 
     **/
    public class QuestionObject {
        @AuraEnabled public String question {get;set;}
        @AuraEnabled public String response {get;set;}
        @AuraEnabled public List<String> prodotto {get;set;}
    }

    /**
     * @author ADIOP
     * @date  24/07/2019
     * @description 
     * @param 
     **/
    public class ProductObject {
        @AuraEnabled public String prodotto {get;set;}
        @AuraEnabled public List<String> statoOcs {get;set;}
    }
}