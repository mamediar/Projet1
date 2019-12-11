public with sharing class XCS_GestioneDeskClass {
	
	@AuraEnabled
	public static InitWrapper initApex(){
        InitWrapper iW = new InitWrapper();	
        
		setManager(iW);
		setAllBranchListPerAreaMap(iW);
        
		return iW; 
	}
	
	@AuraEnabled
	public static XCS_Desk__c addDesk(Account filialeSelected,String deskName){

		XCS_Desk__c deskToAdd = new XCS_Desk__c(
			Branch__c = filialeSelected.Id,
			isActive__c = true,
			DeskName__c = deskName
		);

		insert deskToAdd;
		return deskToAdd;

	}

	@AuraEnabled
	public static XCS_DeskItem__c addDeskItem(XCS_Desk__c deskSelected){

		XCS_DeskItem__c deskItemToAdd = new XCS_DeskItem__c(
			Desk__c = deskSelected.Id,
			Monday__c = true,
			Tuesday__c = true,
			Wednesday__c = true,
			Thursday__c = true,
			Friday__c = true,
			Saturday__c = true,
			Sunday__c = false,
			StartTime__c = Time.newInstance(09, 0, 0, 0),
			EndTime__c = Time.newInstance(18, 0, 0, 0)
		);

		insert deskItemToAdd;
		return deskItemToAdd;

	}

	@AuraEnabled
	public static Map<String,List<XCS_DeskItem__c>> initDeskItemPerDesk(Account filialeSelected){

		List<XCS_DeskItem__c> deskItemList = [SELECT Desk__c,StartTime__c,EndTime__c,Monday__c,Tuesday__c,Wednesday__c,Thursday__c,Friday__c,Saturday__c,Sunday__c FROM XCS_DeskItem__c WHERE Desk__r.Branch__c =: filialeSelected.Id];
		Map<String,List<XCS_DeskItem__c>> deskItemPerDesk = new Map<String,List<XCS_DeskItem__c>>();
		
        for (XCS_DeskItem__c deskItem : deskItemList){

			if(deskItemPerDesk.containsKey(deskItem.Desk__c)){
                deskItemPerDesk.get(deskItem.Desk__c).add(deskItem);
            }else{
                deskItemPerDesk.put(deskItem.Desk__c,new List<XCS_DeskItem__c>{deskItem});
            }
        }

		return deskItemPerDesk;
	}

	@AuraEnabled
	public static void updateDeskApex(List<XCS_Desk__c> deskList){

		if(deskList != null && !deskList.isEmpty())
			update deskList;

	}

	@AuraEnabled
	public static void updateDeskItemApex(List<XCS_DeskItem__c> deskItemList){

		if(deskItemList != null && !deskItemList.isEmpty())
			update deskItemList;

	}

	@AuraEnabled
	public static void deleteDeskItemApex(XCS_DeskItem__c deskItemRow){
		
		if(deskItemRow != null){
			delete deskItemRow;
		}
	}

	private static void setManager(InitWrapper initWrapper){
        String utenteId = UserInfo.getUserId();
        User manager= [SELECT Id,Name,DefaultQueueId__c,Area__c FROM User WHERE Id =: utenteId];
        initWrapper.manager = manager;
	}

	private static void setAllBranchListPerAreaMap(InitWrapper initWrapper){

        List<Account> allBranchList = [SELECT Id,Name,toLabel(Type) TypeLabel,OCS_External_Id__c,OCSAreaId__c,Region_Name__c, (SELECT DeskName__c,isActive__c,Product__c, Branch__c FROM XCS_Desk__r ORDER BY DeskName__c) FROM Account WHERE OCS_External_Id__c != null AND OCSAreaId__c != null AND Region_Name__c != null AND Type = 'FIL' AND RecordType.DeveloperName = 'Branch'];
        Map<String,List<String>> areaListPerRegion = new Map<String,List<String>>();
		Map<String,List<Account>> branchListPerArea = new Map<String,List<Account>>();

        for (Account branch : allBranchList){

			if(areaListPerRegion.containsKey(branch.Region_Name__c)){
				if(!areaListPerRegion.get(branch.Region_Name__c).contains(String.valueOf(branch.OCSAreaId__c)))
					areaListPerRegion.get(branch.Region_Name__c).add(String.valueOf(branch.OCSAreaId__c));
            }else{
                areaListPerRegion.put(branch.Region_Name__c,new List<String>{String.valueOf(branch.OCSAreaId__c)});
            }

            if(branchListPerArea.containsKey(String.valueOf(branch.OCSAreaId__c))){
                branchListPerArea.get(String.valueOf(branch.OCSAreaId__c)).add(branch);
            }else{
                branchListPerArea.put(String.valueOf(branch.OCSAreaId__c),new List<Account>{branch});
            }
        }
		initWrapper.areaListPerRegion = areaListPerRegion;
        initWrapper.branchListPerArea = branchListPerArea;
    }

	public class InitWrapper {
        
		@AuraEnabled
        public User manager;
		@AuraEnabled
        public Map<String,List<String>> areaListPerRegion;
        @AuraEnabled
        public Map<String,List<Account>> branchListPerArea;

	}


}