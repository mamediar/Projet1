//----------------------------------------------------------------------
//-- - Author       : SANA BADJI
//-- - Date         : 01/06/2019
//-- - Description  : Handle Trigger aggiornaPratica
//----------------------------------------------------------------------
trigger UpdateCaseTrigger on Case (after update, after insert) {
    Set<Id> idsToProcess = new Set<Id>();
    Set<Id> managedRecordTypeId = new Set<Id>();
    
    for(Case c : trigger.new)
    {
        idsToProcess.add(c.Id);
        managedRecordTypeId.add(c.RecordTypeId);
    }


    if(Recursion.isTriggerExecuting!=true && trigger.isAfter && (trigger.isUpdate || trigger.isInsert)){
      System.debug('******** Trigger After ');
        if(managedRecordTypeId.contains(CGMWSUtils_1_0.getRecordTypeId('Case','CRM_RichiestaOnline'))){
            HandlerCaseTriggerClass.aggiornamentoHandler(Trigger.new);
            CaseHandlerTriggerClass.caseHandlerDispatcher(trigger.new,idsToProcess);
            }else{System.debug('******** recordTypeNotExist ');}  
    }
        
}