public without sharing class SitesForwardAndTrackCn {
    
    public String tokenStatus 	{public get; private set;} // ok ko finish expired
    public String componentApp 		{public get; set;}
    public String componentName 		{public get; set;}
 	public String objectId 		{public get; set;}
    public String errore 		{public get; set;}

    private List<XCS_Sites_Token__c> tokenVerifyList;
    public List<XCS_Sites_Token__c> listaTemp;

	public SitesForwardAndTrackCn() {
        verifyToken();
    }
    
    public String getListaTemp(){
        return 'Component APP: '+componentApp+ ' Obj Id: '+objectId+' Token'+tokenStatus ;
    }
    private void verifyToken(){
        String token = ApexPages.currentPage().getParameters().get('token');

        listaTemp = [SELECT token__c, Expiration_Date__c  , Burned__c ,ComponentName__c , ComponentApp__c ,ObjectId__c FROM XCS_Sites_Token__c ];
        if(String.isNotBlank(token)){
            tokenVerifyList = [SELECT token__c, Expiration_Date__c  , Burned__c ,ComponentName__c , ComponentApp__c ,ObjectId__c FROM XCS_Sites_Token__c WHERE token__c =: token ];
            if(tokenVerifyList.size()>0){
                try{
                    componentName = tokenVerifyList.get(0).ComponentName__c;
                    componentApp = tokenVerifyList.get(0).ComponentApp__c;
                    objectId = tokenVerifyList.get(0).ObjectId__c;
                    tokenStatus = SitesTokenUtil.verifyToken(tokenVerifyList); 
                }
                catch(Exception e){
                    tokenStatus ='ko';
                }
            }
        }else{
            tokenStatus='ko';
        }
        

    }
    public void Confirm(){
        
        tokenStatus = SitesTokenUtil.burnToken(tokenVerifyList);
        
    }
    
}