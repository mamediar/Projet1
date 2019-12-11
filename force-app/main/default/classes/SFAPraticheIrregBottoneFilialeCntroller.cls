public class SFAPraticheIrregBottoneFilialeCntroller {
  @AuraEnabled
  public static DatiPratica visualizzaBottone(String praticaId) {
	Boolean visualizza=false;  
    Date today=Date.today();
    DatiPratica datiPratica = new DatiPratica();
    SFA_PraticaIrregolare__c pratica=[SELECT Id,Status__c,DataTermineLavoro__c,RiscontroFinale__c,IsNotaFilialeInserita__c FROM SFA_PraticaIrregolare__c WHERE Id = :praticaId];
    System.debug('pratica:: '+pratica);
    if (((pratica.Status__c == 'Pratica - da Gestire' || pratica.Status__c == 'Pratica - Richiesta Maggiori Informazioni') && pratica.RiscontroFinale__c != 'RIC' && pratica.RiscontroFinale__c != 'POS' && pratica.RiscontroFinale__c != 'INF') && today<pratica.DataTermineLavoro__c) {
        datiPratica.visualizza=true;}
	datiPratica.isNotaFilialeInserita = pratica.IsNotaFilialeInserita__c;      
    return datiPratica;
      
  }
    
  @AuraEnabled
  public static void praticaGestitaFiliale(Id praticaId) {

    SFA_PraticaIrregolare__c pratica=[SELECT Id,Status__c,IsNotaFilialeInserita__c FROM SFA_PraticaIrregolare__c WHERE Id = :praticaId];
    pratica.Status__c='Pratica - Gestita filiale';
    pratica.IsNotaFilialeInserita__c = false;
    update pratica;
     
    //recupera email filiale a cui è associato l'user
    User u = [select DefaultQueueId__c from user where id=:userinfo.getuserid()][0]; 
    List<Account> filialeUser = [SELECT id, BusinessEmail__c 
                                   FROM Account WHERE RecordType.Name = 'Branch' AND OCS_External_Id__c = :u.DefaultQueueId__c];      
     
    //Email a GDV per conferma pratica
    String emailTemplate='SFA_PraticaIrregolare_ConfermaPraticaPerGDV';
    List<String> lstEmail= new List<String>();
    String EmailGDV= CompassParametersUtils.getValue('gdv.mail');
    lstEmail.add(EmailGDV);
    Messaging.SingleEmailMessage messageMail = EmailUtils.generateEmail(emailTemplate,lstEmail,praticaId);  
    messageMail.setSenderDisplayName(filialeUser[0].BusinessEmail__c);
    EmailUtils.sendEmail(messageMail); 
      
      
      
  }
    
    public class DatiPratica {
        @AuraEnabled public Boolean visualizza {get;set;}
		@AuraEnabled public Boolean isNotaFilialeInserita {get;set;} 
	}    
    
}