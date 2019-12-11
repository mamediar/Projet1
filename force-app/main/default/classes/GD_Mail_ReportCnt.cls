public with sharing class GD_Mail_ReportCnt {


@AuraEnabled
public static Map<String,object> getProfiles(){
	Map<String, Object> response = new Map<String, Object>();
	response.put('error',false);
	if (!Profile.sObjectType.getDescribe().isAccessible()) {
			throw new AuraHandledException('Non hai accesso');
    }else{
		try {
        List<Profile> profiles = [SELECT Id, Name, PermissionsEmailSingle FROM Profile  WHERE Name in ('Branch Manager', 'Area Manager', 'Trainer')];
		response.put('profiles', profiles);
		} catch (Exception e) {
			response.put('error',true);
			response.put('message',e.getMessage());
			response.put('cause',e.getCause());
			System.debug('message debug: '+e.getMessage());
			System.debug('Cause debug: '+e.getCause());
		}
    }
	return response;
}


@AuraEnabled
public static Map<String,object> sendingMail(List<Id> profileIds, String message){
	Map<String, Object> response = new Map<String, Object>();
	response.put('error',false);
	try {
        /* List<User> users = [SELECT Id, ProfileId, Username, Email, Profile.Name FROM User WHERE ProfileId in:profileIds];
		response.put('users', users); */
		String subject = 'Testing Mass email Report';
        String body = message;       
        // Create a master list to store the emails that we will send
        List<Messaging.SingleEmailMessage> masterListMails = new List<Messaging.SingleEmailMessage>();

		for (User user : [SELECT Id, ProfileId, Username, Email, Profile.Name FROM User WHERE ProfileId in:profileIds])
		{
			// Define the email
			Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 

				// Set list of peoples who should recieve an email
				List<String> sendTo = new List<String>();
				sendTo.add(user.Email);
				//sendTo.add('abdourahmane.ndiaye@terangacloud.com');
				//sendTo.add('khadimrassoul.ndeye@terangacloud.com');
				email.setToAddresses(sendTo);
				email.setSenderDisplayName('Ivass Mail Report');
				// Sets the paramaters of the email
				email.setSubject( subject ); 
				email.setPlainTextBody( body );

				// Add your email address into the master list
				masterListMails.add(email);
				response.put('message','Email sending with success');
		}
		// Sends mass emails
		Messaging.sendEmail(masterListMails);
		} catch (Exception e) {
			response.put('error',true);
			response.put('message',e.getMessage());
			response.put('cause',e.getCause());
			System.debug('message debug: '+e.getMessage());
			System.debug('Cause debug: '+e.getCause());
		}
	return response;
}

 /*public void SendEmail(List<Id> profileIds, String message)
     {
        String subject = 'Testing Mass email Report';
        String body = message;       
        // Create a master list to store the emails that we will send
        List<Messaging.SingleEmailMessage> masterListMails = new List<Messaging.SingleEmailMessage>();

        for (User user : [SELECT Id, ProfileId, Username, Email, Profile.Name FROM User WHERE ProfileId in:profileIds])
        {
           // Define the email
           Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 

            // Set list of peoples who should recieve an email
            List<String> sendTo = new List<String>();
            sendTo.add(user.Email);
            email.setToAddresses(sendTo);
			email.setSenderDisplayName('Ivass Mail Report');
			// Sets the paramaters of the email
			email.setSubject( subject ); 
			email.setPlainTextBody( body );

			// Add your email address into the master list
			masterListMails.add(email);
         }
       // Sends mass emails
       Messaging.sendEmail(masterListMails);
      }*/
}