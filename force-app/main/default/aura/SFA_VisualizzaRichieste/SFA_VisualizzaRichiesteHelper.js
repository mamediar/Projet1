({
	init : function(cmp,event,helper) {
		cmp.set('v.columns', [
			{label: 'Username', fieldName: 'Username', type:'text'},
			{label: 'Alias', fieldName: 'Alias', type:'text'},
			{label: 'Data Pianificata', fieldName: 'Date__c', type: 'text'},
            {label: 'Periodo', fieldName: 'Time__c', type: 'text'},
            {label: 'Stato', fieldName: 'Status__c', type: 'text'}
		]);
		var spinner = cmp.find('spinnerComponent');
        spinner.incrementCounter();
		var action = cmp.get("c.initApexWithUserDetails");
        action.setCallback(this, function(response) {
            var state = response.getState();
            spinner.decreaseCounter();
            if (state === "SUCCESS") {
                var branchWr = response.getReturnValue();
                cmp.set("v.branches",branchWr.branches);
                cmp.set("v.branchMap",branchWr.branchMap);
                cmp.set("v.branchOCSExternalId", branchWr.branches[0].OCS_External_Id__c);
                helper.changeNotaSpeseList(cmp,event,helper);
            }
            else if(response.getState()=='ERROR'){
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        helper.showToast("Errore: " + errors[0].message,'error');
                    }else {
                        helper.showToast('Errore generico','error');
                    }
                } else {
                    helper.showToast('Errore generico','error');
                }
            }
            
        }); 
        $A.enqueueAction(action); 
	},

	populateExtraFields: function(listToPopulate){
		listToPopulate.forEach(element =>{
			element.Username=element.User__r.Name;
			element.Alias=element.User__r.Alias;
		})
    },
    
    changeNotaSpeseList: function(cmp, event,helper){
        var OCSExternalId=cmp.get("v.branchOCSExternalId");
        var branchMap=cmp.get("v.branchMap");
        var notaSpeseList=branchMap[OCSExternalId];
        if(notaSpeseList){
            helper.populateExtraFields(notaSpeseList);
        }
        cmp.set("v.data", notaSpeseList);
    },

    sendMessageHandler: function(component, event, helper){
        if(event.getParam("message") === "refresh" && event.getParam("channel") === "VisualizzaRichieste"){
            helper.init(component, event, helper);
        }
	},

	showToast : function(message,type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "message": message,
            "type" : type
        });
        toastEvent.fire();
    }
})