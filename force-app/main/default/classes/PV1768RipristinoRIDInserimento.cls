/**
 * @File Name          : PV1768RipristinoRIDInserimento.cls
 * @Description        : 
 * @Author             : sabrina vitali
 * @Group              : 
 * @Last Modified By   : sabrina vitali
 * @Last Modified On   : 29/10/2019, 14:05:42
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    29/7/2019, 14:26:20   sabrina vitali     Initial Version
**/
public class PV1768RipristinoRIDInserimento extends PVAction{
	public class PV1768RipristinoRIDInserimentoForm extends PVForm {
        @AuraEnabled public String dataRipristino {get; set;}
		//mi servono come response in caso di KO del servizio
        @AuraEnabled public String messaggioFinale {get; set;}
		//@AuraEnabled public String esitoVariazione {get; set;}
		@AuraEnabled public String destinatario {get; set;}
	}

	@AuraEnabled
	public static void conferma(PV1768RipristinoRIDInserimentoForm datiForm){
    //public static String conferma(PV1768RipristinoRIDInserimentoForm datiForm){
		new PV1768RipristinoRIDInserimento().execute(datiForm);
        PV1768RipristinoRIDInserimentoForm myForm = (PV1768RipristinoRIDInserimentoForm) datiForm;
        //return myForm.messaggioFinale;
	}

	public void execute(PVForm form){
		String messaggio_errore = '';
		try{
			PV1768RipristinoRIDInserimentoForm myForm = (PV1768RipristinoRIDInserimentoForm) form;
			OCSCliente cliente = myForm.cliente;

			myForm.messaggioFinale = '';
			//myForm.esitoVariazione = 'OK';
			myForm.destinatario = '';

            OCSVariazioneDatiPagamentoRequest req = new OCSVariazioneDatiPagamentoRequest();
            req.VariazioneDatiPagamentoRequest.tipoIntermediario = 'AG';
            req.VariazioneDatiPagamentoRequest.intermediario = '12';
            req.VariazioneDatiPagamentoRequest.procedura = myForm.pratica.tipoPratica;
            req.VariazioneDatiPagamentoRequest.provenienza = myForm.pratica.tipoPratica;
            req.VariazioneDatiPagamentoRequest.numPratica = myForm.pratica.numPratica;
            req.VariazioneDatiPagamentoRequest.pagForma = 'RI';
            req.VariazioneDatiPagamentoRequest.ecFrequenza = 'M';
            req.VariazioneDatiPagamentoRequest.abi = '';
            req.VariazioneDatiPagamentoRequest.cab = '' ;
            req.VariazioneDatiPagamentoRequest.cc = '' ;
            req.VariazioneDatiPagamentoRequest.cinBban = '' ;
            req.VariazioneDatiPagamentoRequest.cinIban = '' ;
            req.VariazioneDatiPagamentoRequest.paeseIban = '';
            req.VariazioneDatiPagamentoRequest.iban = myForm.pratica.iban ;
            req.VariazioneDatiPagamentoRequest.intCc = '';
            req.VariazioneDatiPagamentoRequest.intestConto = '';
            req.VariazioneDatiPagamentoRequest.codiceRid = '';
            req.VariazioneDatiPagamentoRequest.firmaSuRid = '';
            req.VariazioneDatiPagamentoRequest.bancaInterna = '';
            req.VariazioneDatiPagamentoRequest.pagGGValuta = '';
            req.VariazioneDatiPagamentoRequest.lettera = '';
            req.VariazioneDatiPagamentoRequest.tipoContatto = 'ALT';
            req.VariazioneDatiPagamentoRequest.ammin = '';
            req.VariazioneDatiPagamentoRequest.dataIniziale = myForm.dataRipristino;
            req.VariazioneDatiPagamentoRequest.variazScadRata = '';
            req.VariazioneDatiPagamentoRequest.speseIncasso = '';
            req.VariazioneDatiPagamentoRequest.speseIncFlg = '';
            req.VariazioneDatiPagamentoRequest.codiceRifExt2 = '';
            req.VariazioneDatiPagamentoRequest.utente = '';
            req.VariazioneDatiPagamentoRequest.pan = '';
            req.VariazioneDatiPagamentoRequest.lunghezzaPan = '';
            req.VariazioneDatiPagamentoRequest.dataScadenza = '';

            OCSVariazionedatiPagamentoResponse res = OCSVariazioneDatiPagamentoInvoker.callVariazioneDatiPagamento(req);
            if(!res.isOK()) {
                //eseguo lo stesso e il Case andrà in gestione a BackOffice
				//myForm.esitoVariazione = 'BACK';
				myForm.destinatario = 'BACK';
                myForm.messaggioFinale = 'Errore di connessione OCS: ' + res.getMessage();
				commonExecute(myForm);
			}
            else if(res.variazioneDatiPagamentoResponse.as400Status == 'KO' && !res.variazioneDatiPagamentoResponse.AS400Errore.equalsIgnoreCase('3107 Disposizione RID elettronica.')) {
				//Common di PVAction
                /*
				//eseguo lo stesso e il Case andrà in gestione a BackOffice
				myForm.esitoVariazione = 'KO';
                myForm.messaggioFinale = 'Errore da OCS: ' + res.variazioneDatiPagamentoResponse.as400Status + ' - ' + res.variazioneDatiPagamentoResponse.as400Errore;
				commonExecute(myForm);
				*/
				//IN QUESTO CASO TORNA AL MITTENTE!
				//myForm.esitoVariazione = 'MITT';
				myForm.destinatario = 'Sender';
                myForm.messaggioFinale = 'Errore da OCS: ' + res.variazioneDatiPagamentoResponse.as400Status + ' - ' + res.variazioneDatiPagamentoResponse.as400Errore;
				commonExecute(myForm);
			}else{
				//KO con esito '3107 Disposizione RID elettronica.' è un OK
				//Common di PVAction
				myForm.messaggioFinale = 'OK : ' + res.variazioneDatiPagamentoResponse.as400Errore;
				commonExecute(myForm);
			}
		}catch(Exception e) {
			messaggio_errore = e.getMessage();
			System.debug('TEST EMAIL EXCEPTION ERRORE:' + messaggio_errore);
		}finally{
			if(messaggio_errore != '') {
				gestisciException(messaggio_errore);
			}
		}
	}

