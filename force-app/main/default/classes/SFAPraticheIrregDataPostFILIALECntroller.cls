public class SFAPraticheIrregDataPostFILIALECntroller {
  @AuraEnabled
  public static Boolean disabilitaBottone(String praticaId) {
	Boolean disabilita=true;  
    Date today=Date.today();
    SFA_PraticaIrregolare__c pratica=[SELECT Id,Status__c,DataTermineLavoro__c,RiscontroFinale__c FROM SFA_PraticaIrregolare__c WHERE Id = :praticaId];

    if ((((pratica.Status__c == 'Pratica - da Gestire' || pratica.Status__c == 'Pratica - Richiesta Maggiori Informazioni')&& pratica.RiscontroFinale__c!='RIC') || pratica.RiscontroFinale__c=='INF' || pratica.RiscontroFinale__c=='POS') && today<pratica.DataTermineLavoro__c) {
        disabilita=false;}
    return disabilita;
      
  }
    
  @AuraEnabled
  public static String salvaDataPosticipoRichiestaFiliale(String praticaId, String dataPosticipoRichiestaString) {
    String messaggio;
    Date dataPosticipoRichiesta = Date.valueOf(dataPosticipoRichiestaString);
    Date today=Date.today();
    SFA_PraticaIrregolare__c pratica=[SELECT Id, DataPosticipoRichiestadaFiliale__c, Status__c, DataTermineLavoro__c,FlagPosticipoRichiesto__c,RiscontroFinale__c FROM SFA_PraticaIrregolare__c WHERE Id = :praticaId];      
    if ((((pratica.Status__c == 'Pratica - da Gestire' || pratica.Status__c == 'Pratica - Richiesta Maggiori Informazioni')&& pratica.RiscontroFinale__c!='RIC') || pratica.RiscontroFinale__c=='INF' || pratica.RiscontroFinale__c=='POS') && today<pratica.DataTermineLavoro__c) {
      	pratica.DataPosticipoRichiestadaFiliale__c=dataPosticipoRichiesta; 
        pratica.FlagPosticipoRichiesto__c=true;
        update pratica;
        String dataPosticipo = dataPosticipoRichiesta.format();
        messaggio='La data posticipo richiesta ('+dataPosticipo+') è stata inviata a GDV.';    
        
        //recupera email filiale a cui è associato l'user
        User u = [select DefaultQueueId__c from user where id=:userinfo.getuserid()][0]; 
        List<Account> filialeUser = [SELECT id, BusinessEmail__c 
                                  	 FROM Account WHERE RecordType.Name = 'Branch' AND OCS_External_Id__c = :u.DefaultQueueId__c];
          
        //Email per richiesta data posticipo a GDV
        String emailTemplate='SFA_PraticaIrregolare_DataPosticipo';
        List<String> lstEmail= new List<String>();
        String EmailGDV= CompassParametersUtils.getValue('gdv.mail');
        lstEmail.add(EmailGDV);
        Messaging.SingleEmailMessage messageMail = EmailUtils.generateEmail(emailTemplate,lstEmail,praticaId);  
        messageMail.setSenderDisplayName(filialeUser[0].BusinessEmail__c);
        EmailUtils.sendEmail(messageMail); 
   
    } else {
        messaggio='Non è più possibile richiedere una data di posticipo.';
    }
    return messaggio; 
  }      
    
    
}