public class CervedOneStepBuyInvoker {

	public static CervedOneStepBuyResponse richiediGlobalExpert(String ragioneSociale, String partitaIva, String codiceFiscale, String indirizzo, String cap, String provincia, String citta) {
		CervedOneStepBuyRequest request = new CervedOneStepBuyRequest();
		request.cervedOneStepBuyRequest.companyName = ragioneSociale;
		request.cervedOneStepBuyRequest.vatNumber = partitaIva;
		request.cervedOneStepBuyRequest.fiscalCode = codiceFiscale;
		request.cervedOneStepBuyRequest.address = indirizzo;
		request.cervedOneStepBuyRequest.zipCode = cap;
		request.cervedOneStepBuyRequest.addressProvince = provincia;
		request.cervedOneStepBuyRequest.town = citta;

		return (CervedOneStepBuyResponse) ApiUtils.callApi('cerved.oneStepBuy', request, CervedOneStepBuyResponse.class);
  }
	
}