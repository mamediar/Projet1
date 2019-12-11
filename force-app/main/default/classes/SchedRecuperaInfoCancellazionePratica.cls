/**
 * @File Name          : SchedRecuperaInfoCancellazionePratica.cls
 * @Description        : 
 * @Author             : sabrina vitali
 * @Group              : 
 * @Last Modified By   : sabrina vitali
 * @Last Modified On   : 17/10/2019, 10:27:56
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    1/10/2019   sabrina vitali     Initial Version
**/
public class SchedRecuperaInfoCancellazionePratica implements Schedulable {

    final String nota_8396 = '8396 Errore/rifiuto CRIF'; 
    final String nota_2623 = '2623 Pratica non presente in banca dati CRIF';
    final String nota_0532 = '0532 Procedura non gestita';
    final String nota_respinta_filiale = 'PRESENTE ALTRA PRATICA DI FINANZIAMENTO IN LAVORAZIONE';
    final String profilo_no_verde = 'PROFILO DIVERSO DA VERDE';

    public void execute(SchedulableContext ctx) {
        
        String destinatario = 'crm@compass.it';
        System.debug('Avviamento...');
        final String EMPTY_STRING = ''; 
        final String ZERO_VALUE = '0';
        String strFlagError = EMPTY_STRING;
        List<Messaging.SingleEmailMessage> emailToSend = new List<Messaging.SingleEmailMessage>();
        
        OCSRecuperaInfoCancPraticaInvoker.Response data;
        
        try {
            data = OCSRecuperaInfoCancPraticaInvoker.invoke();
        } catch (exception e) {
            strFlagError = e.getMessage();
        }
        
        if (EMPTY_STRING.equals(strFlagError)) {
            OCSRecuperaInfoCancPraticaInvoker.RecuperaInfoCancellazionePraticaResponseDTO cancellazionePraticheJson = data.recuperaInfoCancellazionePraticaResponse;
            System.debug('cancellazionePraticheJson : ' + cancellazionePraticheJson);
            if ((cancellazionePraticheJson != null) && (cancellazionePraticheJson.elencoPratiche.size() > 0)) {
                List<Case> casiOCS = prepareData(cancellazionePraticheJson);
                Database.executeBatch(new BatchRecuperaInfoCancellazionePratica(casiOCS),80); //quanti ne faccio alla volta??
            } else {
                //il servizio soap è andato a buon fine ma non ci sono risultati
                strFlagError = '';
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses = new String[]{destinatario};
                mail.setToAddresses(toAddresses);
                mail.setSubject('Compass: PV Cancellazione Pratiche TERMINATO'); 
                mail.setPlainTextBody(strFlagError);
                emailToSend.add(mail); 
            }
        } else {
            //strFlagError valorizzato dal servizio soap iniziale andato in errore.
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[]{destinatario};
            mail.setToAddresses(toAddresses);
            mail.setSubject('Compass: PV Cancellazione Pratiche ERRORE');
            mail.setPlainTextBody('Errore lettura esito pratiche cancellate:' + strFlagError);
            emailToSend.add(mail);
        }
        if ((emailToSend != null) && (emailToSend.size() > 0)) {
            EmailUtils.sendEmail(emailToSend);
        }
    }

