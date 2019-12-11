public class SFAPraticheIrregolariCaricamController {
    
    @AuraEnabled  
    public static Boolean checkFlagInvioEmail(){
        
        Case ultimoCase = [SELECT Id, CaseNumber, FlagEmailInviate__c FROM Case 
                            WHERE ActivityType__c = 'SFA_PRAIRRPARENT'
                            ORDER BY CreatedDate DESC][0];             
        return ultimoCase.FlagEmailInviate__c;        
    }    
    
	@AuraEnabled
	public static DatiCase insertFile(String fileContents, String fileName, String fileExtension, String dataScadenzaString) {		
		try {

            Date dataScadenza = Date.valueOf(dataScadenzaString);
			Id fileId = CompassUtils.fileNewInstance(fileContents, fileName, fileExtension);
			DatiCase datiCase = createCases(fileId, dataScadenza);
			return datiCase;
			
		} catch (Exception ex) {
			System.debug('Il file non è stato inserito');
			System.debug('Eccezione: ' + ex);
			return null;
		}

	}
    
    
    
	@AuraEnabled
	public static Boolean chiudiCasoConErrore(String caseId) {	
        

		try {

            Case case1 = [SELECT Id, Status FROM Case WHERE Id = :caseId AND activitytype__c='SFA_PRAIRRPARENT'][0];
            case1.Status=CaseUtils.ERROREATTIVITA;
            update case1;
            return true;
			
		} catch (Exception ex) {
			System.debug('Il file non è stato inserito');
			System.debug('Eccezione: ' + ex);
			return false;
		}

	}    

	@AuraEnabled
	public static DatiCase createCases(String fileId, Date dataScadenza) {
		Case case1 = new Case();
		case1.ActivityType__c = 'SFA_PRAIRRPARENT';
		case1.Subject = 'Elaborazione Pratiche Irregolari';
		case1.status = 'Pending';
		case1.dataTermineLavoro__c = dataScadenza;
		insert case1;
        
		DatiCase datiCase = new DatiCase();
		datiCase.caseNumber = [SELECT Id, CaseNumber FROM Case WHERE Id = :case1.Id][0].CaseNumber;
		datiCase.caseId = case1.Id;
		CompassUtils.attachFile(fileId, case1.Id);
        
		SFA_PraticheIrregolari_CreazionePratiche sfa_tm_cp = new SFA_PraticheIrregolari_CreazionePratiche(fileId, case1.Id, dataScadenza);
		Id jobId = System.enqueueJob(sfa_tm_cp);
		return datiCase;

	}

	@AuraEnabled
	public static DatiCase checkLoadingStatus() {
		List<Case> lstCase = [
			SELECT Id, Status, CaseNumber, CreatedDate, Description
			FROM Case 
			WHERE ActivityType__c = 'SFA_PRAIRRPARENT'
			ORDER BY CreatedDate DESC
			];
		if (lstCase.size() > 0) {
			DatiCase datiCase = new DatiCase();
			datiCase.caseNumber = lstCase[0].CaseNumber;
			datiCase.caseId = lstCase[0].Id;
			datiCase.caseStatus = lstCase[0].status;
            datiCase.caseDescription = lstCase[0].Description;
			return datiCase;
		}
		else
			return null;
	}

	public class DatiCase {
        @AuraEnabled
        public String caseNumber {get; set;}
        @AuraEnabled
        public String caseId {get; set;}
		@AuraEnabled
        public String caseStatus {get; set;} 
		@AuraEnabled
        public String caseDescription {get; set;}        
    } 


    @AuraEnabled
    public static ListaIndirizziEmail recuperaIndirizziEmail(){
        
        Case ultimoCase = [SELECT Id, FlagEmailInviate__c FROM Case 
                            WHERE ActivityType__c = 'SFA_PRAIRRPARENT' AND Status='Closed'
                            ORDER BY CreatedDate DESC][0];
        Id ultimoCaseId=ultimoCase.Id;
        
        
        List<Case> caseFigli = [SELECT Id FROM Case WHERE ParentId = :ultimoCaseId];  
        Set<Id> caseFigliParentId=new Set<Id>();
        for(Case caseFiglio:caseFigli){
            caseFigliParentId.add(caseFiglio.Id);               
        }
        
        
        List<SFA_PraticaIrregolare__c> praticheOK = [SELECT Id, EsitoCaricamento__c, CodiceDealer__c,ActivityId__c 
                                                     FROM SFA_PraticaIrregolare__c WHERE EsitoCaricamento__c =: 'Pratica caricata' 
                                                     AND ActivityId__c IN :caseFigliParentId];         
        
        //List<Group> lstCoda = [SELECT Id, DeveloperName FROM Group];  
        List<Group> lstCoda =GroupUtils.getQueueList(); 
        List<Account> lstDealer = [SELECT Id, OCS_External_Id__c, Branch__r.OCS_External_Id__c 
                                   FROM Account WHERE RecordType.Name = 'Dealer'];  //seleziona la lista di dealer dagli account
        
        List<Id> lstBranch = new List<Id>();
        List<String> lstOCSExternalIdBranch = new List<String>();
        for (SFA_PraticaIrregolare__c pratica : praticheOK) {
            for (Account dealer : lstDealer) {    
                if (dealer.OCS_External_Id__c == 'D' + pratica.CodiceDealer__c) {
                    for (Group coda : lstCoda) {
                        if (coda.DeveloperName == dealer.Branch__r.OCS_External_Id__c) {
                            if(!lstBranch.contains(dealer.Branch__r.Id))
                               	lstBranch.add(dealer.Branch__r.Id); 
                            if(!lstOCSExternalIdBranch.contains(dealer.Branch__r.OCS_External_Id__c))
                            	lstOCSExternalIdBranch.add(dealer.Branch__r.OCS_External_Id__c);
                            break;
                        }
                    }
                    break;
                }
            }             
        }   

                
        
        List<Account> lstFiliali = [select Id, Name, BusinessEmail__c,OCS_External_Id__c from Account where Id IN:lstBranch];    
       
        
        
        Map < String, String > emailFiliali = new Map < String, String >();
        for(Account filiale:lstFiliali){
            //emailFiliali.put(filiale.OCS_External_Id__c.substring(1, filiale.OCS_External_Id__c.length()), filiale.BusinessEmail__c);
            emailFiliali.put(filiale.Name+' '+filiale.OCS_External_Id__c.substring(1, filiale.OCS_External_Id__c.length()), filiale.BusinessEmail__c);
        }
        //recupero per ogni filiale di interesse la lista degli utenti ad essa accodati, poi faccio in modo mettere nella lista un solo utente per ciascuna filiale per poi risalire agli altri ruoli più in alto        
        List<User> lstUsersFiliali = [SELECT Id,DefaultQueueId__c,UserRoleId, Email FROM User WHERE DefaultQueueId__c IN :lstOCSExternalIdBranch];
        /*DECOMMENTARE NEL CASO SERVA INVIARE LE EMAIL AI SINGOLI UTENTI DELLE FILIALI
        List<String> lstEmailFiliali= new List<String>();
        for(User userfiliale:lstUsersFiliali){
            lstEmailFiliali.add(userfiliale.Email);
        }*/
        
        List<Id> lstUserRoleIdUtenteSoloPerFiliale=new List<Id>();
        List<String> lstOCSExternal=new List<String>();    //mi serve solo per poter recuperare nella lista degli users uno solo per ogni filiale
        for(User utente:lstUsersFiliali){
            if(!lstOCSExternal.contains(utente.DefaultQueueId__c) && utente.UserRoleId!=null){
                lstUserRoleIdUtenteSoloPerFiliale.add(utente.UserRoleId);
                lstOCSExternal.add(utente.DefaultQueueId__c);
            }
        }
                
        //recupero l'Id del ruolo dei manager tramite il ruolo degli utenti di filiale:
        List<UserRole> lstUserRoleUtentiFiliali = [select Id, ParentRoleId from UserRole where id IN :lstUserRoleIdUtenteSoloPerFiliale];
        List<Id> lstUserRoleIdManagerFiliale= new List<Id>();
        for(UserRole ruolo:lstUserRoleUtentiFiliali){
            lstUserRoleIdManagerFiliale.add(ruolo.ParentRoleId);
        }  

		/*//DECOMMENTARE NEL CASO SERVA INVIARLE ANCHE AI MANAGER!recupero email manager:
		List<String> lstEmailFiliali= new List<String>();
        List<User> lstUserManagerFiliale = [select Id,Email from User where UserRoleId IN :lstUserRoleIdManagerFiliale];  //cosi recupero email manager nel caso debba inviare email anche a loro!!!!!!!!!!
        System.debug('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& riga 194 lista Id lstUserManagerFiliale interessate: '+lstUserManagerFiliale);           
        for(User manager:lstUserManagerFiliale){
            lstEmailFiliali.add(manager.Email);
        } 		
        System.debug('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& riga 199 lista Id lstEmailFiliali interessate: '+lstEmailFiliali);           
        */
        
		//recupero l'id del ruolo dei coordinatori d'area tramite il ruolo dei manager
        List<UserRole> lstUserRoleManager = [select Id, ParentRoleId from UserRole where Id IN :lstUserRoleIdManagerFiliale]; 
        List<Id> lstUserRoleIdCoordinatoriArea= new List<Id>();
        for(UserRole ruolo:lstUserRoleManager){
            lstUserRoleIdCoordinatoriArea.add(ruolo.ParentRoleId);
        }
        
        
        //recupero email coordinatori area
        List<User> lstUserCoordinatoriArea = [select Id,Email, Name from User where UserRoleId IN :lstUserRoleIdCoordinatoriArea];  		
 		Map < String, String > emailCoordinatoriArea = new Map < String, String >();        
        for(User coordinatore:lstUserCoordinatoriArea){
            emailCoordinatoriArea.put(coordinatore.Name, coordinatore.Email);        
        }  

		//recupero l'id del ruolo dei regional manager tramite il ruolo dei coordinatori d'area        
        List<UserRole> lstUserRoleCoordinatoriArea = [select Id, ParentRoleId from UserRole where Id IN :lstUserRoleIdCoordinatoriArea]; 
        List<Id> lstUserRoleIdRegionalManager= new List<Id>();
        for(UserRole ruolo:lstUserRoleCoordinatoriArea){
            lstUserRoleIdRegionalManager.add(ruolo.ParentRoleId);
        }

        //recupero email regional manager
        List<User> lstUserRegionalManager = [select Id,Email, Name from User where UserRoleId IN :lstUserRoleIdRegionalManager];  
        Map < String, String > emailRegionalManager = new Map < String, String >();            
        for(User regional:lstUserRegionalManager){
            emailRegionalManager.put(regional.Name, regional.Email);    
        }  

       
        
        //simulate the sending of the email and then roll back just to get the correct template of the email with the merge fields:
        // Pick a dummy Contact
        //Contact c = [select id, Email from Contact where email <> null limit 1];
		//Contact c = [SELECT Id FROM Contact WHERE Name = 'Dummy Dummy'][0];
		Contact c = [SELECT Id FROM Contact WHERE Account.OCS_External_Id__c = 'N00000'][0];        
       //simulate the email sending to FILIALE
        Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
        msg.setTemplateId( [select id from EmailTemplate where DeveloperName='SFA_PraticaIrregolare_MailFiliale'].id );
        msg.setWhatId(ultimoCase.Id);
        msg.setTargetObjectId(c.id);
        msg.setToAddresses(new List<String>{'random_address@opfocus.com'});        
        // Send the emails in a transaction, then roll it back
        Savepoint sp = Database.setSavepoint();
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {msg});
        Database.rollback(sp);
        String emailTemplateFiliale;
        emailTemplateFiliale=msg.getPlainTextBody();
        
       //simulate the email sending to COORDINATORI AREA
        Messaging.SingleEmailMessage msg2 = new Messaging.SingleEmailMessage();
        msg2.setTemplateId( [select id from EmailTemplate where DeveloperName='SFA_PraticaIrregolare_MailArea'].id );
        msg2.setWhatId(ultimoCase.Id);
        msg2.setTargetObjectId(c.id);
        msg2.setToAddresses(new List<String>{'random_address@opfocus.com'});        
        //Send the emails in a transaction, then roll it back
        Savepoint sp2 = Database.setSavepoint();
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {msg2});
        Database.rollback(sp2);
        String emailTemplateCoordinatoriArea;
        emailTemplateCoordinatoriArea=msg2.getPlainTextBody();        

       //simulate the email sending to REGIONAL MANAGER
        Messaging.SingleEmailMessage msg3 = new Messaging.SingleEmailMessage();
        msg3.setTemplateId( [select id from EmailTemplate where DeveloperName='SFA_PraticaIrregolare_MailRegional'].id );
        msg3.setWhatId(ultimoCase.Id);
        msg3.setTargetObjectId(c.id);
        msg3.setToAddresses(new List<String>{'random_address@opfocus.com'});        
        // Send the emails in a transaction, then roll it back
        Savepoint sp3 = Database.setSavepoint();
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {msg3});
        Database.rollback(sp3);
        String emailTemplateRegionalManager;
        emailTemplateRegionalManager=msg3.getPlainTextBody();        
        
      
        
        
		ListaIndirizziEmail listaIndirizziEmail = new ListaIndirizziEmail();    
        listaIndirizziEmail.emailFiliali=emailFiliali;
        listaIndirizziEmail.emailCoordinatoriArea=emailCoordinatoriArea;   
        listaIndirizziEmail.emailRegionalManager=emailRegionalManager;   
        listaIndirizziEmail.emailTemplateFiliale=emailTemplateFiliale;  
        listaIndirizziEmail.emailTemplateCoordinatoriArea=emailTemplateCoordinatoriArea;  
        listaIndirizziEmail.emailTemplateRegionalManager=emailTemplateRegionalManager;  
        return listaIndirizziEmail;
    } 


    
    @AuraEnabled   
    public static void assegnaPraticheEAttivitaAllaCodaeInviaEmail(Map<String,String> emailFiliali, Map<String,String> emailCoordinatoriArea, Map<String,String> emailRegionalManager){
        
        Case ultimoCase = [SELECT Id, FlagEmailInviate__c FROM Case 
                            WHERE ActivityType__c = 'SFA_PRAIRRPARENT'AND Status='Closed'
                            ORDER BY CreatedDate DESC][0];
        Id ultimoCaseId=ultimoCase.Id;
        
        
        List<Case> caseFigli = [SELECT Id FROM Case WHERE ParentId = :ultimoCaseId];  
        Set<Id> caseFigliParentId=new Set<Id>();
        for(Case caseFiglio:caseFigli){
            caseFigliParentId.add(caseFiglio.Id);               
        }
   
        
        List<SFA_PraticaIrregolare__c> praticheOK = [SELECT Id, EsitoCaricamento__c, CodiceDealer__c,ActivityId__c 
                                                   FROM SFA_PraticaIrregolare__c WHERE EsitoCaricamento__c =: 'Pratica caricata' 
                                                   AND ActivityId__c IN :caseFigliParentId];   
        
        List<Case> lstAttivita = [SELECT Id, ParentId, OwnerId,ActivityType__c 
                                                   FROM Case WHERE ActivityType__c = 'SFA_PRAIRR' 
                                                   AND ParentId=:ultimoCase.Id];        
        
        List<Group> lstCoda =GroupUtils.getQueueList();  
        List<Account> lstDealer = [SELECT Id, OCS_External_Id__c, Branch__r.OCS_External_Id__c 
                                   FROM Account WHERE RecordType.Name = 'Dealer'];  //seleziona la lista di dealer dagli account
        List<Id> lstBranch = new List<Id>();
        List<String> lstOCSExternalIdBranch = new List<String>();
        for (SFA_PraticaIrregolare__c pratica : praticheOK) {
            for (Account dealer : lstDealer) {    
                if (dealer.OCS_External_Id__c == 'D' + pratica.CodiceDealer__c) {
                    for (Group coda : lstCoda) {
                        if (coda.DeveloperName == dealer.Branch__r.OCS_External_Id__c) {
                            for (Case attivita: lstAttivita){
                                if(pratica.ActivityId__c==attivita.Id){
                                    attivita.OwnerId=coda.Id;
                                    break;
                                }
                            }
                            break;
                        }
                    }
                    break;
                }
            }             
        }   
        update lstAttivita;
    
		
        List<String> indirizziMailFiliali = new List<String>();
        for (String mapID:emailFiliali.keyset() ){
         	indirizziMailFiliali.add(emailFiliali.get(mapID));
        }                       
        
        List<String> indirizziMailCoordinatori = new List<String>();
        for (String mapID:emailCoordinatoriArea.keyset() ){
         	indirizziMailCoordinatori.add(emailCoordinatoriArea.get(mapID));
        }
 
        List<String> indirizziMailRegional = new List<String>();
        for (String mapID:emailRegionalManager.keyset() ){
         	indirizziMailRegional.add(emailRegionalManager.get(mapID));
        }
        
        

        String emailTemplateFiliale='SFA_PraticaIrregolare_MailFiliale';
        Messaging.SingleEmailMessage messageMailsFiliali = EmailUtils.generateEmail(emailTemplateFiliale,indirizziMailFiliali,ultimoCase.Id);      
		EmailUtils.sendEmail(messageMailsFiliali); 
        
        //Email ai coordinatori d'area
        String emailTemplateCoordinatoreArea='SFA_PraticaIrregolare_MailArea';   
        Messaging.SingleEmailMessage messageMailsCoordinatoriArea = EmailUtils.generateEmail(emailTemplateCoordinatoreArea,indirizziMailCoordinatori,ultimoCase.Id);       
		EmailUtils.sendEmail(messageMailsCoordinatoriArea);         
       
        //Email ai regional manager
        String emailTemplateRegionalManager='SFA_PraticaIrregolare_MailRegional';
        Messaging.SingleEmailMessage messageMailsRegionalManager = EmailUtils.generateEmail(emailTemplateRegionalManager,indirizziMailRegional,ultimoCase.Id);      
		EmailUtils.sendEmail(messageMailsRegionalManager);   
        
		ultimoCase.FlagEmailInviate__c=true;
        update ultimoCase; 

    } 
    
	public class ListaIndirizziEmail {
		@AuraEnabled
        public Map<String,String> emailFiliali {get; set;}
		@AuraEnabled
        public Map<String,String> emailCoordinatoriArea {get; set;}
		@AuraEnabled
        public Map<String,String> emailRegionalManager {get; set;}
		@AuraEnabled
        public String emailTemplateFiliale {get; set;}  
		@AuraEnabled
        public String emailTemplateCoordinatoriArea {get; set;} 
		@AuraEnabled
        public String emailTemplateRegionalManager {get; set;}         
    }
  
}