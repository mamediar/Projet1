public class RecuperaDatiCatColDealerRuoliInvoker {

    public final static String SERVICE_NAME = 'recuperaDatiCatenaCollegatiDealerRuoli';

    public class RecuperaDatiCatColDealerRuoliRequestDTO {      				
        public String codIntermediario {get; set;}
        public RecuperaDatiCatColDealerRuoliRequestDTO(String codInt) {
            codIntermediario=codInt;
        }
        public RecuperaDatiCatColDealerRuoliRequestDTO() {
        }
    }


    public class RecuperaDatiCatColDealerRuoliResponseDTO{
        
        @AuraEnabled public DatiCatenaCollegatiDealerRuoliDTO[] elenco{get;set;}    
        
    }
   

    public class DatiCatenaCollegatiDealerRuoliDTO{

        @AuraEnabled public String codCollegato{get;set;}
        @AuraEnabled public String ragioneSociale{get;set;}
        @AuraEnabled public String cognome{get;set;}
        @AuraEnabled public String nome{get;set;}
        @AuraEnabled public String firmatario{get;set;}
        @AuraEnabled public String rappresentante{get;set;}
        @AuraEnabled public String referente{get;set;}
        @AuraEnabled public String socio{get;set;}
        @AuraEnabled public String titolare{get;set;}
        @AuraEnabled public String responsabileISVAP{get;set;}
        @AuraEnabled public String codIntermediario{get;set;}
        @AuraEnabled public String tipoIntermediario{get;set;}
        @AuraEnabled public String codConvenzionato{get;set;}
        @AuraEnabled public String codAgente{get;set;}
        @AuraEnabled public String email{get;set;}
        @AuraEnabled public String codFiscale{get;set;}
        @AuraEnabled public String dataConvenzione{get;set;}
        @AuraEnabled public String dataNascita{get;set;}
        @AuraEnabled public String luogoNascita{get;set;}
        @AuraEnabled public String provNascita{get;set;}
        @AuraEnabled public String indirizzo{get;set;}
        @AuraEnabled public String sesso{get;set;}
        @AuraEnabled public String cap{get;set;}
        @AuraEnabled public String localita{get;set;}
        @AuraEnabled public String provincia{get;set;}
        @AuraEnabled public String paeseEstero{get;set;}
        @AuraEnabled public String codIscrizioneIvass{get;set;}
        @AuraEnabled public String dataIscrizioneIvass{get;set;}
        @AuraEnabled public String dataScadenzaIscrizioneIvass{get;set;}
        @AuraEnabled public String dataApertura{get;set;}
        @AuraEnabled public String dataChiusura{get;set;}
        @AuraEnabled public String flagPresenzaAnagrafica{get;set;}
        @AuraEnabled public String flagPresenzaProtesti{get;set;}
        @AuraEnabled public String flagPresenzaEsponentiBanca{get;set;}
        @AuraEnabled public String tipoFirma{get;set;}
        @AuraEnabled public String note1{get;set;}
        @AuraEnabled public String note2{get;set;}
        @AuraEnabled public String piva{get;set;}
    }
 

    //********************
    // REQUEST
    //********************
    public class Request extends OCSRequest {
        
        public RecuperaDatiCatColDealerRuoliRequestDTO recuperaDatiCatenaCollegatiDealerRuoliRequest {get; set;}
        
        public Request() {
            serviceId = SERVICE_NAME;
            recuperaDatiCatenaCollegatiDealerRuoliRequest = new RecuperaDatiCatColDealerRuoliRequestDTO();
        }
        
        public Request(String codInt) {        
            serviceId = SERVICE_NAME;
            recuperaDatiCatenaCollegatiDealerRuoliRequest = new RecuperaDatiCatColDealerRuoliRequestDTO(codInt);
        }
        
    }


    //********************
    // RESPONSE DTO
    //********************

    public class Response extends OCSResponse {
        @AuraEnabled
        public RecuperaDatiCatColDealerRuoliResponseDTO recuperaDatiCatenaCollegatiDealerRuoliResponse {get; set;}
            
        public override boolean isOK() {    
            return super.isOK() && 'ok'.equalsIgnoreCase(resultMessage);
        }
                
        public override string getMessage() {
            return super.getMessage();
        }         
    }



    //********************
    // INVOKER
    //********************
    public static Response invoke(String codIntermediario) {        
        
        Request req = new Request(codIntermediario);               
        return (Response)ApiUtils.callApi (SERVICE_NAME,req, Response.class);       
    }

    
}