public class GestioneEmailController {
    @AuraEnabled    
    public static List<CRM_QueueMailFaxConfig__c> doInit(){ 
        List<String> devNameList = new List<String>();
        List<String> devNameListRecall = new List<String>();
        Map<String,String> groupMap = new Map<String,String>();
        Map<String,String> groupMapRecall = new Map<String,String>();
        
        List<CRM_QueueMailFaxConfig__c> queueMailFaxConfigList = [SELECT MailBox__c, DeveloperName__c, Balancing__c,
                                                                  BalancingPercent__c, type__c, Email_per_risposta__c, Recall_Queue__c  
                                                                  FROM CRM_QueueMailFaxConfig__c];        
        for(CRM_QueueMailFaxConfig__c q : queueMailFaxConfigList){
            devNameList.add(q.DeveloperName__c); 
         	devNameListRecall.add(q.Recall_Queue__c);   
        }
        
        List<Group> groupList = [SELECT Name, DeveloperName FROM Group WHERE DeveloperName IN: devNameList AND type = 'queue']; 
        List<Group> groupListRecall = [SELECT Name, DeveloperName FROM Group WHERE DeveloperName IN: devNameListRecall AND type = 'queue'];
        
        for(group g : groupList)
            groupMap.put(g.DeveloperName, g.name);
        for(group g : groupListRecall)
            groupMapRecall.put(g.DeveloperName, g.name);
        
        for(CRM_QueueMailFaxConfig__c q : queueMailFaxConfigList){
            if(groupMap.keySet().contains(q.DeveloperName__c))
                q.DeveloperName__c = groupMap.get(q.DeveloperName__c);
            if(groupMapRecall.keySet().contains(q.Recall_queue__c))
                q.Recall_queue__c = groupMapRecall.get(q.Recall_Queue__c);
        }
        
        
        
        return queueMailFaxConfigList;
    }
    
    @AuraEnabled        
    public static Map<String, Decimal> checkRecords(List<CRM_QueueMailFaxConfig__c> data){
        Map<String, Decimal> res = new Map<String, Decimal>();
        Set<Id> dataIds = new set<Id>();
        Set<String> queueMailFaxObjs_MailSet = new Set<String>();
        List<CRM_QueueMailFaxConfig__c> newQueueMailFax = new List<CRM_QueueMailFaxConfig__c>();
        
        for(CRM_QueueMailFaxConfig__c q : data) dataIds.add(q.Id);		                    
        List<CRM_QueueMailFaxConfig__c> queueMailFaxObjs = [SELECT Id, MailBox__c, DeveloperName__c, Balancing__c, BalancingPercent__c, type__c 
                                                            FROM CRM_QueueMailFaxConfig__c
                                                            WHERE Id IN : dataIds]; 
        for(CRM_QueueMailFaxConfig__c q : queueMailFaxObjs) queueMailFaxObjs_MailSet.add(q.MailBox__c);
        
        List<CRM_QueueMailFaxConfig__c> currentQueueMailFax = [SELECT Id, MailBox__c, DeveloperName__c, Balancing__c, BalancingPercent__c, type__c 
                                                               FROM CRM_QueueMailFaxConfig__c
                                                               WHERE MailBox__c IN : queueMailFaxObjs_MailSet];        
        for(Integer i = 0; i < data.size(); i++)
            for(Integer j = 0; j < currentQueueMailFax.size(); j++)
            if(data[i].Id.equals(currentQueueMailFax[j].Id)){
                currentQueueMailFax[j].Balancing__c = data[i].Balancing__c;
                break;
            }                     	 
        
        for(CRM_QueueMailFaxConfig__c c : currentQueueMailFax)
            res.put(c.MailBox__c, (res.get(c.MailBox__c) == null ? c.Balancing__c : res.get(c.MailBox__c) + c.Balancing__c ));
        
        
        List<CRM_QueueMailFaxConfig__c> objectToUpdate = new List<CRM_QueueMailFaxConfig__c>();
        Set<String> emailToUpdate = new Set<String>();
        
        for(String email : res.keySet())
            if(res.get(email) == 100 || res.get(email) == 0){
                res.remove(email);
                emailToUpdate.add(email);  
            }
        
        for(CRM_QueueMailFaxConfig__c q : currentQueueMailFax){
            if(emailToUpdate.contains(q.MailBox__c) && dataIds.contains(q.id))
                objectToUpdate.add(q);
        }
        
        update(objectToUpdate);
        return res;
    }   
}