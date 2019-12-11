/**
 * @File Name          : BatchFlagLetturaCancellazionePratica.cls
 * @Description        : 
 * @Author             : sabrina vitali
 * @Group              : 
 * @Last Modified By   : sabrina vitali
 * @Last Modified On   : 24/10/2019, 10:35:04
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    23/10/2019   sabrina vitali     Initial Version
**/
public class BatchFlagLetturaCancellazionePratica implements Database.Batchable<Case>, Database.Stateful, Database.AllowsCallouts {
    
    private final String EMPTY_STRING = ''; 
    private String strFlagError = EMPTY_STRING;    
    private String destinatario = 'crm@compass.it';    

    private List<Case> casiOCS;
    private List<OCSInfoCancPraticheFlagLetturaInvoker.CancellazionePraticaDTO> elencoPraticheDaAgg = new List<OCSInfoCancPraticheFlagLetturaInvoker.CancellazionePraticaDTO>();
    private String esitiKO = EMPTY_STRING;
    
    public BatchFlagLetturaCancellazionePratica(List<Case> casiOCS) {
        this.casiOCS = casiOCS;
    }
    
    public Iterable<Case> start(Database.BatchableContext context) {
        return this.casiOCS;
    }
    
    public void execute(Database.BatchableContext context, List<Case> casiOCS) {
        if(casiOCS.size()>0){            
            for(Case praticaOCS : casiOCS){
                System.debug('praticaOCS : ' + praticaOCS);
                //  preparo per invio lista
                OCSInfoCancPraticheFlagLetturaInvoker.CancellazionePraticaDTO pratica = new OCSInfoCancPraticheFlagLetturaInvoker.CancellazionePraticaDTO();
                pratica.numPratica = praticaOCS.NumeroPratica__c;
                pratica.tipoPratica = praticaOCS.Tipo_Pratica__c; 
                pratica.dataInserimento = DateUtils.formatDateYYYYMMDD(praticaOCS.pv_data_poste__c); 
                pratica.esito = '';
                pratica.ufficio = '';
                elencoPraticheDaAgg.add(pratica);
            }

            //richiamo servizio SOAP per impostare il flag lettura in OCS...
            //lancio qui perchè spezzetto le lista in execute, nel finish valuto il risultato finale
            if ((elencoPraticheDaAgg != null) && (elencoPraticheDaAgg.size()>0)) {
                OCSInfoCancPraticheFlagLetturaInvoker.Request req = new OCSInfoCancPraticheFlagLetturaInvoker.Request();
                req.infoCancellazionePraticheFlagLetturaRequest.elenco = elencoPraticheDaAgg;
                OCSInfoCancPraticheFlagLetturaInvoker.Response resp;

                try {
                    resp = OCSInfoCancPraticheFlagLetturaInvoker.invoke(req.infoCancellazionePraticheFlagLetturaRequest);
                } catch (Exception e) {
                    strFlagError = e.getMessage();
                    esitiKO += strFlagError + '\n';
                } finally{
                    if(''.equalsIgnoreCase(strFlagError) && resp.resultCode!= null && resp.resultCode == 0 && resp.infoCancellazionePraticheFlagLetturaResponse.elenco.size()>0){
                        //mi salvo solo gli eventuali esiti negativi
                        for(OCSInfoCancPraticheFlagLetturaInvoker.CancellazionePraticaDTO esitoFinalePratica : resp.infoCancellazionePraticheFlagLetturaResponse.elenco){
                            if('KO'.equalsIgnoreCase(esitoFinalePratica.esito)){
                                esitiKO += 'Errore scrittura flag lettura per pratica : ' + esitoFinalePratica.numPratica + ' - ' + esitoFinalePratica.tipoPratica + ' inserita il ' + esitoFinalePratica.dataInserimento + '\n';
                            }
                        }
                    }
                } 
            }
        }
    }
    
    public void finish(Database.BatchableContext context) {
        //invio mail solo se ci sono errori
        List<Messaging.SingleEmailMessage> emailToSend = new List<Messaging.SingleEmailMessage>();
        if (!(String.isEmpty(esitiKO))) {
            //servizio scrittura andato in errore...
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[]{destinatario};
            mail.setToAddresses(toAddresses);
            mail.setSubject('Compass: Cancellazione pratica : Scrittura flag lettura ERRORE');
            mail.setPlainTextBody('Errori :\n' + esitiKO);
            emailToSend.add(mail);
        }
        if ((emailToSend != null) && (emailToSend.size() > 0)) {
            EmailUtils.sendEmail(emailToSend);
        }
    }
}