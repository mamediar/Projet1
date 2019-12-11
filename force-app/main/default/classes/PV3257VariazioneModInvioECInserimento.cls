/**
 * @File Name          : PV3257VariazioneModInvioECInserimento.cls
 * @Description        : 
 * @Author             : Federico Negro
 * @Group              : 
 * @Last Modified By   : Federico Negro
 * @Last Modified On   : 17/10/2019, 16:40:52
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    9/10/2019   Federico Negro     Initial Version
**/

public class PV3257VariazioneModInvioECInserimento extends PVAction {

    public class PV3257VariazioneModInvioECForm extends PVForm {
        @AuraEnabled public String modalitaNuova {get; set;}
		@AuraEnabled public String modalitaVecchia {get; set;}
		@AuraEnabled public String emailCarta {get; set;}
	}

	/***************************/
	/*   metodi Aura enabled   */
	/***************************/

	//recupera info carta
    @AuraEnabled
	public static OCSRecuperaInfoCartaResponse.RecuperaInfoCartaResponse recuperaInfoCarta(String numeroCarta){
		OCSRecuperaInfoCartaResponse recuperaInfoCartaResponse = OCSRecuperaInfoCartaInvoker.callRecInfoCarta(numeroCarta);
		return recuperaInfoCartaResponse.recuperaInfoCartaResponse;
	}

    //recupera dati finanziari
    @AuraEnabled
	public static OCSCartaDatiFinanziariResponse.DatiCartaDatiFinanziariResponseDTO recuperaDatiFinanziari(String numeroCarta){
		OCSCartaDatiFinanziariResponse cartaDatiFinanziariResponse = OCSCartaDatiFinanziariInvoker.cartaDatiFinanziari(numeroCarta);
		return cartaDatiFinanziariResponse.datiCartaDatiFinanziariResponse;
	}
    
	
	@AuraEnabled
	public static void conferma(PV3257VariazioneModInvioECForm datiForm){
		new PV3257VariazioneModInvioECInserimento().execute(datiForm);
	}

	/***************************/
	/* metodi NON Aura enabled */
	/***************************/

	public void execute(PVForm form){
		String messaggio_errore = '';
		try{
					
		PV3257VariazioneModInvioECForm myForm = (PV3257VariazioneModInvioECForm) form;
		OCSVariazioneModInvioECInvoker.Request req = new OCSVariazioneModInvioECInvoker.Request();

		req.variazioneModalitaInvioECRequest.provenienza='CA';
        req.variazioneModalitaInvioECRequest.tipoIntermediario='AG';
      	req.variazioneModalitaInvioECRequest.intermediario='12';
        req.variazioneModalitaInvioECRequest.procedura='CA';
        req.variazioneModalitaInvioECRequest.numPratica=myForm.pratica.numPratica;
        req.variazioneModalitaInvioECRequest.pan='';
        req.variazioneModalitaInvioECRequest.modInvioEC=myForm.modalitaNuova;
        req.variazioneModalitaInvioECRequest.overrideCommProd='N';
        req.variazioneModalitaInvioECRequest.commInvioEC='';
        req.variazioneModalitaInvioECRequest.tipoDestEC='';
        req.variazioneModalitaInvioECRequest.tipoDestECFlag='';
        req.variazioneModalitaInvioECRequest.email=myForm.emailCarta;
        req.variazioneModalitaInvioECRequest.utente=myForm.userData.user.Alias;

		OCSVariazioneModInvioECInvoker.Response res = OCSVariazioneModInvioECInvoker.invoke(req.variazioneModalitaInvioECRequest);
		
			System.debug('PV3257 Variazione Modalita Invio EC - OCSVariazioneModInvioECInvoker res: ' + res);

			if(res.isOK()) {
				System.debug('Case inserito');
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
		PV3257VariazioneModInvioECForm myForm = (PV3257VariazioneModInvioECForm) form;
		/// : Note specifiche PV
		String notaSpecificaPV;
		notaSpecificaPV =  'Modalità invio E/C precedente: ' + myForm.modalitaVecchia + '\n';
		notaSpecificaPV +=  'Nuova modalità invio E/C: ' + myForm.modalitaNuova + '\n';
		return notaSpecificaPV;
	}

	public override XCS_Messaggio__c preparaMessaggioOCS(PVForm form, XCS_Messaggio__c xcs_messaggio){
		//preparazione XCS_Messaggio
		PV3257VariazioneModInvioECForm myForm = (PV3257VariazioneModInvioECForm) form;
		//xcs_messaggio.CodCliente__c = myForm.cliente.codCliente;
		xcs_messaggio.NumPratica__c = myForm.pratica.numPratica;
		xcs_messaggio.TipoPratica__c = myForm.pratica.tipoPratica;
		return xcs_messaggio;
	}

}