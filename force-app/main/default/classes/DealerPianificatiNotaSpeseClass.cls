public with sharing class DealerPianificatiNotaSpeseClass {
	
	@AuraEnabled
    public static InitWrapper initApex(SFA_NotaSpese__c notaSpese,List<SFA_PianificaAttivita__c> pianificaAttivitaList){
        
		if(pianificaAttivitaList == null){
			pianificaAttivitaList = [SELECT Id,Dealer__c,SFA_Slot__c,SFA_Slot__r.XCS_Zone__c 
                                     FROM SFA_PianificaAttivita__c 
                                     WHERE SFA_Nota_Spese__c =: notaSpese.Id];
		}

        List<Account> dealers = getDealers(pianificaAttivitaList);
		User theUser = getCurrentUser(); 
        Map<Id,List<SFA_Slot__c>> otherSlotsMap = getOtherSlotsMap(theUser.Id,pianificaAttivitaList); 
		Map<String,SFA_PianificaAttivita__c> pianificaAttivitaPerDealer = getpianificaAttivitaPerDealerMap(pianificaAttivitaList);
        InitWrapper iw = new InitWrapper(dealers,otherSlotsMap,pianificaAttivitaPerDealer);
        return iw;
    }

	@AuraEnabled
	public static void deleteAttivitaDealerNonVisitati(List<SFA_PianificaAttivita__c> pianificaAttivitaToDeleteList){
		delete pianificaAttivitaToDeleteList;
	}	

	
    @AuraEnabled
    public static void addDealerApex(Account theDealer,SFA_NotaSpese__c theNotaSpese){
		SFA_PianificaAttivita__c recordPA = new SFA_PianificaAttivita__c(Dealer__c=theDealer.Id,SFA_Slot__c= null,SFA_Nota_Spese__c = theNotaSpese.Id);
		insert recordPA;
    }

	@AuraEnabled
    public static void ripianificaDealerApex(Map<String,SFA_PianificaAttivita__c> attivitaPerDealer,SFA_Slot__c newSlot,List<Account> dealerList){

		SFA_NotaSpese__c newNotaSpese = SFA_PianificaAttivitaController.getNotaSpese(newSlot); 
		List<SFA_PianificaAttivita__c> paList = new List<SFA_PianificaAttivita__c>();
		for(Account dealer : dealerList){
			SFA_PianificaAttivita__c tempPA = attivitaPerDealer.get(dealer.Id);
			tempPA.SFA_Slot__c = newSlot.Id;
			tempPA.SFA_Nota_Spese__c = newNotaSpese.Id;
			paList.add(tempPA);
		}
		update paList;

    }


	private static User getCurrentUser(){
        String utenteId = UserInfo.getUserId();
        return [SELECT FirstName, LastName,Id,Name, Alias,DefaultQueueId__c FROM User WHERE Id =: utenteId];
    }

	private static List<Account> getDealers(List<SFA_PianificaAttivita__c> pianificaAttivitaList){
		List<Id> accountIdList = new List<Id>(); 
		for(SFA_PianificaAttivita__c attivita : pianificaAttivitaList){
			accountIdList.add(attivita.Dealer__c);
		}
		
		return [SELECT Id, Name ,Zone__c,Zone__r.Name,OCS_External_Id__c, CodiceClienteFilled__c ,ShippingStreet,ShippingCity,(SELECT Id , Priority FROM Cases WHERE Status != 'Closed') , (SELECT Id , SFA_Slot__c , SFA_Slot__r.Date__c , SFA_Slot__r.Time__c FROM Attivita_Pianificate__r ORDER BY CreatedDate DESC) 
				FROM Account 
				WHERE Id =: accountIdList AND RecordType.DeveloperName = 'Dealer'];
	}

	private static Map<String,SFA_PianificaAttivita__c> getpianificaAttivitaPerDealerMap(List<SFA_PianificaAttivita__c> pianificaAttivitaList){
		Map<String,SFA_PianificaAttivita__c> attivitaPerDealerMap = new Map<String,SFA_PianificaAttivita__c>();
		for(SFA_PianificaAttivita__c attivita : pianificaAttivitaList){
			attivitaPerDealerMap.put(attivita.Dealer__c,attivita);
		}

		return attivitaPerDealerMap;
	}

	private static Map<Id,List<SFA_Slot__c>> getOtherSlotsMap(Id userId,List<SFA_PianificaAttivita__c> pianificaAttivitaList){

		Set<SFA_Slot__c> slotSet = new Set<SFA_Slot__c>();
		for(SFA_PianificaAttivita__c pa : pianificaAttivitaList){
			slotSet.add(pa.SFA_Slot__r);			
		}

		List<SFA_Slot__c> slotList = new List<SFA_Slot__c>(slotSet);
		List<Id> zoneIdList = new List<Id>();

		for(SFA_Slot__c slot : slotList){
			if(slot != null && slot.XCS_Zone__c != null)
				zoneIdList.add(slot.XCS_Zone__c);			
		}
		  
        List<SFA_Slot__c> otherSlotList = [SELECT Id,Date__c,Time__c,Branch__c,Status__c,User__c,XCS_Zone__c,(SELECT Id , Dealer__c FROM Attivita_Pianificate__r ORDER BY CreatedDate DESC)   
		FROM SFA_Slot__c 
		WHERE XCS_Zone__c =: zoneIdList AND User__c =: userId AND Date__c >= TODAY AND Id !=: slotList ORDER BY Date__c ASC];

		Map<Id,List<SFA_Slot__c>> otherSlotMap = new Map<Id,List<SFA_Slot__c>>();
		
		for(SFA_Slot__c slot : otherSlotList){
            if (otherSlotMap.containsKey(slot.XCS_Zone__c)){
                otherSlotMap.get(slot.XCS_Zone__c).add(slot);
            }
            else{
                otherSlotMap.put(slot.XCS_Zone__c, new List<SFA_Slot__c>{slot});
            }
        } 

		return otherSlotMap; 

	}

    
	public class InitWrapper{
		@AuraEnabled
		public List<Account> dealers;
        @AuraEnabled
		public Map<Id,List<SFA_Slot__c>> otherSlotsMap; 
		@AuraEnabled
		public Map<String,SFA_PianificaAttivita__c> pianificaAttivitaPerDealer;

		public InitWrapper(List<Account> dealers, Map<Id,List<SFA_Slot__c>> otherSlotsMap,Map<String,SFA_PianificaAttivita__c> pianificaAttivitaPerDealer){
			this.dealers= dealers;
            this.otherSlotsMap= otherSlotsMap;
			this.pianificaAttivitaPerDealer = pianificaAttivitaPerDealer;
		}

	}

}