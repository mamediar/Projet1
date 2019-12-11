({	
	doSearch: function(cmp,event,helper){
		var CIP_CF_PIVA=cmp.get("v.CIP_CF_PIVA")? cmp.get("v.CIP_CF_PIVA").trim(): cmp.get("v.CIP_CF_PIVA");
        var ragioneSociale=cmp.get("v.ragioneSociale")? cmp.get("v.ragioneSociale").trim(): cmp.get("v.ragioneSociale");
		if(!(CIP_CF_PIVA || ragioneSociale)){
            helper.showToast('Valorizzare almeno un campo di ricerca','error');
            return;
		}
        

		var spinner = cmp.find('spinnerComponent');
        spinner.incrementCounter();
        var action = cmp.get("c.searchDealers");
		action.setParams({
			CIP_CF_PIVA : CIP_CF_PIVA,
			ragioneSociale: ragioneSociale
		})
        action.setCallback(this, function(response) {
            var state = response.getState();
            spinner.decreaseCounter();
            if (state === "SUCCESS") {
				var result=response.getReturnValue();
				result.forEach(element => {
					if(element.Zone__c){
						element.zoneName=element.Zone__r.Name;
					}
				});
				cmp.set('v.data',result);
			}
			else if(response.getState()=='ERROR'){
                var errors = response.getError();
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
    
    selectDealer:function(cmp, event, helper) {
		//helper.closePopUp(cmp, event, helper);
		var dealerSelected=event.getParam('selectedRows')[0];
		cmp.set("v.dealerSelected", dealerSelected);
	},

	openPopUp: function(cmp,event,helper){	
		cmp.find("theStaticModal").openModal(); 
	},
	closePopUp : function(cmp, event, helper) {
		cmp.find("theStaticModal").closeModal();
	},

	showToast : function(message,type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "message": message,
            "type" : type,
            "mode" : 'dismissible'
        });
        toastEvent.fire();
    },  

})