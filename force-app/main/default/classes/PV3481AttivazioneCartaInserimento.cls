/**
 * @File Name          : PV3481AttivazioneCartaInserimento.cls
 * @Description        : 
 * @Author             : Lorenzo Marzocchi
 * @Group              : 
 * @Last Modified By   : sabrina vitali
 * @Last Modified On   : 11/9/2019, 16:16:40
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    2019-6-19 15:39:07   Lorenzo Marzocchi     Initial Version
**/
public class PV3481AttivazioneCartaInserimento extends PVAction {
	public class PV3481AttivazioneCartaForm extends PVForm {
		@AuraEnabled
		public String statoCartaAttuale {get; set;}
		@AuraEnabled
		public OCSCartaDatiFinanziariResponse.DatiCartaDatiFinanziariResponseDTO datiFinanziari {get; set;}
	}

    @AuraEnabled
    public static void conferma(PV3481AttivazioneCartaForm datiForm){
    	new PV3481AttivazioneCartaInserimento().execute(datiForm);
    } 
    
    @AuraEnabled
    public static OCSCartaDatiFinanziariResponse.DatiCartaDatiFinanziariResponseDTO recuperaDatiFinanziari(String numeroCarta){
        OCSCartaDatiFinanziariResponse cartaDatiFinanziariResponse = OCSCartaDatiFinanziariInvoker.cartaDatiFinanziari(numeroCarta);
		return cartaDatiFinanziariResponse.datiCartaDatiFinanziariResponse;
    } 


	/* metodi NON aura enabled */


	public void execute(PVForm form){
		String messaggio_errore = '';
		try{
			PV3481AttivazioneCartaForm myForm = (PV3481AttivazioneCartaForm) form;

			OCSAttivazioneCartaDiCreditoInvoker.ValoriRichiesti val = new OCSAttivazioneCartaDiCreditoInvoker.ValoriRichiesti();
			val.scadenzaCarta = myForm.datiFinanziari.dataScadenza;
			val.numeroCarta = myForm.pratica.numPratica;
			OCSAttivazioneCartaDiCreditoResponse ocsAttivazioneCartaDiCreditoResponse = OCSAttivazioneCartaDiCreditoInvoker.attivaCarta(val);
			if(!ocsAttivazioneCartaDiCreditoResponse.datiAttivazioneCartaDiCreditoResponse.as400Status.equalsIgnoreCase('KO')){ 
				// per questo servizio non è possbile testare isOk perchè se OK restituisce stringa vuota
				myform.statoCartaAttuale = ocsAttivazioneCartaDiCreditoResponse.datiAttivazioneCartaDiCreditoResponse.statoCarta;
				//Common di PVAction
				commonExecute(myForm);
			}else{
				messaggio_errore = ocsAttivazioneCartaDiCreditoResponse.datiAttivazioneCartaDiCreditoResponse.as400Errore;
			}
		}catch(Exception e) {
			messaggio_errore = e.getMessage();
		}finally{
			if(messaggio_errore != '') {
				//throw new AuraHandledException in PVAction
				gestisciException(messaggio_errore);
			}
		}
	}


	public override Case completaCasePostVendita(Case casoPV,PVForm form){
		//continuare a valorizzare l'oggetto casoPV integrando i dati di questo post vendita
		PV3481AttivazioneCartaForm myForm = (PV3481AttivazioneCartaForm) form;
		return casoPV;
	}

	public override String recuperaNotaSpecificaPV(PVForm form, Case casoPV){
		//preparazione nota specifica PV
		PV3481AttivazioneCartaForm myForm = (PV3481AttivazioneCartaForm) form;
		//7 : Note specifiche PV
		String notaSpecificaPV;
		notaSpecificaPV = 'Numero pratica: CA - ' +  myForm.pratica.numPratica + '<br>';
		notaSpecificaPV +=  'Stato pratica precedente: ' + myForm.pratica.statoPratica + '<br>';
		notaSpecificaPV +=  'Stato pratica attuale: ' + myForm.statoCartaAttuale + '<br>';
		return notaSpecificaPV;
	}


	public override XCS_Messaggio__c preparaMessaggioOCS(PVForm form, XCS_Messaggio__c xcs_messaggio){
		//preparazione XCS_Messaggio
		PV3481AttivazioneCartaForm myForm = (PV3481AttivazioneCartaForm) form;
		//xcs_messaggio.CodCliente__c = myForm.cliente.codCliente;
		xcs_messaggio.NumPratica__c = myForm.pratica.numPratica;
		xcs_messaggio.TipoPratica__c = 'CA';
		return xcs_messaggio;
	}

}