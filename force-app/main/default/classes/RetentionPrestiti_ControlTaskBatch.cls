global class RetentionPrestiti_ControlTaskBatch implements Schedulable
{
	global static void execute(SchedulableContext ct)
    {
        date d = system.today().addDays(-5);
        Group g = GroupUtils.getQueue('Q297');
        List<Group> queueBranchList = GroupUtils.getQueueBranchList();
        List<Case> listActivityCase = CaseUtils.caseListForCategoryAndCategory('Id,AccountId,Branch__c',XCS_CategoriaUtil.OUTBOUND_CALLING_RETENTION,queueBranchList);
        List<Case> listCaseToCreate = new List<Case>();
        List<Task> taskToUpdate = new List<Task>();
        List<Task> listTask = [Select id,Status,Disposition__c,pratica__c,customer__c from Task where WhatId in :listActivityCase AND CreatedDate = :d];
        System.debug('*******' + listTask);
        for(Task tsk : listTask)
        {
            if(tsk.disposition__c == null || ! XCS_DispositionUtils.APPUNTAMENTO_FISSATO.equalsIgnoreCase(tsk.disposition__r.External_id__c))
            {
                tsk.status = 'Closed';
                taskToUpdate.add(tsk);
                listCaseToCreate.add(new Case(OwnerId = g.id ,numeroPratica__c = tsk.pratica__c,accountId = tsk.customer__c, Subject = 'Da customer service a filiale', Categoria_Riferimento__r = new XCS_Categoria__c(External_id__c = XCS_CategoriaUtil.PV_DA_CUSTOMER_SERVICE_A_FILIALE)));
            }
        }
        if(!taskToUpdate.isEmpty())
        {
            update taskToUpdate;
        }
        if(!listCaseToCreate.isEmpty())
        {
            insert listCaseToCreate;
        }   
    }
}