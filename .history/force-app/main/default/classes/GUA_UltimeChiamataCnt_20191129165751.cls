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
        public static Map<String, Object> getTaskByID(String idCase){
            Map<String, Object> response = new Map<String, Object>();
        
            List<Task> ultimeChiamateDealer=null;
            response.put('messageError','');
            response.put('error',false);

            try {
                /*ultimeChiamateDealer= [SELECT Id, CreatedDate, Description, Categoria__c, Disposition__c , Disposition__r.Name,  Subject, CallObject,CallType,Status,ActivityDate,CallDisposition,WhatId
                FROM Task Where WhatId=:idCase  ]; // SELECT Id, Categoria__c, Disposition__c , Disposition__r.Name  FROM Task
            */

                ultimeChiamateDealer= [SELECT Id, CreatedDate, Description, Categoria__c, Disposition__c , Disposition__r.Name,  Subject, CallObject,CallType,Status,ActivityDate,CallDisposition,WhatId
                FROM Task Where WhatId in (select Id from Case where AccountId in (select AccountId from Case where id=:idCase)) ]; 

                Case c = [SELECT Id, Account.Name, Owner.Name, RecordType.DeveloperName  FROM Case WHERE Id =:idCase];
                User u = [select id,Name, Alias from User where id =: userInfo.getUserId()];

                if(ultimeChiamateDealer==null){
                    response.put('ultimeChiamateDealer', new List<Task>());
                }else{
                    response.put('ultimeChiamateDealer', ultimeChiamateDealer);
                }
                response.put('case', c);
                response.put('operatore', u);
            } catch (Exception e) {
                response.put('error',true);
                response.put('ultimeChiamateDealer', new List<Task>());
                response.put('case',null);
                response.put('operatore', null);
                response.put('messageError', e.getLineNumber()+' '+e.getMessage()+' '+e.getCause());
            }

            return response;
    }

    @AuraEnabled
        public static user fetchUser(){
        User u = [select id,Name from User where id =: userInfo.getUserId()];
            return u;
    }
}