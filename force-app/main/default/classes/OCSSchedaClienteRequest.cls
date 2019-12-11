public class OCSSchedaClienteRequest extends OCSRequest{
	@AuraEnabled
    public String numPratica{get;set;}
    @AuraEnabled
    public String flagInfoCliente{get;set;}
    @AuraEnabled
    public String filtroTipoPratica{get;set;}
    @AuraEnabled
    public String codCliente{get;set;}
    @AuraEnabled
    public String cognomeCliente{get;set;}
    @AuraEnabled
    public String nomeCliente{get;set;}
    @AuraEnabled
    public String dataNascitaCliente{get;set;}
    @AuraEnabled
    public String codFiscaleCliente{get;set;}
    @AuraEnabled
    public String pan{get;set;}
    @AuraEnabled
    public String telefonoCliente{get;set;}
    @AuraEnabled
    public String faxCliente{get;set;}
    @AuraEnabled
    public String emailCliente{get;set;}
    @AuraEnabled
    public String provinciaCliente{get;set;}
    @AuraEnabled
    public String ragioneSociale{get;set;}
    
    public OCSSchedaClienteRequest(){
		this.serviceId='schedaCliente';
    }
}