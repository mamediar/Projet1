public class SFACambioFilialeClass {
	
	@AuraEnabled
	public static InitWrapper initApex(){
        InitWrapper iW = new InitWrapper();	
        setManager(iW);
		if (iW.manager.Area__c != null ){
            setBranchListPerAreaMap(iW);
        }else{ 
            setAllBranchListPerAreaMap(iW);
        }
        
		return iW; 
	} 

	private static void setManager(InitWrapper initWrapper){
        String utenteId = UserInfo.getUserId();
        User manager= [SELECT Id,Name,DefaultQueueId__c,Area__c FROM User WHERE Id =: utenteId];
        initWrapper.manager = manager;
	}

    private static void setBranchListPerAreaMap(InitWrapper initWrapper){
        
        List<Account> branchList = [SELECT Id,Name,toLabel(Type) TypeLabel,OCS_External_Id__c,OCSAreaId__c FROM Account WHERE OCSAreaIdText__c =: initWrapper.manager.Area__c AND Type = 'FIL' AND RecordType.DeveloperName = 'Branch'];        
        //List<Account> branchList = [SELECT Id,Name,toLabel(Type) TypeLabel,OCS_External_Id__c,OCSAreaId__c FROM Account WHERE OCSAreaId__c =: Integer.valueOf(initWrapper.manager.Area__c) AND Type = 'FIL' AND RecordType.DeveloperName = 'Branch'];     
        initWrapper.branchListPerArea = new Map<String,List<Account>>{initWrapper.manager.Area__c => branchList};
        initWrapper.filialeSelezionata = initWrapper.manager.DefaultQueueId__c;
        initWrapper.areaSelezionata = initWrapper.manager.Area__c;
    
    }

    private static void setAllBranchListPerAreaMap(InitWrapper initWrapper){
        List<Account> allBranchList = [SELECT Id,Name,toLabel(Type) TypeLabel,OCS_External_Id__c,OCSAreaId__c FROM Account WHERE OCSAreaId__c != null AND Type = 'FIL' AND RecordType.DeveloperName = 'Branch'];
        Map<String,List<Account>> branchListPerArea = new Map<String,List<Account>>();
        String area;
        for (Account branch : allBranchList){
            if(branch.OCS_External_Id__c == initWrapper.manager.DefaultQueueId__c){
                area = String.valueOf(branch.OCSAreaId__c);
            }
            if(branchListPerArea.containsKey(String.valueOf(branch.OCSAreaId__c))){
                branchListPerArea.get(String.valueOf(branch.OCSAreaId__c)).add(branch);
            }else{
                branchListPerArea.put(String.valueOf(branch.OCSAreaId__c),new List<Account>{branch});
            }
        }
        initWrapper.branchListPerArea = branchListPerArea;
        initWrapper.filialeSelezionata = initWrapper.manager.DefaultQueueId__c;
        initWrapper.areaSelezionata = area;
    }

	@AuraEnabled
	public static void updateUser(User manager){
		update manager;     
    }

    public class InitWrapper {
        
		@AuraEnabled
        public User manager;
        @AuraEnabled
        public String areaSelezionata;
        @AuraEnabled
        public String filialeSelezionata;
        @AuraEnabled
        public Map<String,List<Account>> branchListPerArea;

	}

}