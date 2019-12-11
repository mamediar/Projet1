public with sharing class SFADematerializzazioneHelper {



    public final static XCS_Categoria__c categoriaDematerializzazione;
    static {
        categoriaDematerializzazione = [SELECT ID FROM XCS_Categoria__c WHERE External_Id__c = 'AT0122' LIMIT 1];
    }


    private static Case creaAttivitaDematerializzazione(Account dealer){
        Case attivita = new Case();
        attivita.AccountId = dealer.id;
        attivita.Priority = 'Low';
        attivita.Categoria_Riferimento__c = categoriaDematerializzazione.id;
        attivita.Subject = 'Dematerializzazione Delaer';
        attivita.Status = 'New';
        if (dealer!=null && dealer.Branch__c!=null) {
            Account filialeFound  = [SELECT Id, Name, OCS_External_Id__c FROM Account WHERE Id =:dealer.Branch__c LIMIT 1];
             if (filialeFound!=null) {
                 attivita.Branch__c = filialeFound.id;
            }
        }
        attivita.RecordTypeId =RecordTypeUtil.getCaseRecordType('Dematerializzazione');
        attivita = CaseUtils.assignToFilialeQueueByDealer(attivita,dealer.OCS_External_Id__c);
        insert attivita;
        return attivita;       
    }

    //verifica che non esista già una attività aperta e in caso negativo procede a richiamare un servizio B2BSOAP per verificare che il dealer sia effettivamente “dematerializzabile”.
    //crea nuova attivita di dematerializzazione
    public static String creaAttivitaDematerializzazione(String idDealer){
        Account dealer = [SELECT ID, Tipo_Intermediario__c,OCS_External_Id__c,Branch__c FROM Account WHERE ID=:idDealer];
        //verifica che non esista già una attività aperta
        List<Case> attivitaDematarializ = [SELECT ID FROM Case WHERE Status = 'New' AND AccountId =:idDealer AND Categoria_Riferimento__c =:categoriaDematerializzazione.id];
        if (attivitaDematarializ==null || attivitaDematarializ.size()==0) {          
            //in caso negativo procede a richiamare un servizio B2BSOAP per verificare che il dealer sia effettivamente “dematerializzabile”.
            String codOCS = dealer.OCS_External_Id__c;
            if (String.isNotEmpty(codOCS) && codOCS.length()>0) {
                  codOCS = codOCS.substring(1);
            }
            VerificaRequisitiDemDealerInvoker.Request req = new VerificaRequisitiDemDealerInvoker.Request(dealer.Tipo_Intermediario__c,codOCS);
            VerificaRequisitiDemDealerInvoker.Response res = VerificaRequisitiDemDealerInvoker.invoke(req);
            if (!res.isOK()) {
                // esito KO
                return res.getMessage();
            }
            // si puo' procedere alla creazione dell'attività di dematerializzazione
            creaAttivitaDematerializzazione(dealer);
        }
        return null;
    }

}