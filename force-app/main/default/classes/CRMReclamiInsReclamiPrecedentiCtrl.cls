public without sharing class CRMReclamiInsReclamiPrecedentiCtrl {
	@AuraEnabled
    public static List<Case> getReclami(String clienteCode,String praticaCode, String nReclamo ){
        System.debug('CRMReclamiInsReclamiPrecedentiCtrl getReclami input:\nclienteCode: '+clienteCode+'\npraticaCode: '+praticaCode);
        List<Case> res=[select Id, Categoria_Riferimento__c,Categoria_Riferimento__r.Name,Numero_Reclamo__c,Numero_Progressivo_Reclamo__c,NumeroPratica__c,
                       Owner.Name,Status,CreatedDate,Subnumber_Reclamo__c,Progressivo_Annuale_Assicurazione__c,Anno__c, Categoria__c
                       from Case
                        where  RecordType.name='CRM_Reclami' and NumeroPratica__c=:praticaCode and AccountId =:clienteCode and (not Numero_Reclamo__c =:nReclamo) and Subject != 'Reclamo - Stampa IDM'];
        System.debug('CRMReclamiInsReclamiPrecedentiCtrl getReclami res: '+res);
        return res;
    }
    @AuraEnabled
    public static List<Case> getReclamiMB_Fututo(String clienteCode,String praticaCode, String nReclamo ){
        System.debug('CRMReclamiInsReclamiPrecedentiCtrl getReclami input:\nclienteCode: '+clienteCode+'\npraticaCode: '+praticaCode);
        List<Case> res=[select Id, Categoria_Riferimento__c,Categoria_Riferimento__r.Name,Numero_Reclamo__c,Numero_Progressivo_Reclamo__c,NumeroPratica__c,
                       Owner.Name,Status,CreatedDate,Subnumber_Reclamo__c,Progressivo_Annuale_Assicurazione__c,Anno__c, Categoria__c
                       from Case
                        where  RecordType.name='CRM_Reclami' and NumeroPratica__c=:praticaCode and Account_Futuro_MBCS__c =:clienteCode and (not Numero_Reclamo__c =:nReclamo) and Subject != 'Reclamo - Stampa IDM'];
        System.debug('CRMReclamiInsReclamiPrecedentiCtrl getReclami res: '+res);
        return res;
    }
}