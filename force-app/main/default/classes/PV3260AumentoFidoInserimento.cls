/**
 * @File Name          : PV3260AumentoFidoInserimento.cls
 * @Description        :
 * @Author             : Lorenzo Marzocchi
 * @Group              :
 * @Last Modified By   : Lorenzo Marzocchi
 * @Last Modified On   : 2019-9-27 11:43:15
 * @Modification Log   :
 *==============================================================================
 * Ver         Date                     Author                        Modification
 *==============================================================================
 * 1.0    2019-6-26 11:23:02   Lorenzo Marzocchi     Initial Version
 **/

public class PV3260AumentoFidoInserimento extends PVAction {

	public class PV3260AumentoFidoForm extends PVForm {
		@AuraEnabled public String riservaPrincipale {get; set;}
		@AuraEnabled public String riservaSalvadanaio {get; set;}
		@AuraEnabled public String rataMinima {get; set;}

		// campo calcolato nel JS
		@AuraEnabled public String fidoTotale {get; set;}

		// campo restituito da cartaDatiFinanziari
		@AuraEnabled public String riservaInternetFido {get; set;}
		@AuraEnabled public String riservaMulticontoFido {get; set;}

	}



	@AuraEnabled
	public static void conferma(PV3260AumentoFidoForm datiForm){
		new PV3260AumentoFidoInserimento().execute(datiForm);
	}

	@AuraEnabled
	public static OCSCartaDatiFinanziariResponse.DatiCartaDatiFinanziariResponseDTO recuperaDatiFinanziari(String numeroCarta){
		System.debug('numeroCarta: ' + numeroCarta);
		OCSCartaDatiFinanziariResponse cartaDatiFinanziariResponse = OCSCartaDatiFinanziariInvoker.cartaDatiFinanziari(numeroCarta);
		return cartaDatiFinanziariResponse.datiCartaDatiFinanziariResponse;
	}

	@AuraEnabled
	public static VerificaFidoUtilClass.CheckFidoWrapper verificheAF ( String numPratica, String codCliente){
		OCSSchedaClienteResponse.PSVDatiPraticaDTO pratica = new OCSSchedaClienteResponse.PSVDatiPraticaDTO();
		pratica.numPratica = numPratica;
		pratica.codCliente = codCliente;
			System.debug('pratica.numPratica = numPratica: ' + pratica.numPratica + ' '+ numPratica);
		return VerificaFidoUtilClass.VerifyAumentoFidoPV(pratica);
	}

	@AuraEnabled
	public static PSV_Limite_Credito__mdt getStep(String emettitore){

		Integer intEmettitore= Integer.valueOf(emettitore);
		List<PSV_Limite_Credito__mdt > emettitoreFidoTable= [SELECT Emettitore__c, Filtro_prodotto_fax__c,Prodotto__c, Rata_minima__c, Step_di_aumento__c, tipologia__c, minimo_erogabile__c FROM PSV_Limite_Credito__mdt WHERE Emettitore__c=: intEmettitore];

		PSV_Limite_Credito__mdt emettitoreFidoRow = new PSV_Limite_Credito__mdt();
		if(!emettitoreFidoTable.isEmpty()) {
			emettitoreFidoRow= emettitoreFidoTable[0];
		}
		else{
			emettitoreFidoRow.Step_di_aumento__c = '-1';
		}
		return emettitoreFidoRow;
	}

	/* metodi NON aura enabled */


