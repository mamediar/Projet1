public class CaseHandler extends TriggerHandler {

    public override void beforeUpdate() {

        final TriggerData ticketingCsTentativoTriggerData = createTicketingCsTentativoTriggerData();
        if (TriggerData.isData(ticketingCsTentativoTriggerData)) {
            TicketingCsCaseHandler ticketingCsTentativoCaseHandler = new TicketingCsCaseHandler(ticketingCsTentativoTriggerData);
            ticketingCsTentativoCaseHandler.gestisciClienteNonTrovatoByNum();
        }

        final TriggerData ticketingCsRecallTriggerData = createTicketingCsRecallTriggerData();
        if (TriggerData.isData(ticketingCsRecallTriggerData)) {
            TicketingCsCaseHandler ticketingCsRecallCaseHandler = new TicketingCsCaseHandler(ticketingCsRecallTriggerData);
            ticketingCsRecallCaseHandler.gestisciRichiamaCliente();
        }

        final TriggerData ticketingCsClosedTriggerData = createTicketingCsClosedTriggerData();
        if (TriggerData.isData(ticketingCsClosedTriggerData)) {
            TicketingCsCaseHandler ticketingCsCloseCaseHandler = new TicketingCsCaseHandler(ticketingCsClosedTriggerData);
            ticketingCsCloseCaseHandler.gestisciChiusuraCase();
        }

    }

    public override void beforeInsert() {
        
        final TriggerData ticketingTriggerData = createTicketingTriggerData();
        if (TriggerData.isData(ticketingTriggerData)) {
            TicketingCaseHandler ticketingCaseHandler = new TicketingCaseHandler(ticketingTriggerData);
            ticketingCaseHandler.setBranch();
        }
		
        final TriggerData ticketingCsTriggerData = createTicketingCsTriggerData();
        if (TriggerData.isData(ticketingCsTriggerData)) {
            TicketingCsCaseHandler ticketingCsCaseHandler = new TicketingCsCaseHandler(ticketingCsTriggerData);
            System.debug('DP ticketingCsTriggerData: '+ticketingCsTriggerData);
            ticketingCsCaseHandler.updateDispositionAndCategory();
        }
        
    }

    public override void afterInsert() {

        final TriggerData ticketingTriggerData = createTicketingTriggerData();
        if (TriggerData.isData(ticketingTriggerData)) {
            TicketingCaseHandler ticketingCaseHandler = new TicketingCaseHandler(ticketingTriggerData);
            ticketingCaseHandler.insertTeamMemberCase();
            ticketingCaseHandler.insertNotaOCSBorg();
           // ticketingCaseHandler.setBranch();
            ticketingCaseHandler.caseShare();
            ticketingCaseHandler.parentChangeStatusOnInsert();
        }
        
        final TriggerData ticketingCsTriggerData = createTicketingCsTriggerData();
        if (TriggerData.isData(ticketingCsTriggerData)) {
            TicketingCsCaseHandler ticketingCsCaseHandler = new TicketingCsCaseHandler(ticketingCsTriggerData);
            System.debug('DP ticketingCsTriggerData: '+ticketingCsTriggerData);
            ticketingCsCaseHandler.updateSuPrimoInserimento();
        }

    }

    public override void afterUpdate() {

        final TriggerData ticketingChangeOwnerTriggerData = createTicketingChangeOwnerTriggerData();
        if (TriggerData.isData(ticketingChangeOwnerTriggerData)) {
            TicketingCaseHandler ticketingChangeOwnerCaseHandler = new TicketingCaseHandler(ticketingChangeOwnerTriggerData);
            ticketingChangeOwnerCaseHandler.caseShare();
        }

        final TriggerData ticketingTriggerData = createTicketingTriggerData();
        if (TriggerData.isData(ticketingTriggerData)) {
            TicketingCaseHandler ticketingCaseHandler = new TicketingCaseHandler(ticketingTriggerData);
            ticketingCaseHandler.parentChangeStatusOnUpdate();
            
        }

        final TriggerData ticketingClosedAndChangeStatusTriggerData = createTicketingClosedAndChangeStatusTriggerData();
        if (TriggerData.isData(ticketingClosedAndChangeStatusTriggerData)) {
            TicketingCaseHandler ticketingClosedAndChangeStatusCaseHandler = new TicketingCaseHandler(ticketingClosedAndChangeStatusTriggerData);
            ticketingClosedAndChangeStatusCaseHandler.changeChildCaseStatusOnClose();
        }
        
        final TriggerData ticketingCsInvioSMSTriggerData = createTicketingCsInvioSMSTriggerData();
        if (TriggerData.isData(ticketingCsInvioSMSTriggerData)) {
            TicketingCsCaseHandler ticketingCsInvioSMSCaseHandler = new TicketingCsCaseHandler(ticketingCsInvioSMSTriggerData);
            ticketingCsInvioSMSCaseHandler.handleInviaSMS();
        }

    }

    private TriggerData createTicketingTriggerData() {
        final List<Case> ticketingCaseList = new List<Case>();
        for (Case caseItem : (List<Case>) trigger.new) {
            if (TKT_RECORDTYPE_ID == caseItem.RecordTypeId) ticketingCaseList.add(caseItem);
        }
        System.debug('Trovati ' + ticketingCaseList.size() + ' Case di Ticketing');
        TriggerData ticketingTriggerData = null;
        if (ticketingCaseList.size() > 0) {
            ticketingTriggerData = new TriggerData(ticketingCaseList, Trigger.oldMap, Trigger.newMap);
        }
        return ticketingTriggerData;
    }

    private TriggerData createTicketingChangeOwnerTriggerData() {   
        final List<Case> ticketingChangeOwnerCaseList = new List<Case>();
        for (Case caseItem : (List<Case>) trigger.new)
        {
            final Id caseId = caseItem.Id;
            final Case oldCase = (Case) Trigger.oldMap.get(caseId);
            final Case newCase = (Case) Trigger.newMap.get(caseId);
            if (TKT_RECORDTYPE_ID == caseItem.RecordTypeId && oldCase.OwnerId != newCase.OwnerId) 
                ticketingChangeOwnerCaseList.add(newCase);
        }
        System.debug('Trovati ' + ticketingChangeOwnerCaseList.size() + ' Case di Ticketing con cambio owner');
        TriggerData ticketingTriggerData = null;
        if (ticketingChangeOwnerCaseList.size() > 0) {
            ticketingTriggerData = new TriggerData(ticketingChangeOwnerCaseList, Trigger.oldMap, Trigger.newMap);
        }
        return ticketingTriggerData;
    }

    private TriggerData createTicketingClosedAndChangeStatusTriggerData() {
        final List<Case> ticketingCaseList = new List<Case>();
        for (Case caseItem : (List<Case>) trigger.new) {
            final Id caseId = caseItem.Id;
            final Case oldCase = (Case) Trigger.oldMap.get(caseId);
            final Case newCase = (Case) Trigger.newMap.get(caseId);

            if (TKT_RECORDTYPE_ID == caseItem.RecordTypeId && newCase.isClosed && newCase.Status <> oldCase.Status) 
                ticketingCaseList.add(caseItem);
        }
        System.debug('Trovati ' + ticketingCaseList.size() + ' Case di Ticketing chiusi e con cambio stato');
        TriggerData ticketingTriggerData = null;
        if (ticketingCaseList.size() > 0) {
            ticketingTriggerData = new TriggerData(ticketingCaseList, Trigger.oldMap, Trigger.newMap);
        }
        return ticketingTriggerData;
    }

    private TriggerData createTicketingCsTriggerData() {   
        final List<Case> ticketingCsCaseList = new List<Case>();
        
        for (Case caseItem : (List<Case>) trigger.new) {
            if (TKTCS_RECORDTYPE_ID == caseItem.RecordTypeId) ticketingCsCaseList.add(caseItem);
        }
        System.debug('Trovati ' + ticketingCsCaseList.size() + ' Case di TicketingCS');
        TriggerData ticketingCsTriggerData = null;
        if (ticketingCsCaseList.size() > 0) {
            ticketingCsTriggerData = new TriggerData(ticketingCsCaseList, Trigger.oldMap, Trigger.newMap);
        }
        return ticketingCsTriggerData;
    }

    private TriggerData createTicketingCsRecallTriggerData() {   
        final List<Case> ticketingCsCaseList = new List<Case>();

        for (Case caseItem : (List<Case>) trigger.new) {
            final Id caseId = caseItem.Id;
            final Case oldCase = (Case) Trigger.oldMap.get(caseId);
            final Case newCase = (Case) Trigger.newMap.get(caseId);

            if (TKTCS_RECORDTYPE_ID == caseItem.RecordTypeId && oldCase.RecallDate__c <> newCase.RecallDate__c && newCase.TentativoNum__c == oldCase.TentativoNum__c)
                ticketingCsCaseList.add(caseItem);
        }
        System.debug('Trovati ' + ticketingCsCaseList.size() + ' Case di TicketingCS di Richiamo Cliente');
        TriggerData ticketingCsTriggerData = null;
        if (ticketingCsCaseList.size() > 0) {
            ticketingCsTriggerData = new TriggerData(ticketingCsCaseList, Trigger.oldMap, Trigger.newMap);
        }
        return ticketingCsTriggerData;
    }

    private TriggerData createTicketingCsClosedTriggerData() {   
        final List<Case> ticketingCsCaseList = new List<Case>();

        for (Case caseItem : (List<Case>) trigger.new) {
            final Id caseId = caseItem.Id;
            final Case oldCase = (Case) Trigger.oldMap.get(caseId);
            final Case newCase = (Case) Trigger.newMap.get(caseId);

            if (TKTCS_RECORDTYPE_ID == caseItem.RecordTypeId && oldCase.Status <> newCase.Status && newCase.Status == 'Closed')
                ticketingCsCaseList.add(caseItem);
        }
        System.debug('Trovati ' + ticketingCsCaseList.size() + ' Case di TicketingCS che aggiornano lo stato a Closed');
        TriggerData ticketingCsTriggerData = null;
        if (ticketingCsCaseList.size() > 0) {
            ticketingCsTriggerData = new TriggerData(ticketingCsCaseList, Trigger.oldMap, Trigger.newMap);
        }
        return ticketingCsTriggerData;
    }

    private TriggerData createTicketingCsTentativoTriggerData() {   
        final List<Case> ticketingCsCaseList = new List<Case>();

        for (Case caseItem : (List<Case>) trigger.new) {
            final Id caseId = caseItem.Id;
            final Case oldCase = (Case) Trigger.oldMap.get(caseId);
            final Case newCase = (Case) Trigger.newMap.get(caseId);

            if (TKTCS_RECORDTYPE_ID == caseItem.RecordTypeId){ 
                if ((oldCase.TentativoNum__c == null && newCase.TentativoNum__c <> null) ||
                 (newCase.TentativoNum__c == oldCase.TentativoNum__c + 1))
                ticketingCsCaseList.add(caseItem);
            }
        }
        System.debug('Trovati ' + ticketingCsCaseList.size() + ' Case di TicketingCS con aumento di TentativoNum');
        TriggerData ticketingCsTriggerData = null;
        if (ticketingCsCaseList.size() > 0) {
            ticketingCsTriggerData = new TriggerData(ticketingCsCaseList, Trigger.oldMap, Trigger.newMap);
        }
        return ticketingCsTriggerData;
    }
    
    private TriggerData createTicketingCsInvioSMSTriggerData() {   
        final List<Case> ticketingCsCaseList = new List<Case>();

        for (Case caseItem : (List<Case>) trigger.new) {
            final Id caseId = caseItem.Id;
            final Case oldCase = (Case) Trigger.oldMap.get(caseId);
            final Case newCase = (Case) Trigger.newMap.get(caseId);

            if (TKTCS_RECORDTYPE_ID == caseItem.RecordTypeId && newCase.SMSInviatiNum__c <> oldCase.SMSInviatiNum__c) {
                ticketingCsCaseList.add(caseItem);
            }
        }
        System.debug('Trovati ' + ticketingCsCaseList.size() + ' Case di TicketingCS con aumento di SMSInviatiNum');
        TriggerData ticketingCsTriggerData = null;
        if (ticketingCsCaseList.size() > 0) {
            ticketingCsTriggerData = new TriggerData(ticketingCsCaseList, Trigger.oldMap, Trigger.newMap);
        }
        return ticketingCsTriggerData;
    }

    private static final String TKT_RECORDTYPE_ID = RecordTypeUtil.getCaseRecordType('Ticketing');
    private static final String TKTCS_RECORDTYPE_ID = RecordTypeUtil.getCaseRecordType('TicketingCS');
}