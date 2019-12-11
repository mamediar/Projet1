global class SFAListaDaSedeBatListaCheckDelete implements Database.Batchable <sObject>, Schedulable {
	
	
	global Database.QueryLocator start(Database.BatchableContext bcx){
		
		return Database.getQueryLocator([Select Id from SFA_ListaCheck__c]);
	
	}
	
	global void execute(Database.BatchableContext bcx, List<SFA_ListaCheck__c> scope){
		if(scope.size()>0){
		delete scope;
		}
	
	}
	
	global void execute(SchedulableContext sc) {
        SFAListaDaSedeBatListaCheckDelete batch = new SFAListaDaSedeBatListaCheckDelete(); 
        Database.executebatch(batch);
    }
	
	global void finish(Database.BatchableContext bcx){
		
/*
		Datetime dateNow = datetime.now();
	
	
	    //query per l'identificazione del job da inserire nella mail
	    AsyncApexJob a = [Select Id, Status, NumberOfErrors,JobItemsProcessed, TotalJobItems,CreatedDate,CompletedDate 
	              from AsyncApexJob where Id =:bcx.getJobId()];
	
	    //costruzione del messaggio email notifica
	    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	    String[] toAddresses = new String[]{'lorenzo.calo@lynxspa.com'};       //mail destinatario  
	    mail.setToAddresses(toAddresses);                                         //settaggio destinatario
	    mail.setSubject('ESECUZIONE BATCH SCHEDULATO --> RESULT');                //soggetto della mail
	    mail.setPlainTextBody('Batch schedulato: Delete degli scarti del report inserimenti' + '\n'+ '1) Numero totale job processati : '+ a.TotalJobItems + '\n'+ 
	    '2) Numero di fallimenti : '+ a.NumberOfErrors +'\n' +'3) Iniziato alle : '+ a.CreatedDate +'\n'+ '4) Finito alle : ' + a.CompletedDate);
	    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
	    
*/	
	    //creo il csv da mettere come allegato
	    /*String contentCSV ='';
	    for(SFA_ListaCheck__c errore : [Select Id,CodiceFiscale__c,ErrorMessage__c  from SFA_ListaCheck__c]){
	      	contentCSV += errore.CodiceFiscale__c + ',' + errore.OCS_Code__c + ',' + errore.ErrorMessage__c + ',' + errore.SFA_ListeCaricate__c + ','+'\n';
	    }
	    String content = 'Codice Fiscale, Codice OCS, Errore, Lista di Riferimento \n' + contentCSV;
	
	    Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
	    attachment.setFileName( 'DeleteLog ' + dateNow +'.csv' );
	    attachment.setBody( Blob.valueOf( content ) );
	    mail.setFileAttachments( new Messaging.EmailFileAttachment[]{ attachment } );
	    //fine creazione allegato, eventualmente lo tolgo // 
	
	    Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage>{mail};
	    Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);*/

  }

}