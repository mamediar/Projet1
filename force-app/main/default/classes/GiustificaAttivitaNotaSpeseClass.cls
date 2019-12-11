public with sharing class GiustificaAttivitaNotaSpeseClass {
	
	@AuraEnabled
	public static InitWrapper initApex(){
		User manager = getCurrentUser();
		List<SFA_NotaSpese__c> notaSpeseList = getNotaSpeseList(manager);
		Map<Id,Integer> giorniNotaSpese = getGiorniNotaSpeseMap(notaSpeseList);
        InitWrapper iW = new InitWrapper(notaSpeseList,giorniNotaSpese);	
		return iW; 
	}

	@AuraEnabled
	public static branchWrapper initApexWithUserDetails(){
		User manager = getCurrentUser();
		List<Account> branches=getBranches(manager);
		Map<String, List<SFA_NotaSpese__c>> notaSpesePerBranchMap =  getNotaSpeseListWithUserDetails(branches);
		branchWrapper branchWr= new branchWrapper(branches, notaSpesePerBranchMap);
		return branchWr; 
	} 

	@AuraEnabled
	public static void deleteNotaSpese(SFA_NotaSpese__c notaSpese,List<SFA_PianificaAttivita__c> pianificaAttivitaList){
		
		if(pianificaAttivitaList != null && !pianificaAttivitaList.isEmpty()){
			delete pianificaAttivitaList;
		}
		delete notaSpese;

	}

	private static User getCurrentUser(){
        String utenteId = UserInfo.getUserId();
        return [SELECT FirstName, LastName,Id,Name, Alias,DefaultQueueId__c FROM User WHERE Id =: utenteId];
    }

	private static List<SFA_NotaSpese__c> getNotaSpeseList(User manager){
        return [SELECT Id,Date__c,Time__c,Branch__c,Branch__r.ShippingStreet,Branch__r.ShippingCity, 
                       Branch__r.ShippingPostalCode,Status__c,User__c,Tratta__c,OraInizioUscita__c,OraFineUscita__c,
                      (SELECT Id,Dealer__c,SFA_Slot__c,SFA_Slot__r.XCS_Zone__c FROM Pianifica_Attivita__r) 
                         FROM SFA_NotaSpese__c 
                        WHERE Status__c = 'Aperta' 
                          AND Branch__r.OCS_External_Id__c =: manager.DefaultQueueId__c 
                          AND User__c =: manager.Id 
                     ORDER BY Date__c ASC,Time__c ASC];
    }

	private static Map<Id,Integer> getGiorniNotaSpeseMap(List<SFA_NotaSpese__c> notaSpeseList){

		Map<Id,Integer> giorniNotaSpeseMap = new Map<Id,Integer>();
		
		for (SFA_NotaSpese__c notaSpese: notaSpeseList){
			
			Integer giorniCreazione = notaSpese.Date__c.daysBetween(Date.today());
			giorniNotaSpeseMap.put(notaSpese.Id, giorniCreazione);	
		} 

		return giorniNotaSpeseMap;
	}


	private static Map<String, List<SFA_NotaSpese__c>> getNotaSpeseListWithUserDetails(List<Account> branches){
		Map<String, List<SFA_NotaSpese__c>> notaSpeseBranchMap= new Map<String, List<SFA_NotaSpese__c>>();
		List<SFA_NotaSpese__c> notaSpeseList= [SELECT Id,Date__c,Time__c,Branch__c,Branch__r.OCS_External_Id__c,Branch__r.ShippingStreet,Branch__r.ShippingCity,Branch__r.ShippingPostalCode,Status__c,User__c,Tratta__c, User__r.Alias, User__r.Name, (SELECT Id,Dealer__c FROM Pianifica_Attivita__r) 
												FROM SFA_NotaSpese__c 
												WHERE Status__c = 'Aperta' AND Branch__c =: branches ORDER BY CreatedDate ASC];
		for (SFA_NotaSpese__c notaSpese: notaSpeseList){
			if(notaSpeseBranchMap.containsKey(notaSpese.Branch__r.OCS_External_Id__c)){
				notaSpeseBranchMap.get(notaSpese.Branch__r.OCS_External_Id__c).add(notaSpese);
			}
			else{
				notaSpeseBranchMap.put(notaSpese.Branch__r.OCS_External_Id__c, new List<SFA_NotaSpese__c>{notaSpese});
			}
		}
		return notaSpeseBranchMap;
    }

	private static List<Account> getBranches(User manager){
    	return [SELECT FirstName,toLabel(Type) TypeLabel,Type, LastName, Name, OCS_External_Id__c FROM Account WHERE (OCS_External_Id__c =: manager.DefaultQueueId__c OR Parent.OCS_External_Id__c =: manager.DefaultQueueId__c  OR Parent.Parent.OCS_External_Id__c =: manager.DefaultQueueId__c) AND Type IN ('FIL', 'SUC') AND RecordType.Name = 'Branch']; 
	}

	public class InitWrapper {
	  
        @AuraEnabled
        public List<SFA_NotaSpese__c> notaSpeseList;
        @AuraEnabled
		public Map<Id,Integer> giorniNotaSpese;

        public InitWrapper(List<SFA_NotaSpese__c> notaSpeseList,Map<Id,Integer> giorniNotaSpese){
            this.notaSpeseList = notaSpeseList;
			this.giorniNotaSpese = giorniNotaSpese;
		}
	}

	public class branchWrapper{
		@AuraEnabled
		public List<Account> branches;
		@AuraEnabled
		public Map<String, List<SFA_NotaSpese__c>> branchMap;
			
		public branchWrapper(List<Account> branches, Map<String, List<SFA_NotaSpese__c>> branchMap){
			this.branches=branches;
			this.branchMap=branchMap;
		}
	}

}