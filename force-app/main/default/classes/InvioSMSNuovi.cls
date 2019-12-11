public class InvioSMSNuovi implements Schedulable {
    
    //esecuzione dal lunedì al venerdi dalle 09.00 alle 16.00, ogni 4 minuti
    public void execute(SchedulableContext ctx) {
        
        final integer MAX_ROWS = 800;
        
        final String SMS_TEMPLATE_RITORNI_POSTALI = 'SMS.NuoviRitorniPostali';
        String strQueueID = GroupUtils.getQueue(RitorniPostaliUtils.QUEUE_RITORNI_POSTALI_VERIFICA_INDIRIZZO).id;
        List<RitorniPostali__c> ritorniDaProcessare = [Select Id, OCSAnag__c, QueueId__c, SmsSent__c, CellPhone__c, Processato__c 
                                                       from RitorniPostali__c 
                                                       where QueueId__c = :strQueueID and SmsSent__c = 0 and Processato__c = 1 and CellPhone__c != Null order by OCSAnag__c limit :MAX_ROWS];
           
        if (!(ritorniDaProcessare.isEmpty())) {
            
            String strSMSMessageTemplate = XCS_TemplateUtils.getBody(SMS_TEMPLATE_RITORNI_POSTALI);
            List<XCS_Messaggio__c> listSMSNuovi = new List<XCS_Messaggio__c>();
            List<XCS_Messaggio__c> listaOCSNote = new List<XCS_Messaggio__c>();
            String strUserAlias = [select Alias from User where Id=:UserInfo.getUserId()].Alias;
            RecordType rt = [Select id from RecordType where DeveloperName = 'Note' and SobjectType = 'XCS_Messaggio__c' ];
            for (RitorniPostali__c ritorno : ritorniDaProcessare) {
                
                listSMSNuovi.add(OCSInviaSMSInvoker.createSMSMessage(ritorno.CellPhone__c, strSMSMessageTemplate));
                ritorno.SmsSent__c = 1;
                String strNotaOCS = 'Inviato SMS al ' + ritorno.CellPhone__c + ' : ' + strSMSMessageTemplate;
                listaOCSNote.add(OCSGestioneNoteInvoker.createOCSNote(rt, strUserAlias, 
                                                          ritorno.OCSAnag__c, 
                                                          '', 
                                                          '', 
                                                          'A', 
                                                          'P', 
                                                          strNotaOCS));
            }          
            
			insert listSMSNuovi;
            update ritorniDaProcessare;
            insert listaOCSNote;
            
        }
        
    }

}