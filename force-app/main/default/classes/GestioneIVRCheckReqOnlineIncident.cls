@RestResource(urlMapping='/ivr_checkonlinecase/*')
global with sharing class GestioneIVRCheckReqOnlineIncident {


    global final static String CATEG_RICHIESTE_ONLINE = '1324';


    @HttpGet 
    global static Integer checkOnLineCase() {
        String id = RestContext.request.params.get('id');
        System.debug('checkOnLineCase id:'+id);
        Case[] cases = [SELECT Id FROM Case WHERE Categoria_Riferimento__r.External_Id__c =: CATEG_RICHIESTE_ONLINE AND CaseNumber=:id];
        if (cases!=null && cases.size()>0) {
             return 1;
        }
        return 0;
    }
}