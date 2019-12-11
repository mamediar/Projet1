public class XCS_IbanController {
    
    
    @AuraEnabled
    public static OCSCalcolaIbanInvoker.DatiChiamataOCS calcolaIBAN(String abi,String cab,String numConto) { 
        OCSCalcolaIbanResponse response = OCSCalcolaIbanInvoker.callCalcolaIban(abi,cab,numConto);
        OCSCalcolaIbanInvoker.DatiChiamataOCS datiChiamataOCS = OCSCalcolaIbanInvoker.processaResponse(response);
        return datiChiamataOCS;		
	} 
    
    @AuraEnabled
    public static Boolean verificaIBAN(String iban) { 
        return ValidationUtils.isIBANValido(iban);		
	}
    
    @AuraEnabled
    public static OCSCensimentoCCConvenzionatoInvoker.DatiChiamataOCS inserisciAggiornaCCSuOCS(String CCId, String accountId) {    
        return OCSCensimentoCCConvenzionatoInvoker.callCensimentoCCConvenzionato(CCId,accountId);
	}

    

}