public with sharing class OCSBloccoSbloccoCartaInvoker {

    //********************
    // REQUEST
    //********************

    public class Request extends OCSRequest {

        public String numeroCarta { get; set; }
        public String tipoOperazione { get; set; }
        public String bloccoCarta { get; set; }
        public String utente { get; set; }

        public Request(BloccoSbloccoCartaRequestDTO bloccoSbloccoCartaRequestDTO) {
            this.serviceId = 'bloccoSbloccoCarta';
            this.numeroCarta = bloccoSbloccoCartaRequestDTO.numeroCarta;
            this.tipoOperazione = bloccoSbloccoCartaRequestDTO.tipoOperazione;
            this.bloccoCarta = bloccoSbloccoCartaRequestDTO.bloccoCarta;
            this.utente = bloccoSbloccoCartaRequestDTO.utente;
        }
    }

    public class BloccoSbloccoCartaRequestDTO {
        public String numeroCarta { get; set; }
        public String tipoOperazione { get; set; }
        public String bloccoCarta { get; set; }
        public String utente { get; set; }
    }


    //********************
    // RESPONSE DTO
    //********************

    public class Response extends OCSResponse {
        public BloccoSbloccoCartaResponseDTO datiBloccoSbloccoCartaResponse { get; set; }
    }

    public class BloccoSbloccoCartaResponseDTO {
        public String bloccoCarta { get; set; }
        public String as400Status { get; set; }
        public String as400Errore { get; set; }
    }


    //********************
    // INVOKER
    //********************

    public static Response invoke(BloccoSbloccoCartaRequestDTO bloccoSbloccoCartaRequestDTO) {
        Request request = new Request(bloccoSbloccoCartaRequestDTO);
        return (Response) ApiUtils.callApi ('ocs.' + request.serviceId, request, Response.class, 'C');
    }
}