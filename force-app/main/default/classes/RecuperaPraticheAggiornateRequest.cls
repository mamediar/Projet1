public  class RecuperaPraticheAggiornateRequest extends OCSAPIRequest {
    public  RecuperaPraticheAggiornateRequestDTO recuperaPraticheAggiornateRequest;

    public RecuperaPraticheAggiornateRequest() {
        this.serviceId = 'recuperaPraticheAggiornate';

        this.recuperaPraticheAggiornateRequest = new RecuperaPraticheAggiornateRequestDTO();

    }

    public class RecuperaPraticheAggiornateRequestDTO {
    public String dataInizio {get;set;}
    public String oraInizio {get;set;}
    public String filtroPartner{get;set;}
    }
}