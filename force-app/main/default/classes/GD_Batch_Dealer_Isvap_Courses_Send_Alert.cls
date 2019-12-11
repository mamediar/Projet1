global class GD_Batch_Dealer_Isvap_Courses_Send_Alert implements Database.Batchable<sObject>, Database.Stateful {

global Integer recordsProcessed = 0;
global Boolean sendMail = false;
global Integer days;
global List<IVASS_Dealer_courses_Sollecito__c> sollecitoProcessed = new  List<IVASS_Dealer_courses_Sollecito__c>() ;
global List<IVASS_Dealer_courses_Sollecito__c> allSollecito = new  List<IVASS_Dealer_courses_Sollecito__c>() ;
global List<IVASS_Dealer_courses_Iscritti__c> allIscritto= new  List<IVASS_Dealer_courses_Iscritti__c>() ;
global Messaging.SendEmailResult[] result;
global Database.QueryLocator start(Database.BatchableContext bc) {
	return Database.getQueryLocator(
		'SELECT Id, Name, Corso__c, Stato_Corso__c, Corso__r.Tipo_Corso__c, Dealer__c,Cognome__c, Nome__c, Referente__c, '+
		'Referente__r.PersonEmail, Dealer__r.BusinessEmail__c '+
        'FROM IVASS_Dealer_courses_Iscritti__c WHERE Stato_Corso__c =\'ISCRITTO\' '+
		'OR  Stato_Corso__c =\'IN ITINERE\''
		);
}


global void execute(Database.BatchableContext bc, List<IVASS_Dealer_courses_Iscritti__c> scope){
	// process each batch of records
	List<Id> tipoIds = new List<Id>();
	for (IVASS_Dealer_courses_Iscritti__c iscritto : scope) {
		tipoIds.add(iscritto.Corso__r.Tipo_Corso__c);
	}
	allIscritto = scope;
	List <IVASS_Dealer_courses_Sollecito__c> solleciti = [SELECT Id, Name, Descrizione_Corso__c, Destinatari_Sollecito__c,
	                                                      Intervallo_di_alert__c, Ultimo_Invio__c, Attivo__c, Tipo_Corso__c, Tipo_Ricevente__c
	                                                      FROM IVASS_Dealer_courses_Sollecito__c WHERE Tipo_Corso__c in:tipoIds];
	allSollecito = solleciti;
	Set<IVASS_Dealer_courses_Iscritti__c> myset = new Set<IVASS_Dealer_courses_Iscritti__c>();
	List<IVASS_Dealer_courses_Iscritti__c> result = new List<IVASS_Dealer_courses_Iscritti__c>();
	myset.addAll(scope);
	result.addAll(myset);
	Date currentDate = date.today();
	for (IVASS_Dealer_courses_Iscritti__c iscritto : scope) {
		for (IVASS_Dealer_courses_Sollecito__c sollecito : solleciti) {
			if(sollecito.Tipo_Corso__c == iscritto.Corso__r.Tipo_Corso__c) {
				days = math.abs(sollecito.Ultimo_Invio__c.daysBetween(currentDate));
				if((sollecito.Attivo__c == true) && (days == integer.valueof(sollecito.Intervallo_di_alert__c))) {
					System.debug('true returned');
					System.debug('iscritto returned '+ iscritto.Dealer__c);
					sendMail = true;
					recordsProcessed = recordsProcessed + 1;
					sollecitoProcessed.add(sollecito);
					//System.debug('sollecito returned >> '+ sollecito.Destinatari_Sollecito__c);
					mailSending(sollecito, iscritto);
				}
			}
		}
	}
}

global void finish(Database.BatchableContext bc){
	System.debug('finish recordsProcessed: '+ recordsProcessed);
	System.debug('finish sendMail: '+ sendMail);
	System.debug('finish days: '+ days);
	System.debug('sollecito Processed: >>'+ sollecitoProcessed);
	System.debug('all Iscritto Processed: >>'+ allIscritto);
	System.debug('all Iscritto Processed: >>'+ allIscritto.size());
	System.debug('all Sollecito Processed: >>'+ allSollecito);
	System.debug('all Sollecito Processed: >>'+ allSollecito.size());
	/* List<Messaging.SingleEmailMessage> allMsg = new List<Messaging.SingleEmailMessage>();
	   Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	   String[] sendingTo = new String[]{'khadimrassoulndeye@gmail.com', 'khadimrassoul.ndeye@terangacloud.com'};
	   mail.setToAddresses(sendingTo);
	   mail.setSubject('Single Email message Example');
	   mail.setSaveAsActivity(false);
	   allMsg.add(mail);
	   Messaging.SendEmailResult[] result = Messaging.sendEmail(allMsg, false);
	   System.debug('result sendEmail: '+ result) ;*/
}
private static void mailSending(IVASS_Dealer_courses_Sollecito__c sollecito, IVASS_Dealer_courses_Iscritti__c iscritto){
	//if(sollecito.Attivo__c ) {
	if(sollecito.Destinatari_Sollecito__c == 'Dealer + Referente') {
		//For Reference
		/* 
		 * Select the template for the course | Template's Name = Course's Name
		 */
		EmailTemplate tempRef = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where name = 'Corsi Aggiornamento Dealer'];
		List<Messaging.SingleEmailMessage> lstMsgsRef = GD_InvioMailUtility.setupEmail(iscritto, tempRef.Id);
		/* 
		 * Pass Ref's Email from PersonEmail Field from the relations Dealer and Reference
		 */
		String[] sendingToRef = new String[] {iscritto.Referente__r.PersonEmail, iscritto.Dealer__r.BusinessEmail__c};
		//String[] sendingToRef = new String[] {'khadimrassoulndeye@gmail.com', 'khadimrassoul.ndeye@terangacloud.com'};
		GD_InvioMailUtility.sendAlert(lstMsgsRef, iscritto, sollecito, sendingToRef);

		//For Dealer
		EmailTemplate tempDea = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where name = 'Corsi Aggiornamento Dealer'];
		List<Messaging.SingleEmailMessage> lstMsgsDea = GD_InvioMailUtility.setupEmail(iscritto, tempDea.Id);
		/* 
		 * Pass Ref's Email from PersonEmail Field from the relations Dealer and Reference
		 */
		String[] sendingToDea = new String[] {iscritto.Referente__r.PersonEmail, iscritto.Dealer__r.BusinessEmail__c};
		//String[] sendingToDea = new String[] {'khadimrassoulndeye@gmail.com', 'khadimrassoul.ndeye@terangacloud.com'};
		GD_InvioMailUtility.sendAlert(lstMsgsDea, iscritto, sollecito, sendingToDea);

	} 
	else if(sollecito.Destinatari_Sollecito__c == 'Dealer')
	//else if(sollecito.Attivo__c)
	{
		//SEND EMAIL ONLY TO THE ACCOUNT of the record GD_Iscritto__c
		/* 
		 * Select the template for the course | Template's Name = Course's Name
		 */
		EmailTemplate temp = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where name = 'Corsi Aggiornamento Dealer'];
		List<Messaging.SingleEmailMessage> lstMsgs = GD_InvioMailUtility.setupEmail(iscritto, temp.Id);
		/* 
		 * Pass Ref's Email from PersonEmail Field from the relation Dealer
		 */
		String[] sendingTo = new String[] {iscritto.Dealer__r.BusinessEmail__c};
		//String[] sendingTo = new String[] {'khadimrassoulndeye@gmail.com', 'khadimrassoul.ndeye@terangacloud.com'};
		GD_InvioMailUtility.sendAlert(lstMsgs, iscritto, sollecito, sendingTo);

	}
	else if(sollecito.Destinatari_Sollecito__c == 'Referente')
	//else if(sollecito.Attivo__c)
	{
		//SEND EMAIL ONLY TO THE CONTACT of the record GD_Iscritto__c
		/* 
		 * Select the template for the course | Template's Name = Course's Name
		 */
		EmailTemplate temp = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where name = 'Corsi Aggiornamento Dealer'];
		List<Messaging.SingleEmailMessage> lstMsgs = GD_InvioMailUtility.setupEmail(iscritto, temp.Id);
		/* 
		 * Pass Ref's Email from PersonEmail Field from the relation Reference
		 */
		String[] sendingTo = new String[] {iscritto.Referente__r.PersonEmail};
		//String[] sendingTo = new String[] {'khadimrassoulndeye@gmail.com', 'khadimrassoul.ndeye@terangacloud.com'};
		GD_InvioMailUtility.sendAlert(lstMsgs, iscritto, sollecito, sendingTo);
	}

}

}