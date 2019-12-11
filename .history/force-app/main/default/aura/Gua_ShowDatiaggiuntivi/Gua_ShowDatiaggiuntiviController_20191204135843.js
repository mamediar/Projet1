({
	doInit : function(component, event, helper) {
        var recordId = component.get('v.idCase');
        console.log('#l recordId', recordId);
        var action = component.get('c.getDatiaggiuntiviByCase');
        action.setParam('idCase', recordId);
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var customResponse = response.getReturnValue();
                console.log('### customResponse ', JSON.stringify(customResponse));
                if (customResponse.erreur === false) {
                    var dealerCase = customResponse.case;
                    console.log('### customCase ', JSON.stringify(dealerCase));
                    var script = 'non ci sono contenuti di script';
                    var campaignName = 'questa richiesta non è collegata ad alcuna campagna';
                    if (dealerCase.hasOwnProperty('CampaignId__r')){
                        script = dealerCase.CampaignId__r.hasOwnProperty('UAF_Script__c') ? dealerCase.CampaignId__r.UAF_Script__c : 'UAF_Script__c';
                        campaignName = dealerCase.CampaignId__r.hasOwnProperty('Name') ? dealerCase.CampaignId__r.Name : 'Name';                                    
                    }
                    var res = script.replace(/<[^>]*>/g, '');
                    component.set('v.script', res);
                    component.set('v.campaignName', campaignName);

                } else {
                    this.showToast("", "error");
                }
            } else {
                alert('error' + response.getError());
                console.log(JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
		
	}
})