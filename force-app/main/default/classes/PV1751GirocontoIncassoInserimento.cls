/**
 * @File Name          : PV1751GirocontoIncassoInserimento.cls
 * @Description        : 
 * @Author             : sabrina vitali
 * @Group              : 
 * @Last Modified By   : sabrina vitali
 * @Last Modified On   : 11/9/2019, 16:13:52
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    5/8/2019, 11:18:02   sabrina vitali     Initial Version
**/
public class PV1751GirocontoIncassoInserimento extends PVAction {
	
    public class PV1751GirocontoIncassoForm extends PVForm {
        @AuraEnabled public List<PraticaDestinazione> praticheDestinazione {get; set;}
		@AuraEnabled public String modalitaRimborso{get;set;}
		@AuraEnabled public String noteRimborso{get;set;}
		@AuraEnabled public Date dataIncasso{get;set;}
        @AuraEnabled public Boolean hasRimborso{get;set;}
        @AuraEnabled public Double totImporto{get;set;}
        @AuraEnabled public Double totRimborso{get;set;}
	}

	public class PraticaDestinazione {
		// per inserimento via form e batch
		@AuraEnabled public String numPratica {get; set;}
		@AuraEnabled public String tipoPratica {get; set;}
		// solo inserimento via form
		@AuraEnabled public Double importo {get; set;}
        @AuraEnabled public String codCliente {get; set;}
        @AuraEnabled public String ragioneSociale {get; set;}
		// solo inserimento via batch
		@AuraEnabled public String tipoCompensazione {get; set;}
		@AuraEnabled public String anzianitaInsoluto {get; set;}
		@AuraEnabled public Double totaleSpesa {get; set;}
		@AuraEnabled public Double importoCompensazione {get; set;}
	}

	@AuraEnabled
	public static void conferma(PV1751GirocontoIncassoForm datiForm){
        System.debug('praticheDestinazione : ' + datiForm.praticheDestinazione );
        System.debug('praticaO : ' + datiForm.pratica );
        System.debug('clienteO : ' + datiForm.cliente.codCliente );

		/*******************************
			// esempio chiamata esterna
		/***********************************************/
/*		
		// prova inserimento PV esterna
		PV1751GirocontoIncassoInserimento.PV1751GirocontoIncassoForm datiForm = new PV1751GirocontoIncassoInserimento.PV1751GirocontoIncassoForm();

		// se si vuole usare l'utente collegato (deve essere correttamente configurato per l'inseimento PV altrimenti verrà ritornata un'eccezione)
		datiForm = (PV1751GirocontoIncassoInserimento.PV1751GirocontoIncassoForm) PV1751GirocontoIncassoInserimento.prepareFormExternal(datiForm, '1751', null);
		// in alternativa è possibile parrare l'id specifico di un utente (es: simulare l'inserimento da parte di un ufficio specifico)    
		// datiForm = (PV1751GirocontoIncassoInserimento.PV1751GirocontoIncassoForm)PV1751GirocontoIncassoInserimento.prepareFormExternal(datiForm, '1751', '0050Q000002FQu4QAG');
		
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
		datiform.pratica = new OCSPratica();
		datiform.pratica.tipoPratica = 'CA';
		datiform.pratica.numPratica = '2106662676';

		//dati specifici PV
		datiform.modalitaRimborso = 'Assegno';
		datiform.noteRimborso = 'Modalità rimborso: Assegno\nDi seguito è riportato l"indirizzo di spedizione eventualmente modificato su richiesta del cliente.\nDI SALVO ROSA\nVIALE GIOVANNI AMENDOLA 24\n19121 LA SPEZIA (SP)\n';
        datiform.hasRimborso = true;
        datiform.totImporto = 142.16;
        datiform.totRimborso = 120.62;

		//pratiche destinazione
		PV1751GirocontoIncassoInserimento.PraticaDestinazione praticaDe = new PV1751GirocontoIncassoInserimento.PraticaDestinazione();
		PV1751GirocontoIncassoInserimento.PraticaDestinazione praticaDe2 = new PV1751GirocontoIncassoInserimento.PraticaDestinazione();
		datiForm.praticheDestinazione = new List<PV1751GirocontoIncassoInserimento.PraticaDestinazione>();
		praticaDe.numPratica = '0123456';
		praticaDe.tipoPratica = 'CO';
		praticaDe.tipoCompensazione = 'IN';
		praticaDe.anzianitaInsoluto = '2';
		praticaDe.totaleSpesa = 12.40;
		praticaDe.importoCompensazione = 12.40;
		datiForm.praticheDestinazione.add(praticaDe);

		praticaDe2.numPratica = '6543210';
		praticaDe2.tipoPratica = 'CA';
		praticaDe2.tipoCompensazione = 'SP';
		praticaDe2.totaleSpesa = 5.20;
		praticaDe2.importoCompensazione = 5.20;
		datiForm.praticheDestinazione.add(praticaDe2);

		// esecuzione inserimento
		PV1751GirocontoIncassoInserimento.conferma(datiform);
		//se errore il metodo esegue "throw new AuraHandledException"

*/
 		new PV1751GirocontoIncassoInserimento().execute(datiForm);
	}

