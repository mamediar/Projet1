public class GestioneZoneClass {

    @AuraEnabled
	public static InitWrapper initApex(){
        User manager = getManager();
		List<Account> branchList = getBranches(manager);
        Map<String, List<Zone__c>> ZonePerFiliale = getZonePerFiliale(branchList);
        InitWrapper iW = new InitWrapper(branchList,ZonePerFiliale);	
		return iW; 
	}
    
    @AuraEnabled
	public static User getManager(){
        String utenteId = UserInfo.getUserId();
        User manager= [SELECT Id,Name,DefaultQueueId__c FROM User WHERE Id =: utenteId];
        /*
        if(String.isBlank(manager.DefaultQueueId__c)){
            AuraHandledException e = new AuraHandledException('utente non correttamente configurato');
			e.setMessage('utente non correttamente configurato');
			throw e;
        }*/
        return manager;
        
	}
    
    @AuraEnabled
    public static List<Account> getBranches(User manager){
    	List<Account> allBranchList = SetupVisibilityFiliali.getFiliali();
        return allBranchList;    
        /*
        return [SELECT Id,Name,toLabel(Type) TypeLabel,OCS_External_Id__c 
                FROM Account 
                WHERE (OCS_External_Id__c =: manager.DefaultQueueId__c 
                       OR Parent.OCS_External_Id__c =: manager.DefaultQueueId__c  
                       OR Parent.Parent.OCS_External_Id__c =: manager.DefaultQueueId__c) 
                AND Type IN ('FIL', 'SUC') AND RecordType.Name = 'Branch'];   */ 
    }

    @AuraEnabled
	public static Map<String, List<Zone__c>> getZonePerFiliale(List<Account> branchList){ 
        List<String> externalCodeId = new List<String>();
        for(Account branch : branchList){
            if(String.isNotBlank(branch.OCS_External_Id__c)){
                externalCodeId.add(branch.OCS_External_Id__c);
            }
        }
        List<Zone__c> allZoneList = [SELECT Id,Name,Branch__c,Branch__r.OCS_External_Id__c FROM Zone__c WHERE Branch__r.OCS_External_Id__c =: externalCodeId];
		Map<String, List<Zone__c>> zonePerFiliale= new Map<String, List<Zone__c>>();

        for(Zone__c zone : allZoneList){
            if (zonePerFiliale.containsKey(zone.Branch__r.OCS_External_Id__c)){
                zonePerFiliale.get(zone.Branch__r.OCS_External_Id__c).add(zone);
            }
            else{
                zonePerFiliale.put(zone.Branch__r.OCS_External_Id__c, new List<Zone__c>{zone});
            }
        }
		return zonePerFiliale;
	}

    @AuraEnabled
    public static void upsertZone(List<Zone__c> theZoneList,List<Zone__c> deleteZoneList){
        if(theZoneList != null && !theZoneList.isEmpty()){
        	upsert theZoneList;
        }
        
        if(deleteZoneList != null && !deleteZoneList.isEmpty()){
            List<SFA_Slot__c> slotToDeleteList = [SELECT Id FROM SFA_Slot__c  WHERE XCS_Zone__c =: deleteZoneList];
        	delete deleteZoneList;
            delete slotToDeleteList;
        }
    }

    public class InitWrapper {
	  
        @AuraEnabled
        public List<Account> branchList;
        @AuraEnabled
        public Map<String, List<Zone__c>> ZonePerFiliale;
        
        public InitWrapper(List<Account> branchList,Map<String, List<Zone__c>> ZonePerFiliale){
            this.branchList = branchList;
            this.ZonePerFiliale = ZonePerFiliale;
        }

	}
    
}