/**
 * @File Name          : PV1757RimborsoCliSaldoRossoInserimento.cls
 * @Description        : 
 * @Author             : Lorenzo Marzocchi
 * @Group              : 
 * @Last Modified By   : sabrina vitali
 * @Last Modified On   : 11/9/2019, 16:15:14
 * @Modification Log   : 
 *============================================================================== 
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    2019-6-28 14:43:34   Lorenzo Marzocchi     Initial Version
**/
public class PV1757RimborsoCliSaldoRossoInserimento extends PVAction {
	
    public class PV1757RimborsoCliSaldoRossoForm extends PVForm {
		@AuraEnabled public String modalitaRimborso{get;set;}
		@AuraEnabled public String noteRimborso{get;set;}
		@AuraEnabled public Date dataRid{get;set;}
        @AuraEnabled public Decimal importo{get;set;}
	}

	@AuraEnabled
	public static void conferma(PV1757RimborsoCliSaldoRossoForm datiForm){
		new PV1757RimborsoCliSaldoRossoInserimento().execute(datiForm);


		/*******************************
			// esempio chiamata esterna
		/***********************************************/
/*		
		// prova inserimento PV esterna
		PV1757RimborsoCliSaldoRossoInserimento.PV1757RimborsoCliSaldoRossoForm datiForm = new PV1757RimborsoCliSaldoRossoInserimento.PV1757RimborsoCliSaldoRossoForm();

		// se si vuole usare l'utente collegato (deve essere correttamente configurato per l'inseimento PV altrimenti verrà ritornata un'eccezione)
		datiForm = (PV1757RimborsoCliSaldoRossoInserimento.PV1757RimborsoCliSaldoRossoForm) PV1757RimborsoCliSaldoRossoInserimento.prepareFormExternal(datiForm, '1757', null);
		// in alternativa è possibile parrare l'id specifico di un utente (es: simulare l'inserimento da parte di un ufficio specifico)    
		// datiForm = (PV1757RimborsoCliSaldoRossoInserimento.PV1757RimborsoCliSaldoRossoForm)PV1757RimborsoCliSaldoRossoInserimento.prepareFormExternal(datiForm, '1757', '0050Q000002FQu4QAG');
		
		// i dati del cliente sono obbligatori sono obbligatori    
		// visto che potenzialmente potrebbe essere creata un'anagrafica sarebbe corretto passare tutti quelli a disposizione
		datiForm.cliente = new OCSCliente();
		datiForm.cliente.email = 'POSTVENDITA@EMAIL.TEST';
		datiForm.cliente.codCliente = '1';
		datiForm.cliente.cognome = 'COGNOME';
		datiForm.cliente.nome = 'NOME';
		datiForm.cliente.denominazioneAzienda = 'NOME COGNOME';
		datiForm.cliente.dataNascita = '20100101';

		// note operatore/batch
		datiform.note = 'richiesta creata automaticamente';
		
		// specifici per ogni PV 
		// Pratica solo Testata
		datiform.pratica = new OCSPratica();
		datiform.pratica.tipoPratica = 'CA';
		datiform.pratica.numPratica = '2106662676';

		//dati specifici PV
		datiform.modalitaRimborso = 'Assegno';
		datiform.noteRimborso = 'Modalità rimborso: Assegno\nDi seguito è riportato l"indirizzo di spedizione eventualmente modificato su richiesta del cliente.\nDI SALVO ROSA\nVIALE GIOVANNI AMENDOLA 24\n19121 LA SPEZIA (SP)\n';7        datiform.importo = 142.16;

		// esecuzione inserimento
		PV1757RimborsoCliSaldoRossoInserimento.conferma(datiform);
		//se errore il metodo esegue "throw new AuraHandledException"

*/		
	}

	/* metodi NON aura enabled */

	public void execute(PVForm form){
		String messaggio_errore = '';
		try{
			PV1757RimborsoCliSaldoRossoForm myForm = (PV1757RimborsoCliSaldoRossoForm) form;
			commonExecute(myForm);
		}catch(Exception e) {
			messaggio_errore = e.getMessage();
		}finally{
			if(messaggio_errore != '') {
				gestisciException(messaggio_errore);
			}
		}
	}

	public override Case completaCasePostVendita(Case casoPV,PVForm form){
		//continuare a valorizzare l'oggetto casoPV integrando i dati di questo post vendita
        PV1757RimborsoCliSaldoRossoForm myForm = (PV1757RimborsoCliSaldoRossoForm) form;
/*        String subject = casoPV.Subject;
        if(!String.isBlank(String.ValueOf(myForm.dataRid)) && myForm.dataRid.addDays(15) > Date.today()){
            subject = 'Gestire dal ' + DateUtils.formatDateDDslashMMslashYYYY(myForm.dataRid.addDays(15)) +' '+ casoPV.Subject; 
        }
        subject += ' ' + myForm.pratica.tipoPratica + ' - ' +  myForm.modalitaRimborso;
        casoPV.Subject = subject;
*/
        system.debug('myForm.pratica.numPratica' + myForm.pratica.numPratica);
        system.debug('myForm.pratica.tipoPratica' + myForm.pratica.tipoPratica);
        system.debug('myForm.pratica.statoPratica' + myForm.pratica.statoPratica);
        system.debug('myForm.importo' + myForm.importo);
        system.debug('myForm.pratica.convenzionato' + myForm.pratica.convenzionato);

        casopv.Importo_Rimborso__c = myForm.importo;
        //casopv.Filiale_Compass__c = myForm.pratica.filiale;

		return casoPV;
	}

	public override String recuperaNotaSpecificaPV(PVForm form, Case casoPV){
		//preparazione nota
		PV1757RimborsoCliSaldoRossoForm myForm = (PV1757RimborsoCliSaldoRossoForm) form;
		//7 : Note specifiche PV
		String notaSpecificaPV;
		notaSpecificaPV =  'Numero pratica: ' + myForm.pratica.numPratica + '\n';
		notaSpecificaPV +=  'Importo: ' + myForm.importo + '\n';

        if(String.isNotBlank(string.ValueOf(myForm.dataRid))){
            notaSpecificaPV +=  'Data del rid che ha generato il saldo rosso: ' + DateUtils.formatDateDDslashMMslashYYYY(myForm.dataRid) + '\n';
        }
        if(!String.isBlank(String.ValueOf(myForm.dataRid)) && myForm.dataRid.addDays(15) > Date.today()){
            notaSpecificaPV +=  'Gestire dal ' + DateUtils.formatDateDDslashMMslashYYYY(myForm.dataRid.addDays(15)) +'\n'; 
        }

        notaSpecificaPV +=  myForm.noteRimborso + '\n';   
		return notaSpecificaPV;
	}

	public override XCS_Messaggio__c preparaMessaggioOCS(PVForm form, XCS_Messaggio__c xcs_messaggio){
		//preparazione XCS_Messaggio
		PV1757RimborsoCliSaldoRossoForm myForm = (PV1757RimborsoCliSaldoRossoForm) form;
		xcs_messaggio.NumPratica__c = myForm.pratica.numPratica;
		xcs_messaggio.TipoPratica__c = myForm.pratica.tipoPratica;
		return xcs_messaggio;
	}



}