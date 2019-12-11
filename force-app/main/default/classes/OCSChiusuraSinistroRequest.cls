//----------------------------------------------------------------------
//-- - Class Name   : OCSChiusuraSinistroRequest
//-- - Autor        : Fabio Giuliani(Lynx)
//-- - Date         : 02/07/2019
//-- - Description  : Classe Request per ChiusuraSinistro
//-- - Version      : 1.0
//----------------------------------------------------------------------

public class OCSChiusuraSinistroRequest extends OCSRequest {
//    @AuraEnabled public ChiusuraSinistroRequestDTO ChiusuraSinistroRequest {get;set;}
 
    public List<ChiusuraSinistroRequestDTO> elencoSinitri {get;set;}
    public String flagReadOnly {get;set;}
    public String compagnia {get;set;}
    
    public OCSChiusuraSinistroRequest(List<ChiusuraSinistroRequestDTO> elencoSinitri){
        serviceId='chiusuraSinistro';
        compagnia='';
        flagReadOnly='';
        this.elencoSinitri=elencoSinitri;
    }
    
    public class ChiusuraSinistroRequestDTO{

        @AuraEnabled  public String flagEsito{get;set;}
        @AuraEnabled  public String numPratica{get;set;}
        @AuraEnabled  public String tipoPratica{get;set;}
        @AuraEnabled  public String esito{get;set;}
        @AuraEnabled  public String motivo{get;set;}
        @AuraEnabled  public String importoIndennizzato{get;set;}
        @AuraEnabled  public String cognome{get;set;}
        @AuraEnabled  public String nome{get;set;}
        @AuraEnabled  public String tipoSinistro{get;set;}
        @AuraEnabled  public String tipoPagamento{get;set;}
    }
}