  	public List<Case> prepareData(OCSRecuperaInfoCancPraticaInvoker.RecuperaInfoCancellazionePraticaResponseDTO dati){
        List<Case> listaCasiOCS = new List<Case>();
        //List<XCS_Messaggio__c> noteOCSList = new List<XCS_Messaggio__c>();
        Case casoOCS;
        String sThread;
        Boolean insertNotePratica;
        //List<XCS_Messaggio__c> xcs_Messaggio__c;
        OCSRecuperaInfoCancPraticaInvoker.InfoCancellazionePraticaDTO pratica;

        for(Integer i=0;i<dati.elencoPratiche.size();i++){
            pratica = dati.elencoPratiche[i];

            /*System.debug('--!!!-- numPratica : ' + pratica.numPratica);
            System.debug('--!!!-- tipoPratica : ' + pratica.tipoPratica);
            System.debug('--!!!-- dataInserimento : ' + pratica.dataInserimento);
            System.debug('--!!!-- flagCancellazionePratica : ' + pratica.flagCancellazionePratica);
            System.debug('--!!!-- motivoMancataCancellazione : ' + pratica.motivoMancataCancellazione);
            System.debug('--!!!-- tipoPraticaCongiunta : ' + pratica.tipoPraticaCongiunta); 
            System.debug('--!!!-- numPraticaCongiunta : ' + pratica.numPraticaCongiunta);
            System.debug('--!!!-- flagCancellazionePraticaCongiunta : ' + pratica.flagCancellazionePraticaCongiunta);
            System.debug('--!!!-- motivoMancataCancellazioneCongiunta : ' + pratica.motivoMancataCancellazioneCongiunta);
            System.debug('--!!!-- dataElaborazioneOCS : ' + pratica.dataElaborazioneOCS);
            System.debug('--!!!-- flagCancellazioneSic : ' + pratica.flagCancellazioneSic);
            System.debug('--!!!-- noteCancellazioneSic : ' + pratica.noteCancellazioneSic);
            */
            casoOCS = new Case();
            casoOCS.pv_data_sbf__c = DateUtils.parseFromYYYYMMDDString(pratica.dataElaborazioneOCS);
            casoOCS.pv_data_poste__c = DateUtils.parseFromYYYYMMDDString(pratica.dataInserimento);
            casoOCS.NumeroPratica__c = pratica.numPratica;
            casoOCS.Tipo_Pratica__c = pratica.tipoPratica;
            casoOCS.pv_other_loan_number__c = pratica.numPraticaCongiunta;

            sThread = 'Sistema OCS - Procedura Automatica\r\nData Elaborazione: '+ pratica.dataInserimento + '\r\nPratica: ' + pratica.tipoPratica + ' - ' + pratica.numPratica;
            
            if(String.isNotBlank(pratica.flagCancellazionePratica) && pratica.flagCancellazionePratica.equalsIgnoreCase('S')){
                casoOCS.pv_esito_sbf__c = 'S';      //  flag cancellazione
                insertNotePratica = false;
                sThread += '\r\n Cancellazione Pratica: SI';

                if(String.isNotBlank(pratica.flagCancellazioneSic) && pratica.flagCancellazioneSic.equalsIgnoreCase('S')){
                    sThread += '\r\n Cancellazione SIC: SI';
                    //casoOCS.pv_send_to__c = 'NO';
                }
                else if(String.isBlank(pratica.flagCancellazioneSic)){
                    //casoOCS.pv_send_to__c = 'SI';
                    casoOCS.pv_send_to__c = 'Reclami';
                }
                else{
                    sThread += '\r\n Cancellazione SIC: NO';
                    if(String.isNotBlank(pratica.noteCancellazioneSic) 
                        && (
                            (pratica.noteCancellazioneSic.startsWithIgnoreCase(nota_8396) || pratica.noteCancellazioneSic.startsWithIgnoreCase(nota_2623))
                        ||  (pratica.tipoPratica.equalsIgnoreCase('PB') && pratica.noteCancellazioneSic.startsWithIgnoreCase(nota_0532)))
                    ){
                        //casoOCS.pv_send_to__c = 'NO';
                    }else {
                        //casoOCS.pv_send_to__c = 'SI';
                        casoOCS.pv_send_to__c = 'Reclami';
                    }
                    sThread += '\r\n Note Cancellazione SIC: ' + pratica.noteCancellazioneSic.trim();
                }
            } // fine cancellazionePratica = 'S'
            else{ 
                casoOCS.pv_esito_sbf__c = 'N';
                insertNotePratica = true;
                //casoOCS.pv_uffpost_boll__c = 'N';       //UTILIZZATO PER RESPINTA A FILIALE!
                //casoOCS.pv_send_to__c = 'Reclami';

                if(String.isNotBlank(pratica.motivoMancataCancellazione) && nota_respinta_filiale.equalsIgnoreCase(pratica.motivoMancataCancellazione.trim())){
                    //casoOCS.pv_uffpost_boll__c = 'S';   //UTILIZZATO PER RESPINTA A FILIALE!
                    casoOCS.pv_send_to__c = 'Ufficio_inserimento';
                }
                sThread += '\r\n Cancellazione Pratica: NO\r\n Motivo mancata cancellazione: ';
                if(String.isNotBlank(pratica.motivoMancataCancellazione)){
                    sThread += pratica.motivoMancataCancellazione.trim();
                } 
            }// fine cancellazionePratica <> 'S'


            if(String.isNotBlank(pratica.numPraticaCongiunta) && pratica.numPraticaCongiunta <> '0'){
                sThread += '\r\nPratica Congiunta: ' + pratica.tipoPraticaCongiunta + ' - ' + pratica.numPraticaCongiunta;
                sThread += '\r\n Cancellazione Pratica Congiunta: ';
                if(String.isNotBlank(pratica.flagCancellazionePraticaCongiunta) && pratica.flagCancellazionePraticaCongiunta.equalsIgnoreCase('S')){
                    sThread += 'SI';
                }else{
                    sThread += 'NO\r\n Motivo mancata cancellazione pratica congiunta: ';
                    if(String.isNotBlank(pratica.motivoMancataCancellazioneCongiunta)){
                        sThread += pratica.motivoMancataCancellazioneCongiunta.trim();
                    } 
                }
            }//fine gestione pratica congiunta
            
            List<OCSRecuperaInfoCancPraticaInvoker.InfoCancellazioneAnagraficaDTO> elencoAnagrafiche = pratica.elencoAnagrafiche;
            if(pratica.elencoAnagrafiche!=null && pratica.elencoAnagrafiche.size()>0){
                sThread += '\r\nControparti:';
                for(Integer k=0;k<pratica.elencoAnagrafiche.size();k++){
                    OCSRecuperaInfoCancPraticaInvoker.InfoCancellazioneAnagraficaDTO anagrafica = pratica.elencoAnagrafiche[k];
                    System.debug('@@@@ anagrafica : ' + anagrafica);
                    sThread += '\r\n Codice Controparte: ' + anagrafica.tipoControparte + ' - ' + anagrafica.codControparte;
                    sThread += '\r\n Cancellazione Controparte: ';
                    if(String.isNotBlank(anagrafica.flagCancellazione) && anagrafica.flagCancellazione.equalsIgnoreCase('S')){
                        sThread += 'SI\r\n';
                    }else{
                        sThread += 'NO\r\n Motivo mancata cancellazione: ' +  anagrafica.motivoMancataCancellazione.trim();   
                        if(anagrafica.motivoMancataCancellazione.trim().equalsIgnoreCase(profilo_no_verde)){
                            //perchè salva nel Case se è un attributo anagrafico?? Forse se c'è un "no verde" è sempre l'ultima anagrafica della lista?
                            //serve per antiriciclaggio, per cui al momento non si fa nulla
                            casoOCS.pv_ctr_no_sign__c = 'S';
                        }else{
                            casoOCS.pv_ctr_no_sign__c = 'N';
                        }

                        // mi salvo le anagrafiche non cancellate per inserire la nota su OCS (se la pratica è stata cancellata)
                        if(!insertNotePratica){                
                            if(String.isBlank(casoOCS.pv_ctr_no_titolare__c)){
                                casoOCS.pv_ctr_no_titolare__c = anagrafica.codControparte;
                            }else{
                                casoOCS.pv_ctr_no_titolare__c += '|' + anagrafica.codControparte;
                            }
                        }
                    }
                }// fine ciclo anagrafiche
            }//fine gestione anagrafiche
            
            //salvo le note per il thread che andrà aggiunto al Case
            casoOCS.Note__c = sThread;    
            System.debug('@@@@ casoOCS da aggiungere in lista: ' + casoOCS);
            listaCasiOCS.add(casoOCS);
        }    
        return listaCasiOCS;
	}
}