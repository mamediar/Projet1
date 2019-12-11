/**
 * @File Name          : PV3264VariazioneRataMinimaInserimento.cls
 * @Description        : 
 * @Author             : Federico Negro
 * @Group              : 
 * @Last Modified By   : Federico Negro
 * @Last Modified On   : 4/11/2019, 17:11:35
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    14/10/2019   Federico Negro     Initial Version
**/
public class PV3264VariazioneRataMinimaInserimento extends PVAction {

    public class PV3264VariazioneRataMinimaInserimentoForm extends PVForm {
        
        @AuraEnabled public String rataNew {get; set;}
		@AuraEnabled public String rataOld {get; set;}
        @AuraEnabled public String percentualeNew {get; set;}
		@AuraEnabled public String percentualeOld {get; set;}
        
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

	//recupera la rata minima dalla tabella psv_credit_limit
    @AuraEnabled
	public static PSV_Limite_Credito__mdt getRataMinima(String emettitore){
        
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
    
	@AuraEnabled
	public static void conferma(PV3264VariazioneRataMinimaInserimentoForm datiForm){
		new PV3264VariazioneRataMinimaInserimento().execute(datiForm);
	}

	/***************************/
	/* metodi NON Aura enabled */
	/***************************/

	public void execute(PVForm form){
		
		String messaggio_errore = '';
		
		try{
		PV3264VariazioneRataMinimaInserimentoForm myForm = (PV3264VariazioneRataMinimaInserimentoForm) form;

		OCSVariazioneRataMinimaInvoker.Request req = new OCSVariazioneRataMinimaInvoker.Request();

		req.variazioneRataMinimaRequest.provenienza='CA';
        req.variazioneRataMinimaRequest.tipoIntermediario='AG';
      	req.variazioneRataMinimaRequest.intermediario='12';
        req.variazioneRataMinimaRequest.procedura='CA';
        req.variazioneRataMinimaRequest.numPratica=myForm.pratica.numPratica;
        req.variazioneRataMinimaRequest.pagMinImporto = myForm.rataNew;
		req.variazioneRataMinimaRequest.pagMinPerc = myForm.percentualeNew;
        req.variazioneRataMinimaRequest.codiceRifExt = '';
        req.variazioneRataMinimaRequest.codiceRifExt2 = '';
        req.variazioneRataMinimaRequest.utente=myForm.userData.user.Alias;

		OCSVariazioneRataMinimaInvoker.Response res = OCSVariazioneRataMinimaInvoker.invoke(req.variazioneRataMinimaRequest);

			System.debug('PV3264 Variazione Rata Minima - OCSVariazioneRataMinimaInvoker res: ' + res);

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
		PV3264VariazioneRataMinimaInserimentoForm myForm = (PV3264VariazioneRataMinimaInserimentoForm) form;
		/// : Note specifiche PV
		String notaSpecificaPV;
		notaSpecificaPV =  'Rata Minima da ' + (Decimal.valueOf(myForm.rataOld)).setScale(1)+ ' a ' + (Decimal.valueOf(myForm.rataNew)/100).setScale(1) + '\n';
		notaSpecificaPV +=  'Percentuale del saldo da ' + myForm.percentualeOld + ' a ' + (Decimal.valueOf(myForm.percentualeNew)/100).setScale(2) + '\n';
		return notaSpecificaPV;
	}
		
	public override XCS_Messaggio__c preparaMessaggioOCS(PVForm form, XCS_Messaggio__c xcs_messaggio){
		//preparazione XCS_Messaggio
		PV3264VariazioneRataMinimaInserimentoForm myForm = (PV3264VariazioneRataMinimaInserimentoForm) form;
		//xcs_messaggio.CodCliente__c = myForm.cliente.codCliente;
		xcs_messaggio.NumPratica__c = myForm.pratica.numPratica;
		xcs_messaggio.TipoPratica__c = myForm.pratica.tipoPratica;
		return xcs_messaggio;
	}

}