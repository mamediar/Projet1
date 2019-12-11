public class SetupVisibilityFiliali {

    /* Classe che viene richiamata da PianificaSlot, GestioneZoneController, GestioneCapComune e AssenzaProlungata 
     * per il settaggio della visibilità
       delle filiali in base al ruolo e al profilo dell'utente corrente */
    
    public static String typeUser() {
        String userType = [SELECT Name FROM Profile WHERE id=:userinfo.getProfileId() LIMIT 1].name;       
        return userType == null ? '' : userType;      
    }
    
    public static List<Account> getFiliali(){
        String userType = typeUser();
        User u= [SELECT Id,Name,DefaultQueueId__c,Area__c,UserRole.Name FROM User WHERE Id =: UserInfo.getUserId()];
        String OCSExternalId = u.DefaultQueueId__c == null ? '' : u.DefaultQueueId__c;
        String Area = u.Area__c == null ? '' : u.Area__c;
        String Role = u.UserRole.Name == null ? '' : u.UserRole.Name;
        System.debug('DP Ruolo: '+Role);
        System.debug('DP typeUser: '+userType);
        
        String QueryBranch = 'SELECT FirstName, LastName, Name, Id, toLabel(Type) typeLabel,OCS_External_Id__c,OCSAreaId__c,Region_Name__c '+
            				   +' FROM Account '+
                               +' WHERE OCS_External_Id__c != null AND OCSAreaId__c != null AND Region_Name__c != null'+
                               +' AND Type = \'FIL\' AND RecordType.DeveloperName = \'Branch\'';
        

        //Settoggio visibilità filiali:
        //Branch Manager e Branch Employee vedono la singola filiale
        //Area Manager vede la sua singola Area con tutte le filiali che ne fanno parte
        //Area Manager con ruolo contente 'Regione' vede la sua regione con tutte le aree e le filiali sottostanti
        //Area Manager con ruolo contente 'Trainer' vede la sua regione con tutte le aree e le filiali sottostanti
        //Se sei diverso da tutti le condizioni indicate prima l'utente vede tutte le filiali (Sono Admin).
        
        if(userType=='Area Manager' && Role.contains('Trainer')){
           QueryBranch +=' AND toLabel(Region_Name__c) =: Role'; 
           System.debug('DP sono un region manager');
        }
        if(userType=='Area Manager' && Role.contains('REGIONE')){
           QueryBranch +=' AND toLabel(Region_Name__c) =: Role'; 
           System.debug('DP sono un region manager');
        }
        if(userType=='Area Manager' && !Role.contains('REGIONE')){
            QueryBranch +=' AND OCSAreaIdText__c=: Area';
            System.debug('DP sono un Area manager');
        }                                     
        If(userType=='Branch Manager' || userType=='Branch Employee'){
            QueryBranch += ' AND OCS_External_Id__c=: OCSExternalId';
            System.debug('DP sono un utente di filiale');
        }
        
        List<Account> allBranchList = Database.query(QueryBranch);
        system.debug('DP allBranchList: '+allBranchList);	
        return allBranchList;
	}
}