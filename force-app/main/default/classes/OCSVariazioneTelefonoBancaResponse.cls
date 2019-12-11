public class OCSVariazioneTelefonoBancaResponse extends OCSResponse{
    @AuraEnabled public VariazioneTelefonoBancaResponseDTO variazioneTelefoniResponse {get;set;}

    public OCSVariazioneTelefonoBancaResponse() {
        variazioneTelefoniResponse = new VariazioneTelefonoBancaResponseDTO();
    }

    public class VariazioneTelefonoBancaResponseDTO {
        @AuraEnabled  public String as400Status{get;set;}
        @AuraEnabled  public String as400Errore{get;set;}
    }
}