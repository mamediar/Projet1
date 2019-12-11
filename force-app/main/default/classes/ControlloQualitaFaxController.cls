public without sharing class ControlloQualitaFaxController {
    
    @AuraEnabled
    public static void confirmTaskCQ(String sla, String identificazione, String operativita,
                                     String noteOCS, String archiviazione,String note, String recordId)
    {   
        Id userId = Userinfo.getUserId();
        String aliasUser = [Select alias from user where id = : userId].alias;
        Id rtCQ = recordtypeUtil.getRecordType(recordtypeutil.API_NAME_CASE,'CRM_Attivita_CQ');
        List<Case> caseList = new List<Case>(); 
        List<Task> taskList = new List<Task>();
        List<CRM_QueueMailFaxConfig__c> config = new List<CRM_QueueMailFaxConfig__c>();
        List<Group> groupListOutsourcer = new List<Group>();
        List<Group> groupListCSI = new List<Group>();
        Case actualCase = [Select id,parentid,processType__c,(Select whatId, Subject, status, Check_value_before_create_task__c, type
                                                              from tasks) from Case where id = :recordId];
        Task actualTask;
        For(Task tsk : actualCase.tasks)
        {
            if(tsk.Status.equals('Open'))
            {
                actualTask = tsk;
                break;
            }
        }
        Case parentCase = [Select id, Queue_Mail_Fax_Config__c,processType__c,Ownerid,(Select id,Status,processType__c from cases where id != :recordId AND RecordtypeId = :rtCQ) from case where id = :actualCase.ParentId];
        List<Case> listChildBrotherCase = parentCase.cases;
        config = [Select Queue_Outsourcer__c, Queue_CSI__c from CRM_QueueMailFaxConfig__c where id =: parentCase.Queue_Mail_Fax_Config__c];
        groupListOutsourcer = [Select id from group where developerName =: config[0].Queue_Outsourcer__c];
        groupListCSI = [Select id from group where developerName =: config[0].Queue_CSI__c];
        If(actualTask.Check_value_before_create_task__c == true)
        {
            if('SI'.equalsIgnoreCase(sla) && 'SI'.equalsIgnoreCase(identificazione) && 
               'SI'.equalsIgnoreCase(operativita) && 'SI'.equalsIgnoreCase(noteOCS) &&
               'SI'.equalsIgnoreCase(archiviazione))
            {    
                updateCurrentTask(actualTask.id,archiviazione,identificazione,operativita,noteOCS,note,sla,aliasUser);                   
                updateClosedCase(actualCase.id);
                
                if(!isProcessTypeTheActual(listChildBrotherCase,caseutils.GESTIONE_FAX_PROCESSTYPE_DA_CONTROLLARE))
                {
                    if(isProcessTypeTheSame(listChildBrotherCase,caseutils.GESTIONE_FAX_PROCESSTYPE_RICONTROLLATO))
                    {
              
                        updateClosedCase(parentCase.id);

                    }
                    else
                    {
                        parentCase.ProcessType__c = caseutils.GESTIONE_FAX_PROCESSTYPE_INVIABILE;
                        update parentCase;
                    }
                }
            }
            else
            {         
                createTaskControverifica(actualCase.id, note);                             
               	updateCurrentTask(actualTask.id,archiviazione,identificazione,operativita,noteOCS,note,sla,aliasUser); 
                updateChildCase(actualCase.id,caseutils.GESTIONE_FAX_PROCESSTYPE_INVIABILE);
                if(!isProcessTypeTheActual(listChildBrotherCase,caseutils.GESTIONE_FAX_PROCESSTYPE_DA_CONTROLLARE))
                {
                        parentCase.ProcessType__c = caseutils.GESTIONE_FAX_PROCESSTYPE_INVIABILE;
                        update parentCase;
                }
            }
        }
        else {
        	if('Fax Controverifica'.equalsIgnoreCase(actualTask.type)){

                updateCurrentTask(actualTask.id,archiviazione,identificazione,operativita,noteOCS,note,sla,aliasUser);                                        
                createTaskPostControverifica(actualCase.id, note);                          
                updateChildCase(actualCase.id,CaseUtils.GESTIONE_FAX_PROCESSTYPE_CONTESTATO);
                if(!isProcessTypeTheActual(listChildBrotherCase,caseutils.GESTIONE_FAX_PROCESSTYPE_INVIATO))
                {
                   updateOwnerCase(parentCase.Id,groupListCSI[0].id,CaseUtils.GESTIONE_FAX_PROCESSTYPE_CONTESTATO);
                   listChildBrotherCase.add(actualCase);
                    For(Case c : listChildBrotherCase)
                   {
                       c.OwnerId = groupListCSI[0].id;
                   }
                 	update listChildBrotherCase;
                }   
			}
            if('Fax Postcontroverifica'.equalsIgnoreCase(actualTask.type))
            {
                updateCurrentTask(actualTask.Id,archiviazione,identificazione,operativita,noteOCS,note,sla,aliasUser);
                updateClosedCase(actualCase.id);
                if(!isProcessTypeTheActual(listChildBrotherCase,caseutils.GESTIONE_FAX_PROCESSTYPE_CONTESTATO))
                {
              		updateClosedCase(parentCase.Id);
                }                
			}   
        
        
        }
    }                   
    
    private static void createTaskControverifica(String caseId, String note){
        
        RecordType r = [select id, developerName from recordType 
                        where developerName = 'Attivita_Controllo_Qualita_Fax'];
        
        Task tsk = new Task();
        tsk.WhatId = caseId; 
        tsk.RecordTypeId = r.id;
        tsk.Subject = 'Task di controllo qualità ControVerifica';
        tsk.Type = 'Fax Controverifica';
        tsk.Check_value_before_create_task__c = false;
        tsk.Note__c = note;
        
        insert tsk;
    }
    
    private static void createTaskPostControverifica(String caseId, String note){
        
        RecordType r = [select id, developerName from recordType 
                        where developerName = 'Attivita_Controllo_Qualita_Fax'];
        
        Task tsk = new Task();
        tsk.WhatId = caseId; 
        tsk.RecordTypeId = r.id;
        tsk.Subject = 'Task di controllo qualità PostControVerifica';
        tsk.Type = 'Fax Postcontroverifica';
        tsk.Check_value_before_create_task__c = false;
        tsk.Note__c = note;
        
        insert tsk;
    }
    
    private static void updateCurrentTask(String recordId, String archiviazione, String identificazione,
                                          String operativita,String noteOCS, String note, String sla,String aliasUser)
    {       
        Task TaskControlloToUpdate = new Task();
        TaskControlloToUpdate.id = recordId;
        TaskControlloToUpdate.Status = 'Completato';
        taskControlloToUpdate.Archiviazione__c = archiviazione;
        taskControlloToUpdate.Identificazione__c = identificazione;
        taskControlloToUpdate.Operativita__c = operativita;
        taskControlloToUpdate.Note_OCS__c = noteOCS;
        taskControlloToUpdate.Note__c = note;
        taskControlloToUpdate.sla__c = sla;
        taskControlloToUpdate.DataLavorazione__c = system.now();
        taskControlloToUpdate.UtenteLavorazione__c = aliasUser;
        
        system.debug('**************TASK:' + taskControlloToUpdate + '    CAMPI NON INSERITI:' +archiviazione + identificazione +operativita + noteOCS +sla);
        
        update TaskControlloToUpdate;        
    }
    
    private static void updateClosedCase(String caseId){
        
        Case caseToUpdate = new Case();
        caseToUpdate.id = caseId;
        caseToUpdate.status = 'Gestito';
        caseToUpdate.ProcessType__c = caseutils.GESTIONE_FAX_PROCESSTYPE_RICONTROLLATO;
        update caseToUpdate;
        
    }

    private static void updateOwnerCase(String caseId, String ownerQueueId,String processType){
        
        Case caseToUpdate = new Case();
        caseToUpdate.id = caseId;
        caseToUpdate.ownerId = ownerQueueId;
        caseToUpdate.processType__c = processType;
        update caseToUpdate;
    }
    
    private static void updateChildCase(String caseId, String processType)
    {
       	Case caseToUpdate = new Case();
        caseToUpdate.id = caseId;
        caseToUpdate.ProcessType__c = processType;
        update caseToUpdate;
    }
    private static boolean isProcessTypeTheSame(List<Case> lCase, String processType)
    {
     	boolean res = true;
        for(Case c : lCase)
        {
            if(!processType.equals(c.ProcessType__c))
            {
              	res = false;
                break;
            }
        }
        return res;
    }
    private static boolean isProcessTypeTheActual(List<Case> lCase, String processType)
    {
     	boolean res = false;
        for(Case c : lCase)
        {
            if(processType.equals(c.ProcessType__c))
            {
              	res = true;
                break;
            }
        }
        return res;
    }
    private static void updateClosedTask(String recordId){
        Task TaskControlloToUpdate = new Task();
        TaskControlloToUpdate.id = recordId;
        TaskControlloToUpdate.Status = 'Completato';  
        update TaskControlloToUpdate;
        
    }
    // ora ha il riferimento del case figlio
    // CAMBIATA
    @AuraEnabled
    public static void getUserInfo(String recordId){
        Id idUser = Userinfo.getUserId();
        System.debug('Id dell utente corretto = ' + idUser);
        Case c = [Select id,(Select id,ownerId,status from Tasks) from Case Where id =: recordId];
        List<Task> taskList = c.tasks;
        Task tsk;
        For(Task t : taskList)
        {
            if(t.status.equals('Open'))
            {
                tsk = t;
                break;
            }
        }
        //task = [Select id, ownerId from task where id =: recordId];
       // System.debug('Id dell owner del task = ' +  tsk.ownerId);
        //tsk.ownerId = idUser;
       // update tsk;
        
    }
    
}