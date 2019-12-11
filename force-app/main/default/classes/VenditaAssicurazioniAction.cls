public class VenditaAssicurazioniAction extends XCSMenuAction {
    
    public override XCSMenuActionResult preRedirect(){
        OCSRecuperaDatiClienteResponse response = OCSRecuperaDatiClienteInvoker.recuperaDatiCliente(getAccount().getCodice_Cliente__c);
        XCSMenuActionResult res = new XCSMenuActionResult('standard__recordPage');
        String recordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'CRM_MASTER'].Id;
        String query = 'SELECT COUNT() FROM Case ' +
                       'WHERE AccountId = \'' + String.escapeSingleQuotes(getAccount().Id) + '\' ' +
                       'AND ActivityType__c = \'CRM_VENASS\' ' +
                       'AND CreatedDate = LAST_N_DAYS:30';
        Integer openActivities = Database.countQuery(query); 
        Case currentCase = new Case(
            ActivityType__c = 'CRM_VENASS',
            Subject = 'Vendita Assicurazioni',
            RecordTypeId = recordTypeId,
            Type = 'CRM',
            AccountId = getAccount().Id,
            PrivacyAccount__c = (response.recuperaDatiClienteResponse.privacyRilevQualita == 'S' && 
                                 response.recuperaDatiClienteResponse.privacyOffCommInterne == 'S' &&
                                 response.recuperaDatiClienteResponse.privacyOffCommEsterne == 'S' &&
                                 response.recuperaDatiClienteResponse.privacyServiziAltri == 'S')
        );
        currentCase.Esito__c = (openActivities > 0) ? 'Richiesta doppia' : (!currentCase.PrivacyAccount__c) ? 'Privacy KO' : '';
        currentCase.Status = (openActivities > 1 || !currentCase.PrivacyAccount__c) ? 'Closed' :'New';
        insert currentCase;  
        //res.setRecordId(currentCase.Id);
        res.getAttributes().setRecordId(currentCase.Id);
        res.getAttributes().setObjectApiName('Case');	
        res.getAttributes().setActionName('view');	
        
        return res;
    }
}