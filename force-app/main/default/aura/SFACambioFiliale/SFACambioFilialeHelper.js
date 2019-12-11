({
	initBranchList: function (cmp, event, helper) {
		
        var spinner = cmp.find('spinnerComponent');
        spinner.incrementCounter();
        var action = cmp.get("c.initApex");
        action.setCallback(this, function(response) {
            var state = response.getState();
            spinner.decreaseCounter();
            if (state === "SUCCESS") {
                
                var initWrapper= response.getReturnValue();
                var areas = Object.keys (initWrapper.branchListPerArea);
                cmp.set('v.branchListPerArea',initWrapper.branchListPerArea);
                cmp.set('v.manager',initWrapper.manager);
                var preselectedArea = initWrapper.areaSelezionata ? initWrapper.areaSelezionata : areas[0];
                var preselectedBranch = initWrapper.filialeSelezionata ? initWrapper.filialeSelezionata : initWrapper.branchListPerArea[preselectedArea][0].OCS_External_Id__c;
                cmp.set('v.SelectedArea',preselectedArea);
                cmp.set('v.areas',areas);
                cmp.set('v.branchOCSExternalId',preselectedBranch);
                cmp.set('v.branches',initWrapper.branchListPerArea[preselectedArea]);

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
    
    onChangeBranchSelect: function(cmp, event, helper) {
        var SelectedArea = cmp.get('v.SelectedArea');
        var branches = cmp.get('v.branchListPerArea')[SelectedArea];
        cmp.set('v.branchOCSExternalId',branches[0].OCS_External_Id__c);
        cmp.set('v.branches',branches);
    },

	saveChangeFiliale: function(cmp, event, helper){
        var spinner = cmp.find('spinnerComponent');
		spinner.incrementCounter();
        var selectedOCSExternalId= cmp.get('v.branchOCSExternalId');
        var manager = cmp.get('v.manager');
        manager.DefaultQueueId__c = selectedOCSExternalId;
        var action = cmp.get("c.updateUser");
        action.setParams({manager : manager});
        action.setCallback(this, function(response) {
            var state = response.getState();
            spinner.decreaseCounter();
            if (state === "SUCCESS") {
                helper.showToast("Filiale selezionata correttamente","success");
				$A.get('e.force:refreshView').fire();
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        helper.showToast("Errore: " + errors[0].message,'error');
                    }
                } else {
					helper.showToast('Errore generico','error');
                }
            }
            
        }); 
        $A.enqueueAction(action);
    },
	
	showToast : function(message,type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "message": message,
            "type" : type
        });
        toastEvent.fire();
    },    
})