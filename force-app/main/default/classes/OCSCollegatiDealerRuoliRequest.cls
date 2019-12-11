public class OCSCollegatiDealerRuoliRequest extends OCSRequest {

	public DatiCollegatiDealerRuoliRequestDTO datiCollegatiDealerRuoliRequest {get; set;}

	public OCSCollegatiDealerRuoliRequest() {
		serviceId = 'collegatiDealerRuoli';
		datiCollegatiDealerRuoliRequest = new DatiCollegatiDealerRuoliRequestDTO();
	}

	public class DatiCollegatiDealerRuoliRequestDTO {
        public String codCliente {get; set;}
    }
}