/**
 * @File Name          : PVResponse.cls
 * @Description        : 
 * @Author             : Federico Negro
 * @Group              : 
 * @Last Modified By   : Federico Negro
 * @Last Modified On   : 5/11/2019, 16:34:03
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    5/11/2019   Federico Negro     Initial Version
**/
public class PVResponse {

    @AuraEnabled
	public String statusCode {get; set;}
	@AuraEnabled
	public List<List<String>> messages {get; set;}

    public PVResponse() {
        messages = new List<List<String>>();
    }

    public void insMessage (String tipo, String messaggio, String durata){
		List<String> rispAtt=new List<String>();
		rispAtt.add(tipo);
		rispAtt.add(messaggio);
		rispAtt.add(durata);
		messages.add(rispAtt);
    }
    
}