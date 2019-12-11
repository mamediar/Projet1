public class OCS_recuperaInfoPraticaResponse extends OCSResponse{
    
    @AuraEnabled
    public RecuperaInfoPraticaResponse recuperaInfoPraticaResponse{get;set;} 
    
    public class RecuperaInfoPraticaResponse {
        @AuraEnabled public String dataLiquidazione{get;set;}
        @AuraEnabled public String flagAssicLLOYD {get;set;}
        @AuraEnabled public String nota{get;set;}
        @AuraEnabled public String prodotto{get;set;}
        @AuraEnabled public String targa{get;set;}
        @AuraEnabled public String telaio{get;set;}
        @AuraEnabled public String annoMeseImmatricolazione{get;set;}
        @AuraEnabled public String marcaModello{get;set;}
        @AuraEnabled public String descrizioneBene{get;set;}
        @AuraEnabled public String valoreBene{get;set;}
        @AuraEnabled public String cognome{get;set;}
        @AuraEnabled public String nome{get;set;}
        @AuraEnabled public String ragioneSociale{get;set;}
        @AuraEnabled public String finanziato{get;set;}
        @AuraEnabled public String sottogruppo{get;set;}
        @AuraEnabled public String ramoGruppo{get;set;}
        @AuraEnabled public String ateco{get;set;}
        @AuraEnabled public String coniuge{get;set;}
        @AuraEnabled public String tipoProdotto{get;set;}        
    }
}