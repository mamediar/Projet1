({
    init : function(cmp, event, helper) {
        let ca = cmp.get('v.CaseRecord');
        console.log(ca.CampaignId__r.RecordType.Name, ' ', ca.CampaignId__r.ActionCode__c);
        let action = cmp.get('c.scriptObiezioni');
        action.setParams({'filterCampType':ca.CampaignId__r.RecordType.Name, 'filterCampCQS': ca.CampaignId__r.ActionCode__c});
        action.setCallback(this, function(response){
            let state = response.getState();
            console.log('ciao',state);
            if(state == 'SUCCESS'){
                let script = response.getReturnValue();
                cmp.set('v.script', script);
            }
        });   
        $A.enqueueAction(action);
    }
})