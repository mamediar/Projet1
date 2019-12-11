public class XCSGestioneInvioSMSController 
{
    @AuraEnabled
    public static wrapResponse InviaSMS(String caseId, Account account,String customerCellulare,String testoTemplate)
    {
        boolean res = true;
        String messToast = '';
        if(String.isNotBlank(customerCellulare))
        {
            if(!customerCellulare.equalsIgnoreCase(account.PersonMobilePhone))
            {
                if(String.isNotBlank(account.id) && ValidationUtils.isCellValido(customerCellulare))
                {
                    Update new Account(id = account.id, PersonMobilePhone = customerCellulare);	    
                }
                else
                {
                    res = false;
                    messToast = CaseUtils.TELEFONO_NON_CONFORME;
                }
            }
        }
        else
        {
            res = false;
            messToast = CaseUtils.INSERIRE_TELEFONO;
        }
        if(String.isBlank(testoTemplate))
        {
            res = false;
            messToast = caseUtils.SELEZIONARE_UN_SMS;
        }
        if(res)
        {
            messToast = CaseUtils.TOAST_SUCCESS;
            OCSInviaSMSInvoker.inviaSMS('',customerCellulare,'','',testoTemplate);
            Case c = new Case(Id=caseId, UltimoSMSInviato__c=testoTemplate, SuppliedPhone=customerCellulare);
            update c;
        }
        system.debug('********** :' + res + '+++++++++' + messToast);
        return new wrapResponse(res,messToast);
    }
    @AuraEnabled
    public static wrap Inizializzazione(boolean allTemplate,String recordId,boolean onlyByName,String SMSTemplateName)
    {
        List<XCS_Template__c> listTemplate = new List<XCS_Template__c>();
        Account account;
        String customerCellulare;
        Case c = CaseUtils.caseGenericQueryById(CaseUtils.GESTIONE_INVIO_SMS,recordId);
        System.debug('allTemplate : ' + allTemplate);
        if(allTemplate)
        {
            listTemplate.addAll(XCS_TemplateUtils.getListRecordByRecordtypeAndName(XCS_TemplateUtils.SMS_RECORDTYPE_NAME,XCS_TemplateUtils.SMS_Name));
            system.debug('ALL TEMPLATE : ' + listTemplate);
        }
        else
        {
            if(onlyByName)
            {
             	listTemplate.addAll(XCS_TemplateUtils.getListRecordByRecordtypeAndName(XCS_TemplateUtils.SMS_RECORDTYPE_NAME,SMSTemplateName));   
            }
            else
            {
                List<String> listExternalId = new List<String>();
                String groupDeveloperName = groupUtils.getQueueDeveloperName(c.ownerId);
                ConfigCaseCommonAction__c parentAction = CaseUtils.getRecordByCaseCategoryAndOwnerDeveloperName(CaseUtils.COMMON_ACTION_GESTIONE_INVIO_SMS_RECORDTYPE, c.Categoria_Riferimento__r.External_Id__c, groupDeveloperName);
                if(parentAction != null)
                {
                    List<ConfigCaseCommonAction__c> childActions = CaseUtils.getChildsFromParent(parentAction.Id);
                    if(childActions != null || childActions.size() > 0)
                    {
                        for(ConfigCaseCommonAction__c ca : childActions)
                        {
                            listExternalId.add(ca.SMSTemplateDeveloperName__c);
                        }
                        listTemplate.addAll(XCS_TemplateUtils.getRecordByExternalIdList(listExternalId));
                    }
                }    
            }
            
        }
        customerCellulare = c.Account.PersonMobilePhone;
        account = new Account(id = c.AccountId, PersonMobilePhone = c.Account.PersonMobilePhone);
        return new wrap(customerCellulare,listTemplate,account);
    }
    public class wrap
    {
        @AuraEnabled
        public String customerCellulare;
        @AuraEnabled
        public List<XCS_Template__c> listTemplate;
        @AuraEnabled
        public Account account;
        public wrap(String customerCellulare,List<XCS_Template__c> listTemplate,Account account)
        {
            this.listTemplate = listTemplate;
            this.customerCellulare = customerCellulare;
            this.account = account;
        }
    }
    public class wrapResponse
    {
        @AuraEnabled
        public boolean res;
        @AuraEnabled
        public String messToast;
        public wrapResponse(boolean res,String messToast)
        {
            this.res = res;
            this.messToast = messToast;
        }
    }
    
    @AuraEnabled
    public static void handleInvioSMSEvent(String recordId) {
		Case c = CaseUtils.caseGenericQueryById(CaseUtils.GESTIONE_INVIO_SMS,recordId);
        Decimal num = c.SMSInviatiNum__c == null ? 0 : c.SMSInviatiNum__c;
        c.SMSInviatiNum__c = num + 1;
        update c;
    }
}