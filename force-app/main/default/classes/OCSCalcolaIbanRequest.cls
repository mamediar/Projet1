public class OCSCalcolaIbanRequest extends OCSRequest{
	@AuraEnabled
    public String abi;
    @AuraEnabled  
    public String cab;
    @AuraEnabled
    public String numConto;
    
    public OCSCalcolaIbanRequest(){
        this.serviceId='calcolaIban';
    }
}