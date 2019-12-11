public class OCSCreaProspectResponse extends OCSResponse {
    
    public DatiCreaProspectResponseDTO datiCreaProspectResponse;

    public class DatiCreaProspectResponseDTO {
        public String AS400Status;
        public String AS400Errore;
        public String codiceAnagrafico;
        public String flagAnagraficaEsistente;
    }
}