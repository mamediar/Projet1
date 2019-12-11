public class ReclamiTriggerHandler extends TriggerHandler{

    public override void afterUpdate(){
        ReclamiTriggerHandler.sendMail((Map<Id, Case>)Trigger.oldMap,(Map<Id, Case>) Trigger.newMap);
    }
    
    
    public static void sendMail(Map<Id, Case> oldMap, Map<Id, Case> newMap){
        List<Case> newCaseList = [Select id, ownerId, Referenced_company__c,Account_Futuro_MBCS__c, CaseNumber, owner.email, NumeroPratica__c, Scadenza_Reclamo__c, Categoria_Riferimento__r.Name, Account.name, Account_Futuro_MBCS__r.FirstName__c, Account_Futuro_MBCS__r.LastName__c from Case where id = :newMap.keySet() and recordtype.name = 'CRM_Reclami'];
        if(newCaseList == null || newCaseList.size() ==0 || newCaseList.size() > 1)  return;
        List<Case> sendMail = new List<Case>();
        Case nuovo =  newCaseList[0];
        String nome= ' ';
        Case old = oldMap.get(nuovo.id);
        if(old.OwnerId!= null && (old.OwnerId+'').startsWith('00G') && (nuovo.OwnerId+'').startsWith('00G') && old.OwnerId != nuovo.OwnerId){
            EmailTemplate email = [Select id, name, body from emailtemplate where name = 'Cambio Coda'];
            if(nuovo.Referenced_company__c == 'Futuro'){
                if(nuovo.Account_Futuro_MBCS__c != null){
                    nome =nuovo.Account_Futuro_MBCS__r.FirstName__c +' '+nuovo.Account_Futuro_MBCS__r.LastName__c;
                    email.body= email.body.replace('{!Case.Account}', nome);
                }
            } 
            else email.body= email.body.replace('{!Case.Account}', nuovo.Account.Name);
            email.body= email.body.replace('{!Case.NumeroPratica__c}', nuovo.NumeroPratica__c);
            email.body= email.body.replace('{!Case.Categoria}', nuovo.Categoria_Riferimento__r.Name);
            String data = '';
            if(nuovo.Scadenza_Reclamo__c != null){
              Datetime t = Datetime.newInstance(nuovo.Scadenza_Reclamo__c.year(), nuovo.Scadenza_Reclamo__c.month(), nuovo.Scadenza_Reclamo__c.day());  
                data = t.format('dd/MM/yyyy');
            }
            email.body= email.body.replace('{!Case.Scadenza_Reclamo__c}', data);
            


            
            Messaging.SingleEmailMessage sendEmail = new Messaging.SingleEmailMessage();
             String mockmail = CompassParametersUtils.getValue('inviomail.mock');
            List<String> to = new List<String>();
            if(!String.isEmpty(mockmail)){
                to.add(mockmail);
                sendEmail.setToAddresses(to);
            }
            else{
				 to.add(nuovo.OwnerId);
                sendEmail.setToAddresses(to);
            } 
            
            sendEmail.setPlainTextBody(email.body);
            String name = nuovo.Referenced_Company__c == 'Futuro' ? nome : nuovo.Account.Name;
            sendEmail.setSubject( 'Nuovo reclamo '+nuovo.CaseNumber+' - '+ name +' – '+nuovo.NumeroPratica__c);
            List<Messaging.SingleEmailMessage> lista = new List<Messaging.SingleEmailMessage>();
            lista.add(sendEmail);
            System.debug('Email Inviata '+to);
            System.debug(email.body);
            Messaging.sendEmail(lista);    
        }
        
    }    
}