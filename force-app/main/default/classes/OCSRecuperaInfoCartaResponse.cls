/**
 * @File Name          : OCSRecuperaInfoCartaResponse.cls
 * @Description        : 
 * @Author             : sabrina vitali
 * @Group              : 
 * @Last Modified By   : Federico Negro
 * @Last Modified On   : 30/10/2019, 10:19:29
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    26/7/2019, 15:18:32   sabrina vitali     Initial Version
**/
public class OCSRecuperaInfoCartaResponse extends OCSResponse {
    
    public RecuperaInfoCartaResponse recuperaInfoCartaResponse {get;set;}
    
    public OCSRecuperaInfoCartaResponse (){
        recuperaInfoCartaResponse = new RecuperaInfoCartaResponse();  
    }
    
    public class RecuperaInfoCartaResponse  {
        @AuraEnabled public String AS400Status{get;set;}
        @AuraEnabled public String AS400Errore{get;set;}
        
        @AuraEnabled public String modalitaInvioEC {get;set;}
        @AuraEnabled public String commInvioEC {get;set;}
        @AuraEnabled public String emailCarta {get;set;}       
        @AuraEnabled public String multifunzioneF {get;set;}
        @AuraEnabled public String multifunzioneR {get;set;}
        @AuraEnabled public String multifunzioneS {get;set;}
        @AuraEnabled public String multifunzioneT {get;set;}
        @AuraEnabled public String dataAttivazione {get;set;}
        @AuraEnabled public String dataUltimoInvioPin {get;set;}
        @AuraEnabled public String dataUltimoAumentoFido {get;set;}
        @AuraEnabled public String dataUltimaMovimentazione {get;set;}
        @AuraEnabled public String flagProduzione {get;set;}
        @AuraEnabled public String dataInvioProduzione {get;set;}
        @AuraEnabled public String dataRientroProduzione {get;set;}
        @AuraEnabled public String importoCommAdesione {get;set;}        
        @AuraEnabled public String origine {get;set;}
        @AuraEnabled public String emettitore {get;set;}
        @AuraEnabled public String flagInvioPositivo {get;set;}
        @AuraEnabled public String dataInvioPositivo {get;set;}
        @AuraEnabled public String dataRientroDaPositivo {get;set;}
        @AuraEnabled public String dataInizioValidita {get;set;}
        @AuraEnabled public String dataScadenza {get;set;}
        @AuraEnabled public String dataPrimoUtilizzo {get;set;}        
        @AuraEnabled public String dataPrimaAttivazione {get;set;}
        @AuraEnabled public String dataCompetenzaPrimoEC {get;set;}
         
    }

}