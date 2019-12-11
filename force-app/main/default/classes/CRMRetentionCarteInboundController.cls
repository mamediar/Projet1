public class CRMRetentionCarteInboundController 
{
    // Azione Finale Attivata Al Click Del Pulsante Conferma
    @AuraEnabled
    public static RetentionResponse confirmAction(boolean isOkRetentionIn,String caseId,Account customer,List<CRM_Retention__c> listRetention,String customerEmail,String customerCell,String fasciaSelezionata,boolean privacySMS,String noteValue)
    {
        System.debug('***************1');
        if(String.isBlank(customerEmail))
       		customerEmail = ''; 
        if(String.isBlank(customer.personEmail))
            customer.personEmail = '';
        if(String.isBlank(customerCell))
            customerCell = '';
        if(String.isBlank(customer.Telefono_Cellulare__c))
            customer.Telefono_Cellulare__c = '';
        system.debug(fasciaSelezionata);
        List<sObject> listToUpdate = new List<sObject>();
        CRM_Retention__c tempRetention ;
        boolean res = true;
        boolean isAccountToUpdate = false; 
        String messErrore = '';
        //boolean secondoLivello = false;
        Account a;
        List<CRM_Retention__c> retentionOK = new List<CRM_Retention__c>();
        List<CRM_Retention__c> retentionKO = new List<CRM_Retention__c>();
        Case c = new Case(id=caseId);
        for(CRM_Retention__c r : listRetention)
        {
            if(r.Selected__c)
            {
                if((r.Action__c.equalsIgnoreCase('OK') || r.Action__c.equalsIgnoreCase('CON')))
                {
                     retentionOK.add(new CRM_Retention__c(id = r.Id, Selected__c = r.Selected__c));
                }
                else
                {
                    retentionKO.add(r);
                }
            } 
        }
        if(isOkRetentionIn)
        {  
			a = new Account(id = customer.id);
            if(!customerEmail.equals(customer.PersonEmail))
            {
               	System.debug('@@@@@@@@@@@@   PERSON EMAIL EQUALS');
                if(ValidationUtils.isEmailValida(customerEmail))
                {
                    System.debug('@@@@@@@@@@@@   PERSON EMAIL IS VALIDA');
                    a.PersonEmail = customerEmail;
                    isAccountToUpdate = true; 
                }
                else
                {
                    messErrore += CRMRetentionUtil.EMAILNONCONFORME;
                    res = false;
                }
            }
            if(!customerCell.equals(customer.Telefono_Cellulare__c))
            {
               	System.debug('@@@@@@@@@@@@ Telefono Cellulare EQUALS');
                if(ValidationUtils.isCellValido(customerCell))
                {
                    System.debug('@@@@@@@@@@@@ Telefono Cellulare is VALIDA');
                    a.Telefono_Cellulare__c = customerCell;
                	isAccountToUpdate = true; 
                }
                else
                {
                 	messErrore += CRMRetentionUtil.TELEFONONONCONFORME;
                    res = false;
                }
            }
            if(privacySMS != null)
            {
                if(customer.Privacy_SMS__pc != privacySMS)
                {
                	a.Privacy_SMS__pc = privacySMS;
                    isAccountToUpdate = true;
                }
            }
            if(String.isNotBlank(fasciaSelezionata))
            {
             	String[] fascia = fasciaSelezionata.split('-');
                c.CC_FasciaContattoDalle__c = integer.valueOf(fascia[0]);
                c.CC_FasciaContattoAlle__c = integer.valueOf(fascia[1]);
            }
            else
            {
                if(!retentionOK.isEmpty())
                {
                    messErrore += CRMRetentionUtil.FASCIANONSELEZIONATA;
                    res = false;
                }
            }
        }
        if(res)
        {
            if(retentionOK.isEmpty())
            {
                if(!retentionKO.isEmpty())
                {
               		c.Status = CRMRetentionUtil.CASERETENTIONCARTECLOSESTATUS;
                	c.Disposition__c = CRMRetentionUtil.getFirstRetention(c.Id,CRMRetentionUtil.ACTIONKO).Disposition__c;
                }
                else
                {
                 	res = false;
                    messErrore = CRMRetentionUtil.SELEZIONARE_PRATICA;
                }
            }
            else
            {
                c.ProcessType__c = CRMRetentionUtil.CASERETENTIONCARTEPROCESSTYPEOUTBOUND;
                c.OwnerId = GroupUtils.getQueue(CRMRetentionUtil.QUEUERETENTIONCARTENAME).id;
                c.TentativoNum__c = 0;
            }
            if(isAccountToUpdate)
            {
            	listToUpdate.add(a);     
            }
            if(String.isNotBlank(noteValue))
            {
                XCSNoteUtils.postANote(c.id,'Nota Utente',noteValue);
            }
            listToUpdate.addAll(retentionOk);
            listToUpdate.add(c);
            System.debug('***** lista da aggiornare' + listToUpdate);
            update listToUpdate;
        }        
        return new RetentionResponse(res,messErrore);
    }
	// Azione Di Init
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
        return wrap;
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
    public static RetentionResponse saveRetentionDispositionMockup(CRM_Retention__c retention,XCS_Disposition__c disposition,String tipoRevoca)
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
    
    //Azione attivata al click del pulsante Annulla
    @AuraEnabled
    public static void annullaRichiesta(String caseId)
    {
        CaseUtils.cancellaCase(caseId);
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
}