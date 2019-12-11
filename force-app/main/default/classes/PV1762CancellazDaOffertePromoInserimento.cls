/**
 * @File Name          : PV1762CancellazDaOffertePromoInserimento.cls
 * @Description        :
 * @Author             : Andrea Vanelli
 * @Group              :
 * @Last Modified By   : Federico Negro
 * @Last Modified On   : 22/10/2019, 17:24:33
 * @Modification Log   :
 *==============================================================================
 * Ver         Date                     Author                        Modification
 *==============================================================================
 * 1.0    2019-6-19 17:12:51   Andrea Vanelli     Initial Version
 **/
public class PV1762CancellazDaOffertePromoInserimento extends PVAction {

	public class PV1762CancellazDaOffertePromoForm extends PVForm {
	}

	/*********************************/
	/* metodi CUSTOM del singolo PV */





	/*****************************/
	/* metodi STANDARD 			 */	

	@AuraEnabled
	public static void conferma(PV1762CancellazDaOffertePromoForm datiForm){
		new PV1762CancellazDaOffertePromoInserimento().execute(datiForm);
	}


	public void execute(PVForm form){
		String messaggio_errore = '';

		PV1762CancellazDaOffertePromoForm myForm = (PV1762CancellazDaOffertePromoForm) form;
		OCSCliente cliente = myForm.cliente;
		System.debug('FFOORRMM: '+myForm);
		System.debug('Codice cliente: '+cliente.codCliente);
		OCSVariazioneOffertePromoResponse res = OCSVariazioneOffertePromoInvoker.variazioneOffertePromo(cliente.codCliente);
		System.debug('RISPOSTA stato : '+res.status);
		System.debug('#######? : '+res.isOK());
		if(res.isOK()) {
			System.debug('dentrissimo');
			commonExecute(myForm);
			System.debug('dopo common');
		}else{                          
			messaggio_errore = res.getMessage();
		}
		
		if(messaggio_errore != '') { 
			gestisciException(messaggio_errore);
		}
				 
	}

	public override Case completaCasePostVendita(Case casoPV,PVForm form){
		//continuare a valorizzare l'oggetto casoPV integrando i dati di questo post vendita
		PV1762CancellazDaOffertePromoForm myForm = (PV1762CancellazDaOffertePromoForm) form;
		System.debug('MDT: '+myForm.reasonMdt.dispositionId__c);
		//casoPV.Disposition__c = XCS_DispositionUtils.findDispositionByExternalID('DP'+myForm.reasonMdt.dispositionId__c).Id;
		return casoPV;
	}

	public override String recuperaNotaSpecificaPV(PVForm form, Case casoPV){
		//preparazione nota specifica PV
		PV1762CancellazDaOffertePromoForm myForm = (PV1762CancellazDaOffertePromoForm) form;
		String notaSpecificaPV;
		notaSpecificaPV =  'Motivazione: ' + myForm.reasonMdt.Descrizione__c + '<br>';
		return notaSpecificaPV;
	}

	public override XCS_Messaggio__c preparaMessaggioOCS(PVForm form, XCS_Messaggio__c xcs_messaggio){
		//preparazione XCS_Messaggio
		PV1762CancellazDaOffertePromoForm myForm = (PV1762CancellazDaOffertePromoForm) form;
		xcs_messaggio.CodCliente__c = myForm.cliente.codCliente;
		return xcs_messaggio;
	}
}