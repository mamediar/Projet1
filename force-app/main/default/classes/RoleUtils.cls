public class RoleUtils {


    public static final String MonitoraggioDealer = 'Monitoraggio Dealer';
    
    //Attualmente Restituisce solo la mappa per filiale e manager.
    @AuraEnabled
    public static mapNomeIndirizziEmail recordMapExternalIdEmail(List<String> lstOCSExternalIdBranch){
     
    	mapRolesHierarchy mapRoles = recoverRolesHierarchy(lstOCSExternalIdBranch);
		mapNomeIndirizziEmail mapEmail = new mapNomeIndirizziEmail();
        Map<String,Account> mapOCSBranch = new Map<String,Account>();

        Map<String,User> mapRolesUserManager = new Map<String,User>();
        List<Account> listBranch = [Select id,Name,OCS_External_Id__c,nameRoleReference__c,nameParentRoleReference__c from Account Where OCS_External_Id__c IN :lstOCSExternalIdBranch and recordtype.name ='Branch'];        
        
        for(Account acc : listBranch){
            mapOCSBranch.put(acc.OCS_External_Id__c,acc);
        }
        for(Id key : mapRoles.managerFiliali.keySet()){
            mapRolesUserManager.put(mapRoles.managerFiliali.get(key).UserRole.DeveloperName ,mapRoles.managerFiliali.get(key));
        }
        // inizio istanza mappe
        Account valoriMappaAccount;
        for(Id key:mapRoles.filiali.keySet()){
            valoriMappaAccount=mapRoles.filiali.get(key);
            mapEmail.emailFiliali.put(valoriMappaAccount.OCS_External_Id__c,valoriMappaAccount.BusinessEmail__c);            
        }
        for(String ocsCode : lstOCSExternalIdBranch){
            mapEmail.emailManagerFiliali.put(ocsCode,mapRolesUserManager.get(mapOCSBranch.get(ocsCode).nameParentRoleReference__c).Email);
        }
        
        return mapEmail;
    }
    
    @AuraEnabled
    public static mapNomeIndirizziEmail recoverMapRolesEmail(List<String> lstOCSExternalIdBranch) {
             
        
        mapRolesHierarchy mapRoles = recoverRolesHierarchy(lstOCSExternalIdBranch);
        mapNomeIndirizziEmail mapEmail=new mapNomeIndirizziEmail();
        
        Account valoriMappaAccount = new Account();
        for(Id key:mapRoles.filiali.keySet()){
            valoriMappaAccount=mapRoles.filiali.get(key);
            mapEmail.emailFiliali.put(valoriMappaAccount.Name,valoriMappaAccount.BusinessEmail__c);            
        }
        
        User valoriMappaUser = new User();
        for(Id key:mapRoles.managerFiliali.keySet()){
            valoriMappaUser=mapRoles.managerFiliali.get(key);
            mapEmail.emailManagerFiliali.put(valoriMappaUser.Name,valoriMappaUser.Email);            
        }
        
        for(Id key:mapRoles.coordinatoriArea.keySet()){
            valoriMappaUser=mapRoles.coordinatoriArea.get(key);
            mapEmail.emailCoordinatoriArea.put(valoriMappaUser.Name,valoriMappaUser.Email);            
        }  
        
        for(Id key:mapRoles.regionalsManager.keySet()){
            valoriMappaUser=mapRoles.regionalsManager.get(key);
            mapEmail.emailRegionalManager.put(valoriMappaUser.Name,valoriMappaUser.Email);            
        }         
        
        return mapEmail;
    }
     
    @AuraEnabled
    public static lstIndirizziEmail recoverListRolesEmail(List<String> lstOCSExternalIdBranch) {
        
        mapRolesHierarchy mapRoles = recoverRolesHierarchy(lstOCSExternalIdBranch);
        lstIndirizziEmail lstEmail=new lstIndirizziEmail();
                        
        Account valoriMappaAccount = new Account();
        for(Id key:mapRoles.filiali.keySet()){
            valoriMappaAccount=mapRoles.filiali.get(key);
            lstEmail.emailFiliali.add(valoriMappaAccount.BusinessEmail__c);            
        }
        System.debug('lstEmail.emailFiliali'+lstEmail.emailFiliali);
        
        User valoriMappaUser = new User();
        for(Id key:mapRoles.managerFiliali.keySet()){
            valoriMappaUser=mapRoles.managerFiliali.get(key);
            lstEmail.emailManagerFiliali.add(valoriMappaUser.Email);            
        }
        System.debug('lstEmail.emailManagerFiliali'+lstEmail.emailManagerFiliali);
        
        for(Id key:mapRoles.coordinatoriArea.keySet()){
            valoriMappaUser=mapRoles.coordinatoriArea.get(key);
            lstEmail.emailCoordinatoriArea.add(valoriMappaUser.Email);            
        }  
        System.debug('lstEmail.emailCoordinatoriArea'+lstEmail.emailCoordinatoriArea);
        
        for(Id key:mapRoles.regionalsManager.keySet()){
            valoriMappaUser=mapRoles.regionalsManager.get(key);
            lstEmail.emailRegionalManager.add(valoriMappaUser.Email);            
        }         
        System.debug('lstEmail.emailRegionalManager'+lstEmail.emailRegionalManager);
        
        return lstEmail;
    }    
    
    @AuraEnabled
    public static mapRolesHierarchy recoverRolesHierarchy(List<String> lstOCSExternalIdBranch) {
        System.debug('RoleUtils');
        mapRolesHierarchy mapRoles=new mapRolesHierarchy();
        Map<Id,Account> mapRolesFiliali = new Map<Id,Account>([select Id, Name, BusinessEmail__c, OCS_External_Id__c from Account where OCS_External_Id__c IN:lstOCSExternalIdBranch]);
        Map<Id,User> mapRolesManagerFiliali = new Map<Id,User>();
        Map<Id,User> mapRolesCoordinatoriArea = new Map<Id,User>();
        Map<Id,User> mapRolesRegionalsManager = new Map<Id,User>();
        
        System.debug('DP RoleUtils.mapRolesFiliali: '+mapRolesFiliali); // DP Debug da cancellare
        
        mapRoles.filiali=mapRolesFiliali;
        System.debug('mapRoles.filiali'+mapRoles.filiali);
        
        List<User> lstUsersFiliali = [SELECT Id,DefaultQueueId__c,UserRoleId,UserRole.DeveloperName, Email FROM User WHERE DefaultQueueId__c IN :lstOCSExternalIdBranch and ( not UserRole.DeveloperName like '%_Manager' ) ];  // GROUP BY DefaultQueueId__c       
        List<Id> lstUserRoleIdUtentiFiliale=new List<Id>();
        List<String> lstOCSExternal=new List<String>();    
        for(User utente:lstUsersFiliali){
            if(!lstOCSExternal.contains(utente.DefaultQueueId__c) && utente.UserRoleId!=null){
                lstUserRoleIdUtentiFiliale.add(utente.UserRoleId);
                lstOCSExternal.add(utente.DefaultQueueId__c);
            }
        }
                
        //recupero l'Id del ruolo dei manager tramite il ruolo degli utenti di filiale:
        List<UserRole> lstUserRoleUtentiFiliale = [select Id, ParentRoleId from UserRole where id IN :lstUserRoleIdUtentiFiliale];
        List<Id> lstUserRoleIdManagerFiliale= new List<Id>();
        for(UserRole ruolo:lstUserRoleUtentiFiliale){
            System.debug('DP lstUserRoleIdManagerFiliale'); // DP Debug da cancellare
            lstUserRoleIdManagerFiliale.add(ruolo.ParentRoleId);
        }  
 
        //recupero i manager di filiale tramite il ruolo ruolo:
        List<User> lstUserManagerFiliale = [select Id,Name,Email,UserRole.DeveloperName from User where UserRoleId IN :lstUserRoleIdManagerFiliale];  //cosi recupero email manager nel caso debba inviare email anche a loro!!!!!!!!!!
        for (User managerFiliale:lstUserManagerFiliale){
            System.debug('DP mapRolesManagerFiliali'); // DP Debug da cancellare
            mapRolesManagerFiliali.put(managerFiliale.id,managerFiliale);
        }		
        mapRoles.managerFiliali=mapRolesManagerFiliali;
        System.debug('mapRoles.managerFiliali'+mapRoles.managerFiliali);
        
		//recupero l'id del ruolo dei coordinatori d'area tramite il ruolo dei manager
        List<UserRole> lstUserRoleManager = [select Id, ParentRoleId from UserRole where Id IN :lstUserRoleIdManagerFiliale]; 
        List<Id> lstUserRoleIdCoordinatoriArea= new List<Id>();
        for(UserRole ruolo:lstUserRoleManager){
            System.debug('DP lstUserRoleIdCoordinatoriArea'); // DP Debug da cancellare
            lstUserRoleIdCoordinatoriArea.add(ruolo.ParentRoleId);
        }
        
        
        //recupero email coordinatori area
        List<User> lstUserCoordinatoriArea = [select Id,Email, Name,UserRole.DeveloperName from User where UserRoleId IN :lstUserRoleIdCoordinatoriArea];  		
        for (User coordinatoreArea:lstUserCoordinatoriArea){
            System.debug('DP mapRolesCoordinatoriArea'); // DP Debug da cancellare
            mapRolesCoordinatoriArea.put(coordinatoreArea.id,coordinatoreArea);
        }
        mapRoles.coordinatoriArea=mapRolesCoordinatoriArea;
        System.debug('DP mapRoles.coordinatoriArea'+mapRoles.coordinatoriArea);
        
		//recupero l'id del ruolo dei regional manager tramite il ruolo dei coordinatori d'area        
        List<UserRole> lstUserRoleCoordinatoriArea = [select Id, ParentRoleId from UserRole where Id IN :lstUserRoleIdCoordinatoriArea]; 
        List<Id> lstUserRoleIdRegionalManager= new List<Id>();
        for(UserRole ruolo:lstUserRoleCoordinatoriArea){
            System.debug('DP lstUserRoleIdRegionalManager'); // DP Debug da cancellare
            lstUserRoleIdRegionalManager.add(ruolo.ParentRoleId);
        }

        //recupero email regional manager
        List<User> lstUserRegionalManager = [select Id,Email, Name,UserRole.DeveloperName from User where UserRoleId IN :lstUserRoleIdRegionalManager];  
        for (User regionalManager:lstUserRegionalManager){
            System.debug('DP mapRolesRegionalsManager'); // DP Debug da cancellare
            mapRolesRegionalsManager.put(regionalManager.id,regionalManager);
        }     
        mapRoles.regionalsManager=mapRolesRegionalsManager;
        System.debug('mapRoles.regionalsManager'+mapRoles.regionalsManager);

        return mapRoles;
    }      
    

    
	public class mapRolesHierarchy {
		@AuraEnabled
        public Map<Id,Account> filiali {get { if (filiali == null ) filiali = new Map<Id,Account>(); return filiali; } set;}
		@AuraEnabled
        public Map<Id,User> managerFiliali {get { if (managerFiliali == null ) managerFiliali = new Map<Id,User>(); return managerFiliali; } set;}        
		@AuraEnabled
        public Map<Id,User> coordinatoriArea {get { if (coordinatoriArea == null ) coordinatoriArea = new Map<Id,User>(); return coordinatoriArea; } set;}
		@AuraEnabled
        public Map<Id,User> regionalsManager {get { if (regionalsManager == null ) regionalsManager = new Map<Id,User>(); return regionalsManager; } set;}         
    }    
    
    
	public class mapNomeIndirizziEmail {
		@AuraEnabled
        public Map<String,String> emailFiliali {get { if (emailFiliali == null ) emailFiliali = new Map<String,String>(); return emailFiliali; } set;}
		@AuraEnabled
        public Map<String,String> emailManagerFiliali {get { if (emailManagerFiliali == null ) emailManagerFiliali = new Map<String,String>(); return emailManagerFiliali; } set;}        
		@AuraEnabled
        public Map<String,String> emailCoordinatoriArea {get { if (emailCoordinatoriArea == null ) emailCoordinatoriArea = new Map<String,String>(); return emailCoordinatoriArea; } set;}
		@AuraEnabled
        public Map<String,String> emailRegionalManager {get { if (emailRegionalManager == null ) emailRegionalManager = new Map<String,String>(); return emailRegionalManager; } set;}         
    }     
    
    
	public class lstIndirizziEmail {
		@AuraEnabled
        public List<String> emailFiliali {get { if (emailFiliali == null ) emailFiliali = new List<String>(); return emailFiliali; } set;}
		@AuraEnabled
        public List<String> emailManagerFiliali {get { if (emailManagerFiliali == null ) emailManagerFiliali = new List<String>(); return emailManagerFiliali; } set;}        
		@AuraEnabled
        public List<String> emailCoordinatoriArea {get { if (emailCoordinatoriArea == null ) emailCoordinatoriArea = new List<String>(); return emailCoordinatoriArea; } set;}
		@AuraEnabled
        public List<String> emailRegionalManager {get { if (emailRegionalManager == null ) emailRegionalManager = new List<String>(); return emailRegionalManager; } set;}         
    }     
    
}