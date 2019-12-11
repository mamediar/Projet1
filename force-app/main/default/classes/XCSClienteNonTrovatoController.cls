public class XCSClienteNonTrovatoController 
{
    //GESTIRE NOTA CON EVENTO
    @AuraEnabled
    public static wrapObject customerNotFound(String recordId)
    {
        //String selector = 'id,AccountId,Account.Privacy_SMS__pc,Account.Telefono_Cellulare__c,Categoria_Riferimento__r.External_Id__c,TentativoNum__c';
        boolean isOk = false;
        String noteToSend = '';
        String messError = '';
        XCS_Disposition__c dispToAssign; 
        List<String> templateExternalId = new List<String>();
        Map<String,XCS_Template__c> mapTemplateByExternalCode;
        Case c = CaseUtils.caseGenericQueryById(CaseUtils.SELECTCLIENTENONTROVATO,recordId);
       // Case caseToUpdate = new Case(id = c.Id,TentativoNum__c = c.);
        String groupDeveloperName = groupUtils.getQueueDeveloperName(c.ownerId);
        ConfigCaseCommonAction__c parentAction = CaseUtils.getRecordByCaseCategoryAndOwnerDeveloperName(CaseUtils.COMMON_ACTION_CLIENTE_NON_TROVATO_RECORDTYPE, c.Categoria_Riferimento__r.External_Id__c,groupDeveloperName);
        System.debug('**************** 1');
        if(parentAction != null)
        {
            System.debug('**************** 2');
            if(c.TentativoNum__c < parentAction.TentativiMax__c)
            {
                System.debug('**************** 3');
                isOk = true;
                c.TentativoNum__c += 1;
                messError = caseutils.TOAST_SUCCESS; 
                ConfigCaseCommonAction__c childAction = CaseUtils.getChildRecordByParentIdAndAttempt(parentAction.Id,Integer.valueOf(c.TentativoNum__c));
                if(childAction != null)
                {
                    System.debug('**************** 4');
                    templateExternalId.add(childAction.NoteTemplateDeveloperName__c);
                    templateExternalId.add(childAction.SMSTemplateDeveloperName__c);
                    if(String.isNotBlank(childAction.DispositionToAssign__c))
                    {
                        c = XCS_DispositionUtils.aggiungiDispositionCase(c,childAction.DispositionToAssign__c);
                    }
                    if(! templateExternalId.isEmpty())
                    {
                        System.debug('**************** 5');
                        mapTemplateByExternalCode = XCS_TemplateUtils.getMapFromList(XCS_TemplateUtils.getRecordByExternalIdList(templateExternalId));
                    }
                    if(String.isNotBlank(childAction.SMSTemplateDeveloperName__c))
                    {
                        System.debug('**************** 6');
                        if(c.Account.Privacy_SMS__pc != null && c.Account.Privacy_SMS__pc == true)
                        {
                            System.debug('**************** 7');
                            if(!(''.equals(c.Account.Telefono_Cellulare__c) || c.Account.Telefono_Cellulare__c == null ))
                            {
                               System.debug('**************** 8');
                                OCSInviaSMSInvoker.inviaSMS('',c.Account.Telefono_Cellulare__c,'','',mapTemplateByExternalCode.get(childAction.SMSTemplateDeveloperName__c).body__c); 
                            }
                        }
                    }
                    if(String.isNotBlank(childAction.NoteTemplateDeveloperName__c))
                    {
                        noteToSend = mapTemplateByExternalCode.get(childAction.NoteTemplateDeveloperName__c).body__c;
                    }
                }
                if(c.TentativoNum__c == parentAction.TentativiMax__c)
                {
                    if(String.isNotBlank(parentAction.DispositionToAssign__c))
                    {
                    	c = XCS_DispositionUtils.aggiungiDispositionCase(c,parentAction.DispositionToAssign__c);    
                    }
                    if(String.isNotBlank(parentAction.CaseStatusToAssign__c))
                    {
                        c.Status = parentAction.CaseStatusToAssign__c; 
                    }
                    messError = CaseUtils.MESSAGGIO_CASO_CHIUSO;
                }
                Update c;
            }
            else if(c.TentativoNum__c == parentAction.TentativiMax__c)
            {
                isOk = false;
                messError = CaseUtils.LIMITE_TENTATIVI_RAGGIUNTO;
            }
        }
        else
        {
            isOk = false;
            messError = CaseUtils.AZIONE_NON_TROVATA;
        }
    return new wrapObject(isOk,noteToSend,messError);
    }
    public class wrapObject 
    {
        @AuraEnabled
        public boolean isOk;
        @AuraEnabled
        public String noteToInsert;
        @AuraEnabled
        public String messToast;
        public wrapObject(boolean isOk,String noteToInsert,String messToast)
        {
            this.isOk = isOk;
            this.noteToInsert = noteToInsert;
            this.messToast = messToast;
        }
    }
}