	public void execute(PVForm form){
		String messaggio_errore = '';

		try{
			PV3260AumentoFidoForm myForm = (PV3260AumentoFidoForm) form;
 			// moltiplico i valori x100 per fare l'operazionale nel B2B
            if (myForm.fidoTotale != '') {
                myForm.fidoTotale = String.valueOf(Integer.valueOf(myForm.fidoTotale) * 100);
            }
            if (myForm.riservaPrincipale != '') {
                myForm.riservaPrincipale = String.valueOf(Integer.valueOf(myForm.riservaPrincipale) * 100);
            }
            if (myForm.riservaSalvadanaio != '') {
                myForm.riservaSalvadanaio = String.valueOf(Integer.valueOf(myForm.riservaSalvadanaio) * 100);
            }
            if (myForm.rataMinima != '') {
                myForm.rataMinima = String.valueOf(Integer.valueOf(myForm.rataMinima) * 100);
            }
            if (myForm.riservaInternetFido != '') {
                myForm.riservaInternetFido = String.valueOf(Integer.valueOf(myForm.riservaInternetFido) * 100);
            }
            if (myForm.riservaMulticontoFido != '') {
                myForm.riservaMulticontoFido = String.valueOf(Integer.valueOf(myForm.riservaMulticontoFido) * 100);
            }
			
			OCSVariazioneFidoInvoker.Request req = new OCSVariazioneFidoInvoker.Request();

			//indipendenti dalla logica JS pre chiamata
			req.variazioneFidoRequest.intermediario='12';
			req.variazioneFidoRequest.provenienza='CA';
			req.variazioneFidoRequest.tipoIntermediario='AG';
			req.variazioneFidoRequest.procedura='CA';
			req.variazioneFidoRequest.numPratica=myForm.pratica.numPratica;
			req.variazioneFidoRequest.codRifExt='';
			req.variazioneFidoRequest.codRifExt2='';
			req.variazioneFidoRequest.utente=myForm.userData.user.Alias;
			req.variazioneFidoRequest.modalita='';

			// dipendenti dal JS di controllo
			req.variazioneFidoRequest.creditLimit=myForm.fidoTotale;
			req.variazioneFidoRequest.pagMinImporto=myForm.rataMinima;

			//se la riserva principale è uguale al totale, la carta non è a riserve, quindi parametri vuoti
			req.variazioneFidoRequest.risInternet=myForm.riservaInternetFido;
			req.variazioneFidoRequest.risMulticonto=myForm.riservaMulticontoFido;
			req.variazioneFidoRequest.risPrinc=myForm.riservaPrincipale;
			req.variazioneFidoRequest.risSalvad=myForm.riservaSalvadanaio;

			OCSVariazioneFidoInvoker.Response res =OCSVariazioneFidoInvoker.invoke(req.variazioneFidoRequest);

			System.debug('PV3260AumentoFido - OCSVariazioneFidoInvoker res: ' + res);

			if(res.isOK()) {
				//Common di PVAction
				commonExecute(myForm);
			}else{
				messaggio_errore = res.getMessage();
			}
		}catch(Exception e) {
			//messaggio_errore = e.getMessage();
			messaggio_errore = loggaException(e);
		}finally{
			if(messaggio_errore != '') {
				gestisciException(messaggio_errore);
			}
		}
	}



	public override Case completaCasePostVendita(Case casoPV,PVForm form){
		//continuare a valorizzare l'oggetto casoPV integrando i dati di questo post vendita
		return casoPV;
	}

	public override String recuperaNotaSpecificaPV(PVForm form, Case casoPV){
		//preparazione nota
		PV3260AumentoFidoForm myForm = (PV3260AumentoFidoForm) form;
		//7 : Note specifiche PV
		String notaSpecificaPV;
		//notaSpecificaPV =  'Email precedente: ' + myForm.cliente.email + '<br>';
		//notaSpecificaPV +=  'Nuova email: ' + myForm.mailNuova + '<br>';
		return notaSpecificaPV;
	}

	public override XCS_Messaggio__c preparaMessaggioOCS(PVForm form, XCS_Messaggio__c xcs_messaggio){
		//preparazione XCS_Messaggio
		PV3260AumentoFidoForm myForm = (PV3260AumentoFidoForm) form;
		xcs_messaggio.CodCliente__c = myForm.cliente.codCliente;
		return xcs_messaggio;
	}


}