	/* metodi NON aura enabled */
	public void execute(PVForm form){
		String messaggio_errore = '';
		try{
			PV1751GirocontoIncassoForm myForm = (PV1751GirocontoIncassoForm) form;
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
        PV1751GirocontoIncassoForm myForm = (PV1751GirocontoIncassoForm) form;
        casoPV.Has_Rimborso__c = myForm.hasRimborso;
        casopv.Importo_Rimborso__c = myForm.totRimborso;
		return casoPV;
	}

	public override String recuperaNotaSpecificaPV(PVForm form, Case casoPV){
		//preparazione nota
		PV1751GirocontoIncassoForm myForm = (PV1751GirocontoIncassoForm) form;
		//7 : Note specifiche PV
		String notaSpecificaPV;
		notaSpecificaPV =  'Origine: \n';
		notaSpecificaPV +=  ' - Numero pratica: ' + myForm.pratica.tipoPratica + ' - ' + myForm.pratica.numPratica + '\n';
		notaSpecificaPV +=  'Importo Totale: ' + myForm.totImporto + '\n';
		if(myForm.totRimborso != null){
			notaSpecificaPV +=  'di cui da rimborsare al cliente: ' + myForm.totRimborso + '\n';
		}
		Integer contatore;
		for(Integer i=0;i<myForm.praticheDestinazione.size();i++){
			contatore = i+1;
			notaSpecificaPV +=  'Destinazione: ' + contatore + '\n';
			notaSpecificaPV +=  ' - Numero pratica: ' + myForm.praticheDestinazione[i].tipoPratica + ' - ' + myForm.praticheDestinazione[i].numPratica + '\n';
			if(myForm.praticheDestinazione[i].tipoCompensazione == null){
				//solo per compilazione da form
				notaSpecificaPV +=  ' - Cliente: ' + myForm.praticheDestinazione[i].codCliente + ' - ' + myForm.praticheDestinazione[i].ragioneSociale + '\n';
				notaSpecificaPV +=  ' - Importo da girocontare: ' + myForm.praticheDestinazione[i].importo + '\n';
			}else{
				//solo per inserimento batch
				if(myForm.praticheDestinazione[i].tipoCompensazione.equalsIgnoreCase('SP')){
					notaSpecificaPV +=  ' - Tipo Compensazione: Spese\n';
				}else{
					notaSpecificaPV +=  ' - Tipo Compensazione: Insoluto (anzianità ' + myForm.praticheDestinazione[i].anzianitaInsoluto + ')\n' ;
				}
				notaSpecificaPV +=  ' - Totale spesa per la pratica: ' + myForm.praticheDestinazione[i].totaleSpesa + '\n';
				notaSpecificaPV +=  ' - Importo compensazione proposta: ' + myForm.praticheDestinazione[i].importoCompensazione + '\n';
			}
		}
		if(myForm.dataIncasso != null){
			notaSpecificaPV +=  'Data incasso: ' + DateUtils.formatDateDDslashMMslashYYYY(myForm.dataIncasso) + '\n';
		}
		if(myForm.hasRimborso==true){
			notaSpecificaPV +=  'Rimborso: Si' + '\n';
		}else{
			notaSpecificaPV +=  'Rimborso: No' + '\n';
		} 
		if(String.isNotBlank(myForm.noteRimborso)){
			notaSpecificaPV +=  myForm.noteRimborso + '\n';   
		}
        
		return notaSpecificaPV;
	}

	public override XCS_Messaggio__c preparaMessaggioOCS(PVForm form, XCS_Messaggio__c xcs_messaggio){
		//nessun messaggio per questo PV

		//preparazione XCS_Messaggio
		//PV1751GirocontoIncassoForm myForm = (PV1751GirocontoIncassoForm) form;
		//xcs_messaggio.CodCliente__c = '';
		//xcs_messaggio.NumPratica__c = myForm.pratica.numPratica;
		//xcs_messaggio.TipoPratica__c = myForm.pratica.tipoPratica;
		return xcs_messaggio;
	}

}