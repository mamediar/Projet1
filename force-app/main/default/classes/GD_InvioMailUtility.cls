public class GD_InvioMailUtility {

    public static void sendAlert(List<Messaging.SingleEmailMessage> lstMsgs, IVASS_Dealer_courses_Iscritti__c iscritto, IVASS_Dealer_courses_Sollecito__c sollecito, String[] sendingTo) {
        String html = '<p><table border style="border-collapse: collapse;">' +
		'<tbody><tr><th style="border: 1px solid;">'+ sollecito.Descrizione_Corso__c +
        '</th> <th style="border: 1px solid;">'+ iscritto.Stato_Corso__c +'</th></tr><tr>'+
		'</tbody></table></p>';
		String body = lstMsgs[0].getHTMLBody();
		body = body.replace('table_corso', html);
		body = body.replace('Nome__cVariable', iscritto.Nome__c);
		body = body.replace('Cognome_variable', iscritto.Cognome__c);
        String plainTextBody = lstMsgs[0].getPlainTextBody();
        plainTextBody = plainTextBody.replace('table_corso', html);
		plainTextBody = plainTextBody.replace('Nome__cVariable', iscritto.Nome__c);
		plainTextBody = plainTextBody.replace('Cognome_variable', iscritto.Cognome__c);
        // For each SingleEmailMessage that was just populated by the sendEmail() method, copy its
        // contents to a new SingleEmailMessage. Then send those new messages.
        //String[] sendingTo = new String[] {'khadimrassoulndeye@gmail.com', 'khadimrassoul.ndeye@terangacloud.com'};
		List<Messaging.SingleEmailMessage> lstMsgsToSend = new List<Messaging.SingleEmailMessage>();
        /* for (Messaging.SingleEmailMessage email : lstMsgs) {
            Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
            emailToSend.setToAddresses(sendingTo);
            emailToSend.setPlainTextBody(plainTextBody);
            emailToSend.setHTMLBody(body);
            emailToSend.setSubject(email.getSubject());
			emailToSend.setSenderDisplayName('Ivass COMPASS');
			//emailToSend.setReplyTo('no-reply@company.com');
			emailToSend.setUseSignature(false);
			emailToSend.setBccSender(false);
			emailToSend.setSaveAsActivity(false);
            lstMsgsToSend.add(emailToSend);
        } */
       // system.debug('06_11_2019 Destinatari_Sollecito__c>>>'+sollecito.Destinatari_Sollecito__c);
       // system.debug('06_11_2019 iscritto>>> '+iscritto.Nome__c +' '+iscritto.Cognome__c);
       // system.debug('06_11_2019 sendingTo>>>'+sendingTo);
        system.debug('08_11_2019 sendingTo->'+sendingTo);
        Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
        emailToSend.setToAddresses(sendingTo);
        emailToSend.setPlainTextBody(plainTextBody);
        emailToSend.setHTMLBody(body);
        emailToSend.setSubject(lstMsgs[0].getSubject());
        emailToSend.setSenderDisplayName('Ivass COMPASS');
        emailToSend.setReplyTo('no-reply@ivasscompass.com');
        emailToSend.setUseSignature(false);
        emailToSend.setBccSender(false);
        emailToSend.setSaveAsActivity(false);
        lstMsgsToSend.add(emailToSend);
        Messaging.sendEmail(lstMsgsToSend);
        //Messaging.SendEmailResult[] result = Messaging.sendEmail(lstMsgsToSend, false);


        /* Messaging.Email[] messages = new Messaging.Email[0];
        for(...) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        // Set mail parameters
        messages.add(mail);
        }
        Messaging.sendEmail(messages); */
	}
     public static void sendAlertFromDealerIsvapUplodFile(List<Messaging.SingleEmailMessage> lstMsgs, IVASS_Dealer_courses_Iscritti__c iscritto, IVASS_Dealer_Courses__c corso, String[] sendingTo) {

		String body = lstMsgs[0].getHTMLBody();
		body = body.replace('GD_email referente', sendingTo[0]);
		body = body.replace('GD_nome_corso', corso.Name);
		body = body.replace('GD_cognome', iscritto.Nome__c);
		body = body.replace('GD_nome', iscritto.Cognome__c);
        String plainTextBody = lstMsgs[0].getPlainTextBody();
		plainTextBody = plainTextBody.replace('GD_nome_corso', corso.Name);
		plainTextBody = plainTextBody.replace('GD_cognome', iscritto.Cognome__c);
		plainTextBody = plainTextBody.replace('GD_nome', iscritto.Nome__c);
        // For each SingleEmailMessage that was just populated by the sendEmail() method, copy its
        // contents to a new SingleEmailMessage. Then send those new messages.
        //String[] sendingTo = new String[] {'khadimrassoulndeye@gmail.com', 'khadimrassoul.ndeye@terangacloud.com'};
		List<Messaging.SingleEmailMessage> lstMsgsToSend = new List<Messaging.SingleEmailMessage>();
        /* for (Messaging.SingleEmailMessage email : lstMsgs) {
            Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
            emailToSend.setToAddresses(sendingTo);
            emailToSend.setPlainTextBody(plainTextBody);
            emailToSend.setHTMLBody(body);
            emailToSend.setSubject(email.getSubject());
			emailToSend.setSenderDisplayName('Ivass COMPASS');
			//emailToSend.setReplyTo('no-reply@company.com');
			emailToSend.setUseSignature(false);
			emailToSend.setBccSender(false);
			emailToSend.setSaveAsActivity(false);
            lstMsgsToSend.add(emailToSend);
        } */

        Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
            emailToSend.setToAddresses(sendingTo);
            emailToSend.setPlainTextBody(plainTextBody);
            emailToSend.setHTMLBody(body);
            emailToSend.setSubject(lstMsgs[0].getSubject());
			emailToSend.setSenderDisplayName('Ivass COMPASS');
			emailToSend.setReplyTo('no-reply@ivasscompass.com');
			emailToSend.setUseSignature(false);
			emailToSend.setBccSender(false);
			emailToSend.setSaveAsActivity(false);
            lstMsgsToSend.add(emailToSend);
            Messaging.sendEmail(lstMsgsToSend);
        //Messaging.SendEmailResult[] result = Messaging.sendEmail(lstMsgsToSend, false);


        /* Messaging.Email[] messages = new Messaging.Email[0];
        for(...) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        // Set mail parameters
        messages.add(mail);
        }
        Messaging.sendEmail(messages); */
	}
    
    public static List<Messaging.SingleEmailMessage> setupEmail(IVASS_Dealer_courses_Iscritti__c iscritto, Id templateId){
        Contact c = [select id, Email from Contact where email <> null limit 1];
       // system.debug('--contact--'+c);
        // Construct the list of emails we want to send
        List<Messaging.SingleEmailMessage> lstMsgs = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
        // Get the email sender
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'noreplymailr1dev@gmail.com'];
        if ( owea.size() > 0 ) {
            msg.setOrgWideEmailAddressId(owea.get(0).Id);
        }
        msg.setTemplateId(templateId);   
        msg.setWhatId(iscritto.Referente__c);
        msg.setTargetObjectId(c.id);        
        lstMsgs.add(msg);
        // Send the emails in a transaction, then roll it back
        Savepoint sp = Database.setSavepoint();
        Messaging.sendEmail(lstMsgs);
        Database.rollback(sp);
        return lstMsgs;
    }
    public static List<Messaging.SingleEmailMessage> setupEmailFromDealerIsvapUplodFile(Account acc, Id templateId){
        Contact c = [select id, Email from Contact where email <> null limit 1];
        // Construct the list of emails we want to send
        List<Messaging.SingleEmailMessage> lstMsgs = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
        // Get the email sender
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'noreplymailr1dev@gmail.com'];
        if ( owea.size() > 0 ) {
            msg.setOrgWideEmailAddressId(owea.get(0).Id);
        }
        msg.setTemplateId(templateId);   
        msg.setWhatId(acc.Id);
        msg.setTargetObjectId(c.id);        
        lstMsgs.add(msg);
        // Send the emails in a transaction, then roll it back
        Savepoint sp = Database.setSavepoint();
        Messaging.sendEmail(lstMsgs);
        Database.rollback(sp);
        return lstMsgs;
    }
}