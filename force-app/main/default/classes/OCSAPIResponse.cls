public virtual class OCSAPIResponse extends APIResponse {
   	@AuraEnabled
    public Integer resultCode {get; set;}
    @AuraEnabled
    public String resultMessage {get; set;}
    
    public virtual override boolean isOK()
    {
        return this.checkIsOK();
    }
    
    public virtual String getMessage(){
        String res='Success';
        if(!this.checkIsOK()){
            if(super.statusCode!=200){
                res='Errore nella chiamata: '+super.status;
            }
            else{
                res='Errore esecuzione del servizio.'+'\n- - Codice: '+this.resultCode+'\n- - Messaggio: '+this.resultMessage;
            }
        }
        return res;
    }
    
    private boolean checkIsOK(){
        return super.isOK() && this.resultCode==0;
    }
}