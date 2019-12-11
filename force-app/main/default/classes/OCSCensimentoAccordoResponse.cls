public class OCSCensimentoAccordoResponse extends OCSResponse  {
    @AuraEnabled
    public CensimentoAccordoResponse censimentoAccordoResponse{get;set;}     
    
    public class CensimentoAccordoResponse{
        @AuraEnabled
        public List<Elenco> elenco {get; set;}
        
        public CensimentoAccordoResponse() {
            this.elenco=new List<Elenco>();
        }        
    }    
 
    
    public class Elenco {

    }

}