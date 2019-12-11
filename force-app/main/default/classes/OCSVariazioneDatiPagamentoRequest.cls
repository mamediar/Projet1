//----------------------------------------------------------------------
//-- - Class Name   : OCSVariazioneDatiPagamentoRequest
//-- - Autor        : Fabio Giuliani(Lynx)
//-- - Date         : 12/07/2019
//-- - Description  : Classe Request per Variazione Dati Pagamento
//-- - Version      : 1.0
//----------------------------------------------------------------------

public class OCSVariazioneDatiPagamentoRequest extends OCSRequest{
    
   public VariazioneDatiPagamentoRequestDTO variazioneDatiPagamentoRequest {get;set;}
    
    
   public OCSVariazioneDatiPagamentoRequest(){
        serviceId='variazioneDatiPagamento';
        variazioneDatiPagamentoRequest=new VariazioneDatiPagamentoRequestDTO();
   }
    
    public class VariazioneDatiPagamentoRequestDTO{
//        @AuraEnabled public String provenienza {get;set;}
        public String provenienza {get;set;}
        @AuraEnabled public String tipoIntermediario {get;set;}
        @AuraEnabled public String intermediario {get;set;}
        @AuraEnabled public String procedura {get;set;}
        @AuraEnabled public String numPratica {get;set;}
        @AuraEnabled public String pagForma {get;set;}
        @AuraEnabled public String ecFrequenza {get;set;}
        @AuraEnabled public String abi {get;set;}
        @AuraEnabled public String cab {get;set;}
        @AuraEnabled public String cc {get;set;}
        @AuraEnabled public String cinBban {get;set;}
        @AuraEnabled public String cinIban {get;set;}
        @AuraEnabled public String paeseIban {get;set;}
        @AuraEnabled public String iban {get;set;}
        @AuraEnabled public String intCc {get;set;}
        @AuraEnabled public String intestConto {get;set;}
        @AuraEnabled public String codiceRid {get;set;}
        @AuraEnabled public String firmaSuRid {get;set;}
        @AuraEnabled public String bancaInterna {get;set;}
        @AuraEnabled public String pagGGValuta {get;set;}
        @AuraEnabled public String lettera {get;set;}
        @AuraEnabled public String tipoContatto {get;set;}
        @AuraEnabled public String ammin {get;set;}
        @AuraEnabled public String dataIniziale {get;set;}
        @AuraEnabled public String variazScadRata {get;set;}
        @AuraEnabled public String speseIncasso {get;set;}
        @AuraEnabled public String speseIncFlg {get;set;}
        @AuraEnabled public String codiceRifExt2 {get;set;}
        @AuraEnabled public String utente {get;set;}
        @AuraEnabled public String pan {get;set;}
        @AuraEnabled public String lunghezzaPan {get;set;}
        @AuraEnabled public String dataScadenza {get;set;}

    }
}