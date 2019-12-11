public class PVProvinciaLuogoController {
    
    @AuraEnabled
    public static List<XCS_Town__c> loadProvincesApex() {
        List<XCS_Town__c> elencoProvince = new List<XCS_Town__c>();
        for ( XCS_Town__c prov : [SELECT Id,Provincia__c,Comune__c,CAP__c,Soppresso__c,Provincia_Desc__c,Catastale__c
                               FROM XCS_Town__c]) {
                                   if (prov.Comune__c == prov.Provincia_Desc__c) {
                                       elencoProvince.add(prov);
                                   }
                               }
        return elencoProvince;
    }
    
    @AuraEnabled
    public static List<XCS_Town__c> loadComuniApex(String provincia) {
        return [SELECT Id,Provincia__c,Comune__c,CAP__c,Soppresso__c,Provincia_Desc__c,Catastale__c FROM XCS_Town__c where Provincia__c =: provincia];
    }
    
}