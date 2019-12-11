/***
* @author Madicke BALDE  
* @description Customization class for the response of the web service
*@uses
*@code
* @version 1.0
* 2019-06-19
*/
global virtual  class CGMServiceWsr_1_1 {
    
global virtual class CGM_WSR_Response{
    global Integer resultCode;
    global String resultMessage;
    global String errorCode;
    global String errorMessage;

    global CGM_WSR_Response(){
        this.resultCode = CGMWSUtils_1_0.RESULT_CODE_OK;
        this.resultMessage = CGMWSUtils_1_0.STATUS_OK;
    }

    global CGM_WSR_Response(Integer resultCode, String resultMessage, String errorCode){
        this.resultCode = resultCode;
        this.resultMessage = resultMessage;
        this.errorMessage = CGMWSUtils_1_0.ERROR_MESSAGE_MAP.get(errorCode);
        this.errorCode = errorCode;
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