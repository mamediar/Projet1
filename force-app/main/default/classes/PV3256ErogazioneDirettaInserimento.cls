/**
 * @File Name          : PV3256ErogazioneDirettaInserimento.cls
 * @Description        : 
 * @Author             : sabrina vitali
 * @Group              : 
 * @Last Modified By   : Federico Negro
 * @Last Modified On   : 30/10/2019, 12:27:22
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    30/7/2019, 09:41:30   sabrina vitali     Initial Version
**/
public class PV3256ErogazioneDirettaInserimento extends PVAction {   

	public class PV3256ErogazioneDirettaForm extends PVForm { 
		@AuraEnabled public Double importo {get; set;}
		@AuraEnabled public String codiceCampagna {get; set;}
		@AuraEnabled public String numRate {get; set;}
		@AuraEnabled public String modalitaErogazione {get; set;}
		@AuraEnabled public String smsConsenso {get; set;}
		@AuraEnabled public String iban {get; set;}
		@AuraEnabled public String flagCommissioniErogazione {get; set;}
		@AuraEnabled public String intermediario  {get; set;}
		@AuraEnabled public String destErogazione  {get; set;}
		@AuraEnabled public String canale {get; set;}
		@AuraEnabled public String dataScadenza {get; set;}
		@AuraEnabled public String codiceInternoBanca {get; set;}
		@AuraEnabled public String emettitore {get; set;}
		@AuraEnabled public String testoSMS {get; set;}
		@AuraEnabled public String numeroCliente {get; set;}


	}

	@AuraEnabled
	public static OCSCartaDatiFinanziariResponse.DatiCartaDatiFinanziariResponseDTO recuperaDatiFinanziari(String numeroCarta){
		
		OCSCartaDatiFinanziariResponse cartaDatiFinanziariResponse = OCSCartaDatiFinanziariInvoker.cartaDatiFinanziari(numeroCarta);

		if(cartaDatiFinanziariResponse.isStatusOK()) {
			return cartaDatiFinanziariResponse.datiCartaDatiFinanziariResponse;
		}else{
			System.debug('*** Errore : '+cartaDatiFinanziariResponse.getAs400Errore());
			gestisciException('OCSCartaDatiFinanziariInvoker - '+cartaDatiFinanziariResponse.getAs400Errore());
			return null;
		}
		
	}
	
	@AuraEnabled
	public static OCSGenericRecuperaDatiInvoker.GenericRecuperaDatiResponseDTO verificaMandatoSDDAttivo(String tipoPratica,String numeroCarta){
		OCSGenericRecuperaDatiInvoker.Response res = OCSGenericRecuperaDatiInvoker.invoke('verificaMandatoSDDAttivo', tipoPratica, numeroCarta, null, null, null);
		System.debug('debugger VERIFICAMANDATOSDD'+ res);
		return res.genericRecuperaDatiResponseDTO[0];
	}

	@AuraEnabled
	public static String getMinimoErogabile(String emettitore){

		Integer intEmettitore= Integer.valueOf(emettitore);
		List<PSV_Limite_Credito__mdt > emettitoreFidoTable= [SELECT Emettitore__c, Filtro_prodotto_fax__c,Prodotto__c, Rata_minima__c, Step_di_aumento__c, tipologia__c, minimo_erogabile__c FROM PSV_Limite_Credito__mdt WHERE Emettitore__c=: intEmettitore];

		String minimoErogabile;
		if(!emettitoreFidoTable.isEmpty()) {
			minimoErogabile= emettitoreFidoTable[0].minimo_erogabile__c;
		}
		else{
			minimoErogabile= '-1';
		}
		return minimoErogabile;
	}

	// metodo per recuperare gli IBAN dei CPAY
	@AuraEnabled
	public static Map<String,List<Object> > getCpayMatrix(String codCliente){
		Map<String,List<Object> > res=new Map<String,List<Object> >();
		OCSRecuperaDatiPostvenditaRequest request=new OCSRecuperaDatiPostvenditaRequest();
		request.codCliente=codCliente;
		request.filtroTipoPratica='CP';
		request.flagInfoCliente='false';
		List<OCSCliente> clientiList=OCSObjectsFactory.makeClienti(OCSRecuperaDatiPostvenditaInvoker.callRecDatiPV(request));
		res.put('clienti',clientiList);
		return res;
	}


	@AuraEnabled
	public static void conferma(PV3256ErogazioneDirettaForm datiForm){
		new PV3256ErogazioneDirettaInserimento().execute(datiForm);
	}

	@AuraEnabled
	public static boolean isAccountPresente(String codCliente) {
		List<Account> accountList = [SELECT Id FROM Account WHERE OCS_External_Id__c = :codCliente];
		return accountList.size()>0;
	}

	/* metodi NON aura enabled */

