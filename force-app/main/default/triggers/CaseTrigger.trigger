trigger CaseTrigger on Case (before insert, 
                             after insert, 
                             before update, 
                             after update, 
                             before delete, 
                             after delete, 
                             after undelete) 
{
    System.debug('++++ CaseTrigger ++++');
    new AssignQueueCasiChiusiTriggerHandler().run();
    new CaseHandler().run();   
    new CaseTriggerHandlerSLA().run();
    new ReclamiTriggerHandler().run();
    
    // TODO: da spostare nel CaseHandler
    if (Trigger.isBefore && Trigger.isUpdate) {
    /*
    Azione: su update del record case (case.disposition__c) viene aggiornata la data della disposition (case.dispositionData__c)
    */
    system.debug('----------------------------------------------------------------------------------');
    system.debug('-- Trigger Name: CaseTrigger'); 
   
    List<Case> cases = Trigger.new;
        
        for (Case currCase: cases) {
            Case oldCase = Trigger.oldMap.get(currCase.ID);
    
            if (oldCase != null) {
                if (currCase.Disposition__c != oldCase.Disposition__c) {
                    currCase.DispositionData__c = datetime.now();
                }
            } 
        }
    }
}