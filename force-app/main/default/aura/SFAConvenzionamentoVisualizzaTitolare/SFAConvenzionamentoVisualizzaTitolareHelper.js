({
	callGetTitolare: function (component, event) {    
		var action = component.get("c.getTitolareId");
		action.setParams({
			caseId: component.get("v.recordId")
		}); 
		action.setCallback(this, function(response){
			if (response.getState() == 'SUCCESS'){
				component.set("v.titolareId", response.getReturnValue());
                console.log('****titolareId' + component.get("v.titolareId"));
                console.log('****SUCCESS');
            } else {
                console.log('****NOT SUCCESS');
            }
        });		
        $A.enqueueAction(action);
	},
        
    avanti: function(component, event) {
		var action = component.get("c.valutaNextStepLavorazione");
		action.setParams({
            caseId: component.get("v.recordId")
		}); 
		action.setCallback(this, function(response){
			if (response.getState() == 'SUCCESS'){
				console.log('nuovo step aggiornato.');                 
            } else {
                console.log('problema nell\'aggiornamento dello step.');    
            }           
        });
        $A.enqueueAction(action);
        this.changeCategoriaStepLavorazioneEvent(component,event);
        /*var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": component.get('v.recordId')
        });
        navEvt.fire();*/             
    },   
    
    changeCategoriaStepLavorazioneEvent: function (component, event){
		var action = component.get("c.getCategoriaEStepLavorazione");
        var changeStepEvent = $A.get("e.c:ChangeCaseStepEvent");         
		action.setParams({
			caseId: component.get("v.recordId"),
		}); 
		action.setCallback(this, function(response){
			if (response.getState() == 'SUCCESS'){
                var dati=response.getReturnValue();
                if (changeStepEvent) {
                    changeStepEvent.setParams({
                        'categoria' : dati.categoria,
                        'stepLavorazione' : dati.stepLavorazione
                    });
                    changeStepEvent.fire();
                }                 
            }
		});
		$A.enqueueAction(action);         
    },     
    
})