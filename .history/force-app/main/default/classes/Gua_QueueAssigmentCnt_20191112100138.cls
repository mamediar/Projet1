/**
 * @File Name          : Gua_QueueAssigmentCnt
 * @Description        : Class for Managing unita affari
 * @Author             : Abdoulaye DIOP (AD)
 * @CreatedDate        : 08/11/2019
**/
public with sharing class Gua_QueueAssigmentCnt {
    
    /**
     * @author AD
     * @date  08/11/2019
     * @description Method used to get areas value
     * @param none
     **/
    @AuraEnabled
    public static Map<String, Object> getArea(){
        Map<String, Object> response = new Map<String, Object>();
        GUA_Queue_Assigment__c existedQueueAssignement = new GUA_Queue_Assigment__c();
        try {
            existedQueueAssignement  = [SELECT Id, Q281__c, Q285__c, Q286__c, Q287__c, IsActive__c FROM GUA_Queue_Assigment__c WHERE IsActive__c = true LIMIT 1];            
            List<String> regions = Gua_Service.getSelectOptions(existedQueueAssignement, 'Region_Name__c');
            response.put('regions', regions);
            response.put('existedQueueAssignement', existedQueueAssignement);
            response.put('error', false);
        } catch (Exception e) {
            try {
                List<String> regions = Gua_Service.getSelectOptions(existedQueueAssignement, 'Region_Name__c');
                response.put('regions', regions);
                response.put('existedQueueAssignement', null);
                response.put('error', false);
            } catch (Exception ex) {
                response.put('error', true);
                response.put('message', ex.getMessage());
            }
        }
        return response;
    }

    /**
     * @author AD
     * @date  08/11/2019
     * @description Method save a object GUA_Queue_Assigment__c
     * @param none
     **/
    @AuraEnabled
    public static Map<String,Object> saveQueueAssigment(GUA_Queue_Assigment__c myQueueAssig){
        System.debug('************************* Start save_Queue_Assigment ***********************');
        Map<String,Object> response = new Map<String,Object>();
        response.put('error',false);
        try {
            List<GUA_Queue_Assigment__c> existedQueueAssignements  = [SELECT Id, Q281__c, Q285__c, Q286__c, Q287__c, IsActive__c FROM GUA_Queue_Assigment__c WHERE IsActive__c = true];
            if (!existedQueueAssignements.isEmpty()) {
                for (GUA_Queue_Assigment__c existedQueueAssignement : existedQueueAssignements) {
                    existedQueueAssignement.IsActive__c = false;
                }
            }
            myQueueAssig.IsActive__c = true;
            existedQueueAssignements.add(myQueueAssig);
            upsert existedQueueAssignements;
            response.put('data', myQueueAssig);
        } catch (Exception e){
            System.debug('Meassage : '+e.getMessage());
            System.debug('Cause : '+e.getCause());
            System.debug('Strace : '+e.getStackTraceString());
            response.put('error',true);
        }
        System.debug('response : '+response);
        System.debug('************************* End save_Queue_Assigment ***********************');
        return response;
    }
}