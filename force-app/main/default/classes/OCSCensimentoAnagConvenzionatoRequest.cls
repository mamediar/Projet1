public class OCSCensimentoAnagConvenzionatoRequest extends OCSRequest {
	@AuraEnabled
    public OCSCensimentoAnagConvenzionatoRequestData censimentoAnagraficaConvenzionatoRequest{get;set;}
    
    public OCSCensimentoAnagConvenzionatoRequest(){
        this.serviceId='censimentoAnagraficaConvenzionato';
        this.censimentoAnagraficaConvenzionatoRequest=new OCSCensimentoAnagConvenzionatoRequestData();
    }
    
    public class OCSCensimentoAnagConvenzionatoRequestData{
        @AuraEnabled
        public List<Elenco> elenco {get; set;}
        
        public OCSCensimentoAnagConvenzionatoRequestData() {
            this.elenco=new List<Elenco>();
        }
    }

    public class Elenco {
       public String partimestp {get { if (partimestp == null ) partimestp = ''; return partimestp; } set;}   
       public String ngr500Controparte {get { if (ngr500Controparte == null ) ngr500Controparte = '0'; return ngr500Controparte; } set;}
       public String ngr500RagSociale1 {get { if (ngr500RagSociale1 == null ) ngr500RagSociale1 = ''; return ngr500RagSociale1; } set; }               
       public String ngr500RagSociale2 {get { if (ngr500RagSociale2 == null ) ngr500RagSociale2 = ''; return ngr500RagSociale2; } set; }
       public String ngr500Cognome {get { if (ngr500Cognome == null ) ngr500Cognome = ''; return ngr500Cognome; } set;}
       public String ngr500Nome {get { if (ngr500Nome == null ) ngr500Nome = ''; return ngr500Nome; } set;}
       public String ngr500CodiceFiscale {get { if (ngr500CodiceFiscale == null ) ngr500CodiceFiscale = ''; return ngr500CodiceFiscale; } set;}
       public String ngr500PartitaIva {get { if (ngr500PartitaIva == null ) ngr500PartitaIva = ''; return ngr500PartitaIva; } set;}
       public String ngr500TipoAnagrafica {get { if (ngr500TipoAnagrafica == null ) ngr500TipoAnagrafica = ''; return ngr500TipoAnagrafica; } set;}
       public String acFormaGiuridica {get { if (acFormaGiuridica == null ) acFormaGiuridica = ''; return acFormaGiuridica; } set;}
       public String ngr500Sesso {get { if (ngr500Sesso == null ) ngr500Sesso = ''; return ngr500Sesso; } set;}
       public String ngr500NascitaData {get { if (ngr500NascitaData == null ) ngr500NascitaData = '0'; return ngr500NascitaData; } set;}
       public String ngr500NascitaLoc {get { if (ngr500NascitaLoc == null ) ngr500NascitaLoc = ''; return ngr500NascitaLoc; } set;}
       public String ngr500NascitaProv {get { if (ngr500NascitaProv == null ) ngr500NascitaProv = ''; return ngr500NascitaProv; } set;}
       public String ngr500Indirizzo1 {get { if (ngr500Indirizzo1 == null ) ngr500Indirizzo1 = ''; return ngr500Indirizzo1; } set;}
       public String ngr500Indirizzo2 {get { if (ngr500Indirizzo2 == null ) ngr500Indirizzo2 = ''; return ngr500Indirizzo2; } set;}
       public String ngr500Localita {get { if (ngr500Localita == null ) ngr500Localita = ''; return ngr500Localita; } set;}
       public String ngr500Provincia {get { if (ngr500Provincia == null ) ngr500Provincia = ''; return ngr500Provincia; } set;}
       public String ngr500Cap {get { if (ngr500Cap == null ) ngr500Cap = ''; return ngr500Cap; } set;}
       public String ngr500Telefono {get { if (ngr500Telefono == null ) ngr500Telefono = ''; return ngr500Telefono; } set;}
       public String ngr500Telefono2 {get { if (ngr500Telefono2 == null ) ngr500Telefono2 = ''; return ngr500Telefono2; } set;}
       public String ngr500TelefonoCel {get { if (ngr500TelefonoCel == null ) ngr500TelefonoCel = ''; return ngr500TelefonoCel; } set;}
       public String ngr500Email {get { if (ngr500Email == null ) ngr500Email = ''; return ngr500Email; } set;}
       public String ngr500IstruttPratiche {get { if (ngr500IstruttPratiche == null ) ngr500IstruttPratiche = ''; return ngr500IstruttPratiche; } set;}
       public String ngr500RilevQualita {get { if (ngr500RilevQualita == null ) ngr500RilevQualita = ''; return ngr500RilevQualita; } set;}
       public String ngr500OffCommInterne {get { if (ngr500OffCommInterne == null ) ngr500OffCommInterne = ''; return ngr500OffCommInterne; } set;}
       public String ngr500OffCommEsterne {get { if (ngr500OffCommEsterne == null ) ngr500OffCommEsterne = ''; return ngr500OffCommEsterne; } set;}
       public String ngr500ServiziAltri {get { if (ngr500ServiziAltri == null ) ngr500ServiziAltri = ''; return ngr500ServiziAltri; } set;}
       public String ngr500DatiSensibili {get { if (ngr500DatiSensibili == null ) ngr500DatiSensibili = ''; return ngr500DatiSensibili; } set;}
       public String ngr500DtPrivacyIstrutt {get { if (ngr500DtPrivacyIstrutt == null ) ngr500DtPrivacyIstrutt = ''; return ngr500DtPrivacyIstrutt; } set;}
       public String ngr500DtPrivacyOfferte {get { if (ngr500DtPrivacyOfferte == null ) ngr500DtPrivacyOfferte = ''; return ngr500DtPrivacyOfferte; } set;}
       public String ngr500DtPrivacySensibili {get { if (ngr500DtPrivacySensibili == null ) ngr500DtPrivacySensibili = ''; return ngr500DtPrivacySensibili; } set;}
       public String ngr500ConsInfoSic {get { if (ngr500ConsInfoSic == null ) ngr500ConsInfoSic = ''; return ngr500ConsInfoSic; } set;}
       public String ngr500DataConsInfoSic {get { if (ngr500DataConsInfoSic == null ) ngr500DataConsInfoSic = ''; return ngr500DataConsInfoSic; } set;}
       public String ngr500NoteConsInfoSic {get { if (ngr500NoteConsInfoSic == null ) ngr500NoteConsInfoSic = ''; return ngr500NoteConsInfoSic; } set;}
       public String ngr500TipoSegnalaz {get { if (ngr500TipoSegnalaz == null ) ngr500TipoSegnalaz = ''; return ngr500TipoSegnalaz; } set;}
       public String ngr500OrigineCont {get { if (ngr500OrigineCont == null ) ngr500OrigineCont = ''; return ngr500OrigineCont; } set;}
       public String ngr500MotivoCont {get { if (ngr500MotivoCont == null ) ngr500MotivoCont = ''; return ngr500MotivoCont; } set;}
       public String ngr500Fonte {get { if (ngr500Fonte == null ) ngr500Fonte = ''; return ngr500Fonte; } set;}
       public String ngr500RifInterno {get { if (ngr500RifInterno == null ) ngr500RifInterno = ''; return ngr500RifInterno; } set;}
       public String ngr500Nota1 {get { if (ngr500Nota1 == null ) ngr500Nota1 = ''; return ngr500Nota1; } set;}
       public String ngr500Nota2 {get { if (ngr500Nota2 == null ) ngr500Nota2 = ''; return ngr500Nota2; } set;}
       public String ngr500Nota3 {get { if (ngr500Nota3 == null ) ngr500Nota3 = ''; return ngr500Nota3; } set;}
       public String ngr500Camp {get { if (ngr500Camp == null ) ngr500Camp = ''; return ngr500Camp; } set;}
       public String ngr500CampProv {get { if (ngr500CampProv == null ) ngr500CampProv = ''; return ngr500CampProv; } set;}
       public String ngr500CampDataAtt {get { if (ngr500CampDataAtt == null ) ngr500CampDataAtt = ''; return ngr500CampDataAtt; } set;}
       public String ngr500Modalita {get { if (ngr500Modalita == null ) ngr500Modalita = ''; return ngr500Modalita; } set;}
       public String codrnt {get { if (codrnt == null ) codrnt = ''; return codrnt; } set;}
       public String flagrnt {get { if (flagrnt == null ) flagrnt = ''; return flagrnt; } set;}
       public String acSottogruppo {get { if (acSottogruppo == null ) acSottogruppo = ''; return acSottogruppo; } set;}
       public String acRamogruppo {get { if (acRamogruppo == null ) acRamogruppo = ''; return acRamogruppo; } set;}
       public String acAteco {get { if (acAteco == null ) acAteco = ''; return acAteco; } set;}
       public String segnala {get { if (segnala == null ) segnala = ''; return segnala; } set;}
       
    }
    

}