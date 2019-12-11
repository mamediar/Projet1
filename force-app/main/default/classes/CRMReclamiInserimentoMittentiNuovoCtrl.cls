public class CRMReclamiInserimentoMittentiNuovoCtrl {
	@AuraEnabled
    public static List<indirizzi_predefiniti__mdt> buildIndirizzi(String societa){
        indirizzi_predefiniti__mdt[] res=[select Cap__c,Citta__c,External_Id__c,Indirizzo__c,Indpred__c,Name__c,Provincia__c,Saluto__c
                                       from indirizzi_predefiniti__mdt
                                       where Societa__c=:societa];
        return res;
    }
    
    @AuraEnabled
    public static XCS_Mittente__c makeMittente(Boolean da, String tipo, Boolean autorita, String nomeCognomeMittente,String indirizzoMittente,String cittaMittente,String provinciaMittente,String capMittente, String saluti){
        return XCS_MittenteUtils.makeMittente(da,tipo,autorita,nomeCognomeMittente,indirizzoMittente,cittaMittente,provinciaMittente,capMittente,saluti);
    }
    
    @AuraEnabled
    public static XCS_Mittente__c makeMittenteFromIndPred(indirizzi_predefiniti__mdt ip,Boolean principale){
        return XCS_MittenteUtils.makeMittente(ip,principale);
    }
   
}