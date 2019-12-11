/**
 * @File Name          : PVInserimentoController.cls
 * @Description        :
 * @Author             : Andrea Vanelli
 * @Group              :
 * @Last Modified By   : Federico Negro
 * @Last Modified On   : 11/11/2019, 12:37:33
 * @Modification Log   :
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    2019-7-1 11:46:44   Andrea Vanelli     Initial Version
 **/
public without sharing class PVInserimentoController {

/*       @AuraEnabled
    public static String getUserOffice(){
            // estraggo il campo branchOffice dell'utente es: NumeroBlu
        String branchOrOffice = [Select Branch_Or_Office__c From User Where Id = :UserInfo.getUserId()][0].Branch_Or_Office__c;
        return branchOrOffice;
    }
 */
	public class PVInserimentoParamEsterni {
		@AuraEnabled
		public String codClienteOCS;
		@AuraEnabled
		public String codPraticaOCS;
		@AuraEnabled
		public String codCategoria;
		@AuraEnabled
		public String commissioneEDI0C;
		@AuraEnabled
		public List<Id> attachmentsIDs;
		@AuraEnabled
		public Id parentId;


	}

	@AuraEnabled
	public static PVForm.UserData getUserData(){
		return getUserData(UserInfo.getUserId());
	}


	public static PVForm.UserData getUserData(Id userId){
		// estraggo il campo branchOffice dell'utente es: NumeroBlu
        PVForm.UserData userData = new PVForm.UserData();
/*		userdata.user = new User();
		userdata.user.UserRole = new UserRole();
*/

		try {
			System.debug('UserId : ' + userId);
			userData.user = [Select Alias, Name, LastName, FirstName, UserRole.Name, Branch_Or_Office__c,  UserRole.DeveloperName, DefaultQueueId__c from User Where Id = :userId][0];
			System.debug('User: ' + userData.user);
			System.debug('UserRole: ' + userData.user.UserRole);


			//recupero del'Account dell'ufficio o della filiale di riferimento
			if(!String.isBlank(userData.user.Branch_Or_Office__c) && userData.user.Branch_Or_Office__c != 'FIL') {
				//ufficio
				userData.accountOffice = [Select Id from Account where RecordType.Name = 'Uffici e Altro' AND Codice_Ufficio__c =: userData.user.Branch_Or_Office__c][0];
			}else{
				//filiale
				//userData.accountOffice = AccountUtils.getBranch('', userData.user.DefaultQueueId__c)[0];
				userData.accountOffice = AccountUtils.getBranch(userData.user.DefaultQueueId__c.substring(1, userData.user.DefaultQueueId__c.length()))[0];

				// togli F
				userData.codiceFiliale = userData.user.DefaultQueueId__c.substring(1, userData.user.DefaultQueueId__c.length());
				// filla zero a 3
				String s = '';
				for (Integer i = 0; i < 3; i++) {
					s = s+'0';
				}
				userData.codiceFiliale =  s.substring(userData.codiceFiliale.length()) + userData.codiceFiliale;

			}
			System.debug('Account: ' + userData.accountOffice);
		} catch  (Exception e) {
			System.debug('PVInserimentoController.getUserData: User non configurato correttamente per il PV');
			throw new AuraHandledException('User non configurato correttamente per il PV');
		}
        return userData;


	}

	@AuraEnabled
	public static List<PostvenditaConfig_menu__mdt> loadListaTipologia(){

		List<PostvenditaConfig_menu__mdt> listpg = [SELECT MasterLabel__c, UniqueId__c FROM PostvenditaConfig_menu__mdt WHERE ParentId__c = '0' order by MasterLabel__c];
		return listpg;
	}


	@AuraEnabled
	public static List<PostvenditaConfig_menu__mdt> loadFixedSottotipologia(String postVenditaId){
		List<PostvenditaConfig_menu__mdt> listpg = [SELECT Id, PostvenditaId__c, MasterLabel__c FROM PostvenditaConfig_menu__mdt WHERE PostvenditaId__c =: postVenditaId];
		return listpg;
	}


	@AuraEnabled
	public static List<PostvenditaConfig_menu__mdt> loadListaSottotipologia(String tipologiaSelezionata,String branchOrOffice){
		String VisSearchText = '%'+branchOrOffice+'%';

system.debug('loadListaSottotipologia: VisSearchText= ' + VisSearchText );
		//Soluzione 1 con iteration
		List<XCS_Categoria__c> idfilter;
		if (branchOrOffice.equalsIgnoreCase('FIL')) {
			// AV siccome i ticket non sono classificati sono costretto a caricare anche tutto quello che non ha visibilità se il branch è filiale
			// solo che sono tante !!! da rivedere
			idfilter = new List<XCS_Categoria__c>([SELECT External_Id__c FROM XCS_Categoria__c WHERE Visibility__c LIKE: VisSearchText OR Visibility__c = '']);
		} else {
			idfilter = new List<XCS_Categoria__c>([SELECT External_Id__c FROM XCS_Categoria__c WHERE Visibility__c LIKE: VisSearchText]);
		}

		List<String> PVList = new List<String>();
		for(XCS_Categoria__c categPV : idfilter) {
			PVList.add(categPV.External_Id__c);
		}

		List<PostvenditaConfig_menu__mdt> listpg = [SELECT Id, PostvenditaId__c, MasterLabel__c FROM PostvenditaConfig_menu__mdt WHERE ParentId__c =: tipologiaSelezionata AND PostvenditaId__c in :PVList order by MasterLabel__c];
		return listpg;
	}
	@AuraEnabled
	public static List<PostvenditaConfig_subtype__mdt> loadListaSubtypes(String sottotipologiaSelezionata,String branchOrOffice){
		String VisSearchText = '%'+branchOrOffice+'%';
		Integer pvID = Integer.valueOf(sottotipologiaSelezionata);
		List<PostvenditaConfig_subtype__mdt> listpg = [SELECT Id,Descrizione__c, DeveloperName,  Label, QualifiedApiName, uniqueId__c, Visibility__c FROM PostvenditaConfig_subtype__mdt WHERE PostvenditaId__c =: pvID AND Visibility__c LIKE :VisSearchText order by Descrizione__c];
		//  List<PostvenditaConfig_subtype__mdt> listpg = [SELECT Id,Descrizione__c, DeveloperName,  Label, QualifiedApiName, uniqueId__c, Visibility__c   FROM PostvenditaConfig_subtype__mdt WHERE PostvenditaId__c =: pvID];
		return listpg;
	}

	@AuraEnabled
	public static List<PostvenditaConfig_reason__mdt> loadListaReasons(String sottotipologiaSelezionata, String pvsubtypeSelezionata,String branchOrOffice){
		String VisSearchText = '%'+branchOrOffice+'%';
		Integer pvID = Integer.valueOf(sottotipologiaSelezionata);

		List<PostvenditaConfig_reason__mdt> listpg;
		List<PostvenditaConfig_reason__mdt> listpg2;

		// prendo tutte quelle con PostvenditaConfig_subtypeId__c = 0

			listpg = [select Id,Descrizione__c, DeveloperName, dispositionId__c, free_text_required__c, Label, PostvenditaConfig_subtypeId__c, QualifiedApiName, uniqueId__c, Visibility__c from PostvenditaConfig_reason__mdt
			          WHERE PostvenditaId__c =: pvID AND PostvenditaConfig_subtypeId__c = 0 AND  Visibility__c LIKE :VisSearchText order by Descrizione__c];

		if (pvsubtypeSelezionata.equals('')) {
			
		} else {
			Integer subID = Integer.valueOf(pvsubtypeSelezionata);
			
			if (subID > 0) {
				listpg2 = [select Id,Descrizione__c, DeveloperName, dispositionId__c, free_text_required__c, Label, PostvenditaConfig_subtypeId__c, QualifiedApiName, uniqueId__c, Visibility__c from PostvenditaConfig_reason__mdt
			          WHERE PostvenditaConfig_subtypeId__c =: subID AND Visibility__c LIKE :VisSearchText order by Descrizione__c];

			}
		}
		
		if (listpg2 != null) {
			listpg.addAll(listpg2);
		}
		
		return listpg;
	}



	@AuraEnabled
	public static XCS_Categoria__c getCommonComponents( String postVenditaId )
	{
		system.debug('ID postvendita: ' + postVenditaId );
// AV aggiunto Visibility__c perche non ho altro modo di distinguere il ticketing
		List<XCS_Categoria__c> postvendita = [SELECT id,External_Id__c,  Visibility__c,
		                                      flag_ricerca_cliente__c, flag_urgente__c,
		                                      flag_mostra_pratiche__c, flag_mostra_allegati__c,
		                                      Name, XCS_Template__r.Body__c, XCS_Disposition__c,
		                                      Filtro_Pratiche_OCS__c
		                                      FROM XCS_Categoria__c WHERE External_Id__c =: postVenditaId];
		return postvendita[0];
	}

}