public class ContractResult {
    @AuraEnabled
    public List<DocumentResult> okDocuments {get;set;}
    @AuraEnabled
    public List<DocumentResult> koDocuments {get;set;}
    @AuraEnabled
    public Contract contract {get;set;}
    @AuraEnabled
    public OCSCambioStatoPraticaResponse response {get;set;}
    
    
    
    public void setDocResult(List<DocumentResult> docs){
        if(okDocuments==null){
            this.okDocuments=new List<DocumentResult>();
        }
        if(koDocuments==null){
            this.koDocuments=new List<DocumentResult>();
        }
        if(docs != null) {
            for(DocumentResult r:docs){
                if(r.response.isOk()){
                    if(r.response.errore!=null && r.response.errore!='' && !r.response.errore.equals('OK')){
                        this.koDocuments.add(r);
                    }
                    else{
                        this.okDocuments.add(r);
                    }
                }
                else{
                    this.koDocuments.add(r);
                }
            }
        }        
    }
    
    public boolean isOk(){
        return koDocuments.size()==0;
    }
    
    @AuraEnabled
    public boolean getIsOk(){
        return this.isOk();
    }
}