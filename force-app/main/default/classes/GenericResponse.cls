/**
 * ***********************************************************************************
 *     * @author abdoulaye.diopdev3@compass.com.dev
 *     * @date  01/11/2019
 *     * @description class GenericResponse for the response of the webservice
 * ************************************************************************************
 **/
public virtual class GenericResponse {

    public Long resultCode {get; set;}
    public String resultMessage {get; set;}

    public GenericResponse(){}

    public GenericResponse(Long resultCode, String resultMessage){
        this.resultCode = resultCode;
        this.resultMessage = resultMessage;
    }
}