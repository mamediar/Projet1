public class OCSCreaProspectRequest extends OCSRequest {

    @AuraEnabled
    public DatiProspectDTO datiProspect{get;set;}
    
    public class DatiProspectDTO {
        public String ragioneSociale;
        public String nome;
        public String cognome;
        public String codiceFiscale;
        public String sesso;
        public String dataNascita;
        public String localitaNascita;
        public String provinciaNascita;
        public String telefono;
        public String telefonoCellulare;
        public String email;
        public String codiceNDG2;
        public String modalitaAggiornamento;
        public String tipoAnagrafica;
        public String istruttPratiche;
        public String rilevaQualita;
        public String offCommInterne;
        public String offCommEsterne;
        public String serviziAltri;
        public String datiSensibili;
        public String tipoSegnalazione;
    }

    public OCSCreaProspectRequest() {
        this.serviceId = 'creaProspect';
        this.datiProspect = new DatiProspectDTO();
    }
}