public class ClienteNonTrovatoController {
    
    @AuraEnabled
    public static void handleCase(final String recordId) {

        final Case recordCase = [SELECT 
                                    Id, 
                                    Account.Privacy_SMS__pc, 
                                    Account.Id, 
                                    Account.OCS_External_ID__c,
                                    RecordType.DeveloperName,
                                    TentativoNum__c
                                    
                                    FROM Case
                                    WHERE Id =: recordId];

        final Integer numTentativo = recordCase.TentativoNum__c == null ? 0 : recordCase.TentativoNum__c.intValue();
        final ConfigCaseCommonAction__c configCase = CaseUtils.getRecordByRecordtypeAndRange(recordCase.RecordType.DeveloperName, numTentativo);

        if (configCase != null) {
            if (String.isNotBlank(configCase.CaseStatusToAssign__c))
                recordCase.Status = configCase.CaseStatusToAssign__c;
            
            if (String.isNotBlank(configCase.DispositionToAssign__c))
                XCS_DispositionUtils.aggiungiDispositionCase(recordCase, configCase.DispositionToAssign__c);
        }
        else {
            System.debug('ConfigCaseCommonAction non trovata');
        }
        update recordCase;
    }
}