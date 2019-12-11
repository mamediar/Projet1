/**
 * Compass virtual Rest WebService
 *
 * @author Moussa Fofana
 * @version 1.0
 * @description Compass virtual Rest WebService
 * @testedIn GCMServiceWsrTst_1_0
 * @code
 * @errorcode [ERR:CL-XXXYYZZ]
 * @history
 * 2019-03-13 : Moussa Fofana - Original
 */
global virtual class CGMServiceWsr_1_0 {
    
   

    /**
     * isResourceChanged description
     *
     * @param  partner partner description
     * @param  requestTimestamp requestTimestamp description
     *
     * @return return description
     *
     * @code 03
     */
    global static Boolean isResourceChanged(SObject obj, Long requestTimestamp) {

        return requestTimestamp == null || requestTimestamp < 
                CGMWSUtils_1_0.getRequestTimestamp((DateTime)obj.get('LastModifiedDate'));
    }

    /** Compass common web service rest virtual class */
    global virtual class CGMWSRResponse {
       
        global String status;
        global String errorCode;
        global String errorMessage;
        global String errorStackTrace;
        global Integer resultCode;

        global CGMWSRResponse() {

            this.status = CGMWSUtils_1_0.STATUS_OK;
            this.resultCode = CGMWSUtils_1_0.RESULT_CODE_OK;
        }

        global CGMWSRResponse(String status, String errorCode) {

            this.status = status;
            this.errorCode = errorCode;
            this.errorMessage = CGMWSUtils_1_0.ERROR_MESSAGE_MAP.get(errorCode);
        }

        global CGMWSRResponse(String status, String errorCode, String errorStackTrace) {

            this.status = status;
            this.errorCode = errorCode;
            this.errorMessage = CGMWSUtils_1_0.ERROR_MESSAGE_MAP.get(errorCode);
            this.errorStackTrace = errorStackTrace.replaceAll('\n', ' | ');
        }
        global CGMWSRResponse(String status, String errorCode, Integer resultCode) {

            this.status = status;
            this.errorCode = errorCode;
            this.errorMessage = CGMWSUtils_1_0.ERROR_MESSAGE_MAP.get(errorCode);
            this.resultCode = resultCode;
           // this.errorStackTrace = errorStackTrace.replaceAll('\n', ' | ');
        }
    }



    /** Generic sObject wrapper */
    global virtual class ObjectWrapper  {

        global String id;
        global String CaseNumber;
        global String AccountId;

        global ObjectWrapper() {
            
        }

        global ObjectWrapper(String Id) {

            this.Id = Id;
        }

        global ObjectWrapper(String CaseNumber, String AccountId) {
            this.AccountId = AccountId;
            this.CaseNumber = CaseNumber;
        }

        global ObjectWrapper(SObject obj) {

            this.id = obj.Id;
        }
    }
}