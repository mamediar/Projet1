public without sharing class SFAConvenzVerificaSeDealerEsistente {

    @AuraEnabled
    public static List<Account> getListDealerEsistentePerPIoCF(String partitaIVA, String codiceFiscale) {
        List<Account> lstDealerEsistentePerPIoCF = new List<Account>();
        
        if(partitaIVA !='' && partitaIVA !=null ){
            
            lstDealerEsistentePerPIoCF = [SELECT Id, Name, Status__c, Branch__r.getCodice_Cliente__c, Branch__r.OCS_External_Id__c, Partita_IVA__c, Codice_Fiscale__c
            FROM Account
            WHERE RecordType.Name = 'Dealer' AND Partita_IVA__c = :partitaIVA ];
        }
        
        if((lstDealerEsistentePerPIoCF == null || lstDealerEsistentePerPIoCF.size() == 0 ) && codiceFiscale !='' && codiceFiscale !=null) {
            lstDealerEsistentePerPIoCF = [SELECT Id, Name, Status__c, Branch__r.getCodice_Cliente__c, Branch__r.OCS_External_Id__c, Partita_IVA__c, Codice_Fiscale__c
            FROM Account
            WHERE RecordType.Name = 'Dealer' AND Codice_Fiscale__c = :codiceFiscale];
        }
        return lstDealerEsistentePerPIoCF;
    }

    @AuraEnabled
    public static List<Account> getListDealerEsistentePerRagioneSociale(String ragioneSociale) {
        List<Account> lstDealerEsistentePerRagioneSociale = 
        [SELECT Id, Name, Branch__r.getCodice_Cliente__c, Partita_IVA__c, Codice_Fiscale__c
         FROM Account
         WHERE RecordType.Name = 'Dealer' AND Name = :ragioneSociale];

         return lstDealerEsistentePerRagioneSociale;
    }

}