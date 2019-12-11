public with sharing class RiempiCasellaController {
    /******
    @auraEnabled
    public static List<GroupMember>  doCodeFilter_OLD(){
        String roleID = Userinfo.getUserRoleId(); 
		Map<String, UserRole> ruoli = new Map<String, UserRole>([SELECT id, DeveloperName, ParentRoleId FROM UserRole]);
        List<XCS_RiempiCasella__mdt> configfilter = [SELECT IdCoda__c, ListView__c, Items__c, asc_desc__c, Obj_Assigned__c FROM XCS_RiempiCasella__mdt ];
        List<String> devNameConfig = new List<String>();
        for(XCS_RiempiCasella__mdt devnameconf:configfilter){
            devNameConfig.add(devnameconf.IdCoda__c);
        }
        List<Group> code = GroupUtils.getQueueList(devNameConfig);
        List<GroupMember> membri = [SELECT UserOrGroupId  FROM GroupMember where Groupid in:code];
      	List<Id> idmembri = new List<Id>();
        for(GroupMember id:membri){
           idmmembri.add(id.UserOrGroupId);	
        }
        List<Group> ruoliMember = [SELECT Id,DeveloperName  FROM Group WHERE Id in:idmembri];
        set<Id> idruoli = new set<Id>();
        for(Group idrole:ruoliMember){
			if(findRole(ruoli,ruoli.get(roleID), idrole.DeveloperName)){
            idruoli.add(idrole.id);
			}
        }
       	List<GroupMember> codes = [SELECT Group.Name,Group.DeveloperName FROM GroupMember WHERE UserOrGroupId in:idruoli AND Group.DeveloperName in:devnameConfig  ];
 		return codes;   
    }
************/
    @auraEnabled
    public static List<GroupMember>  doCodeFilter(){
        Id userRoleId = Userinfo.getUserRoleId(); 
		Map<Id, UserRole> mapRole = new Map<Id, UserRole>([SELECT id, DeveloperName, ParentRoleId FROM UserRole]);

        //ricerca gerarchia del  ruolo utente...l'utente stesso fa parte della sua gerarchia
        List<Id> lstHierarchyRoleId=new List<Id>{userRoleId};
        Id parentRoleId=mapRole.get(userRoleId).ParentRoleId;
        while(parentRoleId!=null){
            lstHierarchyRoleId.add(parentRoleId);
            parentRoleId=mapRole.get(parentRoleId).ParentRoleId;            
        }
        //RECUPERO i gruppi relazionati alla gerarchia dei ruoli           
        // ATTENZIONE! bisogna selezionare SOLO i ruoli diversi dallo user role che fanno parte del gruppo role & subordinate              
        List<Group> lstRelatedGroup=[select id, name, type from group where 
                (relatedId in :lstHierarchyRoleId and type='RoleAndSubordinates') or (relatedId=:userRoleId and type='Role')];
        //RECUPERO le CODE a cui i membri estratti appartengono
        List<GroupMember> lstMembers= [SELECT Group.Name,Group.DeveloperName, UserOrGroupId,groupid  FROM GroupMember where group.type='Queue' and UserOrGroupId in :lstRelatedGroup ];
        return  lstMembers;
    }

    @auraenabled
    public static boolean findRole(Map<String, UserRole> ruoli, UserRole role,String roleDeveloperNameToFind ){
        
        if(role.DeveloperName == roleDeveloperNameToFind){
            return true;
        }
        else{
            if(role.ParentRoleId == null){
                return false;
            }
            else {
             return findRole(ruoli, ruoli.get( role.ParentRoleId ), roleDeveloperNameToFind);   
            }
        }
    }
    /******
    @auraEnabled
    public static String doRiempiCasellaOLD(String codaSelezionata){
        List<Group> coda = GroupUtils.getQueueList(codaSelezionata);
        
        List<XCS_RiempiCasella__mdt> config = [SELECT IdCoda__c, ListView__c, Items__c, asc_desc__c, Obj_Assigned__c FROM XCS_RiempiCasella__mdt 
                                               WHERE IdCoda__c =: codaSelezionata ];
        if(config.size()==0)  throw new AuraException('no record per IdCoda '+codaSelezionata);
        List<ListView> idListViewSelezionato = [SELECT Id, Name, DeveloperName, SobjectType FROM ListView 
                                                where DeveloperName = :config[0].ListView__c AND SobjectType = 'Case'];
        
        if(idListViewSelezionato.size()==0)  throw new AuraException('no record per ListView '+config[0].ListView__c);
        
        Integer q = Integer.valueOf(config[0].Items__c); 
        List<Case> lCase = CaseUtils.changeOwner(q, coda[0].Id, config[0].asc_desc__c);
        return idListViewSelezionato[0].Id;
    }
    @Auraenabled
    public static XCS_RiempiCasella__mdt getConfig(String idofqueue){
        return [SELECT IdCoda__c, ListView__c, Items__c, asc_desc__c, Obj_Assigned__c FROM XCS_RiempiCasella__mdt 
                                               WHERE IdCoda__c =:idofqueue ];
            
    }
*****/
//ritorna una listview specifica che atterra su tutti i case a cui l'utente è assegnato
    @auraEnabled
    public static String doRiempiCasella(String codaSelezionata){
        List<Group> coda = GroupUtils.getQueueList(codaSelezionata);        
        //TODO rendere configurabile questo numero
        Integer q = Integer.valueOf(5); 
        List<Case> lCase = CaseUtils.changeOwner(q, coda[0].Id, '');
        return '';
    }
    
}