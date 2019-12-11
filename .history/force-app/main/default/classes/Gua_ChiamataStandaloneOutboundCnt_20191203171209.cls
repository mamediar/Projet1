/**
* @File Name          : Gua_ChiamataStandaloneOutboundCnt.cls
* @Description        : 
* @Author             : Mame Bousso kane
* @CreatedDate        : 22/10/2019
*/
public with sharing class Gua_ChiamataStandaloneOutboundCnt {
    @AuraEnabled
    public static Map<String ,Object> getFilialeByNameOrCodiceFiliale(String valueNameCF){
        Map<String ,Object> returnValue = new  Map<String ,Object>();
        returnValue.put('erreur', false);
        try {
            List<Account> filiales = Gua_ManageUnitaAffariQuery.getFiliales(valueNameCF);
            returnValue.put('resultat',filiales);
            if(filiales.size() == 0){
                returnValue.put('message', 'Nessun filiale trovato');
                throw new CustomException('Nessun filiale trovato');
            }
        } catch (Exception e) {
            System.debug('errorMessage Gua_ChiamataStandaloneOutboundCnt getFilialeByNameOrCodiceFiliale '+e.getMessage());
            returnValue.put('message', e.getMessage()+' '+e.getCause()+' '+e.getLineNumber());
            returnValue.put('erreur', true);
        }
        return returnValue;
    }
    
    /**
    * @Description        : retrieve xcs_description__c
    * @Author             : Khalidou I. Sow BA
    * @CreatedDate        : 09/11/2019
    */
    @AuraEnabled(cacheable=true)
    public static Map<String,Object> retrieveDispositionValues(String caseId){
        Map<String ,Object> response = new  Map<String ,Object>();
        String critera = '';
        response.put('error', false);
        
        try {
            System.debug('caseId is blank '+String.isBlank(caseId));
            List<Case> caseList = [SELECT ID,RECORDTYPE.NAME FROM CASE WHERE ID = :caseId];
            System.debug('##caseList## '+caseList);

            if (caseList.size() > 0) {
                if (caseList[0].RECORDTYPE.NAME == 'GUA Contact') {
                    critera = 'CTI Outbound';
                }else if(caseList[0].RECORDTYPE.NAME == 'GUA Inbound') {
                    critera ='CTI Inbound';
                }
            }
            System.debug('##critera## '+critera);

            List<XCS_Disposition__c>  dispositions = [SELECT ID,NAME, Categoria__c FROM XCS_Disposition__c WHERE PARENT__r.Name = 'Affari@Phone' AND PARENT__r.PARENT__r.Name= :critera];                
            if (dispositions.size()>0) {
                response.put('data',dispositions);
            }else{
                response.put('data',null);
            }
            System.debug('##dispositions## '+dispositions);
            
        } catch (Exception e) {
            System.debug('errorMessage   '+e.getMessage());
            response.put('message', e.getMessage()+' '+e.getCause()+' '+e.getLineNumber());
            response.put('error', true);
        }

        return response;
    } 

 
    /**
    * @Description        : create new task with  GUA_Task recordTypeId
    * @Author             : AD
    * @CreatedDate        : 28/11/2019
    */
 	@AuraEnabled
    public static Map<String ,Object> createTasks(List<String> idDispositions,String description,String caseId,Map<String,String> datiAggiuntivi, Boolean closedCase){
        Map<String ,Object> response = new  Map<String ,Object>();
        response.put('error', false);
        String str = '';

        try {
            //get xml static ressource
            StaticResource TemplateToUser = [SELECT Id, Body FROM StaticResource WHERE Name = 'TemplateToUser' LIMIT 1];
            String rsBody = TemplateToUser.Body.toString();

            System.debug('### resource body ### '+rsBody);
            System.debug('### resource datiAggiuntivi.keyset() ### '+datiAggiuntivi.keyset());           
            for( String aggKey : datiAggiuntivi.keyset() )
            {
                str = str + '<'+aggKey+'>'+datiAggiuntivi.get( aggKey )+'</'+aggKey+'>';
            }
            
            System.debug('### str str ### '+str);

            //create task
            List<Task> tasks = new List<Task>();
            for (String idDisp : idDispositions) {
                Task task = new Task();
                Id recordtypeId = Gua_Service.getRecordTypeId('GUA_Task', 'Task');
                task.recordtypeId = recordtypeId;
                task.Disposition__c = idDisp;
                task.Description = description;
                task.WhatId = caseId;
                task.UAF_XMLDatiAggiuntivi__c = rsBody.replace('$content',str);
                task.Subject = 'Call';
                tasks.add(task);
            }
            insert tasks;

            if (closedCase) {
                Case c = [SELECT Id, Status FROM Case WHERE Id =: caseId];
                c.Status = 'Closed';
                update c;
                response.put('caseChiamata', c);
            }
                
            System.debug('##### new task #####  '+tasks);
            response.put('data',tasks);

        } catch (Exception e) {
            System.debug('errorMessage   '+e.getMessage());
            System.debug('errorCause   '+e.getCause());
            response.put('message', e.getMessage()+' '+e.getCause()+' '+e.getLineNumber());
            response.put('error', true);
        }
        return response;
    }  


    
    public class CustomException extends Exception {}
}