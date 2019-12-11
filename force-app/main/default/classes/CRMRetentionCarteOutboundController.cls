public class CRMRetentionCarteOutboundController 
{
    @AuraEnabled
    public static void insertNote(String note,String recordId)
    {
        Case c = CaseUtils.caseGenericQueryById(Caseutils.SELECT_ACCOUNT_FIELD,recordId);
        System.debug('NOTE DA INSERIRE RET CARTE');
       // OCSGestioneNoteInvoker.filtraNote('',c.account.getCodice_Cliente__c,'','','A','P','');
    }
    @AuraEnabled
    public static RetentionResponse confirmAction(String caseId,Account customer,List<CRM_Retention__c> listRetention,String noteValue)
    {
        System.debug('***************1' + listRetention);
        List<sObject> listToUpdate = new List<sObject>();
        CRM_Retention__c tempRetention ;
        boolean res = true;
        boolean check = false;
        map<String,CRM_Retention__c> mapRetention = CRMRetentionUtil.getLoanNumberSObjectMapByList(CRMRetentionUtil.getRetentionRequestedByCaseId(caseId));
        String messErrore = '';
        List<CRM_Retention__c> retentionList = new List<CRM_Retention__c>();
        Case c = new Case(id=caseId);
        for(CRM_Retention__c r : listRetention)
        {
            System.debug('******' + r.Action__c);
            if(r.Action__c.equalsIgnoreCase('OK') || r.Action__c.equalsIgnoreCase('CON'))
            {
                System.debug('°°°°°°°°°' + r.Action__c);
                if(r.Selected__c)
                {
                    check = true;
                    System.debug('##########' + r.Disposition__c);
                    if(String.isBlank(r.Disposition__c))
                    {
                        res = false;
                        messErrore += CRMRetentionUtil.DISPOSITION_NON_VALORIZZATE; // MESSAGGIO ERRORE DA VALUTARE 
                    }
                }
            } 
        }
        if(res)
        {
            if(check)
            {
                messErrore = CaseUtils.TOAST_SUCCESS;
                c.Status = CRMRetentionUtil.CASERETENTIONCARTECLOSESTATUS;
                c.Disposition__c = CRMRetentionUtil.getFirstRetention(c.Id,CRMRetentionUtil.ACTIONOK).Disposition__c;
                if(String.isNotBlank(noteValue))
                {
                    XCSNoteUtils.postANote(c.id,XCSNoteUtils.USER_NOTE_TITLE,noteValue);
                }
                listToUpdate.add(c);
                System.debug('***** lista da aggiornare' + listToUpdate);
                update listToUpdate;
            }
            else
            {
                res = false;
                messErrore = CRMRetentionUtil.SELEZIONARE_PRATICA;
            }

        }        
        return new RetentionResponse(res,messErrore);
    }
    @AuraEnabled
    public static RetentionResponse saveRetentionDisposition(CRM_Retention__c retention,XCS_Disposition__c disposition,String apexClass)
    {
        XCSDispositionResult res = null;
        boolean isToExecute = false;
        if(String.isNotBlank(apexClass))
        {
            XCSDispositionAction action = (XCSDispositionAction)Type.forName(apexClass).newInstance();
            action.setSObject(retention);
            action.setDisposition(disposition);
            res = action.execute();
            isToExecute = true;
        }
        if(!isToExecute || (isToExecute && res.result))
        {
            CRMRetentionUtil.saveRetentionWithDisposition(retention,disposition);
        }
        RetentionResponse r = new RetentionResponse(isToExecute,'');
        r.dispositionResult = res;
        system.debug('**********' + r);
        return r;
    }
    @AuraEnabled
    public static RetentionResponse saveRetentionDispositionMock(CRM_Retention__c retention,XCS_Disposition__c disposition,String tipoRevoca)
    {
        String motivoRevoca = '';
        boolean check = false;
        boolean tempCheck = false;
        String tRevoca = tipoRevoca.equalsIgnoreCase('NO') ? CRMRetentionUtil.TRATTENUTO : CRMRetentionUtil.REVOCATO ;
        OCSRecuperaStatoRichiestePSVResponse.ResponseClass res = CRMRetentionUtil.getLastValueOfPSVService(retention.LoanNumber__c, retention.LoanType__c); 
        system.debug('******1');
        if(res != null && res.stato.equals('30') && res.blocco.equals(''))
        {
            system.debug('******2');
            if(CRMRetentionUtil.REVOCATO.equals(res.codAzione))	   
            {
                tempCheck = true;
            }
            else if(CRMRetentionUtil.TRATTENUTO.equals(res.codAzione))
            { 
                tempCheck = true;
                motivoRevoca = CRMRetentionUtil.TRATTENUTOTESTO;    
            }
            if(tempCheck)
            {
                if(tRevoca.equalsIgnoreCase(res.codAzione))
                {
                    check = true; 
                }
                else
                {
                    motivoRevoca = CRMRetentionUtil.MESSAGGIOERROREDISCREPANZA;
                }
            }
        }
        else if(tipoRevoca.equalsIgnoreCase('NO'))
        {
            check = true;
            system.debug('******3');
        }
        else
        {
            system.debug('******4');
            motivoRevoca = CRMRetentionUtil.MESSAGGIOERRORE;
        }
        if(check)
        {
            system.debug('******5 FINISH');
            CRMRetentionUtil.saveRetentionWithDisposition(retention,disposition);             
        }
        return new RetentionResponse(check,motivoRevoca);
    }
    
    
    @AuraEnabled
    public static RetentionWrap getRetentionList(String caseId)
    {
        RetentionWrap wrap = new RetentionWrap(
            CRMRetentionUtil.getRetentionRequestedByCaseId(caseId),
            XCSScriptUtil.getScriptForName(XCSScriptUtil.RETENTIONSCRIPTINITIALNAME),
            XCSScriptUtil.RETENTIONSCRIPTALERT,
            XCSScriptUtil.RETENTIONSCRIPTINITIALNAME,
            AccountUtils.getAccountFromId(CaseUtils.getAccountAssigment(caseId))
        );
        system.debug(wrap);
        return wrap;
    }
    public class RetentionWrap
    {
        @AuraEnabled
        List<CRM_Retention__c> retentionList {get; set;}
        @AuraEnabled
        List<XCS_Script__c> scriptList {get; set;}
        @AuraEnabled
        String scriptAlertName {get; set;}
        @AuraEnabled
        String scriptGenericName {get; set;}
        @AuraEnabled
        Account clientAccount{get; set;}
        
        public RetentionWrap(List<CRM_Retention__c> lRetention,List<XCS_Script__c> lScript,String scriptAlertName,String scriptGenericName,Account clientAccount)
        {
            this.retentionList = lRetention;
            this.scriptList = lScript;
            this.scriptAlertName = scriptAlertName;
            this.scriptGenericName = scriptGenericName;
            this.clientAccount = clientAccount;
        }
        
    }
    public class RetentionResponse
    {
        @AuraEnabled
        boolean res {get;set;}
        @AuraEnabled
        String messError {get;set;}
        @AuraEnabled
        XCSDispositionResult dispositionResult{get; set;}
        
        public RetentionResponse(boolean res,String messError)
        {
            this.res = res;
            this.messError = messError;
        }
    }
}