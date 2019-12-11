public class AggiungiDealerPopUpControllerApex {
    @AuraEnabled
    public static List<Account> searchDealers(String CIP_CF_PIVA, String ragioneSociale){
        User manager = getCurrentUser();
        String likeExpressionRagioneSociale='%'+ragioneSociale+'%';
        String dealString='Dealer';
        String branchOCSCode = manager.DefaultQueueId__c;
        String query='SELECT Id, Name, Zone__r.Name , ShippingStreet,ShippingCity, CodiceClienteFilled__c, OCS_External_Id__c, Vat_Code__c, FiscalCode__c FROM Account WHERE RecordType.Name =:dealString AND Branch__r.OCS_External_Id__c =: branchOCSCode AND ';
        if(String.isNotBlank(CIP_CF_PIVA)){
            //query=query+'(OCS_External_Id__c =:CIP_CF_PIVA OR Vat_Code__c =:CIP_CF_PIVA OR FiscalCode__c =:CIP_CF_PIVA)';
            query=query+'(CodiceClienteFilled__c =:CIP_CF_PIVA OR Vat_Code__c =:CIP_CF_PIVA OR FiscalCode__c =:CIP_CF_PIVA)';
        }
        if(String.isNotBlank(ragioneSociale)){
            if(String.isNotBlank(CIP_CF_PIVA)){
                query=query+' AND '; 
            }
            query=query+'Name LIKE :likeExpressionRagioneSociale';
        }
        //List<Account> accounts= [SELECT Id, Name, Zone__c, BillingAddress, CIP__c, Vat_Code__c, FiscalCode__c 
        //FROM Account
        //WHERE CIP__c =:CIP_CF_PIVA OR Vat_Code__c =:CIP_CF_PIVA OR FiscalCode__c =:CIP_CF_PIVA Name LIKE : %ragioneSociale%];
        List<Account> accounts = Database.query(String.escapeSingleQuotes(query));
        return accounts;
    }

    private static User getCurrentUser(){
        String utenteId = UserInfo.getUserId();
        return [SELECT FirstName, LastName,Id,Name,DefaultQueueId__c FROM User WHERE Id =: utenteId];
    }

}