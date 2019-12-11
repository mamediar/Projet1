public class OCSRecuperaTitolariEffettiviRequest extends OCSRequest{

    @AuraEnabled 
    public String authorization {get;set;}
    @AuraEnabled
    public DatiRecuperaTitolariEffettiviRequest recuperaTitolariEffettiviRequest {get;set;}

    public OCSRecuperaTitolariEffettiviRequest() {
        this.serviceId = 'recuperaTitolariEffettivi';
        this.recuperaTitolariEffettiviRequest = new DatiRecuperaTitolariEffettiviRequest();
    }
    
    
    
    public class DatiRecuperaTitolariEffettiviRequest {    
        
		@AuraEnabled public String codCliente {get { if (codCliente == null ) codCliente = ''; return codCliente; } set;}
        
	}


}