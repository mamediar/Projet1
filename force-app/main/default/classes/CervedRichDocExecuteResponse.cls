public class CervedRichDocExecuteResponse extends OCSResponse {

    /*@AuraEnabled public String statusMessage {get {
    	// definiamo logica
    };} */
		
    @AuraEnabled public CervedRichDocExecuteResponseDTO cervedRichDocExecuteResponse;

    public CervedRichDocExecuteResponse() {
        this.cervedRichDocExecuteResponse = new CervedRichDocExecuteResponseDTO();
    }

    public class CervedRichDocExecuteResponseDTO {
        @AuraEnabled public String responseId;
        @AuraEnabled public Long timeStamp;
        @AuraEnabled public RichDocOutput richDocOutput;
        @AuraEnabled public Error error;
        @AuraEnabled public List<String> clientMessage;
        @AuraEnabled public List<String> token;

        public CervedRichDocExecuteResponseDTO() {
            this.richDocOutput = new RichDocOutput();
            this.error = new Error();
            this.clientMessage = new List<String>();
            this.token = new List<String>();
        }
    }

    public class RichDocOutput {
        @AuraEnabled public String outcome;
        @AuraEnabled public String deferredId;
        @AuraEnabled public String resultXML;
        @AuraEnabled public String resultPDF;
    }

    public class Error {
        @AuraEnabled public Integer errorCode;
        @AuraEnabled public String errorMessage;
    }
}