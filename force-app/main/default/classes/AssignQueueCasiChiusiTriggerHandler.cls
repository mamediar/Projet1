public class AssignQueueCasiChiusiTriggerHandler extends TriggerHandler {
    
    public override void afterupdate(){
        List<Case> lstCase=(List<Case>)Trigger.new;
        Map<Id,Case> mapOldCase=(Map<Id,Case>) Trigger.oldMap;
        Map<Id,case> mapNewCase=(Map<Id,Case>) Trigger.newMap;
        
        List<Case> cases = new List<Case>{}; 
        for(Case c : [select id,status from case where id=:lstCase])
            if(mapNewCase.get(c.id).isClosed && mapNewCase.get(c.id).status!=mapOldCase.get(c.id).status){ //status modificato a 1 di chiusura
                System.debug('********************AssignQueueCasiChiusiTriggerHandler**************START');
                //System.debug('mapNewCase.get(c.id).status-->'+mapNewCase.get(c.id).status);
                //System.debug('mapOldCase.get(c.id).status-->'+mapOldCase.get(c.id).status);
                //facciamo intervenire l'assignment rule
                Database.DMLOptions caseOptions=c.getOptions();
                System.debug('caseOptions-->'+caseOptions);
                if(caseOptions==null || (caseOptions.assignmentRuleHeader!=null && 
                    caseOptions.assignmentRuleHeader.assignmentRuleId==null)){ //non sono impostate assignment rule specifiche
                    System.debug('---ENTRATO NELLA SEZIONE CASEOPTIONS');
                    caseOptions=new Database.DMLOptions();
                    caseOptions.assignmentRuleHeader.useDefaultRule= true;
                    c.setOptions(caseOptions);
                    cases.add(c);
                }
                
            } 
        //TriggerHandler.bypass('CaseTriggerHandlerSLA');
        //TriggerHandler.bypass('AssignQueueCasiChiusiTriggerHandler');
        update cases;
    }
}