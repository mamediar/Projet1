public class CRMRetentionPrestitiBadController 
{
	@AuraEnabled
    public static wrapInit doInit(String caseId)
    {     	  
        return new wrapInit(CaseUtils.caseGenericQueryById(CRMRetentionUtil.QUERY_CASE_ACCOUNTCODE,caseId),CRMRetentionUtil.getRetentionRequestedByCaseId(caseId)); 
    }
    
    @AuraEnabled
    public static wrapResponse completaAction(list<CRM_Retention__c> listaRetention,String notaUtente,Case c)
    {
        boolean res = true;
        boolean redirect = false;
        system.debug(c);
        String dispNonInteressato = XCS_DispositionUtils.findDispositionByExternalID(XCS_DispositionUtils.NON_INTERESSATO_ALLA_PROPOSTA).id;
        String messToast = '';
        String notaSistema = '';
        String notaOCS = '';
        String notaPraticaBody = XCS_TemplateUtils.getBody(CRMRetentionUtil.NOTE_PRATICA_ESITO);
        String notaPratica = '';
        List<sObject> lToUpdate = new List<sObject>();
        for(CRM_Retention__c r : listaRetention)
        {
            if(String.isNotBlank(r.Disposition__c))
            {
                notaPratica = '\n' + XCS_templateUtils.buildTemplate(notaPraticaBody,new List<String>{r.LoanNumber__c,r.Disposition__r.name});
                if(dispNonInteressato.equalsIgnoreCase(r.Disposition__c))
                {
                    redirect = true;
                }
            }
            else
            {
                res = false;
            }
        }
        if(res)
        {
            String roleName = [select name from userRole where id = :userinfo.getUserRoleId()].name;
            notaSistema = XCS_templateUtils.buildTemplateByName(CRMRetentionUtil.NOTE_UFFICIO_HEADER,new List<String>{roleName,notaPratica});
            notaOCS = XCS_TemplateUtils.buildTemplateByName(CRMRetentionUtil.NOTE_RETENTION_PRESTITI_RICHIESTA_CRM, new List<String>{c.CaseNumber,notaPratica,notaUtente});
            c.Status = CaseUtils.CHIUSO;
            lToUpdate.addAll(listaRetention);
            lToUpdate.add(c);
            messToast = CaseUtils.TOAST_SUCCESS ;
            XCSNoteUtils.postANote(c.id,XCSNoteUtils.SYSTEM_NOTE_TITLE,notaSistema);
            if(String.isNotBlank(notaUtente))
            	XCSNoteUtils.postANote(c.id,XCSNoteUtils.USER_NOTE_TITLE,notaUtente);
            String aliasUser = [select alias from user where id = :UserInfo.getUserId()].alias;
            OCSGestioneNoteInvoker.filtraNote(aliasUser,c.account.getCodice_Cliente__c ,'' ,'' , 'A', 'P',notaOCS );
            update lToUpdate;
        }
        else
        {
            messToast = CRMRetentionUtil.PRATICHE_NON_ESITATE;
        }
        return new wrapResponse(res,redirect,messToast,XCSCompassConstants.POSTVENDITA_LAUNCHER_COMPONENT,XCSCompassConstants.POSTVENDITA_ID_ESTINZIONE_ANTICIPATA);
    }
    public class wrapInit
    {
        @AuraEnabled
        public Case c {get; set;}
        @AuraEnabled
        public List<CRM_Retention__c> lRetention {get; set;}
        public wrapInit(Case c, List<CRM_Retention__c> lRetention)
        {
            this.c = c;
            this.lRetention = lRetention;
        }
    }
    public class wrapResponse
    {
        @AuraEnabled
        public boolean res {get; set;}
        @AuraEnabled
        public boolean redirect{get; set;}
        @AuraEnabled
        public String messToast {get; set;}
        @AuraEnabled
        public String componentNameRedirect{get; set;}
        @AuraEnabled
        public String postVenditaId {get; set;}

        public wrapResponse(boolean res,boolean redirect,String messToast,String componentNameRedirect,String postVenditaId)
        {
            this.res = res;
            this.redirect = redirect;
            this.messToast = messToast;
            this.componentNameRedirect = componentNameRedirect;
            this.postVenditaId = postVenditaId;
        }
    }
}