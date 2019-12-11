public class TaskGestioneFaxRecallController {
    
    @AuraEnabled
    public static Double getRecallMax(String recordId){
        
        Task tsk = [SELECT Id, Stato_Azione__c, codice_cliente__c, pratica__c, prodotto__c, ProdottoID__c,
                    CategoriaID__c, whatId, Recall_Count__c, Status, Esito__c, Stato_Comunicazione__c  
                    FROM Task WHERE Id = : recordId][0];
        
        CRM_Gestione_Fax_Config__mdt config = [SELECT recall_number__c FROM CRM_Gestione_Fax_Config__mdt 
                                               WHERE idCategoria__c =: tsk.CategoriaID__c 
                                               AND idProdotto__c =: tsk.ProdottoID__c LIMIT 1];
        return config.recall_number__c;
    }
    
}