public class OCSRecuperaEstrattoContoPDFRequest extends OCSRequest {
    public RecuperaEstrattoContoPDFRequestDTO recuperaEstrattoContoPDFRequest{get;set;}

    public OCSRecuperaEstrattoContoPDFRequest() {
        serviceId = 'recuperaEstrattoContoPDF';
        recuperaEstrattoContoPDFRequest = new RecuperaEstrattoContoPDFRequestDTO();
    }
    public class RecuperaEstrattoContoPDFRequestDTO{

        @AuraEnabled public string codCliente{get;set;}
        @AuraEnabled public string numPratica{get;set;}
		@AuraEnabled public string mese{get;set;}
		@AuraEnabled public string anno{get;set;}
            
    }
}