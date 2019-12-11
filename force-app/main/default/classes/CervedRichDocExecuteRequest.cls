public class CervedRichDocExecuteRequest extends OCSRequest {

    public CervedRichDocExecuteRequestDTO cervedRichDocExecuteRequest;

    public CervedRichDocExecuteRequest() {
		serviceId = 'cervedRichDocExecute';
		this.cervedRichDocExecuteRequest = new CervedRichDocExecuteRequestDTO();
    }

	public class Options {
		@AuraEnabled public List<Entry> entry;

        public Options() {
            entry = new List<Entry>();
        }
	}

	public class Entry {
		@AuraEnabled public String key;
		@AuraEnabled public String value;

		public Entry(String key, String value) {
            this.key = key;
			this.value = value;
        }
	}

	public class RichDocInput {
		@AuraEnabled public String requestType;
		@AuraEnabled public String taxCode;
		@AuraEnabled public String customerReference;
		@AuraEnabled public String deferredId;
		@AuraEnabled public String profile;
	}

	public class CervedRichDocExecuteRequestDTO {
		@AuraEnabled public String clientType;
		@AuraEnabled public String application;
		@AuraEnabled public String service;
		@AuraEnabled public Options options;
		@AuraEnabled public RichDocInput richDocInput;
		@AuraEnabled public String callerId;
		@AuraEnabled public Integer requestId;

		public CervedRichDocExecuteRequestDTO() {
			this.options = new Options();
        	this.richDocInput = new RichDocInput();
		}
	}


}