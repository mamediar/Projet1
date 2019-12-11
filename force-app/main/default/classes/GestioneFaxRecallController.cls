public class GestioneFaxRecallController {
    
    @AuraEnabled
    public static Double getRecallMax(String recordId){
        
        /*
        Task tsk = [SELECT Id, Stato_Azione__c, codice_cliente__c, pratica__c, prodotto__c, ProdottoID__c,
                    CategoriaID__c, whatId, Recall_Count__c, Status, Esito__c, Stato_Comunicazione__c  
                    FROM Task WHERE Id = : recordId][0];
        */
                    Case tsk = [SELECT Id, Stato_Azione__c, Account.getCodice_cliente__c, NumeroPratica__c, Product__r.Name, Product__r.Rss_External_id__c,
                    Categoria_riferimento__r.External_id__c, parentid, TentativoNum__c, Status, GestioneFax_Esito__c, Stato_Comunicazione__c  
                    FROM Case WHERE Id = : recordId][0];
        
        /*
        CRM_Gestione_Fax_Config__mdt config = [SELECT recall_number__c FROM CRM_Gestione_Fax_Config__mdt 
                                               WHERE idCategoria__c =: tsk.CategoriaID__c 
                                               AND idProdotto__c =: tsk.ProdottoID__c LIMIT 1];
        */
        
        CRM_Gestione_Fax_Config__mdt config = [SELECT recall_number__c FROM CRM_Gestione_Fax_Config__mdt 
                                               WHERE idCategoria__c =: Integer.valueof(tsk.Categoria_riferimento__r.External_id__c) 
                                               AND idProdotto__c =: Integer.valueof(tsk.Product__r.Rss_External_id__c) LIMIT 1];
        
        
        
        
        
        return config.recall_number__c;
    }
    
}