public class OCSrecuperaTimbratureZucchettiResponse extends OCSResponse{
    public recuperaTimbratureZucchettiResponse recuperaTimbratureZucchettiResponse{get;set;}

    public class recuperaTimbratureZucchettiResponse{
        public elencoTimbrature[] elencoTimbrature{get;set;}
    }

    public class elencoTimbrature{
        @AuraEnabled
        public String giorno {get;set;}
        @AuraEnabled
        public Time ora {get;set;}
        @AuraEnabled
        public String verso {get;set;}
        @AuraEnabled
        public String ordinamento {get;set;}
    }
}