public class SFAListaDaSedeGestListeCaricateCtrl {
	@AuraEnabled
    public Static List<SFA_ListeCaricate__c> getListeCaricate(Integer Limits, Boolean showOnly){ 
        if(showOnly) {
            return [Select id, Ordine_Visualizzazione__c, Nome_Lista__c, Data_Visibilita__c, Tipo_Attivita__r.Name, Tipo_Attivita__r.Descrizione__c, Numero_Righe__c, Data_Caricamento__c, Chiuso__c From SFA_ListeCaricate__C WHERE Chiuso__c=false ORDER BY Ordine_Visualizzazione__c LIMIT :Integer.valueof(Limits)]; 
        }
        else {
            return [Select id, Ordine_Visualizzazione__c, Nome_Lista__c, Data_Visibilita__c, Tipo_Attivita__r.Name, Tipo_Attivita__r.Descrizione__c, Numero_Righe__c, Data_Caricamento__c, Chiuso__c From SFA_ListeCaricate__C ORDER BY Ordine_Visualizzazione__c LIMIT :Integer.valueof(Limits)]; 
        }
    }
    @AuraEnabled
    public static Integer totalListeCaricate(Boolean showOnly){
        if(showOnly) {
            AggregateResult results = [SELECT Count(Id) TotalListe From SFA_ListeCaricate__c WHERE Chiuso__c=false];
            Integer totalListe = (Integer)results.get('TotalListe');
            return totalListe;
        }
        else {
            AggregateResult results = [SELECT Count(Id) TotalListe From SFA_ListeCaricate__c];
            Integer totalListe = (Integer)results.get('TotalListe');
            return totalListe;
        }
    } 
    @AuraEnabled
    public static Integer updateListeCaricate (List<SFA_ListeCaricate__c> Liste) {
        upsert Liste;
        return 1;
    }
    
    @AuraEnabled
    public static Boolean closeAllRelatedCase (List<SFA_ListeCaricate__c> draftValues) {
        if(!draftValues.isEmpty()){
            system.debug('@@@CONTROLLER: '+draftValues);
            SFAListaDaSedeChiusuraListe batch = new SFAListaDaSedeChiusuraListe(draftValues);
            Database.executeBatch(batch, 50);
            return true;

        }
        return false;
    }

}