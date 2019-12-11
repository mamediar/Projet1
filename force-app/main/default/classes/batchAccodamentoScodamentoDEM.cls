/**
 * @File Name          : batchAccodamentoScodamentoDEM.cls
 * @Description        : 
 * @Author             : CISSE Ahmet
 * @Group              : 
 * @Last Modified By   : CISSE Ahmet
 * @Last Modified On   : 23/09/2019 à 13:38:39
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    26/06/2019 à 08:26:43   CISSE Ahmet     Initial Version
**/

global class batchAccodamentoScodamentoDEM implements Database.Batchable < sObject > ,Database.Stateful {

	// Constructor
	public batchAccodamentoScodamentoDEM() {}

	global Database.QueryLocator start(Database.BatchableContext bc) 
    {
		//String query = 'Select Id, FirstName, email, DEM_Value__c, DEM_Da_Inviare__c, Ultima_DEM_Inserita__c, DEM_Param_1_del__c, DEM_Param_2__c, DEM_Param_3__c, DEM_Param_4__c, DEM_Param_5__c, AccountId From Contact';
        String query = 'Select Id,FirstName,PersonEmail, DEM_Value__pc, DEM_Da_Inviare__pc, Ultima_DEM_Inserita__pc, DEM_Param_1_del__pc,'+
                       'DEM_Param_2__pc, DEM_Param_3__pc, DEM_Param_4__pc, DEM_Param_5__pc, PersonContactId,'+
                       'DEM_Param_6__pc, DEM_Param_7__pc, DEM_Param_8__pc, DEM_Param_9__pc, DEM_Param_10__pc '+
                       'From Account WHERE Recordtype.Name = \'Person Account\' AND DEM_Da_Inviare__pc = true ';

        System.debug(Database.getQueryLocator(query));
		return Database.getQueryLocator(query);
	}

	global void execute(Database.BatchableContext bc, List < Account > scope) 
    {
        system.debug('11_10_2019 scope->'+scope);
		// process each batch of records
		List < AccountRichiesteDEM__c > accountRichiesteDEMs = [ SELECT Id,DEM_Value__c,DEM_Param_1__c,DEM_Param_2__c, 
                                                                        DEM_Param_3__c,DEM_Param_4__c,DEM_Param_5__c, 
                                                                        DEM_Data_invio__c, Account__c, Account__r.PersonEmail 
                                                                 FROM AccountRichiesteDEM__c 
                                                                 WHERE Account__c IN : scope AND Account__c != null ];
                                                                //DEM_Data_invio__c = :Date.today()];

		List < Account > contactsToUpdate = new List < Account > ();
		List < AccountRichiesteDEM__c > accountRichiesteDEMsToDelete = new List < AccountRichiesteDEM__c > ();
        Map<Id,List<AccountRichiesteDEM__c>> MappPersonAccRichiesteDEM = new Map<Id,List<AccountRichiesteDEM__c>>();
        Messaging.SingleEmailMessage[] messages = new List < Messaging.SingleEmailMessage >();

        system.debug('09_10_2019 accountRichiesteDEMs->'+accountRichiesteDEMs);
        
        
        
		if( accountRichiesteDEMs.size() > 0 && scope.size() > 0 ) 
        {
			for( Integer i = 0; i < accountRichiesteDEMs.size() ; i++ ) 
            {
                if( !MappPersonAccRichiesteDEM.containsKey( accountRichiesteDEMs[i].Account__c ) )
                {
                    
                    List<AccountRichiesteDEM__c> ListAccRichDEM = new List<AccountRichiesteDEM__c>();
                    ListAccRichDEM.add( accountRichiesteDEMs[i] );
                    MappPersonAccRichiesteDEM.put( accountRichiesteDEMs[i].Account__c , ListAccRichDEM );
                
                }else{
                            
                    List<AccountRichiesteDEM__c> ListAccRichDEM2 = MappPersonAccRichiesteDEM.get( accountRichiesteDEMs[i].Account__c );
                    ListAccRichDEM2.add( accountRichiesteDEMs[i] );
                    MappPersonAccRichiesteDEM.put( accountRichiesteDEMs[i].Account__c , ListAccRichDEM2 );
                        
                }
				
			}
		}
		
        System.debug('10_10_2019 MappPersonAccRichiesteDEM->'+MappPersonAccRichiesteDEM);
        for( Account Acc : scope )
        {
             List<AccountRichiesteDEM__c> ListAccRichDEMAcc = MappPersonAccRichiesteDEM.get( Acc.Id );
            
             //Caso quando DEM_Da_Inviare__pc == true 
             if( Acc.DEM_Da_Inviare__pc == true )
             {
                     //Ci sono AccountRichiesteDEM da gestire nella coda 
                     if( ListAccRichDEMAcc != null && ListAccRichDEMAcc.size() > 0 )
                     {
                         for( AccountRichiesteDEM__c AccRichiesteDEM : ListAccRichDEMAcc )
                         {
                              if( AccRichiesteDEM.DEM_Value__c != null )
                              {
                                  messages.add( sendRelatedContactNotification( Acc , AccRichiesteDEM.DEM_Value__c ) );
                                  //sendRelatedContactNotification( Acc , AccRichiesteDEM.DEM_Value__c );
                                  accountRichiesteDEMsToDelete.add( AccRichiesteDEM );
                              }
                         }
                     }
             
                 //Invio Mail per quel PersonAccount con DEM_Da_Inviare__pc == true
                 if( Acc.DEM_Value__pc != null )
                 {
                 messages.add( sendRelatedContactNotification( Acc , Acc.DEM_Value__pc ) );
                 }
                 //Sbiancamento Campi PersonAcc
                 Acc.DEM_Da_Inviare__pc  = false;
                 Acc.DEM_Param_1_del__pc = '';
                 Acc.DEM_Param_2__pc     = '';
                 Acc.DEM_Param_3__pc     = '';
                 Acc.DEM_Param_4__pc     = '';
                 Acc.DEM_Param_5__pc     = '';
                 Acc.DEM_Value__pc       = '';
                 Acc.DEM_Param_6__pc     = '';
                 Acc.DEM_Param_7__pc     = '';
                 Acc.DEM_Param_8__pc     = '';
                 Acc.DEM_Param_9__pc     = '';
                 Acc.DEM_Param_10__pc    = '';
                 contactsToUpdate.add( Acc );
                       
              }
                
        }
        
        //Invio Email
         Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        
        //Cancellazione Record di Dem
        if( accountRichiesteDEMsToDelete != null && accountRichiesteDEMsToDelete.size() > 0 )
            delete accountRichiesteDEMsToDelete;
        
        //Aggiornamento Record 
        if( contactsToUpdate != null && contactsToUpdate.size() > 0 )
            update contactsToUpdate;
        
       
	}

	global void finish(Database.BatchableContext bc) 
    {}

	//This metode will be called in execute for updating a contact after checking the conditions
	public static Contact updateRelatedContact( Id idContact, String nameOfCampaign, String demParam1, String demParam2, 
                                                String demParam3, String demParam4, String demParam5 )
    {

		Contact con = new Contact();

		con.Id = idContact;
		con.DEM_Param_1_del__c = demParam1;
		con.DEM_Param_2__c = demParam2;
		con.DEM_Param_3__c = demParam3;
		con.DEM_Param_4__c = demParam4;
		con.DEM_Param_5__c = demParam5;
		con.DEM_Value__c = nameOfCampaign;

		//Reset ultimaDEMinserita
		con.Ultima_DEM_Inserita__c = Datetime.now();
		con.DEM_Da_Inviare__c = true;

		return con;
	}

	//This metode will be called in execute for sending a mail to contact.email
	public static Messaging.SingleEmailMessage sendRelatedContactNotification(Account contact , String NomeTemplate) 
    {
           system.debug('--10_10_2019--');
		   Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
		   message.setTargetObjectId(contact.PersonContactId);
		   message.setSenderDisplayName('Compass Support');
		   message.setReplyTo('no-reply@compass.com');
		   message.setUseSignature(false);
		   message.setBccSender(false);
		   message.setSaveAsActivity(false);

		   EmailTemplate emailTemplate = [ SELECT Id, Subject, Description, HtmlValue, DeveloperName, Body 
                                           FROM EmailTemplate 
                                           WHERE name =: NomeTemplate ];// 'DEM2063'];
		
           message.setTemplateID(emailTemplate.Id);
		   message.setWhatId(contact.Id/*contact.AccountId*/); //This is important for the merge fields in template to work
		   message.toAddresses = new String[] { contact.PersonEmail };
           
           String emailBody = emailTemplate.Body;
           String emailSubject = emailTemplate.Subject;

           /*
           emailBody = emailBody.Replace('{!License__c.Account_Name__c}', lc.Account_Name__c );


           for (String key : emailMessageWrapper.ParameterBodyMap.keySet()) 
           {
  31:             htmlBody = htmlBody.replace(key, (emailMessageWrapper.ParameterBodyMap.get(key) == null) ? '' : emailMessageWrapper.ParameterBodyMap.get(key));
  32:             plainBody = plainBody.replace(key, (emailMessageWrapper.ParameterBodyMap.get(key) == null) ? '' : emailMessageWrapper.ParameterBodyMap.get(key));
  33:         }
           HtmlValue */
           return message;
           /*
		   Messaging.SingleEmailMessage[] messages = new List < Messaging.SingleEmailMessage > { message };
               
               
		   Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);

		   if( results[0].success ) 
           {
			   System.debug('The email was sent successfully.');
		   }else{
			   System.debug('The email failed to send: ' + results[0].errors[0].message);
		   }*/
	}

}