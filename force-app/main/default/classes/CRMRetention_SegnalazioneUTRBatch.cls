global class CRMRetention_SegnalazioneUTRBatch implements Schedulable
{
    global static void execute(SchedulableContext ct)
    {
        List<Group> queueBranchList = GroupUtils.getQueueBranchList();
        String recordtypeTaskId = RecordtypeUtil.getRecordType('Task','Attivita_Retention_Outbound_Recall');
        Map<String,Group> mapQueue = GroupUtils.getQueueMapByDeveloperName(queueBranchList);
        Map<String,Case> mapCase = new Map<String,Case>();
        Map<String,String> setMapActivityToCreate = new Map<String,String>();
        List<Task> listTask = new List<Task>();
        List<Case> listCaseToCreate = new List<Case>();
        List<Case> listActivityCase = CaseUtils.caseListForCategoryAndCategory('Id,AccountId,Branch__c',XCS_CategoriaUtil.OUTBOUND_CALLING_RETENTION,queueBranchList);
        For(Case c : listActivityCase)
        {
            mapCase.put(c.Branch__c,c);
        }
        List<CRM_Retention__c> listRetentionToCreate = CRMRetentionUtil.getRetentionToCreateNotUsed();
       	System.debug('*********');
        For(CRM_Retention__c ret : listRetentionToCreate)
        {
            if(mapCase.get(ret.Branch__c) == null)
            {
                setMapActivityToCreate.put(ret.Branch__r.OCS_External_Id__c,ret.Branch__c);  
            }
        }
        if(! setMapActivityToCreate.isEmpty())
        {
            For(String s : setMapActivityToCreate.keySet())
            {
                listCaseToCreate.add(new Case(Categoria_Riferimento__r = new XCS_Categoria__c(External_Id__c = XCS_CategoriaUtil.OUTBOUND_CALLING_RETENTION),Subject = CRMRetentionUtil.CASE_ACTIVITY_OUTBOUND_RETENTION ,branch__c = setMapActivityToCreate.get(s) , OwnerId = mapQueue.get(s).id ));
            }
            insert listCaseToCreate;
            For(Case c : listCaseToCreate)
            {
                mapCase.put(c.Branch__c,c);
            }
        }
        System.debug(mapCase);
        For(CRM_Retention__c ret : listRetentionToCreate)
        {
            listTask.add(New Task(Customer__c = ret.Customer__c,recordtypeid = recordtypeTaskId ,whatId = mapCase.get(ret.Branch__c).id,Subject = 'Call',Pratica__c = ret.LoanNumber__c));
        	ret.Selected__c = true;
        }
        
        if(! listTask.isEmpty())
        {
            insert listTask;
            update listRetentionToCreate;
        }
    }
}