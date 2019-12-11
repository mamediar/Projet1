public class OCSRecuperaTipoControparteResponse extends OCSResponse{
    public class OCSRecuperaTipoControparteResponseData{
        @AuraEnabled
        public String tipoControparte1{get;set;}
        @AuraEnabled
        public String tipoControparte2{get;set;}
        @AuraEnabled
        public String tipoControparte3{get;set;}
        @AuraEnabled
        public String tipoControparte4{get;set;}
        @AuraEnabled
        public String tipoControparte5{get;set;}
        @AuraEnabled
        public String tipoControparte6{get;set;}
        @AuraEnabled
        public String tipoControparte7{get;set;}
        @AuraEnabled
        public String tipoControparte8{get;set;}
        @AuraEnabled
        public String tipoControparte9{get;set;}
        @AuraEnabled
        public String tipoControparte10{get;set;}
        @AuraEnabled
        public String tipoControparte11{get;set;}
        @AuraEnabled
        public String tipoControparte12{get;set;}
        @AuraEnabled
        public String tipoControparte13{get;set;}
        @AuraEnabled
        public String tipoControparte14{get;set;}
        @AuraEnabled
        public String tipoControparte15{get;set;}
        @AuraEnabled
        public String tipoControparte16{get;set;}
        @AuraEnabled
        public String tipoControparte17{get;set;}
        @AuraEnabled
        public String tipoControparte18{get;set;}
        @AuraEnabled
        public String tipoControparte19{get;set;}
        @AuraEnabled
        public String tipoControparte20{get;set;}
        @AuraEnabled
        public String tipoControparte21{get;set;}
    }
    
    @AuraEnabled
    public OCSRecuperaTipoControparteResponseData recuperaTipoControparteResponse{get;set;}
    
    public OCSRecuperaTipoControparteResponse(){
        this.recuperaTipoControparteResponse=new OCSRecuperaTipoControparteResponseData();
    }
    
	public Boolean isAGEorCNV(){
        return('S'.equalsIgnoreCase(this.recuperaTipoControparteResponse.tipoControparte2)
               || 'S'.equalsIgnoreCase(this.recuperaTipoControparteResponse.tipoControparte12));
    }
    
    public Boolean isFIR(){
        return 'S'.equalsIgnoreCase(this.recuperaTipoControparteResponse.tipoControparte14);
    }
    
}