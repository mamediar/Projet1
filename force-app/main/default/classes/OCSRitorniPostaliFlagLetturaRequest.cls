public class OCSRitorniPostaliFlagLetturaRequest extends OCSRequest{
    
    public List<String> elencoProgressiviPostel {get;set;}
    
    public OCSRitorniPostaliFlagLetturaRequest(List<String> elencoProgressiviPostelParam) {
        serviceId = 'ritorniPostaliFlagLettura';
        this.elencoProgressiviPostel = elencoProgressiviPostelParam;
    }

}