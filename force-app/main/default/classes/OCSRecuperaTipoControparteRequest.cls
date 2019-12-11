public class OCSRecuperaTipoControparteRequest extends OCSRequest{ 
    @AuraEnabled
    public OCSRecuperaTipoControparteRequestData recuperaTipoControparteRequest{get;set;}
    
    public OCSRecuperaTipoControparteRequest(){
        this.serviceId='recuperaTipoControparte';
        this.recuperaTipoControparteRequest=new OCSRecuperaTipoControparteRequestData();
    }
    
    public class OCSRecuperaTipoControparteRequestData{
        @AuraEnabled
        public String codCliente{get;set;}
    }
    
}