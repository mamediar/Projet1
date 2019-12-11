public without sharing class OutboundCallingRetentionController 
{
	@AuraEnabled
    public static wrapInit doInit(String recordId) 
    {
       Task tsk = [Select id,customer__c,customer__r.Telefono_casa__c,customer__r.Telefono_cellulare__c,customer__r.firstName,customer__r.lastname,customer__r.OCS_External_Id__c,WhatId from Task Where id = :recordId];
       Case c = [Select id,Categoria_Riferimento__r.Name from Case Where id = :tsk.WhatId];
        
        return new wrapInit(tsk,c.categoria_Riferimento__r.name);
    }
    @AuraEnabled
    public static wrapResponse saveSelection(String recordId,XCS_Disposition__c esito,String noteUtente)
    {
        boolean res = true;
        boolean redirect = false;
        String messToast = '';
        System.debug('********1');
        if(esito != null)
        {
              System.debug('********2');
            if(XCS_DispositionUtils.APPUNTAMENTO_FISSATO.equalsIgnoreCase(esito.External_Id__c))
            {
                // da effettuare Redirect su Fissa Appuntamento
                // redirect = true;
                messToast = 'IN ATTESA DI FISSA APPUNTAMENTO';
                  System.debug('********3');
            }
            else
            {
                  System.debug('********4');
                messToast = XCSCompassConstants.SUCCESSO_CHIUDERE_CHIAMATA;   
            }
           	update new Task(id=recordId,Status=XCSCompassConstants.TASK_STATUS_CLOSED);//,Disposition__c = esito.id); 
        }
        else
        {
            res = false;
            messToast = CRMRetentionUtil.NON_ESITATO; 
              System.debug('********5');
        }
 		return new wrapResponse(res,messToast);
    }
    @AuraEnabled
    public static void fissaAppuntamento(String recordId)
    {
        XCS_Disposition__c disp = XCS_DispositionUtils.findDispositionByExternalID(XCS_DispositionUtils.APPUNTAMENTO_FISSATO);
        Task tsk = new Task(id=recordId,Status=XCSCompassConstants.TASK_STATUS_CLOSED,Disposition__c = disp.id); 
    
        update tsk;	 
    }
    public class wrapResponse
    {
        @AuraEnabled
        public boolean res {get; set;}
        @AuraEnabled
        public String messToast {get;set;}
        public wrapResponse(boolean res,String messToast)
        {
            this.res = res;
            this.messToast = messToast;
        }
        
    }
    public class wrapInit
    {
        @AuraEnabled
        public Task tk {get; set;}
        @AuraEnabled
        public String prodotto {get; set;}
        public wrapInit(Task tk,String prodotto)
        {
            this.tk = tk;
            this.prodotto = prodotto;
        }
    }
}