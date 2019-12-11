public with sharing class PV1754StornoAddebito extends PVAction {
    
    
     public class PV1754StornoAddebitoForm extends PVForm {
		
	}

    @AuraEnabled
	public static void conferma(PV1754StornoAddebitoForm datiForm) {
        System.debug('---> [PV1754StornoAddebito - conferma] datiForm: ' + datiForm);
		new PV1754StornoAddebito().execute(datiForm);
	}

	public void execute(PVForm form) {
		String messaggio_errore = '';

        try {
			PV1754StornoAddebitoForm myForm = (PV1754StornoAddebitoForm) form;
            System.debug('---> [PV1754StornoAddebito - execute] PVForm: ' + myForm);
			commonExecute(myForm);
		} catch (Exception e) {
			messaggio_errore = e.getMessage();
		} finally {
			if (messaggio_errore != '') {
				gestisciException(messaggio_errore);
			}
		}
	}
    public override Case completaCasePostVendita(Case casoPV, PVForm form) {
		return casoPV;
	}

	public override String recuperaNotaSpecificaPV(PVForm form, Case casoPV) {
		return '';
	}

	public override XCS_Messaggio__c preparaMessaggioOCS(PVForm form, XCS_Messaggio__c xcs_messaggio) {
		PV1754StornoAddebitoForm myForm = (PV1754StornoAddebitoForm) form;
		xcs_messaggio.NumPratica__c = myForm.pratica.numPratica;
		xcs_messaggio.TipoPratica__c = myForm.pratica.tipoPratica;
		xcs_messaggio.CodCliente__c = myForm.pratica.codCliente;
		return xcs_messaggio;
	}
}