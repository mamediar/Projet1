/**
 * @File Name          : OCSVariazioneDatiPagamentoResponse.cls
 * @Description        : 
 * @Author             : sabrina vitali
 * @Group              : 
 * @Last Modified By   : sabrina vitali
 * @Last Modified On   : 30/7/2019, 17:37:11
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    30/7/2019, 17:32:59   sabrina vitali     Initial Version
**/
//----------------------------------------------------------------------
//-- - Class Name   : OCSVariazioneDatiPagamentoResponse
//-- - Autor        : Fabio Giuliani(Lynx)
//-- - Date         : 12/07/2019
//-- - Description  : Classe Response per Variazione Dati Pagamento
//-- - Version      : 1.0
//----------------------------------------------------------------------

public class OCSVariazioneDatiPagamentoResponse extends OCSResponse {

    
    public class VariazioneDatiPagamentoResponseDTO{
        @AuraEnabled public String  AS400Status;
        @AuraEnabled public String  AS400Errore;
    }    
    
    @AuraEnabled 
    //sabry: questa response è errata
    public VariazioneDatiPagamentoResponseDTO variazioneDatiPagamentoResponseDTO {get;set;}
    //sabry: response corretta
    public VariazioneDatiPagamentoResponseDTO variazioneDatiPagamentoResponse {get;set;}
    
    
}