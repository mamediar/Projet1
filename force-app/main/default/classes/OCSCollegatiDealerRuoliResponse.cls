public class OCSCollegatiDealerRuoliResponse extends OCSResponse {

	public List<DatiCollegatiDealerRuoliDTO> datiCollegatiDealerRuoli;

	public OCSCollegatiDealerRuoliResponse() {
		datiCollegatiDealerRuoli = new List<DatiCollegatiDealerRuoliDTO>();
	}

	public class DatiCollegatiDealerRuoliDTO {
		public String codCliente;
		public String cognome;
		public String nome;
		public String firmatario;
		public String rappresentante;
		public String referente;
		public String socio;
		public String titolare;
		public String responsabileISVAP;
	}
}