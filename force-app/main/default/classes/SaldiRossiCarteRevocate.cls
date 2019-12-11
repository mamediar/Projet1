public class SaldiRossiCarteRevocate implements Schedulable {
    
    public void execute(SchedulableContext ctx) {
        
        String destinatario = 'crm@compass.it';
        System.debug('Avviamento...');
        final String EMPTY_STRING = ''; 
        final String ZERO_VALUE = '0';
        final String NUM_PRATICA_003 = '003';
        String strFlagError = EMPTY_STRING;   
        List<Messaging.SingleEmailMessage> emailToSend = new List<Messaging.SingleEmailMessage>();
        
        OCSRecuperaSaldiRossiCarteRevocateRes data;
        
        try {
            data = OCSRecuperaSaldiRossiInvoker.recuperaSaldiRossiCarteRevocate();
        } catch (Exception e) {
            strFlagError = e.getMessage();
        }
        
        if (EMPTY_STRING.equals(strFlagError)) {
            
            Datetime executionDate = Datetime.now();
            Integer executionDay = executionDate.day();
            Boolean isFirstDay = (executionDay == 1) ? true : false;
            List<OCSRecuperaSaldiRossiCarteRevocateRes.SaldoRossoDTO> saldiRossiJson = data.recuperaSaldiRossiResponse.elencoSaldiRossi;
            if ((saldiRossiJson != null) && (saldiRossiJson.size() > 0)) {
                
                Database.executeBatch(new BatchSaldiRossi(saldiRossiJson), 100);
                                      
            } else {
                //il servizio soap è andato a buon fine ma non ci sono risultati
                strFlagError = 'Attenzione. Nessun saldo rosso carte revocate presente.';
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses = new String[]{destinatario};
                mail.setToAddresses(toAddresses);mail.setSubject('Compass: Recupero Saldi Rossi carte revocate TERMINATO');mail.setPlainTextBody(strFlagError);
                emailToSend.add(mail); 
            }
            
        } else {
            //strFlagError valorizzato dal servizio soap iniziale andato in errore.
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[]{destinatario};
            mail.setToAddresses(toAddresses);mail.setSubject('Compass: Recupero Saldi Rossi carte revocate ERRORE');mail.setPlainTextBody('Errore lettura saldi:' + strFlagError);
            emailToSend.add(mail);
        } 
        
        if ((emailToSend != null) && (emailToSend.size() > 0)) {
                EmailUtils.sendEmail(emailToSend);
        }
        
    }
    
}