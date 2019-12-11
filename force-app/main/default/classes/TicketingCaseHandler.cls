public class TicketingCaseHandler {

    public TicketingCaseHandler(final TriggerData triggerData) {
        this.triggerData = triggerData;
        ticketingCaseList = (List<Case>) triggerData.itemList;
    }

    // Prima di inserire il Case imposta il campo Branch__c con la filiale dell'utente che ha creato il Case
    // Se il campo è già stato impostato (es. migrazione) non lo cambia
    public void setBranch() {
        System.debug('---- setBranch ----');
        final List<Case> cases = ticketingCaseList;
        if (cases.size() == 0) return;
        final List<Id> userIdList = new List<Id>();
        for (Case caseItem : cases) {
            System.debug('Branch__c: ' + caseItem.Branch__c);
            if (caseItem.Branch__c != null) continue;
            userIdList.add(UserInfo.getUserId());
            System.debug('Aggiunta alla lista utente: ' + UserInfo.getUserId());
        }

        final Map<Id, Id> userIdBranchIdMap = UserUtils.getUserIdBranchIdMap(userIdList);
		System.debug('setBranch2');
        for (Case caseItem : cases) {
            if (caseItem.Branch__c != null) continue;
            caseItem.Branch__c = userIdBranchIdMap.get(UserInfo.getUserId());
            System.debug('Branch__c assegnato: ' + caseItem.Branch__c);
        }
        
        System.debug('---- setBranch END ----');
    }

    // Condivide il Case di Ticketing con la coda dell'utente che l'ha creato: inserisce la coda nella Branch__c del Case
    public void caseShare() {
        System.debug('---- caseShare ----');
        final List<Case> cases = ticketingCaseList;
        if (cases.size() == 0) return;
        final List<Id> branchIdList = new List<Id>();

        for (Case caseItem : cases) {
            System.debug('Branch__c: ' + caseItem.Branch__c);
            branchIdList.add(caseItem.Branch__c);
        }

        final Map<Id, Id> branchIdDefaultQueueIdMap = UserUtils.getBranchIdDefaultQueueIdMap(branchIdList);

        final Map<Id, Id> caseIdParentOwnerIdMap = getCaseIdParentOwnerIdMap(cases);

        final Map<Id, List<Id>> caseIdTeamMembersIdMap = getCaseIdTeamMembersIdMap(cases);

        final List<CaseShare> caseShareList = new List<CaseShare>();

        for (Case caseItem : cases) {
            final String branchId = caseItem.Branch__c;
            /*
            final String userId = caseItem.CreatedById;
            System.debug('userId: ' + userId);

            CaseShare userCaseShare = new CaseShare(
                caseId = caseItem.Id,
                userOrGroupId = userId,
                caseAccessLevel = 'Edit'
            );

            caseShareList.add(userCaseShare);
            System.debug('Sharing Case ' + userCaseShare.caseId + ' with user ' + userCaseShare.userOrGroupId);
            */
            final String queueId = branchIdDefaultQueueIdMap.get(branchId);
            System.debug('queueId: ' + queueId);
            if (queueId != null) {
                CaseShare queueCaseShare = new CaseShare(
                    caseId = caseItem.Id,
                    userOrGroupId = queueId,
                    caseAccessLevel = 'Edit'
                );

                caseShareList.add(queueCaseShare);
                System.debug('Sharing Case ' + queueCaseShare.caseId + ' with queue ' + queueCaseShare.userOrGroupId);
            }

            final String parentOwnerId = caseIdParentOwnerIdMap.get(caseItem.Id);
            System.debug('parentOwnerId: ' + parentOwnerId);
            if(parentOwnerId != null) {
                CaseShare parentOwnerCaseShare = new CaseShare(
                    caseId = caseItem.Id,
                    userOrGroupId = parentOwnerId,
                    caseAccessLevel = 'Edit'
                );

                caseShareList.add(parentOwnerCaseShare);
                System.debug('Sharing Case ' + parentOwnerCaseShare.caseId + ' with ParentOwner ' + parentOwnerCaseShare.userOrGroupId);
            }

            final List<Id> parentCaseIdList = getParentIdList(caseItem);
            for (Id parentCaseId : parentCaseIdList) {
                CaseShare parentCaseShare = new CaseShare(
                    caseId = parentCaseId,
                    userOrGroupId = caseItem.OwnerId,
                    caseAccessLevel = 'Read'
                );

                caseShareList.add(parentCaseShare);
                System.debug('Sharing Parent Case ' + parentCaseShare.caseId + ' with Case Owner ' + parentCaseShare.userOrGroupId);

                // Condivisione ai Case Team Members dei Parent Case: in creazione di un nuovo Case Team Member
                // non è possibile definire trigger (previsto per Winter '20) quindi al momento la rendiamo una
                // funzionalità non supportata
                /*
                final List<Id> teamMemberIdList = caseIdTeamMembersIdMap.get(caseItem.Id);
                for (Id teamMemberId : teamMemberIdList) {
                    CaseShare teamMemberCaseShare = new CaseShare(
                        caseId = parentCaseId,
                        userOrGroupId = teamMemberId,
                        caseAccessLevel = 'Read'
                    );

                    caseShareList.add(teamMemberCaseShare);
                    System.debug('Sharing Parent Case ' + userCaseShare.caseId + ' with Team Member ' + userCaseShare.userOrGroupId);
                }
                */

            }
        }

        if (caseShareList.size() > 0)
            Database.upsert(caseShareList, false);
        
        System.debug('---- caseShare END ----');
    }

    private Map<Id, Id> getCaseIdParentOwnerIdMap(List<Case> cases) {
        final Map<Id, Id> caseIdParentIdMap = new Map<Id, Id>();
        for (Case caseItem : cases) {
            if (caseItem.ParentId == null) continue;
            caseIdParentIdMap.put(caseItem.Id, caseItem.ParentId);
        }
        final List<Case> parentCaseList = [SELECT Id, OwnerId from Case where Id IN : caseIdParentIdMap.values()];
        final Map<Id, Id> parentCaseIdOwnerIdMap = new Map<Id, Id>();
        for (Case parentCaseItem : parentCaseList) {
            parentCaseIdOwnerIdMap.put(parentCaseItem.Id, parentCaseItem.OwnerId);
        }

        Map<Id, Id> caseIdParentOwnerIdMap = new Map<Id, Id>();
        for (Id caseItemId : caseIdParentIdMap.keySet()) {
            caseIdParentOwnerIdMap.put(caseItemId, parentCaseIdOwnerIdMap.get(caseIdParentIdMap.get(caseItemId)));
        }
        return caseIdParentOwnerIdMap;
    }

    private List<Id> getParentIdList(final Case caseItem) {
        final List<Id> parentCaseIdList = new List<Id>();
        getRecursiveParentIdList(parentCaseIdList, caseItem);
        return parentCaseIdList;
    }

    private void getRecursiveParentIdList(final List<Id> parentCaseIdList, final Case caseItem) {
        if (caseItem.ParentId == null) return;
        parentCaseIdList.add(caseItem.ParentId);
        final Case parentCase = [SELECT Id, ParentId from Case where Id =: caseItem.ParentId];
        getRecursiveParentIdList(parentCaseIdList, parentCase);
    }

    private Map<Id, List<Id>> getCaseIdTeamMembersIdMap(final List<Case> cases) {
        final List<Id> caseItemIdList = new List<Id>();
        for (Case caseItem : cases) {
            caseItemIdList.add(caseItem.Id);
        }
        
        List<CaseTeamMember> caseTeamMemberList = [SELECT ParentId, MemberId from CaseTeamMember where ParentId IN :caseItemIdList];

        final Map<Id, List<Id>> caseIdTeamMembersIdMap = new Map<Id, List<Id>>();
        for (CaseTeamMember teamMemberItem : caseTeamMemberList) {
            List<Id> teamMemberList = caseIdTeamMembersIdMap.get(teamMemberItem.ParentId);
            if (teamMemberList == null) teamMemberList = new List<Id>();
            teamMemberList.add(teamMemberItem.MemberId);
        }
        return caseIdTeamMembersIdMap;
    }


    // Se il Case ha un parent (è un sotto-Ticket) imposta lo stato del Padre a 'Inoltrato'
    public void parentChangeStatusOnInsert() {
        System.debug('---- parentChangeStatusOnInsert ----');
        final List<Case> parentCaseList = new List<Case>();
        
        for (Case caseItem : ticketingCaseList) {
            final Id parentId = caseItem.ParentId;
            System.debug('Parent Case Id: ' + parentId);
            if (parentId != null) {
                final Case parentCase = new Case(
                    Id = parentId,
                    Status = 'Inoltrato'
                );
                parentCaseList.add(parentCase);
            } 
        }

        if (parentCaseList.size() > 0)
            update parentCaseList;
        System.debug('---- parentChangeStatusOnInsert  END----');
    }

    // Se il Case ha un parent (è un sotto-Ticket) imposta lo stato del Padre in base allo stato del (o dei) figli
    public void parentChangeStatusOnUpdate() {
        System.debug('---- parentChangeStatusOnUpdate ----');
        final List<Case> parentCaseList = new List<Case>();
        final List<Id> parentCaseIdList = new List<Id>();
        
        for (Case caseItem : ticketingCaseList) {
            final Id caseId = caseItem.Id;
            final Case oldCase = (Case) triggerData.oldMap.get(caseId);
            final Case newCase = (Case) triggerData.newMap.get(caseId);
            final Id parentId = newCase.ParentId;

            System.debug('Case Status: ' + newCase.Status + ' ParentId: ' + parentId);

            if (parentId == null) continue;

            if (newCase.Status <> oldCase.Status && newCase.isClosed) {
                parentCaseIdList.add(parentId);
            }
            else if (!newCase.Parent.isClosed) {
                final Case parentCase = new Case (
                    Id = parentId,
                    Status = 'Inoltrato'
                );
                parentCaseList.add(parentCase);
            }
        }

        if (parentCaseIdList.size() > 0) {
            final Map<Id, List<Case>> parentIdSubCaseMap = new Map<Id, List<Case>>();
            final List<Case> subCaseList = [SELECT Id, Status, IsClosed, ParentId from CASE where ParentId IN :parentCaseIdList];

            for (Case subCase : subCaseList) {
                if (parentIdSubCaseMap.get(subCase.ParentId) == null) parentIdSubCaseMap.put(subCase.ParentId, new List<Case>());
                final List<Case> subCaseOfParentList = parentIdSubCaseMap.get(subCase.ParentId);
                subCaseOfParentList.add(subCase);
            }
            
            for (Id parentCaseId : parentCaseIdList) {
                final List<Case> subCaseOfParentList = parentIdSubCaseMap.get(parentCaseId);

                System.debug('Trovati ' + subCaseOfParentList.size() + ' Case del Parent ' + parentCaseId);

                Boolean allSubCasesAreClosed = true;
                for (Case subCaseOfParent : subCaseOfParentList) {
                    if (!subCaseOfParent.isClosed) {
                        allSubCasesAreClosed = false;
                        break;
                    }
                }
                if (allSubCasesAreClosed)  {
                    System.debug('Tutti i sotto-Case di ' + parentCaseId + ' sono chiusi');
                    final Case parentCase = new Case(
                        Id = parentCaseId,
                        Status = 'Pending'
                    );
                    parentCaseList.add(parentCase);
                }
            }
        }

        if (parentCaseList.size() > 0)
            update parentCaseList;

        System.debug('---- parentChangeStatusOnUpdate END ----');
    }

    // Se viene chiuso il Padre chiudo anche i figli
    public void changeChildCaseStatusOnClose() {
        System.debug('---- changeChildCaseStatusOnClose ----');
        
        for (Case caseItem : ticketingCaseList) {
            final List<Case> childCaseList = [SELECT Id, Status FROM Case where ParentId =: caseItem.Id];
            if (childCaseList == null || childCaseList.size() == 0) continue;

            for (Case childCaseItem : childCaseList) {
                childCaseItem.Status = caseItem.Status;
            }

            update childCaseList;
        }

        System.debug('---- changeChildCaseStatusOnClose END ----');
    }

    public void insertTeamMemberCase() {   

		boolean Trainer = false;
		boolean Coordinatori = false;
		boolean Regional = false;
		boolean CapoFiliale = false;
        String userId;
        String caseIdNew;
        
        for (Case caseItem : ticketingCaseList) {
            userId = caseItem.CreatedById;
            caseIdNew = caseItem.Id;
            if(caseItem.ShareCaseteam__c!=null){
                if (caseItem.ShareCaseteam__c.contains('Trainer')) Trainer = true;
                if (caseItem.ShareCaseteam__c.contains('Coordinatori')) Coordinatori = true;
                if (caseItem.ShareCaseteam__c.contains('Regional')) Regional = true;
                if (caseItem.ShareCaseteam__c.contains('Capo Filiale')) CapoFiliale = true;
            }   			
        }
        List<String> OCSExternalIdBranch = new List<String>();
        String Branch = [SELECT id, DefaultQueueId__c FROM User WHERE id=:userId].DefaultQueueId__c;
        OCSExternalIdBranch.add(Branch);
        System.debug('DP Branch: '+Branch);
        
        System.debug('DP OCSExternalIdBranch per mapRolesHierarchy: '+OCSExternalIdBranch);
        If(Branch==null)return;
        
        RoleUtils.mapRolesHierarchy mapRolesHierarchy= RoleUtils.recoverRolesHierarchy(OCSExternalIdBranch);
        
        Map<Id,Account> TrainerUser = new Map<Id,Account>();
        Map<Id,User> Coordinatore = new Map<Id,User>();
        Map<Id,User> RegionalUser = new Map<Id,User>();
        Map<Id,User> CapoFilialeUser = new Map<Id,User>();
        List<User> userCaseTeam = new List<User>();
        List<CaseTeamMember> CTM = new List<CaseTeamMember>();

        //mapRolesHierarchy.filiali; Manca la logica della mappa dei Trainer

        if(Coordinatori){
            system.debug('DP Aggiungo a UserCaseTeam gli Id degli utenti per coordinatore');
            Coordinatore = mapRolesHierarchy.coordinatoriArea;
            for(User target : Coordinatore.values()) {
                system.debug('DP Dentro for Coordinatori');
                userCaseTeam.add(target);
                system.debug('DP Dentro for Coordinatori userCaseTeam: '+userCaseTeam);
            }          
        }
        if(Regional){
            system.debug('DP Aggiungo a UserCaseTeam gli Id degli utenti per Regional');
            RegionalUser = mapRolesHierarchy.regionalsManager;
            for(User target : RegionalUser.values()) {
                system.debug('DP Dentro for Regional');
                userCaseTeam.add(target);
                system.debug('DP Dentro for Regional userCaseTeam: '+userCaseTeam);
            }
        }
        if(CapoFiliale){
            system.debug('DP Aggiungo a UserCaseTeam gli Id degli utenti per CapoFiliale');
            CapoFilialeUser = mapRolesHierarchy.managerFiliali;
            for(User target : CapoFilialeUser.values()) {
                system.debug('DP Dentro for CapoFiliale');
                userCaseTeam.add(target);
                system.debug('DP Dentro for CapoFiliale userCaseTeam: '+userCaseTeam);
            }
        }
        
        if(userCaseTeam.size()>0){
            String RoleId = [SELECT id FROM CaseTeamRole WHERE name = 'Ticketing-RO'].Id;
            
            List<CaseTeamMember> caseTeamList = new List<CaseTeamMember>();
            system.debug('DP userCaseTeam: '+userCaseTeam);
            for(User u: userCaseTeam){
                
                CaseTeamMember queueTeamShare = new CaseTeamMember(
                    ParentId = caseIdNew,
                    TeamRoleId = RoleId, 
                    MemberId = u.Id
                );

                caseTeamList.add(queueTeamShare);
                
            }
            If(caseTeamList.size()!=null){
               insert caseTeamList;
            }
            system.debug('DP caseTeamList: '+caseTeamList);
        }
                        
        System.debug('DP  Utenti da aggiungere al Case team: '+userCaseTeam);
        system.debug('DP  Trainer: '+Trainer);
        system.debug('DP  Coordinatori: '+Coordinatori);
        system.debug('DP  Regional: '+Regional);
        system.debug('DP  CapoFiliale: '+CapoFiliale);
        
	}
    
    public void insertNotaOCSBorg() {
        if(!agenziaBorg()) return;
        String aliasUser;
        String notaOCS;
        String userId;
        String caseIdNew;
        String CategoriaName;
        String CategoriaId;
        String sottoCategoria;
        String descryption;
                
        for (Case caseItem : ticketingCaseList) {
            userId = caseItem.CreatedById;
            caseIdNew = caseItem.Id; 
            //Categoria = caseItem.Categoria_Riferimento__r.Name;
            CategoriaId = caseItem.Categoria_Riferimento__c;
            descryption = caseItem.Description;
            sottoCategoria = caseItem.Categoria_Rif_Parent__c;
            
        }
        
        CategoriaName = [select id, name from XCS_Categoria__c where id = :CategoriaId].name;
        aliasUser = [select alias from user where id = :userId].alias;
        notaOCS = XCS_TemplateUtils.buildTemplateByName(CRMRetentionUtil.NOTE_TICKETING_BORG, 
                                                        new List<String>{aliasUser,
                                                            			 sottoCategoria,
                                                                         CategoriaName,
                                                                         descryption}
                                                       );

        OCSGestioneNoteInvoker.filtraNote(aliasUser,'' ,'' ,'' , 'A', 'P',notaOCS );
        
    }
    
    private boolean agenziaBorg() {   
        Boolean isBorg;
        String CategoriaId;
        String CatId;
        String profileId = userinfo.getProfileId();
        String profileName = [SELECT Name FROM Profile WHERE id=:profileId LIMIT 1].Name;
        
        for (Case caseItem : ticketingCaseList) {
            CategoriaId = caseItem.Categoria_Riferimento__c;          
        }
        if(CategoriaId!=null){
            CatId = [select id, External_Id__c from XCS_Categoria__c where id = :CategoriaId].External_Id__c;
                    if(profileName=='Borg' || CatId=='4666'){
                        isBorg = true;
                    }else{
                        isBorg = false;
                    }            
        }else{
            isBorg = false;
        }       
        system.debug('DP agenziaBorg: '+isBorg);       
        return isBorg;
    }

    private TriggerData triggerData;
    private final List<Case> ticketingCaseList;
}