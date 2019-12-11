({
    doAction: function(cmp, item){
        var navService = cmp.find("navService");        
        var action = cmp.get('c.doPreRedirect');
        action.setParams({'item': item, 'accountId':cmp.get('v.recordId')});
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                console.log('NuovoCasoContestualizzato action res');
                var res = response.getReturnValue();
                console.log("*** res :: " + JSON.stringify(res));
                if (res && res.attributes) {
                    if (res.attributes.isOK) {
                        console.log('*** caso if');
                        var pageReference = response.getReturnValue();
                        navService.navigate(pageReference);
                    }
                    else {
                        console.log('*** caso else');
                        this.showToastWarning(cmp, event, res.attributes.errorMessage);           
                    }
                }
            }
        });
        $A.enqueueAction(action);
    },

    showToastOK: function(component, event) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title: "Operazione completata",
			type: "success",
			message: "Salvataggio completato con successo!"
		});
		toastEvent.fire();
	},
	
	showToastKO: function(component, event, message) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title: "Errore",
			type: "error",
			message: message
		});
		toastEvent.fire();
	},

	showToastWarning: function(component, event, message) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title: "Attenzione",
			type: "warning",
			message: message
		});
		toastEvent.fire();
	},
    
    /*loadResource : function(cmp,item) {        
        if(item.Type__c == 'FLOW'){
            this.loadFlow(cmp, item);
        }else if(item.Type__c == 'LCMP'){
            this.loadComponent(cmp,item);
        }
    },
    
    loadComponent : function(cmp,item){
        
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : 'c:' + item.Destination__c,
            componentAttributes: {
                utenteSelezionato : cmp.get('v.recordId')
            }
        });
        evt.fire();
        
        var navService = cmp.find('navService');
        var pageReference = {
            type: 'standard__component',
            attributes: {
                componentName: 'c__' + item.Destination__c
            },
            status: {
                utenteSelezionato: cmp.get('v.recordId')                
            }
        }
        navService.navigate(pageReference);
    },
    
    loadFlow : function(cmp, item){
        var flow = cmp.find("flowData");
        flow.startFlow(item.Destination__c);
    }*/
})