/**
*@author 		Mame bousso kane
*created 		05/08/2019
*descripttion   AppuntamentoCercaRequest class
*/
public class AppuntamentoCercaRequest extends OCSAPIRequest{
    public String  societa {get;set;}
    public String  utenteEsterno {get;set;}
    public String  utenteInterno {get;set;}
    public String  codiceFiscale {get;set;}

    public AppuntamentoCercaRequest (){
        super();
    }
    public AppuntamentoCercaRequest(String  societa, String utenteEsterno, String utenteInterno,String codiceFiscale) {
        
        this.societa=societa;
        this.utenteEsterno=utenteEsterno;
        this.utenteInterno=utenteInterno;
        this.codiceFiscale=codiceFiscale;
    }
    
}