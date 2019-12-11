public class OCSVariazioneTelefonoBancaRequest extends OCSRequest{
    @AuraEnabled public VariazioneTelefonoBancaRequestDTO variazioneTelefonoBancaRequest {get;set;}

    public OCSVariazioneTelefonoBancaRequest() {
          serviceId = 'variazioneTelefonoBanca';
          variazioneTelefonoBancaRequest = new VariazioneTelefonoBancaRequestDTO();
    }

    public class VariazioneTelefonoBancaRequestDTO{

        @AuraEnabled  public String abi{get;set;}
        @AuraEnabled  public String cab{get;set;}
        @AuraEnabled  public String telefono{get;set;}
    }

}