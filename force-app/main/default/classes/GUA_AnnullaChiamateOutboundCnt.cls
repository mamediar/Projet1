//----------------------------------------------------------------------
    //-- - Author       : Aminata GUEYE
    //-- - Date         : 30/09/2019
    //-- - Class  : GUA_GestionCampagnaCnt
    //--------------------------------------------------------------------
public with sharing class GUA_AnnullaChiamateOutboundCnt {
     
     
     @AuraEnabled 
    public List<Case> casList = new List<Case>();
    
    @AuraEnabled 
    public List<Case> delRec = new List<Case>();
     
     /**
     * @author Aminata GUEYE
     * @date  30/09/2019
     * @description Method used to get the Campagne Name
     **/
     @AuraEnabled //get Campaign Name Values
    public static Map<String, Object> getCampName(){
       List<Campaign> names;
       Id recordType=CGMWSUtils_1_0.getRecordTypeId('Campaign','GUA_Unita_Affari_Campagna');
       Map<String,Object> response=new Map<String, Object>();
       response.put('error',false);
       try {
           names = [SELECT Name FROM Campaign where RecordTypeId =:recordType];
           response.put('data',names);
       
       } catch(Exception e){
           response.put('error',true);
           response.put('message',e.getMessage());
           response.put('cause',e.getCause());
           response.put('stackTrace',e.getStackTraceString());
       }
       system.debug(response);
       return response; 
    }
     /**
     * @author Aminata GUEYE
     * @date  01/10/2019
     * @description Method used to search Case
     **/
     @AuraEnabled
 public static List <Case> fetchCase(String codi, String campagna) {
  list<sobject> records;
       string condition = '';
     
       
       if(campagna !='Selezionatutte'){
           condition+= ' And CampaignId__r.Name =\''+campagna+'\'';
       }
       if(String.isNotEmpty(codi)){
           condition+= ' And CodiceDealer__c LIKE \'%'+codi+'%\'';
       }
       
       string query = 'select Id, CodiceDealer__c,CampaignId__r.Name,NumeroPratica__c,CaseNumber from Case where id!=null ' + condition ;
       system.debug(query);
       records = Database.query(query);
       return records;
 }

/**
     * @author Aminata GUEYE
     * @date  02/10/2019
     * @description Method used to delete Case selected
     **/
    @AuraEnabled 
    public static List<Case> delSlctRec(List<String> slctRec)
    {
        GUA_AnnullaChiamateOutboundCnt clc = new GUA_AnnullaChiamateOutboundCnt();
        clc.delRec = [SELECT Id FROM Case WHERE Id IN: slctRec ];
        try {
            delete clc.delRec;
        } catch(Exception ex) {
                throw new AuraHandledException(ex.getMessage());
        }
        clc.casList = Database.query('select Id, CodiceDealer__c,CampaignId__r.Name,NumeroPratica__c,CaseNumber from Case');
        return clc.casList;        
    }
}