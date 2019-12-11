public class AppuntamentoListaFilialiResponse  extends APIXMLResponse{
      @AuraEnabled
    public  XMLWrapper xml {get;set;}
   

    public AppuntamentoListaFilialiResponse(){
        this.xml =  new XMLWrapper();

    }
   public override Set<String> getTagNamesAsArray() {
         Set<String> tagNamesAsArray = new Set<String>();
         tagNamesAsArray.add('FilialiOCSs');
         return tagNamesAsArray;
    }
    public class XMLWrapper {
      @AuraEnabled
    public Result result {get;set;}
    @AuraEnabled
    public String prodotto {get;set;} 
    }

    public class Result {
        @AuraEnabled
        public  PuntoRicercatoOCS puntoRicercato {get;set;}
         @AuraEnabled
        public  List<FilialeOCS>  Filiali {get;set;}

        public Result(){
             this.puntoRicercato = new PuntoRicercatoOCS();
             this.Filiali = new List<FilialeOCS>();
        }
  
    }
  
     public class FilialeOCS {
        @AuraEnabled
        public String id {get;set;}
        @AuraEnabled
        public String idL {get;set;}
        @AuraEnabled
        public String idMappa {get;set;}
        @AuraEnabled
        public String pV {get;set;}
        @AuraEnabled
        public String indirizzo {get;set;}
        @AuraEnabled
        public String citta {get;set;}
        @AuraEnabled
        public String provincia {get;set;}
        @AuraEnabled
        public String cap {get;set;}
        @AuraEnabled
        public String email {get;set;}
        @AuraEnabled
        public String area {get;set;}
        @AuraEnabled
        public String manager {get;set;}
        @AuraEnabled
        public String tel {get;set;}
        @AuraEnabled
        public String longitudine {get;set;}
        @AuraEnabled
        public String latitudine {get;set;}
        @AuraEnabled
        public String dst {get;set;}
        @AuraEnabled
        public String occupazione {get;set;}
        @AuraEnabled
        public  String ele_text {get;set;}

    }
   

    public class PuntoRicercatoOCS{
        @AuraEnabled
        public String coordinates {get;set;}
        @AuraEnabled
        public String postalCodeNumber {get;set;}
        @AuraEnabled
        public String addressGeoCode {get;set;}
    }
}