//----------------------------------------------------------------------
//-- - Class Name   : OCSAperturaSinistroRequest
//-- - Autor        : Fabio Giuliani(Lynx)
//-- - Date         : 01/07/2019
//-- - Description  : Classe Request per AperturaSinistro
//-- - Version      : 1.0
//----------------------------------------------------------------------

public class OCSAperturaSinistroRequest extends OCSRequest{

    public AperturaSinistroRequestDTO datiAperturaSinistroRequest {get;set;}
    
    public OCSAperturaSinistroRequest(){
        serviceId='aperturaSinistro';
        datiAperturaSinistroRequest = New AperturaSinistroRequestDTO();



    }
    public class AperturaSinistroRequestDTO{

        @AuraEnabled  public String compagnia{get;set;}
        @AuraEnabled  public String numPratica{get;set;}
        @AuraEnabled  public String tipoPratica{get;set;}
        @AuraEnabled  public String dataSinistro{get;set;}
        @AuraEnabled  public String tipoSinistro{get;set;}
        @AuraEnabled  public String cognome{get;set;}
        @AuraEnabled  public String nome{get;set;}
        @AuraEnabled  public String flagReadOnly{get;set;}
    }
}