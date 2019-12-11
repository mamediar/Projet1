public class AssenzaProlungataController {

    @AuraEnabled
	public static InitWrapper initApex(){
        User manager = getManager();
		List<Account> branchList = getBranches(manager);
        Map<String, List<User>> filialistiPerFiliale = getFilialistiPerFiliale(branchList,manager);
        Map<String, List<SFA_Assenza_Prolungata__c>> assenzePerFiliale = getAssenzePerFiliale(filialistiPerFiliale);
        List<Map<String,String>> motivoAssenzaPicklist = getMotivoAssenzaPicklist();
        InitWrapper iW = new InitWrapper(branchList,filialistiPerFiliale,assenzePerFiliale,motivoAssenzaPicklist);	
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
        return [SELECT FirstName,toLabel(Type) TypeLabel,Type, LastName, Name, OCS_External_Id__c 
                FROM Account 
                WHERE (OCS_External_Id__c =: manager.DefaultQueueId__c 
                       OR Parent.OCS_External_Id__c =: manager.DefaultQueueId__c  
                       OR Parent.Parent.OCS_External_Id__c =: manager.DefaultQueueId__c) 
                AND RecordType.Name = 'Branch'];*/
	}

    @AuraEnabled
	public static Map<String, List<User>> getFilialistiPerFiliale(List<Account> branchList, User manager){ 
        List<String> externalCodeId = new List<String>();
        for(Account branch : branchList){
            if(String.isNotBlank(branch.OCS_External_Id__c)){
                externalCodeId.add(branch.OCS_External_Id__c);
            }
        }
        List<User> allFilialisti = [SELECT FirstName, LastName,Name, Id,DefaultQueueId__c 
                                    FROM User 
                                    WHERE DefaultQueueId__c =: externalCodeId
                                    AND IsActive = true];
		Map<String, List<User>> filialistiPerFiliale= new Map<String, List<User>>();

        for(User utente : allFilialisti){
            if (filialistiPerFiliale.containsKey(utente.DefaultQueueId__c)){
                filialistiPerFiliale.get(utente.DefaultQueueId__c).add(utente);
            }
            else{
                filialistiPerFiliale.put(utente.DefaultQueueId__c, new List<User>{utente});
            }
        }
		return filialistiPerFiliale;
	}

    @AuraEnabled
	public static Map<String,List<SFA_Assenza_Prolungata__c>> getAssenzePerFiliale(Map<String, List<User>> filialistiPerFiliale){

        List<Id> userListId= new list<Id>();
		//userListId.add(manager.Id);
		for(List<User> listOfUser:filialistiPerFiliale.values()){
			for(User user:listOfUser){
				userListId.add(user.Id);
			}
		}
        List<SFA_Assenza_Prolungata__c> assenzeProlungateList = [SELECT RisorsaFiliale__r.DefaultQueueId__c,Risorsa_Name__c,RisorsaFiliale__c,RisorsaFiliale__r.Name ,StartDate__c,EndDate__c,MotivazioneAssenza__c,toLabel(MotivazioneAssenza__c) MotivazioneAssenzaLabel FROM SFA_Assenza_Prolungata__c WHERE RisorsaFiliale__c =: userListId];
        Map<String, List<SFA_Assenza_Prolungata__c>> assenzePerFiliale = new Map<String, List<SFA_Assenza_Prolungata__c>>(); 
        for(SFA_Assenza_Prolungata__c assenza : assenzeProlungateList){
            if (assenzePerFiliale.containsKey(assenza.RisorsaFiliale__r.DefaultQueueId__c)){
                assenzePerFiliale.get(assenza.RisorsaFiliale__r.DefaultQueueId__c).add(assenza);
            }
            else{
                assenzePerFiliale.put(assenza.RisorsaFiliale__r.DefaultQueueId__c, new List<SFA_Assenza_Prolungata__c>{assenza});
            }
        }
		return assenzePerFiliale;  
	}

    @AuraEnabled
	public static List<Map<String,String>> getMotivoAssenzaPicklist(){
        Schema.DescribeFieldResult fieldResult = SFA_Assenza_Prolungata__c.MotivazioneAssenza__c.getDescribe();
        return (List<Map<String,String>>) JSON.deserialize(JSON.serialize(fieldResult.getPicklistValues()),List<Map<String,String>>.Class);
    }

    @AuraEnabled
    public static Map<String,String> upsertAssenzaApex(SFA_Assenza_Prolungata__c theAssenza,String ocsCode){
        List<SFA_Slot__c> slotList = [SELECT Id FROM SFA_Slot__c  WHERE User__c =: theAssenza.RisorsaFiliale__c AND Branch__r.OCS_External_Id__c =: ocsCode AND Date__c >=:  theAssenza.StartDate__c AND Date__c <=: theAssenza.EndDate__c];

        if(theAssenza != null && slotList.isEmpty()){
        	upsert theAssenza;
            return new Map<String,String>{'isError'=>'false'};
        }else{
            return new Map<String,String>{'isError'=>'true','errorMessage' => 'L\'utente è già schedulato per un\' attività nel periodo selezionato'};
        }
        
    }

    @AuraEnabled
    public static void deleteAssenzaApex(SFA_Assenza_Prolungata__c theAssenza){
        if(theAssenza != null){
        	delete theAssenza;
        }
    }

	public class InitWrapper {
	  
        @AuraEnabled
        public List<Account> branches;
        @AuraEnabled
        public Map<String, List<User>> filialistiPerFiliale;
        @AuraEnabled
        public Map<String, List<SFA_Assenza_Prolungata__c>> assenzePerFiliale;
        @AuraEnabled
        public Date today;
        @AuraEnabled
        public List<Map<String,String>> motivoAssenzaPicklist;
        

        public InitWrapper(List<Account> branches,Map<String, List<User>> filialistiPerFiliale,Map<String, List<SFA_Assenza_Prolungata__c>> assenzePerFiliale,List<Map<String,String>> motivoAssenzaPicklist){
            this.branches = branches;
            this.filialistiPerFiliale = filialistiPerFiliale;
            this.assenzePerFiliale = assenzePerFiliale;
            this.today = Date.today();
            this.motivoAssenzaPicklist = motivoAssenzaPicklist;
        }

	}

}