public class CRMReclamiInserimentoMittentiMainCtrl{
	@AuraEnabled
    public static XCS_Mittente__c makeMittenteFromCliente(OCSCliente cliente){
        system.debug('makeMittenteFromCliente: '+cliente);
        return XCS_MittenteUtils.makeMittente(cliente);
    }
    @AuraEnabled
    public static XCS_Mittente__c makeMittenteFromClientePR(OCSCliente cliente){
        system.debug('makeMittenteFromCliente: '+cliente);
        return XCS_MittenteUtils.makeMittentePrincipale(cliente);
    }
    @AuraEnabled
    public static XCS_Mittente__c[] makeMittentiFromClienti(OCSCliente[] clienti){
         system.debug('makeMittentiFromClienti: '+clienti);
        return XCS_MittenteUtils.makeMittenti(clienti);
    }
    @AuraEnabled
    public static XCS_Mittente__c[] makeMittentiFromClientiPR(OCSCliente[] clienti){
         system.debug('makeMittentiFromClienti: '+clienti);
        return XCS_MittenteUtils.makeMittentiPR(clienti);
    }
    
}