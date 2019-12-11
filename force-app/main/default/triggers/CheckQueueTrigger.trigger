trigger CheckQueueTrigger on CRM_QueueMailFaxConfig__c (before insert, before update) {
    
    Map<String,Group> queueInSalesforce = GroupUtils.getAllQueuesByDeveloperName();    
    List<CRM_QueueMailFaxConfig__c> listQueueMailFaxConfig = [SELECT MailBox__c, Balancing__c, BalancingPercent__c, Email_per_risposta__c, Outsourcer__c, Max_Number__c, Min_Number__c, Queue_CSI__c, Queue_Outsourcer__c, Checked_in_this_month__c, Recall_Queue__c, Fax_to_check__c, Categoria_Ext_Id_Reference__c, DeveloperName__c, Type__c, Id FROM CRM_QueueMailFaxConfig__c where Type__c = 'Fax'];
    Map<String,CRM_QueueMailFaxConfig__c> mapQueueMailFaxConfig = new Map<String,CRM_QueueMailFaxConfig__c>();
    for (CRM_QueueMailFaxConfig__c qmfx : listQueueMailFaxConfig)
    {
    	mapQueueMailFaxConfig.put(qmfx.developername__c,qmfx);    
    }
    system.debug('*****' + mapQueueMailFaxConfig.keySet());
     if(trigger.isBefore){
        if(trigger.isInsert || trigger.isUpdate){
            for (CRM_QueueMailFaxConfig__c qmfx : trigger.new) {
                if('Fax'.equalsIgnoreCase(qmfx.Type__c) && mapQueueMailFaxConfig.keySet().contains(qmfx.DeveloperName__c) && mapQueueMailFaxConfig.get(qmfx.DeveloperName__c).id != qmfx.id)
                {
                    qmfx.addError('Esiste già una configurazione per la coda di lavorazione per il fax');
                }
                else if(!(queueInSalesforce.keySet().contains(qmfx.DeveloperName__c)))
                {    
                    qmfx.addError('Non esiste alcuna coda con il DeveloperName inserito');
                }    
            }
        }
    }
}