	public override Case completaCasePostVendita(Case casoPV,PVForm form){
		//continuare a valorizzare l'oggetto casoPV integrando i dati di questo post vendita
		PV1768RipristinoRIDInserimentoForm myForm = (PV1768RipristinoRIDInserimentoForm) form;
		/*if(myForm.esitoVariazione.equalsIgnoreCase('BACK')){
			casoPV.UfficioDestinazione__c = [Select Id from Account where RecordType.Name = 'Uffici e Altro' AND Codice_Ufficio__c = 'BACK'][0].id;
		}*/
		casoPV.pv_send_to__c = myForm.destinatario; //null,Back,Mittente
		//System.debug('myForm.esitoVariazione : ' + myForm.esitoVariazione);
		//System.debug('casoPV.UfficioDestinazione__c : ' + casoPV.UfficioDestinazione__c);
		System.debug('casoPV.pv_send_to__c : ' + casoPV.pv_send_to__c);
		System.debug('casoPV.Step_PV__c : ' + casoPV.Step_PV__c);
		System.debug('casoPV.Status : ' + casoPV.Status);
		return casoPV;
	}

	public override String recuperaNotaSpecificaPV(PVForm form, Case casoPV){
		//preparazione nota
		PV1768RipristinoRIDInserimentoForm myForm = (PV1768RipristinoRIDInserimentoForm) form;
		//7 : Note specifiche PV
		String notaSpecificaPV;
		notaSpecificaPV = 'Numero pratica: ' + myForm.pratica.tipoPratica + ' - ' + myForm.pratica.numPratica + '\n';
        notaSpecificaPV += 'Data di ripristino: ' + myForm.dataRipristino + '\n';
        notaSpecificaPV += 'Dati bancari: \n';
        //notaSpecificaPV = 'Intestatario: ' + myForm.pratica. + '\n';
        notaSpecificaPV += 'ABI: ' + myForm.pratica.abi + '\n';
        notaSpecificaPV += 'CAB: ' + myForm.pratica.cab + '\n';
        notaSpecificaPV += 'C/C: ' + myForm.pratica.numConto + '\n';
        notaSpecificaPV += 'IBAN: ' + myForm.pratica.iban + ' : presa visione variazione IBAN\n';
        notaSpecificaPV += 'Modalità pagamento da : ' + myForm.pratica.tipoPagamento + ' a RI\n';
		if(String.isNotBlank(myForm.messaggioFinale)){
			notaSpecificaPV += '\n' + myForm.messaggioFinale + '\n';
		}
		return notaSpecificaPV;
	}

	public override XCS_Messaggio__c preparaMessaggioOCS(PVForm form, XCS_Messaggio__c xcs_messaggio){
		//preparazione XCS_Messaggio
		PV1768RipristinoRIDInserimentoForm myForm = (PV1768RipristinoRIDInserimentoForm) form;
		//xcs_messaggio.CodCliente__c = myForm.cliente.codCliente;
		xcs_messaggio.NumPratica__c = myForm.pratica.numPratica;
		xcs_messaggio.TipoPratica__c = myForm.pratica.tipoPratica;
		return xcs_messaggio;
	}

	@AuraEnabled
	public static OCSRecuperaSaldoClienteResponse.RecuperaSaldoClienteResponse recuperaSaldoCliente(String codCliente, String userLogin){
		OCSRecuperaSaldoClienteResponse recuperaSaldoClienteResponse = OCSRecuperaSaldoClienteInvoker.callGetSaldoCliente(codCliente);
		return recuperaSaldoClienteResponse.recuperaSaldoClienteResponse;
	}

}