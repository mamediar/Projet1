public class XCSReclamiDettagliOutputDTO {
    @AuraEnabled
    public HeaderOutputDTO headerOutput;
    @AuraEnabled
    public RadioOutputDTO radioOutput;
    @AuraEnabled
    public AggiuntiviOutputDTO aggiuntiviOutput; ///////////////////////////////
    @AuraEnabled
    public ChiusuraOutputDTO chiusuraOutput;
    @AuraEnabled
    public InadempimentoOutputDTO sezInadempimentoOutput;
    
    @AuraEnabled
    public CodaXSocieta__mdt codaSelezionata;
    @AuraEnabled
    public List<String> attribuzioneReclamo;
    @AuraEnabled
    public String contattoPrecedente; //////////////////////////////
    @AuraEnabled
    public Case currentCase;
    
    //Classi per oggetti interni
    public class HeaderOutputDTO{
        @AuraEnabled
        public String accessoDati;
        @AuraEnabled
        public String areaDettagli;
        @AuraEnabled
        public XCS_Categoria__c categoriaDettagli;
        @AuraEnabled
        public String dataComunicazione;
        @AuraEnabled
        public String dataDecisione;
        @AuraEnabled
        public String dataRicezione;
        @AuraEnabled
        public String dataRicezioneIDM;
        @AuraEnabled
        public String delegaPresente;
        @AuraEnabled
        public String reclamoCompleto;
        @AuraEnabled
        public String tipoDettagli;
        @AuraEnabled
        public String modalitaInvioDettagli;
        @AuraEnabled
        public String isGrave;
    }
    
    public class RadioOutputDTO{
        @AuraEnabled
        public ComuniOutputDTO comuniOutput;
        @AuraEnabled
        public FuturoOutputDTO futuroOutput;
        @AuraEnabled
        public XCSRadioGroupGenericReclamiDTO rimborsoOutput;
        @AuraEnabled
        public XCSRadioGroupGenericReclamiDTO standaloneOutput;
    }
    
    public class AggiuntiviOutputDTO{
        @AuraEnabled
        public String trattabile;
        @AuraEnabled
        public String tipoProdottoVita;
        @AuraEnabled
        public String tipoProdottoDanni;
        @AuraEnabled
        public String areaAziendale;
        @AuraEnabled
        public String tipoProponente;
        @AuraEnabled
        public String areaGeograficaProponente;
        @AuraEnabled
        public String tipoReclamante;
    }
    
    //Classi per radioOutput
    public class FuturoOutputDTO{
        @AuraEnabled
        public XCSRadioGroupGenericReclamiDTO commissioniOutput;
        @AuraEnabled
        public XCSRadioGroupGenericReclamiDTO provvAccOutput;
        @AuraEnabled
        public XCSRadioGroupGenericReclamiDTO premioAssOutput;
        @AuraEnabled
        public XCSRadioGroupGenericReclamiDTO varieOutput;
        @AuraEnabled
        public XCSRadioGroupGenericReclamiDTO speseLegaliOutput;
    }
    
    public class ComuniOutputDTO{
        @AuraEnabled
        public XCSRadioGroupGenericReclamiDTO abbuonoOutput;
        @AuraEnabled
        public XCSRadioGroupGenericReclamiDTO risarcimentoOutput;
        @AuraEnabled
        public XCSRadioGroupGenericReclamiDTO RimborsoOutput;
        @AuraEnabled
        public XCSRadioGroupGenericReclamiDTO standaloneOutput;
    }
    /*
public class ComuniOutputDTO{
@AuraEnabled
public XCSRadioGroupGenericReclamiDTO abbuonoOutput;
@AuraEnabled
public XCSRadioGroupGenericReclamiDTO risarcimentoOutput;
@AuraEnabled
public XCSRadioGroupGenericReclamiDTO RimborsoOutput;
}

*/
    
    //Classe per comuni, futuro
    public class XCSRadioGroupGenericReclamiDTO{
        @AuraEnabled
        public String selection;
        @AuraEnabled
        public Double value;
    }
    /*
public class ChiusuraOutputDTO{
@AuraEnabled
public String RimborsoOutput;
@AuraEnabled
public String RimborsoCommOutput;
@AuraEnabled
public String abbuonoOutput;
@AuraEnabled
public String RimborsoProAccOutput;
@AuraEnabled
public String RimborsoPreAssOutput;
@AuraEnabled
public String RimborsoVarOutput;
@AuraEnabled
public String RimborsoSpeLegOutput;
@AuraEnabled
public String RisarcimentoOutput;
@AuraEnabled
public String FondatoOutput;
@AuraEnabled
public String ResponsabilitaOutput;
@AuraEnabled
public String AllegatiCompletiOutput;
@AuraEnabled
public String SocietaAssOutput;
@AuraEnabled
public String SocietaRecOutput;
@AuraEnabled
public String attesaOutput;
@AuraEnabled
public String AssegnoOutput;
@AuraEnabled
public InvioRisIDMOutputDTO InvioRisIDMOutput ;
}
*/
    public class ChiusuraOutputDTO{
        @AuraEnabled
        public InvioRisIDMOutputDTO RimborsoOutput;
        @AuraEnabled
        public InvioRisIDMOutputDTO RimborsoCommOutput;
        @AuraEnabled
        public InvioRisIDMOutputDTO abbuonoOutput;
        @AuraEnabled
        public InvioRisIDMOutputDTO RimborsoProAccOutput;
        @AuraEnabled
        public InvioRisIDMOutputDTO RimborsoPreAssOutput;
        @AuraEnabled
        public InvioRisIDMOutputDTO RimborsoVarOutput;
        @AuraEnabled
        public InvioRisIDMOutputDTO RimborsoSpeLegOutput;
        @AuraEnabled
        public InvioRisIDMOutputDTO RisarcimentoOutput;
        @AuraEnabled
        public InvioRisIDMOutputDTO FondatoOutput;
        @AuraEnabled
        public InvioRisIDMOutputDTO ResponsabilitaOutput;
        @AuraEnabled
        public InvioRisIDMOutputDTO AllegatiCompletiOutput;
        @AuraEnabled
        public InvioRisIDMOutputDTO SocietaAssOutput;
        @AuraEnabled
        public InvioRisIDMOutputDTO SocietaRecOutput;
        @AuraEnabled
        public InvioRisIDMOutputDTO attesaOutput;
        @AuraEnabled
        public InvioRisIDMOutputDTO AssegnoOutput;
        @AuraEnabled
        public InvioRisIDMOutputDTO InvioRisIDMOutput ;
        @AuraEnabled
        public InvioRisIDMOutputDTO Decisione;
    }
    
    public class InvioRisIDMOutputDTO{
        @AuraEnabled
        public String selection;
        @AuraEnabled
        public String value;
    }
    
    public class InadempimentoOutputDTO {
        @AuraEnabled
        public String stageInadempimento;
        @AuraEnabled
        public String filiale;
        @AuraEnabled
        public String gravitaDettagli;
        @AuraEnabled
        public Double FTSent;
        @AuraEnabled
        public Double FTReceived;
        @AuraEnabled
        public Object reclamoCompletoCheckbox;
    }
}