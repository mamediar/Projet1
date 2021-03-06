//----------------------------------------------------------------------
    //-- - Author       : SANA BADJI
    //-- - Date         : 22/10/2019
    //-- - Class  : GUA_UltimeChiamateCnt
    //----------------------------------------------------------------------

public with sharing class GUA_UltimeChiamataCnt {
       
    /**
     * @author Sana Badji
     * @date  30/10/2019
     * @description Method used to get List Campaign 
     **/
    @AuraEnabled
        public static Map<String, Object> getTaskByID(String accountId){
            Map<String, Object> response = new Map<String, Object>();
        
            List<Task> ultimeChiamateDealer=null;
            // Check to make sure all fields are accessible to this user
            String[] fieldsToCheck = new String[] {
            'Id', 'CallObject', 'CallType', 'Status', 'ActivityDate', 
            'CallDisposition','WhatId'
            };

            Map<String,Schema.SObjectField> fieldDescribeTokens = 
            Schema.SObjectType.Campaign.fields.getMap();
            System.System.debug('accountId '+accountId);
            ultimeChiamateDealer= [SELECT Id, CreatedDate, Description, Categoria__c, Disposition__c , Disposition__r.Name,  Subject, CallObject,CallType,Status,ActivityDate,CallDisposition,WhatId
                FROM Task Where WhatId=:accountId  ]; // SELECT Id, Categoria__c, Disposition__c , Disposition__r.Name  FROM Task

            
            Case c = [SELECT Id, Account.Name, Owner.Name, RecordType.DeveloperName  FROM Case WHERE Id =:accountId];
            User u = [select id,Name, Alias from User where id =: userInfo.getUserId()];

            if(ultimeChiamateDealer==null){
                System.System.debug('ultimeChiamateDealer is  '+ultimeChiamateDealer);
                //return ultimeChiamateDealer;
                response.put('ultimeChiamateDealer', new List<Task>());
            }else{
                response.put('ultimeChiamateDealer', ultimeChiamateDealer);
            }
            response.put('case', c);
            response.put('operatore', u);
            /*try {
                
            } catch (Exception e) {
                
            }*/

            return response;
    }

    @AuraEnabled
        public static user fetchUser(){
        User u = [select id,Name from User where id =: userInfo.getUserId()];
            return u;
    }
}