/**
 * @File Name          : PVGestioneController.cls
 * @Description        :
 * @Author             : Andrea Vanelli
 * @Group              :
 * @Last Modified By   : Andrea Vanelli
 * @Last Modified On   : 26/10/2019, 11:55:34
 * @Modification Log   :
 *==============================================================================
 * Ver         Date                     Author                        Modification
 *==============================================================================
 * 1.0    3/8/2019, 17:48:26   Andrea Vanelli     Initial Version
 **/
public without sharing class PVGestioneController {

	@AuraEnabled
	public static Case getCaseFields(String recordId){
		// estraggo i dati del Case necessari
		Case theCase =  [Select Id,AccountId ,Account.FirstName, account.getCodice_Cliente__c, Account.LastName, Status, OwnerId, Step_PV__c,Categoria_Riferimento__r.External_Id__c, NumeroPratica__c, Tipo_Pratica__c,LocazioneContratto__c, pv_ctr_no_sign__c, pv_ctr_no_taeg__c, pv_ctr_no_titolare__c, pv_ctr_no_bene__c, pv_ctr_esiste__c, pv_send_to__c FROM Case Where Id =: recordId limit 1][0];
		System.debug('PV getCaseFields'  + theCase);
		//System.debug('PV getCaseFields cliente '  + theCase.Account.getCodice_Cliente__c);
		return theCase;
	}
/*    @AuraEnabled
    public static String getUserOffice(){
        // estraggo il campo branchOffice dell'utente es: NumeroBlu
        return [Select Branch_Or_Office__c From User Where Id = :UserInfo.getUserId()][0].Branch_Or_Office__c;
    }
 */
	@AuraEnabled
	public static PVForm.UserData getUserData(String queueId){
		// estraggo il campo branchOffice dell'utente es: NumeroBlu

		System.debug('UserId : ' + UserInfo.getUserId());
		String myuser = UserInfo.getUserId()		;
		//myuser = '0050Q000000M2itQAC';
		PVForm.UserData userData = new PVForm.UserData();
		userData.user = [Select Alias, Name, LastName, FirstName, UserRoleId, UserRole.Name, Branch_Or_Office__c,  UserRole.DeveloperName,DefaultQueueId__c from User Where Id = :myuser][0];
		System.debug('User: ' + userData.user);
		//recupero del'Account dell'ufficio o della filiale di riferimento
		if(String.isBlank(userData.user.Branch_Or_Office__c)) {
			userData.user.Branch_Or_Office__c = '';
		}
		else if(userData.user.Branch_Or_Office__c != 'FIL') {
			//ufficio
			userData.accountOffice = [Select Id from Account where RecordType.Name = 'Uffici e Altro' AND Codice_Ufficio__c =: userData.user.Branch_Or_Office__c][0];
		}else{
			//filiale
			userData.accountOffice = AccountUtils.getBranch(userData.user.DefaultQueueId__c.substring(1, userData.user.DefaultQueueId__c.length()))[0];
		}
		System.debug('Account: ' + userData.accountOffice);

/* old
		System.debug('@@@@ UserRoleId: ' + userData.user.UserRoleId);
		if (userData.user.UserRoleId != null)  {
			Group mygroup = [select Id,DeveloperName from Group where RelatedId =:userData.user.UserRoleId and Type='Role'][0];
			System.debug('@@@@ mygroup: ' + mygroup);
			if (mygroup != null && mygroup.DeveloperName == 'ADMIN'){
				userData.isAbilitatoGestione = true;
			} else {
				List<GroupMember> code = [SELECT Id FROM GroupMember WHERE UserOrGroupId = :mygroup.Id and GroupId = :queueId AND Group.Type = 'Queue'];
				System.debug('@@@@ code: ' + code);
				if (code.size() > 0) {
					userData.isAbilitatoGestione = true;
				}
			}
		}
*/
		userData.isAbilitatoGestione = false;
        Id userRoleId = Userinfo.getUserRoleId(); 
		Map<Id, UserRole> mapRole = new Map<Id, UserRole>([SELECT id, DeveloperName, ParentRoleId FROM UserRole]);

		if(mapRole.get(userRoleId).DeveloperName.equals('ADMIN')) {
			userData.isAbilitatoGestione = true;
		} else {
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
			List<GroupMember> lstCode= [SELECT Group.Name,Group.DeveloperName, UserOrGroupId,groupid  FROM GroupMember where group.type='Queue' 
											and UserOrGroupId in :lstRelatedGroup and  GroupId = :queueId ];
			if (lstCode.size() > 0 ) {
				userData.isAbilitatoGestione = true;
			}

		}
		
		return userData;
	}

}