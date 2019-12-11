public class ContractUtils {
	@AuraEnabled
    public static void ritiraContratto(Contract c){
        c.WorkStatus__c='403';
        List<Documento__c> docs=[	select Id,SituazioneDocumento__c
                                	from Documento__c
                                	where Contract__c=:c.Id];
        for(Documento__c d:docs){
            if(!d.SituazioneDocumento__c.equals('M')){
                d.SituazioneDocumento__c='R';
            }
        }
        
        update docs;
        update(c);
        System.debug('Contratto ritirato!');
    }
}