	public void execute(PVForm form){
		String messaggio_errore = '';
		Boolean truecheck = false;
		String msg ='';
		try{
			// preparo la REQUEST per l'EDI
			PV3256ErogazioneDirettaForm myForm = (PV3256ErogazioneDirettaForm) form;
			String smsConsenso = myForm.smsConsenso;
			OCSAcquistiErogazioneDirettaInvoker.Request req = new OCSAcquistiErogazioneDirettaInvoker.Request();
			req.datiAcquistiErogazioneDirettaRequest.intermediario = myForm.intermediario;
			req.datiAcquistiErogazioneDirettaRequest.numeroCarta = myForm.pratica.numPratica;
			req.datiAcquistiErogazioneDirettaRequest.importo = String.valueOf((myForm.importo * 100).intValue());
			req.datiAcquistiErogazioneDirettaRequest.codiceCampagna = myForm.codiceCampagna;
			req.datiAcquistiErogazioneDirettaRequest.destErogazione = myForm.destErogazione;
			req.datiAcquistiErogazioneDirettaRequest.modalitaErogazione = myForm.modalitaErogazione;
			req.datiAcquistiErogazioneDirettaRequest.flagCommissioniErogazione = myForm.flagCommissioniErogazione;
			req.datiAcquistiErogazioneDirettaRequest.dataScadenza = myForm.dataScadenza;
			req.datiAcquistiErogazioneDirettaRequest.dataNascita = myForm.cliente.dataNascita;
			req.datiAcquistiErogazioneDirettaRequest.numRate = myForm.numRate;
			req.datiAcquistiErogazioneDirettaRequest.iban = myForm.iban;
			req.datiAcquistiErogazioneDirettaRequest.canale = myForm.canale;
			req.datiAcquistiErogazioneDirettaRequest.utente = myForm.userData.user.Alias;

			System.debug('debugger req ' + req);
			System.debug('debugger req ' + req.datiAcquistiErogazioneDirettaRequest.flagCommissioniErogazione);
			System.debug('debugger req ' + req.datiAcquistiErogazioneDirettaRequest.intermediario);
			// chiamo servizio EDI
			OCSAcquistiErogazioneDirettaInvoker.Response res = OCSAcquistiErogazioneDirettaInvoker.invoke(req.datiAcquistiErogazioneDirettaRequest);
			System.debug('debugger res ' + res);

			if(res.isOK()) {
				if ((res.datiAcquistiErogazioneDirettaResponse.protocollo != '') && (res.datiAcquistiErogazioneDirettaResponse.protocollo != '0')) {
					if(myForm.codiceInternoBanca != '') {

						OCSLiquidazioneAcquistiInvoker.Request request = new OCSLiquidazioneAcquistiInvoker.Request();
						request.datiLiquidazioneAcquistiRequest.emettitore = myForm.emettitore;
						request.datiLiquidazioneAcquistiRequest.protocollo = res.datiAcquistiErogazioneDirettaResponse.protocollo;
						request.datiLiquidazioneAcquistiRequest.formaPagamento = myForm.modalitaErogazione;
						request.datiLiquidazioneAcquistiRequest.tipoDestErogazione = myForm.destErogazione;
						request.datiLiquidazioneAcquistiRequest.docDaEmettere = 'D';
						request.datiLiquidazioneAcquistiRequest.bancaInterna = myForm.codiceInternoBanca;
						request.datiLiquidazioneAcquistiRequest.utente = myForm.userData.user.Alias;
						// chiamo LiquidazioneAcquisti
						System.debug('debugger res ' + request);
						OCSLiquidazioneAcquistiInvoker.Response response = OCSLiquidazioneAcquistiInvoker.invoke(request.datiLiquidazioneAcquistiRequest);
						System.debug('debugger res ' + response);
						truecheck = response.isOK();
						msg = response.getMessage();
					}
					else{
						// se è CPAY quindi non ha codiceBanca allora non deve fare la liquidazione
						truecheck = true;

					}
					if(truecheck) {
						//Common di PVAction
						System.debug('SONO NELL EXECUTE');
						commonExecute(myForm);
						System.debug('PRE SMS '+myForm.smsConsenso);
						if (myForm.smsConsenso == 'true') {
							System.debug('INVIO SMS'+ myForm.numeroCliente+myForm.testoSMS+myForm.cliente.codCliente);
							OCSInviaSMSInvoker.inviaSMS('',myForm.numeroCliente,myForm.testoSMS,myForm.cliente.codCliente);
						}
						System.debug('FINE');
					}
					else {
						messaggio_errore = msg;
					}
				}
				else{
					messaggio_errore = 'Protocollo non valorizzato: ' +res.datiAcquistiErogazioneDirettaResponse.as400Errore;
				}
			}
			else if(((res.datiAcquistiErogazioneDirettaResponse.protocollo == '') || (res.datiAcquistiErogazioneDirettaResponse.protocollo == '0'))) {
				messaggio_errore = 'Protocollo non valorizzato: ' +res.datiAcquistiErogazioneDirettaResponse.as400Errore;
			}
			else{
				messaggio_errore = res.getMessage();
			}
		}catch(Exception e) {
		//	messaggio_errore = e.getMessage();
				messaggio_errore = loggaException(e);
		}finally{
			if(messaggio_errore != '') {
				gestisciException(messaggio_errore);
			}
		}
	}



	public override Case completaCasePostVendita(Case casoPV,PVForm form){
		//continuare a valorizzare l'oggetto casoPV integrando i dati di questo post vendita
		PV3256ErogazioneDirettaForm myForm = (PV3256ErogazioneDirettaForm) form;
		return casoPV;
	}

	public override String recuperaNotaSpecificaPV(PVForm form, Case casoPV){
		//preparazione nota
		PV3256ErogazioneDirettaForm myForm = (PV3256ErogazioneDirettaForm) form;
		//7 : Note specifiche PV
		String notaSpecificaPV;
		notaSpecificaPV =  'Importo: ' + myForm.importo + '<br>';
		notaSpecificaPV +=  'Campagna: ' + myForm.codiceCampagna + '<br>';
		notaSpecificaPV +=  'Rate: ' + myForm.numRate + '<br>';
		notaSpecificaPV +=  'Carta: ' +  myForm.pratica.numPratica + '<br>';
		return notaSpecificaPV;
	}

	public override XCS_Messaggio__c preparaMessaggioOCS(PVForm form, XCS_Messaggio__c xcs_messaggio){
		//preparazione XCS_Messaggio
		PV3256ErogazioneDirettaForm myForm = (PV3256ErogazioneDirettaForm) form;
		xcs_messaggio.CodCliente__c = myForm.cliente.codCliente;
		return xcs_messaggio;
	}



}