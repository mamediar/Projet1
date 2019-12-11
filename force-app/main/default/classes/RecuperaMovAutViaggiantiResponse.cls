public class RecuperaMovAutViaggiantiResponse extends OCSAPIResponse {
  
public RecuperaMovAutViaggiantiResponseDTO recuperaMovimentiAutorizzazioniViaggiantiResponse {get;set;}
public RecuperaMovAutViaggiantiResponse () {
    this.recuperaMovimentiAutorizzazioniViaggiantiResponse = new RecuperaMovAutViaggiantiResponseDTO();
    this.recuperaMovimentiAutorizzazioniViaggiantiResponse.recuperaAutViaggiantiResponse = new RecuperaAutViaggiantiResponseDTO();
    this.recuperaMovimentiAutorizzazioniViaggiantiResponse.recuperaMovViaggiantiResponse = new  RecuperaMovViaggiantiResponseDTO();
}
public class RecuperaMovAutViaggiantiResponseDTO {
    @AuraEnabled public RecuperaMovViaggiantiResponseDTO  recuperaMovViaggiantiResponse {get;set;}
    @AuraEnabled  public RecuperaAutViaggiantiResponseDTO recuperaAutViaggiantiResponse {get;set;}
    public RecuperaMovAutViaggiantiResponseDTO(){
     //   this.recuperaMovViaggiantiResponse.elencoMovimenti = new 
    }
}
public class RecuperaMovViaggiantiResponseDTO{
   
   @AuraEnabled  public  List<MovimentoViaggianteDTO> elencoMovimenti {get;set;}
   @AuraEnabled   public String as400Status {get;set;}
   @AuraEnabled   public String as400Errore {get;set;}
}
public class MovimentoViaggianteDTO {
    @AuraEnabled   public String dataOperazione {get;set;}
    @AuraEnabled  public String dataValuta {get;set;}
    @AuraEnabled  public String causale {get;set;}
    @AuraEnabled  public String importo{get;set;}
    @AuraEnabled  public String importoSegno {get;set;}
    @AuraEnabled  public String dareAvere {get;set;}
    @AuraEnabled  public String tipoMov {get;set;}
    @AuraEnabled  public String esercente {get;set;}
    @AuraEnabled   public String citta {get;set;}
    @AuraEnabled public String nazione {get;set;}
    @AuraEnabled public String catMerc {get;set;}
}
public class RecuperaAutViaggiantiResponseDTO {
  @AuraEnabled   public String as400Status {get;set;}
   @AuraEnabled  public String as400Errore  {get;set;}
   @AuraEnabled  public String progressivoAutorizazione {get;set;}
   @AuraEnabled  public   List<AutorizzazioneViaggianteDTO> elencoAutorizzazioni {get;set;}

}
public class AutorizzazioneViaggianteDTO {
    @AuraEnabled   public   String  autorizzazione {get;set;}
    @AuraEnabled  public   String  data {get;set;}
    @AuraEnabled   public   String  ora {get;set;}
    @AuraEnabled   public   String  intermediario {get;set;}

    @AuraEnabled  public   String  codEsercente {get;set;}
    @AuraEnabled  public    String  desEsercente {get;set;}
    @AuraEnabled  public   String  importo {get;set;}
    @AuraEnabled  public String  importoSegno {get;set;}

    @AuraEnabled  public String  importoDivisaEstera {get;set;}
    @AuraEnabled  public   String  divisa {get;set;}
    @AuraEnabled   public  String  stato {get;set;}
    @AuraEnabled   public   String  esito {get;set;}

    @AuraEnabled  public  String  codAzione {get;set;}
    @AuraEnabled  public  String  desAzione {get;set;}
}


}