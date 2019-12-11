public class CervedRichDocExecuteInvoker {

	public static CervedRichDocExecuteResponse richiediQuickReport(String partitaIva, String idDifferita, String requestType) {
		CervedRichDocExecuteRequest request = new CervedRichDocExecuteRequest();
		request.cervedRichDocExecuteRequest.clientType = 'WEB';
		request.cervedRichDocExecuteRequest.application = 'COMPASS';
		request.cervedRichDocExecuteRequest.service = 'RICHDOC';

		request.cervedRichDocExecuteRequest.options.entry.add(new CervedRichDocExecuteRequest.Entry('DIV', 'E'));
		request.cervedRichDocExecuteRequest.options.entry.add(new CervedRichDocExecuteRequest.Entry('TYPE', 'I'));
		request.cervedRichDocExecuteRequest.options.entry.add(new CervedRichDocExecuteRequest.Entry('OUTPUT', 'XML,PDF'));
		request.cervedRichDocExecuteRequest.options.entry.add(new CervedRichDocExecuteRequest.Entry('VERPRES', '2'));

		request.cervedRichDocExecuteRequest.richDocInput.profile = 'CD2483';
        //request.cervedRichDocExecuteRequest.richDocInput.requestType = 'DOCUMENT';
		request.cervedRichDocExecuteRequest.richDocInput.requestType = requestType;
        request.cervedRichDocExecuteRequest.richDocInput.taxCode = partitaIva;
		request.cervedRichDocExecuteRequest.richDocInput.deferredId = idDifferita;
		request.cervedRichDocExecuteRequest.richDocInput.customerReference = null;

		return (CervedRichDocExecuteResponse) ApiUtils.callApi('cerved.richDocExecute', request, CervedRichDocExecuteResponse.class);

    }

}