/**
 * @File Name          : PV1760CopiaContrattoInserimento.cls
 * @Description        :
 * @Author             : Lorenzo Marzocchi
 * @Group              :
 * @Last Modified By   : Lorenzo Marzocchi
 * @Last Modified On   : 2019-9-23 14:14:54
 * @Modification Log   :
 *==============================================================================
 * Ver         Date                     Author                        Modification
 *==============================================================================
 * 1.0    2019-8-29 11:53:05   Lorenzo Marzocchi     Initial Version
 **/
public without sharing class PV1760CopiaContrattoInserimento extends PVAction {

	public class PV1760CopiaContrattoForm extends PVForm {
		@AuraEnabled public String destinatario {get; set;}
		@AuraEnabled public String indirizzo {get; set;}
		@AuraEnabled public String FEA {get; set;}
		@AuraEnabled public String statoLotto {get; set;}
	}


	@AuraEnabled
	public static void conferma(PV1760CopiaContrattoForm datiForm){
		new PV1760CopiaContrattoInserimento().execute(datiForm);
	}


	@AuraEnabled
	public static String recuperaDatiStampaPratica(String numPratica, String tipoPratica){
		String messaggio_errore = '';

		OCSrecuperaDatiStampaPraticaInvoker.Request req = new OCSrecuperaDatiStampaPraticaInvoker.Request();
		req.recuperaDatiStampaPraticaRequest.input_numPratica = numPratica;
		req.recuperaDatiStampaPraticaRequest.tipoPratica = tipoPratica;
		OCSrecuperaDatiStampaPraticaInvoker.Response res = OCSrecuperaDatiStampaPraticaInvoker.invoke(req.recuperaDatiStampaPraticaRequest);
		if(res.isOK()) {
			if(res.recuperaDatiStampaPraticaResponse.tipoFirma != '' && res.recuperaDatiStampaPraticaResponse.tipoFirma != 'C') {
				return 'FEA';
			}
			else{
				return 'CARTACEA';
			}
		}
		else{
			messaggio_errore = res.getMessage();
		}

		return '';

	}


	@AuraEnabled
	public static String recuperaStatoLotto(String numPratica){
		String statoLotto = '';
		List<Contract> contractRow= [SELECT SFALotto__r.Status__c,ContractNumber,ContractNumber__c FROM Contract WHERE ContractNumber__c=: numPratica];

		/* se viene recuperata l'informazione relativa alla pratica restituisco lo stato,
		   in alternativa considero il lotto come arrivato ad IDM che è il percorso più completo in termini di controlli
		 */
		if(!contractRow.isEmpty()) {
			statoLotto= contractRow[0].SFALotto__r.Status__c;
		}
		else{
			statoLotto= 'NON IN ARCHIVIO';
		}

		return statoLotto;
	}

	/* metodi NON aura enabled */

	public void execute(PVForm form){
		String messaggio_errore = '';
		try{
			PV1760CopiaContrattoForm myForm = (PV1760CopiaContrattoForm) form;

			//Common di PVAction
			commonExecute(myForm);
		}catch(Exception e) {
			messaggio_errore = loggaException(e);
		}finally{
			if(messaggio_errore != '') {
				gestisciException(messaggio_errore);
			}
		}
	}

	public override Case completaCasePostVendita(Case casoPV,PVForm form){
		//continuare a valorizzare l'oggetto casoPV integrando i dati di questo post vendita
		PV1760CopiaContrattoForm myForm = (PV1760CopiaContrattoForm) form;

		// se il contratto è tipo FEA il lotto non esiste, viceversa è necessario tracciare se il lotto è da IDM o in Filiale
		if (myForm.FEA == 'FEA') {
			casoPV.LocazioneContratto__c = myForm.FEA;
		}
		else{
			casoPV.LocazioneContratto__c = myForm.statoLotto;
		}
		casoPV.pv_send_to__c = myForm.destinatario;

		// imposto i valori a 0 , verranno successivamente valorizzati da IDM
		// contratto_esiste a 0 significa che non è stato trovato, anomalie a 0 significa no anomalia
		casoPV.pv_ctr_no_sign__c = '0';
		casoPV.pv_ctr_no_taeg__c = '0';
		casoPV.pv_ctr_no_titolare__c = '0';
		casoPV.pv_ctr_no_bene__c = '0';
		casoPV.pv_ctr_esiste__c = '0';

		return casoPV;
	}

	public override String recuperaNotaSpecificaPV(PVForm form, Case casoPV){
		//preparazione nota
		PV1760CopiaContrattoForm myForm = (PV1760CopiaContrattoForm) form;

		//7 : Note specifiche PV
		String notaSpecificaPV;
		notaSpecificaPV = 'Pratica: ' +  myForm.pratica.numPratica + '<br>';
		notaSpecificaPV += 'Tipologia di firma: ' + myForm.FEA + '<br>';
		notaSpecificaPV += 'Inviare a: ' + myForm.destinatario + '<br>';
		notaSpecificaPV += 'Indirizzo spedizione: (eventualmente variato su richiesta del cliente): ' + myForm.indirizzo + '<br>';
		return notaSpecificaPV;

	}

	public override XCS_Messaggio__c preparaMessaggioOCS(PVForm form, XCS_Messaggio__c xcs_messaggio){
		//preparazione XCS_Messaggio
		PV1760CopiaContrattoForm myForm = (PV1760CopiaContrattoForm) form;
		xcs_messaggio.CodCliente__c = myForm.cliente.codCliente;
		return xcs_messaggio;
	}

}