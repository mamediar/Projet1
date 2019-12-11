public class SFAHomeActivityRecapController {
    @AuraEnabled
    public static returnWrapper doInitApex(String configurationName) {
        
        String title = getTitle(configurationName);
        String FieldCount = getFieldCount(configurationName);
        
        list<activityConfig> activityConfigList = getActivityConfig(configurationName);
        List<activityReturn> activityReturnList = new List<activityReturn>();
        
        Map<String,Integer> activityMap = String.isNotBlank(fieldCount) ? getActivityMap(activityConfigList,fieldCount) : New  Map<String,Integer>();
        Integer total = getTotal(activityMap);
        Map<String,String> listViewMap = getListViewMap(activityConfigList);
        
        for(activityConfig ac : activityConfigList){
            if(activityMap.containsKey(ac.subject) || ac.isStatic)
            	activityReturnList.add(new activityReturn(ac.label, listViewMap.get(ac.listViewDevName), activityMap.containsKey(ac.subject) ? activityMap.get(ac.subject) : 0));
        }
        
        return new returnWrapper(activityReturnList,title,total);
    }
    
    private static Map<String,Integer> getActivityMap(list<activityConfig> activityConfigList,String fieldCount) {
        List<String> subjectList = new List<String>();
        Map<String,Integer> countPerSubjectMap = new Map<String,Integer>();

        for(activityConfig ac : activityConfigList){
            subjectList.add(ac.subject);
        }
		
		
           
        List<String> statusList = new List<String>{'New'};

        //AggregateResult[] activityList = [SELECT Subject  ,  COUNT(Id) number  FROM Case WHERE Status =:statusList AND Subject != NULL  AND Subject =: subjectList GROUP BY Subject Limit 45000];
		
        String queryString = 'SELECT '+fieldCount+' Sub ,  COUNT(Id) number  FROM Case WHERE Status =:statusList AND  '+fieldCount+'  != NULL  AND  '+fieldCount+'  =: subjectList GROUP BY  '+fieldCount+'  Limit 45000';
        
        AggregateResult[] activityList = Database.query(String.escapeSingleQuotes(queryString));
            
        for(AggregateResult ar : activityList){
            countPerSubjectMap.put((String)ar.get('Sub'), (Integer)ar.get('number') );
        }
        
        return countPerSubjectMap;
    }
    
    private static Map<String,String> getListViewMap(list<activityConfig> activityConfigList) {
        
        List<String> listViewDevNameList = new List<String>();
        for(activityConfig ac : activityConfigList){
            listViewDevNameList.add(ac.listViewDevName);
        }
        List<ListView> listViewList = [SELECT id, DeveloperName FROM ListView WHERE DeveloperName =: listViewDevNameList];
       
        Map<String,String> ListViewMap = new Map<String,String>();
        for(ListView lv : listViewList){
            ListViewMap.put(lv.DeveloperName,lv.Id);
        }
        
        return(ListViewMap);
    }
    
    private static String getTitle(String configurationName) {
        
       	if(String.isBlank(configurationName))
            return 'Nessuna Configuazione Selezionata';
        
        List<SFA_Activity_Recap_Config__mdt> sfaActivityConfList = [SELECT id, MasterLabel FROM SFA_Activity_Recap_Config__mdt WHERE DeveloperName =: configurationName];
        
        if(sfaActivityConfList.isEmpty())
        	return 'Nessuna configurazione Corrispndente a '+configurationName+' è stata trovata';
        
        return sfaActivityConfList.get(0).MasterLabel;
    }
    
    private static String getFieldCount(String configurationName) {
        
       	if(String.isBlank(configurationName))
            return '';
         
        List<SFA_Activity_Recap_Config__mdt> sfaActivityConfList = [SELECT id, FieldCount__c  FROM SFA_Activity_Recap_Config__mdt WHERE DeveloperName =: configurationName];
        
        if(sfaActivityConfList.isEmpty())
        	return '';
        
        return sfaActivityConfList.get(0).FieldCount__c;
    }
    
    private static Integer getTotal(Map<String,Integer> activityMap) {
        Integer total = 0;
        for(Integer partial : activityMap.values())
            total = total + partial;
        return total;
    }
    
    private static list<activityConfig> getActivityConfig(String configurationName) {
        
        List<SFA_Activity_Recap_Config__mdt> sfaActivityConfList = [SELECT id, MasterLabel, (SELECT MasterLabel, Subject__c, isStatic__c, Order__c, listViewDevName__c , SFA_Activity_Config__r.FieldCount__c From SFA_Activity_Config_Items__r ORDER BY Order__c ASC) FROM SFA_Activity_Recap_Config__mdt WHERE DeveloperName =: configurationName];
        
        list<activityConfig> activityConfigList = new list<activityConfig>();
        if(!sfaActivityConfList.isEmpty())
            for(SFA_Activity_Recap_Config_Item__mdt sfaActivityConfigItem : sfaActivityConfList.get(0).SFA_Activity_Config_Items__r){
                activityConfigList.add(new activityConfig(sfaActivityConfigItem));
            }
        return activityConfigList;
    }
    
    public class activityConfig {
        public activityConfig(SFA_Activity_Recap_Config_Item__mdt sfaActivityConfigItem){
            this.label= sfaActivityConfigItem.MasterLabel;
            this.subject= sfaActivityConfigItem.Subject__c;
            this.listViewDevName= sfaActivityConfigItem.listViewDevName__c;
            this.isStatic= sfaActivityConfigItem.isStatic__c;
        }
        String label;
        String subject;
        String listViewDevName;
        Boolean isStatic = false;
        
    }
    
    public class activityReturn {
        public activityReturn(String label, String listViewId, Integer count){
            this.label= label;
            this.listViewId= listViewId;
            this.count= count;
        }
        @AuraEnabled
        String label {get; set;}
        @AuraEnabled
        String listViewId {get; set;}
        @AuraEnabled
        Integer count {get; set;}
        
    }
    public class returnWrapper {
        public returnWrapper(List<activityReturn> activityReturnList, String title, Integer total){
            this.activityReturnList= activityReturnList;
            this.title= title;
            this.total= total;
        }
        @AuraEnabled
        public List<activityReturn> activityReturnList {get; set;}
        @AuraEnabled
        public String title {get; set;}
        @AuraEnabled
        public Integer total {get; set;}
        
    }
}