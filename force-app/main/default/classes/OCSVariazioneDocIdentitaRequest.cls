public class OCSVariazioneDocIdentitaRequest extends OCSRequest{

    @AuraEnabled 
    public String authorization {get;set;}
    @AuraEnabled
    public DatiVariazioneDocIdentitaRequest datiVariazioneDocIdentitaRequest {get;set;}

    public OCSVariazioneDocIdentitaRequest() {
        this.serviceId = 'variazioneDocIdentita';
        this.datiVariazioneDocIdentitaRequest = new DatiVariazioneDocIdentitaRequest();
    }
    
    
    
    public class DatiVariazioneDocIdentitaRequest {    

		@AuraEnabled public String codCliente {get { if (codCliente == null ) codCliente = ''; return codCliente; } set;}   
		@AuraEnabled public String tipoDoc {get { if (tipoDoc == null ) tipoDoc = ''; return tipoDoc; } set;}   
		@AuraEnabled public String numeroDoc {get { if (numeroDoc == null ) numeroDoc = ''; return numeroDoc; } set;}   
		@AuraEnabled public String ufficioRilascio {get { if (ufficioRilascio == null ) ufficioRilascio = ''; return ufficioRilascio; } set;}   
		@AuraEnabled public String localitaRilascio {get { if (localitaRilascio == null ) localitaRilascio = ''; return localitaRilascio; } set;}   
		@AuraEnabled public String provinciaRilascio {get { if (provinciaRilascio == null ) provinciaRilascio = ''; return provinciaRilascio; } set;}   
		@AuraEnabled public String dataRilascio {get { if (dataRilascio == null ) dataRilascio = '0'; return dataRilascio; } set;}   
		@AuraEnabled public String dataScadenza {get { if (dataScadenza == null ) dataScadenza = '0'; return dataScadenza; } set;}   
	}


}