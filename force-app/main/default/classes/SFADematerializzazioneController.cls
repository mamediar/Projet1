public with sharing class SFADematerializzazioneController {




    @AuraEnabled
    public static Case getDematerializzazione(String caseId){
        return [SELECT ID, Priority, DueDate__c, AccountId, Account.Name, Branch__r.Name, Account.ShippingCity, Account.ShippingStreet, Account.ShippingPostalCode, Description, Esito__c, Status FROM Case  WHERE Categoria_Riferimento__c =:SFADematerializzazioneHelper.categoriaDematerializzazione.id AND ID=:caseId];
    }


    // metodo per inviare una richiesta di dematerializzazione a OCS
    @AuraEnabled
    public static String insertRichiestaDem(String idDealer){
        Account dealer = [SELECT ID, Tipo_Intermediario__c,OCS_External_Id__c FROM Account WHERE ID=:idDealer];
        String codDelaer = dealer.OCS_External_Id__c.substring(1);
        User userCurrent= [SELECT Id,Alias FROM User WHERE Id =: UserInfo.getUserId()];     
        InserimentoRichiestaDemDealerInvoker.Request req = new InserimentoRichiestaDemDealerInvoker.Request(dealer.Tipo_Intermediario__c,codDelaer,userCurrent.Alias);
        InserimentoRichiestaDemDealerInvoker.Response res = InserimentoRichiestaDemDealerInvoker.invoke(req);
        System.debug('isOK:'+res.isOK());
        System.debug('getMessage():'+res.getMessage());
        if (res.inserimentoRichiestaDematerializzazioneDealerResponse!=null) {
                System.debug('esito:'+res.inserimentoRichiestaDematerializzazioneDealerResponse.esito); 
                System.debug('desErrore:'+res.inserimentoRichiestaDematerializzazioneDealerResponse.desErrore); 
        }        
        if (!res.isOK()) {
            return res.getMessage();
        }
        return null;
       
    }    

 
    @AuraEnabled
    public static String process(String caseId){
        System.debug('process caseId:'+caseId);
        Case activity = [SELECT ID, Status, AccountId FROM Case WHERE Id=:caseId];
        // verrà chiusa l’attivita di Dematerializzazione
        activity.Status = 'Closed';
        update activity;
        return null;
    }

}