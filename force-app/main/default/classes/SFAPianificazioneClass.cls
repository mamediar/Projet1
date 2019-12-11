public with sharing class SFAPianificazioneClass {

    @AuraEnabled
    public static InitWrapper initApex(Date theDate){
        
        theDate = theDate == null ? Date.today() : theDate;
        List<SFA_Slot__c> slotlist = getSlotList(theDate);
        List<WrapperRow> WrapperRowList = setDealersSlotMap(slotlist);
        InitWrapper theWrp = new InitWrapper(WrapperRowList,theDate);

        return theWrp;   
    }

    private static List<SFA_Slot__c> getSlotList(Date theDate){ 
        Id utenteId = UserInfo.getUserId();
        User user = [SELECT DefaultQueueId__c FROM User WHERE Id =: utenteId];
        return [SELECT Id,Date__c,Name,Time__c,toLabel(Type__c) Type, XCS_Zone__c, XCS_Zone__r.Name , User__c FROM SFA_Slot__c WHERE Date__c =: theDate AND User__c =: utenteId AND Branch__r.OCS_External_Id__c =: user.DefaultQueueId__c];   
    }

    private static List<WrapperRow> setDealersSlotMap(List<SFA_Slot__c> theSlotList){
        List<Id> zoneListId = new List<Id>();
        for(SFA_Slot__c slot : theSlotList){
            zoneListId.add(slot.XCS_Zone__c);
        }
        List<Account> allDealer =  [SELECT Id,Zone__c,
                                    (SELECT Id , SFA_Slot__c , SFA_Slot__r.Date__c , SFA_Slot__r.Time__c 
                                    FROM Attivita_Pianificate__r
                                    WHERE SFA_Slot__c =: theSlotList
                                    ORDER BY CreatedDate DESC)
                                FROM Account 
                                WHERE Id IN (SELECT AccountId FROM Case WHERE Status != 'Closed' AND Account.Zone__c =: zoneListId AND Account.RecordType.DeveloperName = 'Dealer')];
        
        Map<Id,List<Account>> allDealerMap = new Map<Id,List<Account>>();    
        for(Account dealer : allDealer){
            if (allDealerMap.containsKey(dealer.Zone__c)){
                allDealerMap.get(dealer.Zone__c).add(dealer);
            }else{
                allDealerMap.put(dealer.Zone__c,new List<Account> {dealer});
            }
        } 
        Map<Id,Integer> dealerNonPianificatiMap = new Map<Id,Integer>();    
        Map<Id,Integer> dealerPianificatiMap = new Map<Id,Integer>();

        List<WrapperRow> WrapperRowList = new List<WrapperRow>();
        for(SFA_Slot__c slot : theSlotList){
            Integer pianificatiCount = 0;
            Integer nonPianificatiCount = 0;
            if(allDealerMap.containsKey(slot.XCS_Zone__c)){
                 List<Account> allDealerSlot = allDealerMap.get(slot.XCS_Zone__c);
                for (Account dealer : allDealerSlot){
                    if(dealer.Attivita_Pianificate__r.isEmpty()){
                        nonPianificatiCount++;
                    }else{
                        pianificatiCount++;
                    }
                }
            }
            WrapperRowList.add(new WrapperRow(slot,nonPianificatiCount,pianificatiCount));

        }
        return WrapperRowList;
    }

    public class InitWrapper{

		@AuraEnabled
		public List<WrapperRow> WrapperRowList;
		@AuraEnabled
		public Date targetDate;
        
        public InitWrapper( List<WrapperRow> WrapperRowList, Date targetDate){
			this.WrapperRowList= WrapperRowList;
			this.targetDate= targetDate;

		}

	}

    public class WrapperRow{

		@AuraEnabled
		public SFA_Slot__c slot;
        @AuraEnabled
        public Integer dealerNonPianificati;
        @AuraEnabled    
        public Integer dealerPianificati;
        
        public WrapperRow(SFA_Slot__c slot,Integer dealerNonPianificati,Integer dealerPianificati){
			this.slot = slot;
            this.dealerNonPianificati = dealerNonPianificati;
            this.dealerPianificati = dealerPianificati;
		}

	}


}