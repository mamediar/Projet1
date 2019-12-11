public class OCSCollegatiDealerRuoliInvoker {
	
	public static OCSCollegatiDealerRuoliResponse retrieveCollegatiDealerRuoli(String codiceCliente) {

		OCSCollegatiDealerRuoliRequest request = new OCSCollegatiDealerRuoliRequest();
		request.datiCollegatiDealerRuoliRequest.codCliente = codiceCliente;

		OCSCollegatiDealerRuoliResponse response = (OCSCollegatiDealerRuoliResponse)ApiUtils.callApi('ocs.collegatiDealerRuoli', request, OCSCollegatiDealerRuoliResponse.class);

        return response;
	}
}