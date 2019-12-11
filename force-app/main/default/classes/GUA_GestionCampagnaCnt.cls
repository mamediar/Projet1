//----------------------------------------------------------------------
    //-- - Author       : SANA BADJI
    //-- - Date         : 12/09/2019
    //-- - Class  : GUA_GestionCampagnaCnt
    //----------------------------------------------------------------------

    public with sharing  class GUA_GestionCampagnaCnt {
        
    /**
     * @author Sana Badji
     * @date  16/09/2019
     * @description Method used to get List Campaign 
     **/
    @AuraEnabled
        public static List<Campaign> getCampaign(String pageSize, String pageNumber) {
                    // Check to make sure all fields are accessible to this user
            String[] fieldsToCheck = new String[] {
                'Id', 'Name', 'StartDate', 'EndDate', 'UAF_Script__c', 
                'UAF_DatiAggiuntivi__c'
            };
            
            Map<String,Schema.SObjectField> fieldDescribeTokens = 
                Schema.SObjectType.Campaign.fields.getMap();
            
            for(String field : fieldsToCheck) {
                if( ! fieldDescribeTokens.get(field).getDescribe().isAccessible()) {
                    throw new System.NoAccessException();
                }
            }
            Id recordType=CGMWSUtils_1_0.getRecordTypeId('Campaign','GUA_Unita_Affari_Campagna');
            Integer psize = Integer.valueOf(pageSize);
            Integer pnumber = Integer.valueOf(pageNumber)-1;
            // OK, they're cool, let 'em through
            return [SELECT Id, Name, StartDate, EndDate, UAF_Script__c, 
                        UAF_DatiAggiuntivi__c 
                    FROM Campaign  Where RecordTypeId =:recordType Order by CreatedDate desc  LIMIT :Integer.valueOf(psize) OFFSET :(psize*pnumber)];
        }
        
    /**
     * @author Sana Badji
     * @date  16/09/2019
      * @param Integer limits
     * @description Method used to get List Campaign setting the limit to display
     **/
    @AuraEnabled
        public static List<Campaign> getCampaignLimit(Integer limits){
        System.debug('limits'+limits);
                // Check to make sure all fields are accessible to this user
            String[] fieldsToCheck = new String[] {
                'Id', 'Name', 'StartDate', 'EndDate', 'UAF_Script__c', 
                'UAF_DatiAggiuntivi__c'
            };
            
            Id recordType=CGMWSUtils_1_0.getRecordTypeId('Campaign','GUA_Unita_Affari_Campagna');
            Map<String,Schema.SObjectField> fieldDescribeTokens = 
                Schema.SObjectType.Campaign.fields.getMap();
            
            for(String field : fieldsToCheck) {
                if( ! fieldDescribeTokens.get(field).getDescribe().isAccessible()) {
                    throw new System.NoAccessException();
                }
            }
            
        Integer intlimits = integer.valueof(limits);
        if(intlimits==0){
            return [SELECT Id, Name, StartDate, EndDate, UAF_Script__c, 
                        UAF_DatiAggiuntivi__c 
                    FROM Campaign Where RecordTypeId =:recordType Order by CreatedDate desc ];
        }else{
        // OK, they're cool, let 'em through
            return [SELECT Id, Name, StartDate, EndDate, UAF_Script__c, 
                        UAF_DatiAggiuntivi__c 
                    FROM Campaign Where RecordTypeId =:recordType Order by CreatedDate desc Limit :intlimits];
        }
    } 

        /**
     * @author Sana Badji
     * @date  09/10/2019
      * @param String Id
     * @description get list Campaign by iD
     **/
    @AuraEnabled
        public static List<Campaign> getCampaignByID(String campaignId){
                // Check to make sure all fields are accessible to this user
            String[] fieldsToCheck = new String[] {
                'Id', 'Name', 'StartDate', 'EndDate', 'UAF_Script__c', 
                'UAF_DatiAggiuntivi__c'
            };
            Id recordType=CGMWSUtils_1_0.getRecordTypeId('Campaign','GUA_Unita_Affari_Campagna');
            Map<String,Schema.SObjectField> fieldDescribeTokens = 
                Schema.SObjectType.Campaign.fields.getMap();
            
            for(String field : fieldsToCheck) {
                if( ! fieldDescribeTokens.get(field).getDescribe().isAccessible()) {
                    throw new System.NoAccessException();
                }
            }
            
        // OK, they're cool, let 'em through
            return [SELECT Id, Name, StartDate, EndDate, UAF_Script__c, 
                        UAF_DatiAggiuntivi__c 
                    FROM Campaign Where Id=:campaignId  ];
        
    } 

    /**
     * @author Sana Badji
     * @date  16/09/2019
      * @param String name
     * @description Method used to get List Campaign by Name
     **/
    @AuraEnabled
        public static List<Campaign> getCampaignbyName(String name){
                // Check to make sure all fields are accessible to this user
            String[] fieldsToCheck = new String[] {
                'Id', 'Name', 'StartDate', 'EndDate', 'UAF_Script__c', 
                'UAF_DatiAggiuntivi__c'
            };
             Id recordType=CGMWSUtils_1_0.getRecordTypeId('Campaign','GUA_Unita_Affari_Campagna');
            Map<String,Schema.SObjectField> fieldDescribeTokens = 
                Schema.SObjectType.Campaign.fields.getMap();
            
            for(String field : fieldsToCheck) {
                if( ! fieldDescribeTokens.get(field).getDescribe().isAccessible()) {
                    throw new System.NoAccessException();
                }
            }
           // String key='%'+name+'%';
            
        // OK, they're cool, let 'em through
            return [SELECT Id, Name, StartDate, EndDate, UAF_Script__c, 
                        UAF_DatiAggiuntivi__c 
                    FROM Campaign Where  Name =:name and RecordTypeId =:recordType];
    } 
    /**
     * @author Sana Badji
     * @date  16/09/2019
      * @param Object Campaign as Type :  campaign
     * @description Method used to save Campaign
     **/
    @AuraEnabled
        public static Campaign saveCampaign(Campaign campaign) {
            // Perform isUpdatable() checking first, then
            try{
                
               Id recordType=CGMWSUtils_1_0.getRecordTypeId('Campaign','GUA_Unita_Affari_Campagna');
               campaign.RecordTypeId=recordType;
                upsert  campaign;
                System.debug('campaign'+campaign);     
            }catch(DmlException e){
                //throw exception message
                System.debug('error insert campaign'+campaign);
               // throw new AuraHandledException(e.getMessage());
            }
             return campaign;
        }
        /**
     * @author Sana Badji
     * @date  10/10/2019
      * @param Object Campaign as Type :  campaign
     * @description Method used to update Campaign
     **/
    @AuraEnabled
        public static List<Campaign> updateCampaign(List<Campaign> camp ,String datiAggiuntivi ){
            System.debug('--camp --'+camp);
            try{
                if(datiAggiuntivi==null){
                    update camp;
                }else{
                    camp[0].UAF_DatiAggiuntivi__c=datiAggiuntivi;
                    update camp;
                }
                 System.debug('camp updated'+camp);  
            }catch(DmlException e){
                //throw exception message
                 System.debug('camp  fail'+camp); 
                  //System.debug('error update campaign'+ids);
                //throw new AuraHandledException(e.getMessage());
            } 
           return camp;  
        }
  /**
     * @author Sana Badji
     * @date  16/09/2019
      * @param List Campaign as Type :  campaign
     * @description Method used to delete Campaign
     **/
    @AuraEnabled
        public static void deleteCampaigns(String ids ){
             try{
                Delete [Select id from Campaign where  id=:ids];
            }catch(DmlException e){
                //throw exception message
                System.debug('error delete campaign'+ids);
               // throw new AuraHandledException(e.getMessage());
            } 
    } 
      /**
     * @author Sana Badji
     * @date  16/09/2019
     * @description Method used to get  the total number of recorded Campaign
     **/
    @AuraEnabled
        public static Integer getTotalCount(){
             Id recordType=CGMWSUtils_1_0.getRecordTypeId('Campaign','GUA_Unita_Affari_Campagna');
            AggregateResult results = [select  count(Id) total  from Campaign Where RecordTypeId =:recordType];
            Integer total =(Integer)results.get('total') ; 
            return total;
        } 
    }