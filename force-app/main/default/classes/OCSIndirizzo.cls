public with sharing class OCSIndirizzo {
    
    @AuraEnabled
    public String tipoIndirizzo{get;set;}
    @AuraEnabled
    public String indirizzo{get;set;}
    @AuraEnabled
    public String cap{get;set;}
    @AuraEnabled
    public String localita{get;set;}
    @AuraEnabled
    public String provincia{get;set;}

    public OCSIndirizzo() {

    }
}