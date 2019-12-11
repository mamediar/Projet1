public class OCSRecuperaRitorniPostaliResponse extends OCSResponse{
    
    @AuraEnabled
    public List<RitornoPostaleDTO> ritorniPostali {get;set;}
    
    public OCSRecuperaRitorniPostaliResponse(){
        
        ritorniPostali = new List<RitornoPostaleDTO>();
    }
    
    public class RitornoPostaleDTO {
        
        @AuraEnabled public String cognome {get;set;}
        @AuraEnabled public String codCliente {get;set;}
        @AuraEnabled public String nome {get;set;}
        @AuraEnabled public String dataNascita {get;set;}
        @AuraEnabled public String luogoNascita {get;set;}
        @AuraEnabled public String provNascita {get;set;}
        @AuraEnabled public String sesso {get;set;}
        @AuraEnabled public String codFiscale {get;set;}
        @AuraEnabled public String piva {get;set;}
        @AuraEnabled public String indirizzo {get;set;}
        @AuraEnabled public String localita {get;set;}
        @AuraEnabled public String provincia {get;set;}
        @AuraEnabled public String cap {get;set;}
        @AuraEnabled public String paeseEstero {get;set;}
        @AuraEnabled public String email {get;set;}
        @AuraEnabled public String tipoDocumento {get;set;}
        @AuraEnabled public String numDocumento {get;set;}
        @AuraEnabled public String ufficioRilascio {get;set;}
        @AuraEnabled public String luogoRilascio {get;set;}
        @AuraEnabled public String provRilascio {get;set;}
        @AuraEnabled public String dataRilascio {get;set;}
        @AuraEnabled public String denominazioneAzienda {get;set;}
        @AuraEnabled public String formaGiuridica {get;set;}
        @AuraEnabled public String tipoAnagrafica {get;set;}
        @AuraEnabled public String dataScadenza {get;set;}
        @AuraEnabled public String telefonoCasa {get;set;}
        @AuraEnabled public String telCellulare {get;set;}
        @AuraEnabled public String tipoRapporto {get;set;}
        @AuraEnabled public String dataDepennamento {get;set;}
        @AuraEnabled public String ndg {get;set;}
        @AuraEnabled public String dataRegistrazione {get;set;}
        @AuraEnabled public String dataVariazioneIndirizzo {get;set;}
        @AuraEnabled public String dataInvio {get;set;}
        @AuraEnabled public String dataRitorno {get;set;}
        @AuraEnabled public String tipoLettera {get;set;}
        @AuraEnabled public String codLettera {get;set;}
        @AuraEnabled public String codTipoLettera {get;set;}
        @AuraEnabled public String procedura {get;set;}
        @AuraEnabled public String numPratica {get;set;}
        @AuraEnabled public String progressivoPostel {get;set;}
        @AuraEnabled public String causaleRitorno {get;set;}
        @AuraEnabled public String codFiliale {get;set;}
        @AuraEnabled public String flagContatto {get;set;}
        @AuraEnabled public String flagResoMacero {get;set;}
        @AuraEnabled public String flagRiproduzione {get;set;}
        @AuraEnabled public String tipoPagamento {get;set;}
        @AuraEnabled public String indirizzoInvio {get;set;}
        @AuraEnabled public String capInvio {get;set;}
        @AuraEnabled public String localitaInvio {get;set;}
        @AuraEnabled public String provinciaInvio {get;set;}
        @AuraEnabled public String dataEC {get;set;}
        @AuraEnabled public String flagFornitore {get;set;}
    }
}