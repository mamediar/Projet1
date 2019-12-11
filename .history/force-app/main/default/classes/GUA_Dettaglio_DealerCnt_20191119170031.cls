/**
* @File Name          : GUA_Dettaglio_DealerCnt.cls
* @Description        : 
* @Author             : Aminata GUEYE
* @CreatedDate        : 22/10/2019
*/public class GUA_Dettaglio_DealerCnt {
    @AuraEnabled
    public static List<Case> getCaseDetail(String accId){
         // Check to make sure all fields are accessible to this user
            String[] fieldsToCheck = new String[] {
                'Id', 'AccountId','RagioneSociale__pc', 'Macroarea__c', 'ProdottoDominanteMacroarea__c', 'Data_Creazione_Pratica__c', 
                'Partita_Iva__c','Stato_Pratica__c'
            };
            Id recordType=CGMWSUtils_1_0.getRecordTypeId('Case','GUA_Contact');
        
            Map<String,Schema.SObjectField> fieldDescribeTokens = 
                Schema.SObjectType.Campaign.fields.getMap();
            
           /* for(String field : fieldsToCheck) {
                if( ! fieldDescribeTokens.get(field).getDescribe().isAccessible()) {
                    throw new System.NoAccessException();
                }
            }*/
         return [SELECT Id, AccountId,Account.RagioneSociale__pc, Account.Macroarea__c, Account.ProdottoDominanteMacroarea__c, Data_Creazione_Pratica__c, Partita_Iva__c,TipoChiamata__c, Stato_Pratica__c
                         FROM Case Where AccountId=:accId and RecordTypeId =:recordType];
        
        
    }
}