public class OCSRientroDocumentiPraticaResponse extends OCSResponse{
    @AuraEnabled
    public String errore {get;set;}
    
    public OCSRientroDocumentiPraticaResponse(){
    }
    
    @AuraEnabled
    override public String getMessage(){
        String res=!super.isOk() ? super.getMessage() : this.errore;
        return res;
    }
}