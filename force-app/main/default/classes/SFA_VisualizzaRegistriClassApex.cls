public without sharing class SFA_VisualizzaRegistriClassApex {

    private static User getCurrentUser(){
        String utenteId = UserInfo.getUserId();
        return [SELECT FirstName, LastName,Id,Name,DefaultQueueId__c, Profile.Name FROM User WHERE Id =: utenteId];
    }
    
    @AuraEnabled
    public static string typeUser(){
        String typeUser = getCurrentUser().Profile.Name;
        System.debug('DP typeUser: '+typeUser);
        return typeUser;
    }
    
    @AuraEnabled
    public static void updateDraftNote(List<SFA_NotaSpese__c> sns ){
        System.debug('DP sono in APEX sns: '+sns);
        database.update(sns);
    }
    
    private static List<SFA_NotaSpese__c> getNotaSpeseList(User actualUser, Date selectedDate, String targa){
        String defaultqueueid=actualUser.DefaultQueueId__c;
        String manId=actualUser.Id;
        List<String> statusList=new List<String>{'Da Approvare', 'Approvata'};
        String query= 'SELECT Id,Date__c,Time__c,Branch__c,Status__c,User__c,User__r.Alias, '
            +' User__r.Name,Tratta__c,OraInizioUscita__c,OraFineUscita__c,'
            +' KmInizioUscita__c,KmFineUscita__c,TargaVeicolo__c,'
            +' DataApprovazione__c,Note__c,KmRifornimento__c,LuogoRifornimento__c,'
            +' ImportoRifornimento__c,ManagerApprovazione__r.Alias,'
            +' (SELECT Id,Dealer__c FROM Pianifica_Attivita__r) '
            +' FROM SFA_NotaSpese__c '
            +' WHERE Status__c =: statusList '
                +' AND Branch__r.OCS_External_Id__c =: defaultqueueid ';
                    //+' AND User__c =: manId ';
        if(typeUser()!='Branch Manager'){
            query+= ' AND User__c =: manId ';
        }
                        
        if(selectedDate!=null){
            Date startDate=selectedDate.toStartOfMonth();
            Date lastDate=Date.newInstance(startDate.year(), startDate.month()+1, 1);
            query=query+'AND Date__c >=: startDate AND Date__c <: lastDate ';
        }
        if(String.isNotBlank(targa)){
            query=query+'AND TargaVeicolo__c=: targa ';
        }
        query=query+'ORDER BY Date__c ASC';
        System.debug('DP query getNotaSpeseList: '+Database.query(query));
        return Database.query(query);
    }
    @AuraEnabled
    public static List<SFA_NotaSpese__c> searchNoteSpeseApex(Date selectedDate, String targa, User actualUser){
		return getNotaSpeseList(actualUser, selectedDate, targa);
    }

    @AuraEnabled
    public static List<SFA_NotaSpese__c> updateNoteSpese(List<SFA_NotaSpese__c> updatedNotaSpeseList, User actualUser){
        for(SFA_NotaSpese__c notaSpese: updatedNotaSpeseList){
            notaSpese.Status__c='Approvata';
            notaSpese.DataApprovazione__c=Date.today();
            notaSpese.ManagerApprovazione__c= actualUser.Id;
        }
        update updatedNotaSpeseList; 
        updatedNotaSpeseList= searchNoteSpeseApex(updatedNotaSpeseList[0].Date__c, updatedNotaSpeseList[0].TargaVeicolo__c, actualUser);
        return updatedNotaSpeseList;
    }

    @AuraEnabled
    public static initWrapper initApex(){
        Date selectedDate=Date.today();
        User actualUser = getCurrentUser();
        return new initWrapper(getNotaSpeseList(actualUser, selectedDate, ''), actualUser);
    }

    public class initWrapper{
		@AuraEnabled
		public Date today;
		@AuraEnabled
		public List<SFA_NotaSpese__c> noteSpese;
        @AuraEnabled
        public User actualUser;
			
		public initWrapper(List<SFA_NotaSpese__c> noteSpese, User actualUser){
            this.today=Date.today();
			this.noteSpese=noteSpese;
            this.actualUser=actualUser;
		}
	}
}