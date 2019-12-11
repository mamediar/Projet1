public class SFAPraticheIrregNoteFILIALEController {

    @AuraEnabled
    public static List<ContentDocument> getAllNotes(String praticaId)
        { 
        List<ContentDocument> notes= new List<ContentDocument>();
		notes=XCSNoteUtils.getAllNotesByContentDocument(praticaId);
        return notes;            
        }
    

    
    @AuraEnabled
    public static List<ContentDocument> insertNote(String body, String praticaId) {
  
        ContentNote cn = new ContentNote();
        User u = [select firstname, lastname, DefaultQueueId__c from user where id=:userinfo.getuserid()][0]; 
        List<Account> filialeUser = [SELECT id, Name, OCS_External_Id__c, RecordType.Name, BusinessEmail__c 
                       FROM Account WHERE RecordType.Name = 'Branch' AND OCS_External_Id__c = :u.DefaultQueueId__c];         
        String title;
        if (string.isEmpty(u.DefaultQueueId__c) || filialeUser.size()<1){
            title =u.firstname+' '+u.lastname;
        } else {
            title =filialeUser[0].Name;
        }
        
        
        SFA_PraticaIrregolare__c pratica = [select Id, UltimaNotaInseritaDaFiliale__c, IsNotaFilialeInserita__c from SFA_PraticaIrregolare__c 
                                            where id=:praticaId]; 
 
        pratica.UltimaNotaInseritaDaFiliale__c=body;
        pratica.IsNotaFilialeInserita__c=true;
        update pratica;
        
 
        
        XCSNoteUtils.postaNoteInContentDocument(praticaId,title,body);   

        
        //Email a GDV per conferma pratica
        String emailTemplate='SFA_PraticaIrregolare_NotaInserita';
        List<String> lstEmail= new List<String>();
        String EmailGDV= CompassParametersUtils.getValue('gdv.mail');
        lstEmail.add(EmailGDV);
        Messaging.SingleEmailMessage messageMail = EmailUtils.generateEmail(emailTemplate,lstEmail,praticaId);  
        if (string.isEmpty(u.DefaultQueueId__c) || filialeUser.size()<1){
        	messageMail.setSenderDisplayName(u.firstname+' '+u.lastname);
        } else {
            messageMail.setSenderDisplayName(filialeUser[0].BusinessEmail__c);
        }
        EmailUtils.sendEmail(messageMail); 
        
             
		//recupera tutte le note allegate alla pratica:
		List<ContentDocument> notes= new List<ContentDocument>(); 
		notes=XCSNoteUtils.getAllNotesByContentDocument(praticaId);
        return notes;           
    }

      @AuraEnabled
      public static Boolean disabilitaBottone(String praticaId) {
        Boolean disabilita=true;  
        Date today=Date.today();
        SFA_PraticaIrregolare__c pratica=[SELECT Id,Status__c,DataTermineLavoro__c,RiscontroFinale__c FROM SFA_PraticaIrregolare__c WHERE Id = :praticaId];
 
        
        if (((pratica.Status__c == 'Pratica - da Gestire' || pratica.Status__c == 'Pratica - Richiesta Maggiori Informazioni' || pratica.RiscontroFinale__c == 'POS' || pratica.RiscontroFinale__c == 'INF') && pratica.RiscontroFinale__c != 'RIC') && today<pratica.DataTermineLavoro__c) {
            disabilita=false;}

          
        return disabilita;
          
      }

}