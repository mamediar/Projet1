/**
* @Author:      Orlando S.
* @Description:
* 
* */
global class COM_BatchCaseFilialiAssignment implements Database.Batchable<sObject> , Database.Stateful
{
    //Attributes
    @testvisible private String queryToDO        = '';
    @testvisible private Id IDRecordTypeFiliale;
    
    //Constructor
    global COM_BatchCaseFilialiAssignment()
    {
            IDRecordTypeFiliale  = getCaseRecordTypeId();
            system.debug('15_05_2019 IDRecordTypeFiliale->'+IDRecordTypeFiliale);
            queryToDo        =    'SELECT Id , CaseNumber , Owner.Name,Owner.Id,Branch__c,Branch__r.Name '+
                                  ' FROM Case '+
                                  ' WHERE Owner.Name = \'CodaCommodityFilliale\' ';
                                  //' WHERE RecordTypeId = \' '+IDRecordTypeFiliale+' \' AND Owner.Name = \'CodaCommodityFilliale\' ';
    }
    //Start Method
    global Database.QueryLocator start(Database.BatchableContext BC) 
    {
        return Database.getQueryLocator( queryToDO );
    }
     
    //Execute Method
    global void execute(Database.BatchableContext BC, List<SObject> scope ) 
    {
        try{
            system.debug('15_05_2019 execute');
            checkCaseToAssign( scope );
        }catch( Exception ErrorException )
        {
            
        }
    }
    
    //Finish Method
    global void finish(Database.BatchableContext BC) 
    {
        AsyncApexJob job = [ SELECT Id,
                            ApexClass.Name,
                            CompletedDate,
                            JobType,
                            NumberOfErrors,
                            JobItemsProcessed,
                            TotalJobItems,
                            CreatedBy.Email,
                            CreatedBy.Name,
                            Createddate 
                            FROM AsyncApexJob
                            WHERE Id =: BC.getJobId() ];
        
    }
    
    public static Id getCaseRecordTypeId() 
    {
        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName()
                .get('XCS_Post_Vendita').getRecordTypeId();
        return RecordTypeId;
    }
     /********************************Work Methods*************************************/
    @testvisible 
    private void checkCaseToAssign(List<SObject> listCases )
    {
            List<Case> ListCaseToAssign   = new List<Case>();
            Set<String> FilialiNames      = new Set<String>();
            Map<String,Id> MapNameQueueId = new Map<String,Id>();
        
            system.debug('15_05_2019 listCases:'+listCases);
            if( listCases != null && listCases.size() > 0 )
            {
                for( SObject SSObj : listCases )
                {
                     Case cc = (Case)SSObj;
                     if( cc.Branch__c != null && cc.Branch__r.Name != null )
                     {
                         FilialiNames.add( cc.Branch__r.Name );    
                     }    
                }
                system.debug('15_05_2019 FilialiNames->'+FilialiNames);
                List<Group> ListQueue = new List<Group>();
                if( FilialiNames != null && FilialiNames.size() > 0 )
                {
                         ListQueue = [ SELECT Id, Name, DeveloperName, RelatedId, Type, Email, QueueRoutingConfigId, 
                                            OwnerId, DoesSendEmailToMembers, DoesIncludeBosses, CreatedDate, CreatedById, 
                                            LastModifiedDate, LastModifiedById, SystemModstamp 
                                     FROM Group 
                                     WHERE Type = 'Queue' AND Name IN : FilialiNames ];
                }
                system.debug('15_05_2019 ListQueue->'+ListQueue);
                if( ListQueue != null && ListQueue.size() > 0 )
                {
                    for( Group QueueIter : ListQueue )
                    {
                         if( QueueIter.Name != null )MapNameQueueId.put( QueueIter.Name , QueueIter.Id );
                    }
                }
                system.debug('15_05_2019 MapNameQueueId->'+MapNameQueueId);
                if( MapNameQueueId != null && MapNameQueueId.size() > 0 )
                {
                        for( SObject SSObj : listCases )
                        {
                             Case cc = (Case)SSObj;
                             if( cc.Branch__c != null && cc.Branch__r.Name != null )
                             {
                                 Id IdQueue = MapNameQueueId.get( cc.Branch__r.Name );
                                 if( IdQueue != null)cc.OwnerId = IdQueue;
                                 ListCaseToAssign.add( cc );
                             }    
                        }
                }
                
                
            }
        
            system.debug('15_05_2019 ListCaseToAssign->'+ListCaseToAssign);
            if( ListCaseToAssign != null && ListCaseToAssign.size() > 0 )
            {
                update ListCaseToAssign;
            }
    }
    
    
}