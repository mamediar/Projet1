public class SFA_CompilaRegistriControllerApex {
    @AuraEnabled
    public static Date onInitGetDate(){
        return Date.today();        
    }

    @AuraEnabled
    public static OCSrecuperaTimbratureZucchettiResponse.elencoTimbrature[] getTimbrature(Date dataTimbrature){
        User currentUser = getCurrentUser();
        OCSrecuperaDatiUtenteZucchettiResponse.recuperaDatiUtenteZucchettiResponse response= OCSrecuperaDatiUtenteZucchettiInvoker.callRecuperaDatiUtenteZucchetti(currentUser.Alias).recuperaDatiUtenteZucchettiResponse;
        if(response==null){
            AuraHandledException e= new AuraHandledException('utente non trovato');
            e.setMessage('utente non trovato');
            throw e;
        }
        OCSrecuperaTimbratureZucchettiResponse.recuperaTimbratureZucchettiResponse printsResponse= OCSrecuperaTimbratureZucchettiInvoker.callrecuperaTimbratureZucchetti(response.idCompany, response.idEmploy, dataTimbrature).recuperaTimbratureZucchettiResponse;
        if(printsResponse != null){
            return printsResponse.elencoTimbrature;
        }
        else{
            AuraHandledException e= new AuraHandledException('Nessuna timbratura presente');
            e.setMessage('Nessuna timbratura presente');
            throw e;
        }
    }
    
    private static User getCurrentUser(){
        String utenteId = UserInfo.getUserId();
        return [SELECT FirstName, LastName,Id,Name, Alias, DefaultQueueId__c FROM User WHERE Id =: utenteId];
    }
    private static Account getBranches(User currentUser){
		return [SELECT Id FROM Account WHERE OCS_External_Id__c =: currentUser.DefaultQueueId__c  AND RecordType.Name = 'Branch'];
	}

    @AuraEnabled
    public static void insertNotaSpese(SFA_NotaSpese__c notaSpese){
        User currentUser=getCurrentUser();
        notaSpese.User__c=currentUser.Id;
        notaSpese.Branch__c=getBranches(currentUser).Id;
        
        notaSpese.Status__c='Da Approvare';
        insert notaSpese;
    }
}