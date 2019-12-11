public virtual class APIResponse {
	@AuraEnabled
    public String status {get;set;}
    @AuraEnabled
    public Integer statusCode {get;set;}
    
    public virtual Boolean isOK(){
        return this.statusCode==200;
    }
}