/**
*@author 		Mame bousso kane
*created 		05/08/2019
*descripttion 	AppuntamentoCercaResponse class
*/
public class AppuntamentoCercaResponse extends OCSAPIResponse{
    @AuraEnabled
    public AppuntamentoCercaReturn appuntamentoCercaReturn {get;set;}


    //response of the service
    public class AppuntamentoCercaReturn {
        @AuraEnabled
        public Cliente cliente{get;set;}
        @AuraEnabled
        public String codRes{get;set;}
        @AuraEnabled
        public String desRes{get;set;}
        @AuraEnabled
        public List<listaApp> listaApp{get;set;}
    }

    //data cliente
    public class Cliente{
        @AuraEnabled
        public String capResidenza{get;set;}
        @AuraEnabled
        public String cellulare{get;set;}
        @AuraEnabled
        public String codiceFiscale{get;set;}
        @AuraEnabled
        public String cognome{get;set;}
        @AuraEnabled
        public String contactID{get;set;}
        @AuraEnabled
        public Date dataNascita{get;set;}
        @AuraEnabled
        public String email{get;set;}
        @AuraEnabled
        public String indirizzoResidenza{get;set;}
        @AuraEnabled
        public String localitaNascita{get;set;}
        @AuraEnabled
        public String localitaResidenza{get;set;}
        @AuraEnabled
        public String nome{get;set;}
        @AuraEnabled
        public String privacyExtcommoffer{get;set;}
        @AuraEnabled
        public String privacyInterncommoffer{get;set;}
        @AuraEnabled
        public String privacyOtherservice{get;set;}
        @AuraEnabled
        public String privacyProfilazione{get;set;}
        @AuraEnabled
        public String provinciaNascita{get;set;}
        @AuraEnabled
        public String sesso{get;set;}
        @AuraEnabled
        public String siglaProvinciaResidenza{get;set;}
        @AuraEnabled
        public String tipoOccupazione{get;set;}
    }

    //data listaApp
    public class ListaApp{
        @AuraEnabled
        public String codFiliale{get;set;}
        @AuraEnabled
        public String data{get;set;}
        @AuraEnabled
        public String nomeFiliale{get;set;}
        @AuraEnabled
        public String oppID{get;set;}
        @AuraEnabled
        public String ora{get;set;}
        @AuraEnabled
        public String titolo{get;set;}
    }
}