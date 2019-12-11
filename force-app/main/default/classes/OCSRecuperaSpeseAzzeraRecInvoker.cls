/**
 * @File Name          : OCSRecuperaSpeseAzzeraRecInvoker.cls
 * @Description        :
 * @Author             : Andrea Vanelli
 * @Group              :
 * @Last Modified By   : Andrea Vanelli
 * @Last Modified On   : 21/10/2019, 14:23:33
 * @Modification Log   :
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    29/7/2019, 11:24:28   Andrea Vanelli     Initial Version
 **/

public class OCSRecuperaSpeseAzzeraRecInvoker {


//********************
// REQUEST
//********************
	public class Request extends OCSRequest {

		public String numPratica {get; set;}
		public String tipoPratica {get; set;}

		public Request() {
			serviceId = 'recuperaSpeseAzzeramentoRecupero';
		}

	}


//********************
// RESPONSE DTO
//********************

	public class Response extends OCSResponse {
		@AuraEnabled
		public List<SpesaRecuperoDTO> elencoSpese {get; set;}
		public boolean hasAnnullate;

		public Response() {
			elencoSpese = new List<SpesaRecuperoDTO>();
			hasAnnullate=false;
		}
	private String descrizioneSpesa(SpesaRecuperoDTO s) {
				String testo = '';
				testo += 'Spesa di ' + s.tipoSpesaDescr;
				if (s.rata != '') {
					testo += ' rata ' + s.rata;
				} else {
					testo += ' (#' + s.progressivo + ') ';
				}
				testo += ' del ' + s.dataRegistrazione;
				testo += ' importo ' + s.importoMaturato;
				testo += ' non incassato ' + s.saldo;

				return testo;
	}
		public void prepareData() {
			for (SpesaRecuperoDTO s : elencoSpese) {
				//System.debug('aaaaaaaaaaaaaa' + s.dataRegistrazione);
				s.customID = s.provenienza + s.pratica.leftPad(12, ' ') + s.tipoSpesa + s.progressivo.leftPad(9, ' ');
				s.importoMaturato = OCSResponse.setNumber(s.importoMaturato);
				s.importoIncassato = OCSResponse.setNumber(s.importoIncassato);
				s.saldo = OCSResponse.setNumber(s.saldo);
				s.descrizioneSpesa = descrizioneSpesa(s);

				if (s.statoRecord.equals('A')) {
					hasAnnullate=true;
				}
/*				System.debug('aaaaaaaaaaaaaa' + s.dataRegistrazione);
System.debug('aaaaaaaaaaaaaa' + s.descrizioneSpesa);*/
				/*	elencoSpese.newRow();
				        elencoSpese.setField_psv_loan_instalment_cost_id(dati.getProgressivo());
				        elencoSpese.setField_psv_loan_instalment_cost_type(dati.getTipoSpesa());
				        elencoSpese.setField_psv_loan_instalment_cost_regist_dt(convertiData(dati.getDataRegistrazione()));
				        elencoSpese.setField_psv_loan_instalment_cost_accrued_import(convertiImporto(dati.getImportoMaturato()));
				        elencoSpese.setField_psv_loan_instalment_cost_cashed_import(convertiImporto(dati.getImportoIncassato()));
				        elencoSpese.setField_psv_loan_instalment_cost_balance_import(convertiImporto(dati.getSaldo()));
				        elencoSpese.setField_psv_loan_instalment_cost_taking_dt(convertiData(dati.getDataIncasso()));
				        elencoSpese.setField_psv_loan_instalment_id(dati.getRata());
				        elencoSpese.setField_psv_loan_instalment_import(convertiImporto(dati.getImportoRata()));
				        elencoSpese.setField_psv_loan_instalment_cost_proven(dati.getProvenienza());
				        elencoSpese.setField_psv_loan_instalment_cost_pratica(dati.getPratica());
				        elencoSpese.setField_psv_loan_instalment_cost_cLettera(dati.getCodiceLettera());
				        elencoSpese.setField_psv_loan_instalment_cost_scrittura(dati.getScrittura());
				        elencoSpese.setField_psv_loan_instalment_cost_stato(dati.getStatoRecord());
				        elencoSpese.setField_psv_loan_instalment_cost_impon_import(convertiImporto(dati.getImponibile()));
				        elencoSpese.setField_psv_loan_instalment_cost_effettiva_perc(dati.getPercCalc());
				        elencoSpese.setField_psv_loan_instalment_cost_contrat_perc(dati.getPercCont());

				        // creo l'ID univoco di selezione
				        // [prov##][pratica'           0'][Tipo#][progressivo####]
				        StringBuilder id = new StringBuilder();
				        id
				        .append(dati.getProvenienza())
				        .append(String.format("%12d", convertiNumero(dati.getPratica())))
				        .append(dati.getTipoSpesa())
				        .append(String.format("%09d", convertiNumero(dati.getProgressivo())));
				        elencoSpese.setField_psv_loan_instalment_cost_sel_id(id.toString());
				        elencoSpese.addRow();

				        // verifiche
				        if (dati.getStatoRecord().equals("A")) {
				                hasAnnullate=true;
				        }*/


			}

		}



	}

	public class SpesaRecuperoDTO {
		// ritorno dal servizio
		@AuraEnabled public String tipoSpesa {get; set;}
		@AuraEnabled public String dataRegistrazione {get{ return OCSResponse.getDate(dataRegistrazione);} set;}
		@AuraEnabled public Double importoMaturato {get; set;}
		@AuraEnabled public Double importoIncassato {get; set;}
		@AuraEnabled public Double saldo {get; set;}
		@AuraEnabled public String dataIncasso {get { return OCSResponse.getDate(dataIncasso);} set;}
		@AuraEnabled public String rata {get; set;}
		@AuraEnabled public String provenienza {get; set;}
		@AuraEnabled public String pratica {get; set;}
		@AuraEnabled public String progressivo {get; set;}
		@AuraEnabled public String codiceLettera {get; set;}
		@AuraEnabled public String scrittura {get; set;}
		@AuraEnabled public String statoRecord {get; set;}
		@AuraEnabled public String importoRata {get; set;}
		@AuraEnabled public String imponibile {get; set;}
		@AuraEnabled public String percCalc {get; set;}
		@AuraEnabled public String percCont {get; set;}

		// campi aggiuntivi che servono
		@AuraEnabled public String customID {get; set;}
		@AuraEnabled public String selezioneOriginale {get; set;}
		@AuraEnabled public String showClass {get; set;}
		@AuraEnabled public String buttonIcon {get; set;}

		@AuraEnabled
		public String tipoSpesaDescr {
			get {
				if (tipoSpesa == 'E') {
					return 'Esattoria';
				} else if (tipoSpesa == 'S') {
					return 'Sollecito';
				} else {
					return tipoSpesa;
				}
			} set;
		}


		@AuraEnabled
		public String descrizioneSpesa{get; set;}
		




	}




//********************
// INVOKER
//********************

	public static Response invoke (String numPratica, String tipoPratica ){

		Request req = new Request();
		req.numPratica = numPratica;
		req.tipoPratica = tipoPratica;

		Response res = (Response)ApiUtils.callApi ('ocs.'+req.serviceId,req, Response.class, 'C' );
		res.prepareData();
		return res;

	}


/***********************
 *   CHIAMATA PER TEST
 ************************/


	//OCSRecuperaSpeseAzzeraRecInvoker.invoke('15157523', 'CO');

}