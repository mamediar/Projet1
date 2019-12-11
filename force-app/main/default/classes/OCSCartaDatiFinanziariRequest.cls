/**
 * @File Name          : OCSCartaDatiFinanziariRequest.cls
 * @Description        : 
 * @Author             : Federico Negro
 * @Group              : 
 * @Last Modified By   : Federico Negro
 * @Last Modified On   : 30/10/2019, 09:41:30
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    30/10/2019   Federico Negro     Initial Version
**/
public class OCSCartaDatiFinanziariRequest extends OCSRequest{ 

    @auraEnabled
    public DatiCartaDatiFinanziariRequestDTO datiCartaDatiFinanziariRequest {get; set;}
  
    public OCSCartaDatiFinanziariRequest() {
        
        serviceId = 'cartaDatiFinanziari';
        datiCartaDatiFinanziariRequest = new DatiCartaDatiFinanziariRequestDTO();
       
    }
    
    
    
    public class DatiCartaDatiFinanziariRequestDTO {
        
        public String numeroPratica {get; set;}
        
    }
    
    
}