public class SFA_CalendarioRisorseController {
	@AuraEnabled
	public static InitWrapper initApex(){
		List<List<pianificaSlotController.DataWrapper>> currentMonthWeekList= initMonthDays(null);
		User manager= pianificaSlotController.getCurrentUser();
		List<Account> branches= pianificaSlotController.getBranches(manager);
		Map<String, List<User>> filialistiPerFiliale= getFilialistiPerFiliale(manager, branches);
        List<pianificaSlotController.DataWrapper> allDaysOfMonth = getMonthDaysList(currentMonthWeekList);
		List<SFA_Slot__c> slotList= pianificaSlotController.getSlots(allDaysOfMonth,manager,filialistiPerFiliale);
		List<SFA_Assenza_Prolungata__c> assenzeProlungateList= pianificaSlotController.getAssenzeProlungate(allDaysOfMonth,manager,filialistiPerFiliale);
		Map<String, List<Zone__c> > zonePerFiliale= pianificaSlotController.getZonePerFiliale(branches);
		List<Map<String,String>> TypeSelectOptions = pianificaSlotController.getTypeSelectOptions();
		
		
		return new InitWrapper(manager, 
                                filialistiPerFiliale, 
                                slotList, 
                                assenzeProlungateList,
                                currentMonthWeekList,
                                branches,
                                zonePerFiliale,
                                TypeSelectOptions,
                                null);
	}

	private static List<pianificaSlotController.DataWrapper> getMonthDaysList(List<List<pianificaSlotController.DataWrapper>> currentMonthWeekList){
		List<pianificaSlotController.DataWrapper> allDaysOfMonth = new List<pianificaSlotController.DataWrapper>();
        for(List<pianificaSlotController.DataWrapper> weekDaysList: currentMonthWeekList){
            allDaysOfMonth.addAll(weekDaysList);
        }
		return allDaysOfMonth;
	}

	@AuraEnabled
	public static Map<String, List<User>> getFilialistiPerFiliale(User manager, List<Account> branches){
		Map<String, List<User>> filialistiPerFiliale= pianificaSlotController.getFilialistiPerFiliale(manager, branches);
		System.debug(filialistiPerFiliale);
		List<String> branchExternalId = manager.DefaultQueueId__c.split(';');
		if(filialistiPerFiliale.containsKey(branchExternalId[0])){
			filialistiPerFiliale.get(branchExternalId[0]).add(manager);
		}
		else{
			filialistiPerFiliale.put(branchExternalId[0], new List<User>{manager});
		}
		return filialistiPerFiliale;
	}

	@AuraEnabled
	public static InitWrapper changeTargetDate(Date targetDate,User manager,Map<String, List<User>> filialistiPerFiliale){
		System.debug(targetDate);


		List<List<pianificaSlotController.DataWrapper>> currentMonthWeekList= initMonthDays(targetDate);
		List<pianificaSlotController.DataWrapper> allDaysOfMonth = getMonthDaysList(currentMonthWeekList);
		List<SFA_Slot__c> slotList= pianificaSlotController.getSlots(allDaysOfMonth,manager,filialistiPerFiliale);
		List<SFA_Assenza_Prolungata__c> assenzeProlungateList= pianificaSlotController.getAssenzeProlungate(allDaysOfMonth,manager,filialistiPerFiliale);
		
		return new InitWrapper(null, 
								null, 
								slotList, 
								assenzeProlungateList,
								currentMonthWeekList,
								null,
								null,
								null,
								targetDate);
	}

    public static List<List<pianificaSlotController.DataWrapper>> initMonthDays(Date targetDate){
        Date currentCycleDate = null == targetDate ? Date.today().toStartOfMonth() : targetDate.toStartOfMonth();
        Integer monthNumber= currentCycleDate.month();
        Integer monthNumberOfCurrentCycle= monthNumber;
        List<List<pianificaSlotController.DataWrapper>> currentMonthWeekList = new List<List<pianificaSlotController.DataWrapper>>();
        while(monthNumberOfCurrentCycle == monthNumber){
            currentMonthWeekList.add(pianificaSlotController.initWeekDays(currentCycleDate));
            currentCycleDate= currentCycleDate.addDays(7);
            monthNumberOfCurrentCycle= currentCycleDate.toStartOfWeek().month();
        }
        return currentMonthWeekList;
    }

    public class InitWrapper{
		@AuraEnabled
		public User manager;
		@AuraEnabled
		public Map<String, List<User>> filialistiPerFiliale;
		@AuraEnabled
		public List<SFA_Slot__c> slotList;
		@AuraEnabled
		public List<SFA_Assenza_Prolungata__c> assenzeProlungateList;
		@AuraEnabled
		public List<List<pianificaSlotController.DataWrapper>> currentMonthWeekList;
		@AuraEnabled
		public Date targetDate;
		@AuraEnabled
		public List<Account> branches;
		@AuraEnabled
		public Map<String, List<Zone__c> > zonePerFiliale;
		@AuraEnabled
		public List<Map<String,String>> TypeSelectOptions;


		public InitWrapper(User manager,
											 Map<String, List<User>> filialistiPerFiliale, 
											 List<SFA_Slot__c> slotList, 
											 List<SFA_Assenza_Prolungata__c> assenzeProlungateList,
											 List<List<pianificaSlotController.DataWrapper>> currentMonthWeekList,
											 List<Account> branches,
											 Map<String, List<Zone__c> > zonePerFiliale,
											 List<Map<String,String>> TypeSelectOptions,
											 Date targetDate ){
			this.manager= manager;
			this.filialistiPerFiliale= filialistiPerFiliale;
			this.slotList= slotList;
			this.currentMonthWeekList= currentMonthWeekList;
			this.targetDate= targetDate == null ? Date.today() : targetDate;
			this.branches= branches;
			this.zonePerFiliale= zonePerFiliale;
			this.TypeSelectOptions= TypeSelectOptions;
			this.assenzeProlungateList= assenzeProlungateList;

		}
	}
}