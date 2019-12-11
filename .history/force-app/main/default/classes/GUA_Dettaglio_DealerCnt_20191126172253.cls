/**
* @File Name          : GUA_Dettaglio_DealerCnt.cls
* @Description        : 
* @Author             : Aminata GUEYE
* @CreatedDate        : 22/10/2019
*/public class GUA_Dettaglio_DealerCnt {
    @AuraEnabled
    public static Map<String ,Object>  getCaseDetail(String caseId){
         // Check to make sure all fields are accessible to this user
         Map<String ,Object> returnValue = new  Map<String ,Object>();
        returnValue.put('erreur', false);
       try {
           
            Case cse= [select id, AccountId from Case where id=:caseId];
            Account accnt = [SELECT Id, AccountId,Account.RagioneSociale__pc, Account.Macroarea__c, Account.ProdottoDominanteMacroarea__c, Data_Creazione_Pratica__c, Partita_Iva__c,TipoChiamata__c, Stato_Pratica__c
                         FROM Case Where AccountId=:cse.Id];
            returnValue.put('dealer', false);
       }catch(Exceptione e){
            System.debug('errorMessage GUA_DettaglioDealerCnt getCaseDetail '+e.getMessage());
             returnValue.put('message', e.getMessage()+' '+e.getCause()+' '+e.getLineNumber());
             returnValue.put('erreur', true);
       }
        return returnValue;
        
    }

    @AuraEnabled
    public static Map<String ,Object> getFilialeById(String idAccount){
        Map<String ,Object> returnValue = new  Map<String ,Object>();
        returnValue.put('erreur', false);
       try {
           Account filialeCase = Gua_ManageUnitaAffariQuery.getFilialeById(idAccount);
           returnValue.put('filiale',filialeCase);
       } catch (Exception e) {
            System.debug('errorMessage GUA_DettaglioDealerCnt getFilialeById '+e.getMessage());
             returnValue.put('message', e.getMessage()+' '+e.getCause()+' '+e.getLineNumber());
             returnValue.put('erreur', true);
       }
        return returnValue;
    }

}