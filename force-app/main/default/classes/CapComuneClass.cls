public class CapComuneClass {

	@AuraEnabled
	public static InitWrapper initApex(){
		User manager = getManager();
		List<Account> branches= getBranches(manager);
		Map<String, List<Zone__c> > zoneList = getZoneList(branches);
		Map<String, List<CAP_2_Branch__c>> capComuniMap = getCapComune(branches);
		InitWrapper iW = new InitWrapper(capComuniMap,zoneList, branches);	
		return iW;
	}

	private static User getManager(){
		String utenteId = UserInfo.getUserId();
        User manager= [SELECT Id,DefaultQueueId__c FROM User WHERE Id =: utenteId];
        /*
		if(String.isBlank(manager.DefaultQueueId__c)){
			AuraHandledException e = new AuraHandledException('utente non correttamente configurato');
			e.setMessage('utente non correttamente configurato');
			throw e;
		}*/
		return manager;
	}

	private static List<Account> getBranches(User manager){
        List<Account> allBranchList = SetupVisibilityFiliali.getFiliali();
        return allBranchList;
        /*
    	return [SELECT FirstName,toLabel(Type) TypeLabel,Type, LastName, Name, OCS_External_Id__c 
                FROM Account 
                WHERE (OCS_External_Id__c =: manager.DefaultQueueId__c 
                       OR Parent.OCS_External_Id__c =: manager.DefaultQueueId__c  
                       OR Parent.Parent.OCS_External_Id__c =: manager.DefaultQueueId__c) 
                AND Type IN ('FIL', 'SUC') AND RecordType.Name = 'Branch']; */
	}
	
	@AuraEnabled
	public static Map<String, List<CAP_2_Branch__c>> getCapComune(List<Account> branches){
		Map<String, List<CAP_2_Branch__c>> capComuniMap= new Map<String, List<CAP_2_Branch__c>>();
		List<CAP_2_Branch__c> capComuniList= [SELECT Id ,Branch__c, Branch__r.OCS_External_Id__c, CAP__c, CAP_Generico__c,Zone__c , Zone__r.Name , Zone__r.OCS_External_Id__c,Regione__c, Provincia__c, OCS_External_Id__c ,Comune__c 
                FROM CAP_2_Branch__c WHERE Branch__c =: branches];
		for (CAP_2_Branch__c capComune: capComuniList){
			if(capComuniMap.containsKey(capComune.Branch__r.OCS_External_Id__c)){
				capComuniMap.get(capComune.Branch__r.OCS_External_Id__c).add(capComune);
			}
			else{
				capComuniMap.put(capComune.Branch__r.OCS_External_Id__c, new List<CAP_2_Branch__c>{capComune});
			}
		}
		return capComuniMap;
	}
	
	@AuraEnabled
	public static Map<String, List<Zone__c>> getZoneList(List<Account> branches){
		System.debug(branches);
		List<Zone__c> zoneList= [SELECT Id, Name, Branch__c, Branch__r.OCS_External_Id__c FROM Zone__c WHERE Branch__c=:branches ];
		Map<String, List<Zone__c> > zonePerFiliale= new Map<String, List<Zone__c> >();
		for(Zone__c zona:zoneList){
			if(zonePerFiliale.containsKey(zona.Branch__r.OCS_External_Id__c)){
				zonePerFiliale.get(zona.Branch__r.OCS_External_Id__c).add(zona);
			}
			else{
				zonePerFiliale.put(zona.Branch__r.OCS_External_Id__c, new List<Zone__c>{zona});
			}
		}
		return zonePerFiliale;
	}
    
    @AuraEnabled
	public static void updateCapComune(List<CAP_2_Branch__c> capComuniList){
        if(null != capComuniList && !capComuniList.isEmpty() ){
            update capComuniList;
        }
	}

	public class InitWrapper {
	
	@AuraEnabled
    public Map<String, List<CAP_2_Branch__c>> capComuniMap;
    @AuraEnabled
    public Map<String, List<Zone__c>> zoneList;
	@AuraEnabled
	public List<Account> branches;

    public InitWrapper(Map<String, List<CAP_2_Branch__c>> capComuniMap,Map<String, List<Zone__c>> zoneList,List<Account> branches){
        this.capComuniMap = capComuniMap;
        this.zoneList = zoneList;
		this.branches = branches;
    }

}

}