public class OCSCensimentoAnagConvenzionatoResponse  extends OCSResponse{

    @AuraEnabled
    public CensimentoAnagConvenzionatoResponse censimentoAnagraficaConvenzionatoResponse{get;set;}     
    
    public class CensimentoAnagConvenzionatoResponse{
        @AuraEnabled
        public List<Elenco> elenco {get; set;}
        
        public CensimentoAnagConvenzionatoResponse() {
            this.elenco=new List<Elenco>();
        }        
    }    
 
    
    public class Elenco {
        @AuraEnabled public String partimestp {get;set;}
        @AuraEnabled public String ngr500Controparte {get;set;}
        @AuraEnabled public String ngr500RagSociale1 {get;set;}
        @AuraEnabled public String ngr500RagSociale2 {get;set;} 
        @AuraEnabled public String ngr500Cognome {get;set;}
        @AuraEnabled public String ngr500Nome {get;set;}
        @AuraEnabled public String ngr500CodiceFiscale {get;set;}
        @AuraEnabled public String ngr500PartitaIva {get;set;} 
        @AuraEnabled public String ngr500TipoAnagrafica {get;set;}
        @AuraEnabled public String acFormaGiuridica {get;set;}
        @AuraEnabled public String ngr500Sesso {get;set;}
        @AuraEnabled public String ngr500NascitaData {get;set;} 
        @AuraEnabled public String ngr500NascitaLoc {get;set;}
        @AuraEnabled public String ngr500NascitaProv {get;set;}
        @AuraEnabled public String ngr500Indirizzo1 {get;set;}
        @AuraEnabled public String ngr500Indirizzo2 {get;set;} 
        @AuraEnabled public String ngr500Localita {get;set;}
        @AuraEnabled public String ngr500Provincia {get;set;}
        @AuraEnabled public String ngr500Cap {get;set;}
        @AuraEnabled public String ngr500Telefono {get;set;} 
        @AuraEnabled public String ngr500Telefono2 {get;set;}
        @AuraEnabled public String ngr500TelefonoCel {get;set;}
        @AuraEnabled public String ngr500Email {get;set;}
        @AuraEnabled public String ngr500IstruttPratiche {get;set;} 
        @AuraEnabled public String ngr500RilevQualita {get;set;}
        @AuraEnabled public String ngr500OffCommInterne {get;set;}
        @AuraEnabled public String ngr500OffCommEsterne {get;set;}
        @AuraEnabled public String ngr500ServiziAltri {get;set;} 
        @AuraEnabled public String ngr500DatiSensibili {get;set;}
        @AuraEnabled public String ngr500DtPrivacyIstrutt {get;set;}
        @AuraEnabled public String ngr500DtPrivacyOfferte {get;set;}
        @AuraEnabled public String ngr500DtPrivacySensibili {get;set;} 
        @AuraEnabled public String ngr500ConsInfoSic {get;set;}
        @AuraEnabled public String ngr500DataConsInfoSic {get;set;}
        @AuraEnabled public String ngr500NoteConsInfoSic {get;set;}
        @AuraEnabled public String ngr500TipoSegnalaz {get;set;} 
        @AuraEnabled public String ngr500OrigineCont {get;set;}
        @AuraEnabled public String ngr500MotivoCont {get;set;}
        @AuraEnabled public String ngr500Fonte {get;set;}
        @AuraEnabled public String ngr500RifInterno {get;set;} 
        @AuraEnabled public String ngr500Nota1 {get;set;}
        @AuraEnabled public String ngr500Nota2 {get;set;}
        @AuraEnabled public String ngr500Nota3 {get;set;}
        @AuraEnabled public String ngr500Camp {get;set;} 
        @AuraEnabled public String ngr500CampProv {get;set;}
        @AuraEnabled public String ngr500CampDataAtt {get;set;}
        @AuraEnabled public String ngr500Modalita {get;set;}
        @AuraEnabled public String codrnt {get;set;} 
        @AuraEnabled public String flagrnt {get;set;}
        @AuraEnabled public String acSottogruppo {get;set;}
        @AuraEnabled public String acRamogruppo {get;set;}
        @AuraEnabled public String acAteco {get;set;} 
        @AuraEnabled public String segnala {get;set;}     
    }
    
}