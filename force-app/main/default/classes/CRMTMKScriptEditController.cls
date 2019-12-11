public with sharing class CRMTMKScriptEditController {

    @AuraEnabled
    public static Map<String,XCS_Script__c> cloneScript( String idoldScript,String text, String codprod,String codprodlvl2,String actioncode,
                                        String actioncodelvl2, 
                                        String sectioncode,
                                        String sectiontype, 
                                        Boolean active, 
                                        String tipocamp, 
                                        Date startDate, 
                                        Date endDate ){
        Map<String,XCS_Script__c> mapCtrl = new Map<String,XCS_Script__c>();
                                         
        System.debug( idoldScript + ' ' + text + ' ' + codprod + ' ' + codprodlvl2 +' ' + actioncode + ' ' + actioncodelvl2 +' ' + sectioncode +' '+ active +' ' + tipocamp +' ' + startDate + ' ' + endDate);                                    
        if(idoldScript != null){
        XCS_Script__c oldScript = [SELECT Id, SectionType__c, SectionCode__c, TipoCampagna__c, 
                                EndDate__c, StartDate__c, ActionCodeLvl2__c, 
                                ActionCode__c, Active__c, CodProdLvl2__c, 
                                CodProd__c, CaseActivityType__c, Text__c FROM XCS_Script__c where Id =:idoldScript];
            					
            if(oldScript.StartDate__c != startDate){mapCtrl = controllTrue(oldScript,startDate);} else{mapCtrl = controllFalse(oldScript,startDate);}} 
                                            system.debug('controllo map '+ mapCtrl.containsKey('UP'));
                                            if(mapCtrl.containsKey('UP')|| idoldScript == null){
        XCS_Script__c newScript = new XCS_Script__c( Text__c = text, 
                                                    SectionCode__c = sectioncode, 
                                                    SectionType__c = sectiontype, 
                                                    StartDate__c = startDate,
                                                    EndDate__c = endDate,
                                                    CodProd__c = codprod,
                                                    CodProdLvl2__c = codprodlvl2,
                                                    ActionCode__c = actioncode,
                                                    ActionCodeLvl2__c = actioncodelvl2,
                                                    Active__c = active,
                                                    TipoCampagna__c = tipocamp);
        insert newScript;
                                            system.debug('la mappa '+mapCtrl);
                                            }
            return mapCtrl;
        
    }
    
                                            
    public static Map<String,XCS_Script__c> controllTrue(XCS_Script__c iScript, Date startdatee){
        Map<String,XCS_Script__c> mapCtrl = new Map<String,XCS_Script__c>();
                                                iScript.EndDate__c = startdatee.addDays(-1);
                                                update iScript;
                                                mapCtrl.put('UP', iScript);
                                                return mapCtrl;
                                            
    }
  	public static Map<String,XCS_Script__c> controllFalse(XCS_Script__c Script, Date startdate){
        Map<String,XCS_Script__c> mapCtrl = new Map<String,XCS_Script__c>();
                                                
                                                    mapCtrl.put('noUP', Script);
                                                return mapCtrl;
                                            
    }                                        
                                            
                                            
                                            
                                            
                                            
                                            
                                            
                                            
                                            
                                            
                                            
                                            
                                           
                                            
                                           

}