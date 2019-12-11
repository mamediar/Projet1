public class OCSCensimentoCollegatiResponse extends OCSResponse {
    
    @AuraEnabled
    public CensimentoCollegatiResponse censimentoCollegatiResponse{get;set;}     
    
    public class CensimentoCollegatiResponse{
        @AuraEnabled
        public List<Elenco> elenco {get; set;}
        
        public CensimentoCollegatiResponse() {
            this.elenco=new List<Elenco>();
        }        
    }    
 
    
    public class Elenco {
        @AuraEnabled public String partimestp {get;set;}
        @AuraEnabled public String nomefile {get;set;}
        @AuraEnabled public String icoCodice {get;set;}
        @AuraEnabled public String icoCollegato {get;set;} 
        @AuraEnabled public String icoFirmatario {get;set;}
        @AuraEnabled public String icoRappresentante {get;set;}
        @AuraEnabled public String icoReferente {get;set;}
        @AuraEnabled public String icoSocio {get;set;} 
        @AuraEnabled public String icoTitolare {get;set;}
        @AuraEnabled public String icoResponsabileIsvap {get;set;}
        @AuraEnabled public String icoCodIscrizIsvap {get;set;}
        @AuraEnabled public String icoDataIscrizIsvap {get;set;} 
        @AuraEnabled public String icoDataApertura {get;set;}
        @AuraEnabled public String icoDataChiusura {get;set;}
        @AuraEnabled public String icoPresAna {get;set;}
        @AuraEnabled public String icoPresProtesti {get;set;} 
        @AuraEnabled public String icoPresEspBanca {get;set;}
        @AuraEnabled public String icoTipoFirma {get;set;}
        @AuraEnabled public String icoNote01 {get;set;}
        @AuraEnabled public String icoNote02 {get;set;} 
        @AuraEnabled public String segnala {get;set;}
        @AuraEnabled public String icoEmail {get;set;}
             
    }

}