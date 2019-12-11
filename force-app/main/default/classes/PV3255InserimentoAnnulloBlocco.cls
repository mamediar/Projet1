public with sharing class PV3255InserimentoAnnulloBlocco extends PVAction {

	public class BloccoCarta {
		@AuraEnabled
		public String keyCode { get; set; }
		@AuraEnabled
		public String descrizione {
			get {
				return descrizione;
			}
			set {
				descrizione = value != null ? value.trim() : value;
			}
		}
	}

	public class BloccoSbloccoCartaResult {
		@AuraEnabled
		public String bloccoCarta { get; set; }
		@AuraEnabled
		public String as400Status { get; set; }
		@AuraEnabled
		public String as400Errore { get; set; }
	}

	@AuraEnabled
	public static List<BloccoCarta> getBlocchiCarte(String numeroCarta, String filtroBlocchi, Integer sottoTipologia) {
		List<BloccoCarta> blocchi;

		if (sottoTipologia == 116) {
			blocchi = getBlocchiCarteInserimento();
		} else if (sottoTipologia == 117) {
			blocchi = getBlocchiCarteAnnullo(numeroCarta, filtroBlocchi);
		}

		return blocchi;
	}

	@AuraEnabled
	public static BloccoSbloccoCartaResult bloccoSbloccoCarta(String numeroCarta, String tipoOperazione, String bloccoCarta, String utente) {
		BloccoSbloccoCartaResult result;

		try {

			OCSBloccoSbloccoCartaInvoker.BloccoSbloccoCartaRequestDTO bloccoSbloccoCartaRequestDTO = new OCSBloccoSbloccoCartaInvoker.BloccoSbloccoCartaRequestDTO();
			bloccoSbloccoCartaRequestDTO.numeroCarta = numeroCarta;
			bloccoSbloccoCartaRequestDTO.tipoOperazione = tipoOperazione;
			bloccoSbloccoCartaRequestDTO.bloccoCarta = bloccoCarta;
			bloccoSbloccoCartaRequestDTO.utente = utente;

			OCSBloccoSbloccoCartaInvoker.Response response = OCSBloccoSbloccoCartaInvoker.invoke(bloccoSbloccoCartaRequestDTO);
			System.debug('---> [PV3255InserimentoAnnulloBlocco - bloccoSbloccoCarta] response: ' + response);

			if (response != null && response.statusCode == 200 && response.resultCode == 0) {
				result = new BloccoSbloccoCartaResult();
				result.bloccoCarta = response.datiBloccoSbloccoCartaResponse.bloccoCarta;
				result.as400Status = response.datiBloccoSbloccoCartaResponse.as400Status;
				result.as400Errore = response.datiBloccoSbloccoCartaResponse.as400Errore;
			}

		} catch (Exception e) {
			System.debug('---> [PV3255InserimentoAnnulloBlocco - bloccoSbloccoCarta] Exception: ' + e.getMessage());
			result = null;
		}

		System.debug('---> [PV3255InserimentoAnnulloBlocco - bloccoSbloccoCarta] result: ' + result);
		return result;
	}

	private static List<BloccoCarta> getBlocchiCarteInserimento() {
		List<BloccoCarta> blocchi = new List<BloccoCarta>();
		List<BlocchiCarte__mdt> blocchiCarteMtdList = [SELECT CodiceBlocco__c, DescBlocco__c FROM BlocchiCarte__mdt WHERE psvVisibile__c = '1'];

		if (!blocchiCarteMtdList.isEmpty()) {
			for (BlocchiCarte__mdt bloccoCarteMtd : blocchiCarteMtdList) {
				BloccoCarta bloccoCarta = new BloccoCarta();
				bloccoCarta.keyCode = bloccoCarteMtd.CodiceBlocco__c;
				bloccoCarta.descrizione = bloccoCarteMtd.DescBlocco__c;
				blocchi.add(bloccoCarta);
			}
		}

		System.debug('---> [PV3255InserimentoAnnulloBlocco - getBlocchiCarteInserimento] blocchi: ' + blocchi);
		return blocchi;
	}

    private static List<BloccoCarta> getBlocchiCarteAnnullo(String numeroCarta, String filtroBlocchi) {
		List<BloccoCarta> blocchi;

		try {

			OCSrecuperaBlocchiCartaInvoker.RecuperaBlocchiCartaRequestDTO recuperaBlocchiCartaRequestDTO = new OCSRecuperaBlocchiCartaInvoker.RecuperaBlocchiCartaRequestDTO();
			recuperaBlocchiCartaRequestDTO.numCarta = numeroCarta;
			recuperaBlocchiCartaRequestDTO.filtroBlocchi = filtroBlocchi;

			OCSrecuperaBlocchiCartaInvoker.Response response = OCSrecuperaBlocchiCartaInvoker.invoke(recuperaBlocchiCartaRequestDTO);
			System.debug('---> [PV3255InserimentoAnnulloBlocco - getBlocchiCarteAnnullo] response: ' + response);

			if (response != null && response.statusCode == 200 && response.resultCode == 0) {
				blocchi = new List<BloccoCarta>();

				if (response.recuperaBlocchiCartaResponse.elencoBlocchi != null) {
					for (OCSrecuperaBlocchiCartaInvoker.BloccoCarta blocco : response.recuperaBlocchiCartaResponse.elencoBlocchi) {
						BloccoCarta bloccoCarta = new BloccoCarta();
						bloccoCarta.keyCode = blocco.keyCode;
						bloccoCarta.descrizione = blocco.descrizione;
						blocchi.add(bloccoCarta);
					}
				}
			}

		} catch (Exception e) {
			System.debug('---> [PV3255InserimentoAnnulloBlocco - getBlocchiCarteAnnullo] Exception: ' + e.getMessage());
			blocchi = null;
		}

		return blocchi;
	}

	/*****************************************************************************************************************/

    public class PV3255InserimentoAnnulloBloccoForm extends PVForm {
		@AuraEnabled
		public BloccoCarta bloccoCarta { get; set;}
	}

    @AuraEnabled
	public static void conferma(PV3255InserimentoAnnulloBloccoForm datiForm) {
        System.debug('---> [PV3255InserimentoAnnulloBlocco - conferma] datiForm: ' + datiForm);
		new PV3255InserimentoAnnulloBlocco().execute(datiForm);
	}

	public void execute(PVForm form) {
		String messaggio_errore = '';

        try {
			PV3255InserimentoAnnulloBloccoForm myForm = (PV3255InserimentoAnnulloBloccoForm) form;
            System.debug('---> [PV3255InserimentoAnnulloBlocco - execute] PVForm: ' + myForm);
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
		PV3255InserimentoAnnulloBloccoForm myForm = (PV3255InserimentoAnnulloBloccoForm) form;
		xcs_messaggio.NumPratica__c = myForm.pratica.numPratica;
		xcs_messaggio.TipoPratica__c = myForm.pratica.tipoPratica;
		xcs_messaggio.CodCliente__c = myForm.pratica.codCliente;
		return xcs_messaggio;
	}
}