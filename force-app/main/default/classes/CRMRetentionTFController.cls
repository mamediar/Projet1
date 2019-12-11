public class CRMRetentionTFController 
{
    @AuraEnabled
    public static Case doInit(String recordId)
    {
        return CaseUtils.caseGenericQueryById('Id, Retention_LetteraEstinzioneAnticipata__c, Retention_DescrizioneCausaleConteggio__c, Retention_CodiceCausaleConteggio__c, Retention_DataConteggio__c, Retention_Offerta__c, Tipo_Prodotto__c, NumeroPratica__c, Account.getCodice_Cliente__c, Branch__r.getCodice_Cliente__c,ProcessType__c,Branch__r.Name',recordId);
    }
    @AuraEnabled
    public static wrapResponse completaAttivita(String obiezioneSelezionata,String tassoOfferto,String notaUtente,Case c,XCS_Disposition__c disp)
    {
        boolean res = true;
        String messToast = '';
        List<sObject> lToUpdate = new List<sObject>();
        if(disp != null)
        {
            if(String.isNotBlank(obiezioneSelezionata))
            {
                c.Retention_Obiezione__c = obiezioneSelezionata;
            }
            if(String.isNotBlank(tassoOfferto))
            {
                c.Retention_Tasso__c = tassoOfferto;
            }
            c.Disposition__c = disp.id;
            c.Status = CaseUtils.CHIUSO;
            messToast = CaseUtils.TOAST_SUCCESS;
			update c;            
        }
        else
        {
            res = false;
            messToast = CRMRetentionUtil.NON_ESITATO;
        }
        return new wrapResponse(res,messToast);
    }
    public class wrapResponse
    {
        @AuraEnabled
        public boolean res {get; set;}
        @AuraEnabled
        public String messToast {get; set;}
        public wrapResponse(boolean res,String messToast)
        {
            this.res = res;
            this.messToast = messToast;
        }
    }
}