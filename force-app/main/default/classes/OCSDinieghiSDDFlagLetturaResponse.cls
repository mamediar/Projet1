public class OCSDinieghiSDDFlagLetturaResponse extends OCSResponse {

    @AuraEnabled
    public DinieghiSDDFlagLetturaResponseDTO dinieghiSDDFlagLetturaResponse{get;set;}
    
    public class DinieghiSDDFlagLetturaResponseDTO{
        @AuraEnabled public String esito;
        @AuraEnabled public String erroreCanomanProgressivo;
        @AuraEnabled public String erroreCanomanProgreMan;
    }
}