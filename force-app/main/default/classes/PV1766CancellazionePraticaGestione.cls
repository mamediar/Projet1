/**
 * @File Name          : PV1766CancellazionePraticaGestione.cls
 * @Description        : 
 * @Author             : sabrina vitali
 * @Group              : 
 * @Last Modified By   : sabrina vitali
 * @Last Modified On   : 24/10/2019, 14:22:22
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    25/9/2019   sabrina vitali     Initial Version
**/
public class PV1766CancellazionePraticaGestione extends PVActionGestione {

	public class PV1766CancellazionePraticaGestioneForm extends PVForm {
       	@AuraEnabled
        public String esito{get;set;}
	}


	@AuraEnabled
	public static void saveCase(PV1766CancellazionePraticaGestioneForm form, Case theCase){
		String messaggio_errore = '';
		//Boolean inserisciRegistro = false;
		try{
			system.debug('theCase : ' + theCase);	//verificare quando scaarto da batch per filiale
			// modifico il case
			// se voglio forzare lo stato devo modificare form.newStatus
			String note = creaNote(form, theCase);
			System.debug('********** Branch_Or_Office__c : ' + form.userData.user.Branch_Or_Office__c + ' - esito : ' + form.esito + ' - stato : ' + form.newStatus);

			//Gestione DCRAV : esito KO --> chiusura
			//Gestione DCRAV : esito OK --> torna sospeso ad ufficio inserimento in step 998 per richiesta cancellazione
			//Gestione BACK step 2 --> torna sospeso ad ufficio inserimento in step 998 per richiesta cancellazione
			//Gestione BACK step 4 --> sospeso in step 998 per nuova richiesta cancellazione, coda invariata
			//Gestione FIL step 4 --> sospeso in step 998 per nuova richiesta cancellazione, coda invariata
			//Gestione RLCM step 4 --> chiusura

			//aggiungere gestione filiale se si tratta di un ritorno da batch
			//manca gestito da filiale con esito OCS KO
			/*if(form.newStatus.equalsIgnoreCase(CaseUtils.CHIUSO) && (form.userData.user.Branch_Or_Office__c.equalsIgnoreCase('BACK')
				|| (form.userData.user.Branch_Or_Office__c.equalsIgnoreCase('DCRAV') && form.esito.equalsIgnoreCase('OK')))){
			}*/
			
			if(String.isNotBlank(form.esito)){
				theCase.pv_ctr_no_sign__c = form.esito;		
			}

			saveUtil(form, theCase, note);
		}catch(Exception e) {                    
			messaggio_errore = loggaException(e);          
		}finally{                       
			if(messaggio_errore != '') {                                                    
				gestisciException(messaggio_errore);                    
			}
		}
	}

/*    @AuraEnabled
    public static OCSRecuperaSpeseAzzeraRecInvoker.Response recuperaSpeseAzzeramentoRecupero(String numPratica, String tipoPratica){
        // AV TODO select da tabella selezionate
        // incrocio e complesto con S prima di ritornare
		return OCSRecuperaSpeseAzzeraRecInvoker.invoke(numPratica, tipoPratica);
    } 
*/
	/* metodi NON aura enabled */

	private static String creaNote(PV1766CancellazionePraticaGestioneForm myform, Case theCase) {
		String nota = '';
		if(String.isNotBlank(myform.esito)){
			nota += 'Esito: ' + myform.esito + '\n';
		}
		if(String.isNotBlank(myform.note)){
			nota += 'Note: ' + myform.note;
		}

		return nota; 
	}


}