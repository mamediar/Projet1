public with sharing class SFAComunicazioneUtenzeController {

    private final static XCS_Categoria__c categoriaComunicazione;
    static {
        categoriaComunicazione = [SELECT ID FROM XCS_Categoria__c WHERE External_Id__c = 'AT0114' LIMIT 1];
    }


    @AuraEnabled
    public static Case getComunicazione(String idCase){
        return [SELECT ID, Priority, DueDate__c, Account.Name, Branch__r.Name, Account.ShippingCity, Account.ShippingStreet, Account.ShippingPostalCode, Status FROM Case  WHERE ID =:idCase];
    }


    @AuraEnabled
    public static List<Comunicazione_Utenze__c> listUtenzeNominative(String caseId){
        return [SELECT ID, Note__c, Last_Name__c, First_Name__c, Utenza__c, Tipo_Utenza__c, Data_Creazione__c, Canale__c, OCS_Code_Delegato__c FROM Comunicazione_Utenze__c  WHERE CaseAttivit_di_Riferimento__c =: caseId];
    }

    private static void aggiornaFlagUtenze(String caseId) {
        List<comunicazione_Utenze__c> listaComun = [SELECT Id,Is_Worked__c FROM comunicazione_Utenze__c WHERE CaseAttivit_di_Riferimento__c=:caseId];
        if (listaComun!=null && listaComun.size()>0) {
            for (comunicazione_Utenze__c com :listaComun) {
                com.Is_Worked__c = true;
            }
            update listaComun;
        }
    }

    @AuraEnabled
    public static String process(String caseId){
        System.debug('process caseId:'+caseId);
        Case activity = [SELECT ID, Status, AccountId FROM Case WHERE Id=:caseId];
        // si procederà all’ultima parte del processo in cui verrà effettuata 
        // la dematerializzazione della gestione pratiche per il dealer
        String error = SFADematerializzazioneHelper.creaAttivitaDematerializzazione(activity.AccountId);
        System.debug('process Dematerializzazione error:'+error);
        // verrà chiusa l’attivita di Comunicazione Utenze (indipendentemente dall'esito della dematerializzazione)
        activity.Status = 'Closed';
        update activity;
        aggiornaFlagUtenze(caseId);
        return error;
    }


    @AuraEnabled
    public static String getBase64PDFUtenzeNominative(String IdCase) {

        String bodyBase64 = '';
     	PageReference pdf = Page.SFAUtenzeNominativePDF;
   		pdf.getParameters().put('IdCase', idCase);
    	pdf.setRedirect(true);
        if (!test.isRunningTest()){
  		    Blob pageContent = pdf.getContent();         
            System.debug('body:'+pageContent);
            bodyBase64 = EncodingUtil.base64Encode(pageContent);
        }
        return bodyBase64;
            
    }

}