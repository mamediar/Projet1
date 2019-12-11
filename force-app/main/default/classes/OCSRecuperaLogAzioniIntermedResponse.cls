public class OCSRecuperaLogAzioniIntermedResponse extends OCSResponse {

	public RecuperaLogAzioniIntermediarioResponseDTO recuperaLogAzioniIntermediarioResponse;

	public OCSRecuperaLogAzioniIntermedResponse() {
		recuperaLogAzioniIntermediarioResponse = new RecuperaLogAzioniIntermediarioResponseDTO();
	}

	public class Elenco {
		public String intermediario;
		public String data;
		public String ora;
		public String dataRiferimento;
		public String utente;
		public String utenteForzatura;
		public String forzatura;
		public String stato;
		public String attributo;
		public String dataUltimoStatoFL;
		public String dataUltimoAttrSS;
		public String irregolarita;
		public String note01;
		public String note02;
		public String procedura;
		public String pratica;
	}

	public class RecuperaLogAzioniIntermediarioResponseDTO {
		public List<Elenco> elenco;

		public RecuperaLogAzioniIntermediarioResponseDTO() {
			elenco = new List<Elenco>();
		}
	}
}