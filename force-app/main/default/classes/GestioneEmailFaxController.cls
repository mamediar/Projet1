public class GestioneEmailFaxController {
    
    public class Data{        
        @InvocableVariable
        public String caseId;
    }
    
    @InvocableMethod
    public static void doAction(List<Data> data){ 
        System.debug('GestioneMailController d.caseId = ' + data[0].caseId);
        for(Data d : data){
            Integer maxValue = -99999999;
            String queueMaxValue = '';
            Map<String, Integer> aviableStorages = new Map<String, Integer>();
            Set<String> queueDeveloperNameList = new Set<String>();  
            Set<String> queueIdsList = new Set<String>();  
            
            EmailMessage emailMessage = [select toAddress from EmailMessage where ParentId =: d.caseId];
            List<CRM_QueueMailFaxConfig__c> queueMailFaxConfigList = [select MailBox__c, DeveloperName__c, Balancing__c 
                                                                      from CRM_QueueMailFaxConfig__c 
                                                                      where MailBox__c =: emailMessage.toAddress];           
            for(CRM_QueueMailFaxConfig__c q : queueMailFaxConfigList) queueDeveloperNameList.add(q.DeveloperName__c);
            List<Group> queueList = [SELECT Id, DeveloperName FROM Group WHERE DeveloperName IN : queueDeveloperNameList];
            for(Group g : queueList) queueIdsList.add(g.Id);        
            String queryForActalBalance = 'SELECT COUNT() FROM Case WHERE Status = \'New\' AND OwnerId IN : queueList';
            Integer totalInbox = Database.countQuery(queryForActalBalance);
            totalInbox = totalInbox == 0 ? 1 : totalInbox;
            
            for(Group g : queueList){            
                String tempQuery = 'SELECT COUNT() FROM Case WHERE Status = \'New\' AND OwnerId = \'' + String.escapeSingleQuotes(g.Id) + '\'';
                Integer actualInbox = Database.countQuery(tempQuery);
                for(CRM_QueueMailFaxConfig__c q : queueMailFaxConfigList){
                    if(q.DeveloperName__c.equalsIgnoreCase(g.DeveloperName)){
                        aviableStorages.put(g.DeveloperName, (Integer)(q.Balancing__c - (((double)(actualInbox) / (double)(totalInbox)) * 100)));
                        System.debug((Integer)(q.Balancing__c - (((double)(actualInbox) / (double)(totalInbox)) * 100)));
                        break;
                    }
                }
            } 
            
            for(String k : aviableStorages.keySet()){
                if(aviableStorages.get(k) > maxValue){
                    maxValue = aviableStorages.get(k);
                    queueMaxValue = k;
                }               
            }      
            System.debug(aviableStorages);
            CaseUtils.assignToQueue(d.caseId, queueMaxValue);
        }  
    }
    
}