public class OCSrecuperaDatiUtenteZucchettiRequest extends OCSRequest{

    public recuperaDatiUtenteZucchettiRequestDTO recuperaDatiUtenteZucchettiRequest{get; set;}

    public OCSrecuperaDatiUtenteZucchettiRequest(){
        this.serviceId= 'recuperaDatiUtenteZucchetti';
        this.recuperaDatiUtenteZucchettiRequest= new recuperaDatiUtenteZucchettiRequestDTO();
    }

    public class recuperaDatiUtenteZucchettiRequestDTO{
        public String codiceUtente{get;set;}
    }
}