({
	initApex : function(component, event, helper) {
        var spinner = component.find('spinnerComponent');
		spinner.incrementCounter();
		var action=component.get('c.initApex');
        action.setCallback(this,function(resp){
            spinner.decreaseCounter();
            if(resp.getState()=='SUCCESS'){
                var initWrapper= resp.getReturnValue();
                component.set('v.targetDate', initWrapper.targetDate);
                component.set('v.today', initWrapper.targetDate);   
                component.set('v.filialistiPerFiliale', initWrapper.filialistiPerFiliale);
                
                component.set('v.slotList', initWrapper.slotList);
                component.set('v.assenzeProlungateList', initWrapper.assenzeProlungateList);
				component.set('v.userSelected', initWrapper.manager)
                var branch= initWrapper.branches.find(actualBranch => {
                    return actualBranch.OCS_External_Id__c == initWrapper.manager.DefaultQueueId__c.split(";")[0];
                });
                component.set('v.users', initWrapper.filialistiPerFiliale[branch.OCS_External_Id__c]);
                component.set('v.branches', initWrapper.branches);
                component.set('v.branch', branch);
                component.set('v.branchOCSExternalId', branch.OCS_External_Id__c);
                component.set('v.zonePerFiliale', initWrapper.zonePerFiliale);
                component.set('v.TypeSelectOptions', initWrapper.TypeSelectOptions);
                component.set('v.currentMonthWeekList', initWrapper.currentMonthWeekList);
            }
            else if(resp.getState()=='ERROR'){
                var errors = resp.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                                 helper.showToast("Errore: " + 
                                 errors[0].message,'error');
                    }else {
                        console.log("Unknown error");
                        helper.showToast('Errore generico','error');
                    }
                } else {
                    console.log("Unknown error");
                    helper.showToast('Errore generico','error');
                }
            }
        });
        $A.enqueueAction(action);
    },
    submitNewTargetDate : function(component, event, helper) {
        var spinner = component.find('spinnerComponent');
		spinner.incrementCounter();
		var action=component.get('c.changeTargetDate');
        action.setParams({targetDate: component.get('v.targetDate'), 
                            manager: component.get('v.userSelected'), 
                            filialistiPerFiliale: component.get('v.filialistiPerFiliale')});
        action.setCallback(this,function(resp){
            spinner.decreaseCounter();
            if(resp.getState()=='SUCCESS'){
                var initWrapper= resp.getReturnValue();
                component.set('v.targetDate', initWrapper.targetDate); //?
                component.set('v.slotList', initWrapper.slotList);
                component.set('v.assenzeProlungateList', initWrapper.assenzeProlungateList);
                component.set('v.currentMonthWeekList', initWrapper.currentMonthWeekList);
            }
            else if(resp.getState()=='ERROR'){
                var errors = resp.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                                 helper.showToast("Errore: " + 
                                 errors[0].message,'error');
                    }else {
                        console.log("Unknown error");
                        helper.showToast('Errore generico','error');
                    }
                } else {
                    console.log("Unknown error");
                    helper.showToast('Errore generico','error');
                }
            }

        });
        $A.enqueueAction(action);
    },
    
    onChangeBranchSelect: function(component, event, helper) {
        var branchOCSExternalId = component.get('v.branchOCSExternalId');
        component.set('v.users', component.get('v.filialistiPerFiliale')[branchOCSExternalId]);
        var users= component.get('v.users');
        if(users){
            component.set('v.userSelected', component.get('v.users')[0]);
        }
        else{
            component.set('v.userSelected', '');
        }
        component.set('v.branch', component.get('v.branches')
                    .find(branch => {return branch.OCS_External_Id__c===branchOCSExternalId}) );
        var childComponents= component.find('CalendarBoxContainerFilialistiId');
        var spinner = component.find('spinnerComponent');
        childComponents.forEach(component => {
            component.refreshComponent();
        });
    },
    
    showToast : function(message,type){
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			message: message,
			type: type
		});
		toastEvent.fire();
    },
	
	onChangeUserSelect: function(component, event, helper) {
		var userID= component.get('v.userSelectedID');
        component.set('v.userSelected', component.get('v.users').find(user => user.Id===userID));
        var childComponents= component.find('CalendarBoxContainerFilialistiId');
        var spinner = component.find('spinnerComponent');
        childComponents.forEach(component => {
            component.refreshComponent();
        });
    }
})