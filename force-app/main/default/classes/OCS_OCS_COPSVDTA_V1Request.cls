public class OCS_OCS_COPSVDTA_V1Request extends OCSRequest {
    @AuraEnabled 
    public String authorization {get;set;}
    @AuraEnabled
    public Copsvdtarequest copsvdtarequest {get;set;}

    public OCS_OCS_COPSVDTA_V1Request() {
        this.serviceId = 'OCS_COPSVDTA_V1';
        this.copsvdtarequest = new Copsvdtarequest();
    }
    
    public class Copsvdtarequest {
        public Integer mftcopsdta_PRATICA {get;set;}
        public String mftcopsdta_TARGA {get;set;}
        public String mftcopsdta_TELAIO {get;set;}
        public String mftcopsdta_MARCA {get;set;}
        public String mftcopsdta_MODELLO {get;set;}
        public Integer mftcopsdta_CILINDRATA {get;set;}
        public String mftcopsdta_DATA_IMMATRIC {get;set;}
        public String msflogon_TMP_KEY {get;set;}
        public String msfilogon_SENDER_TIPO {get;set;}
        public Integer msfilogon_SENDER_CODICE {get;set;}
        public String msfilogon_CANALE_ACQUISIZ {get;set;}
        public String msfilogon_TIPO_CARICAMENTO {get;set;}                          
    }

}