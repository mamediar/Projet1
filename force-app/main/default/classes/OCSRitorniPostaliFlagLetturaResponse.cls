public class OCSRitorniPostaliFlagLetturaResponse extends OCSResponse {
    
    @AuraEnabled
    public String esito {get;set;}
    
    @AuraEnabled
    public String esitoProgressivo {get;set;}
    
    public OCSRitorniPostaliFlagLetturaResponse() {
        
    }

}