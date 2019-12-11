({
	changeAttivitaStepAndType : function(component, event, newDispositionExternalId, newStep, assignActivity,newCategoria,newOggetto) {
        var spinner = component.find('spinnerComponent');
        spinner.incrementCounter();        
        console.log('***BUTTON AVANTI INDIETRO --- HELPER');
        var action=component.get('c.handleCase');
        //var ifNavigate=component.get('v.ifNavigate');
        action.setParam('recordId',component.get('v.recordId'));
        action.setParam('newDispositionExternalId',newDispositionExternalId);        
        action.setParam('newStep',newStep);
        action.setParam('assignActivity',assignActivity);   
        action.setParam('queueToAssignCase',component.get('v.queueToAssignCase'));   
        action.setParam('newCategoria',newCategoria);
        action.setParam('newOggetto',newOggetto);
        action.setCallback(this,function(response){
            console.log('***BUTTON AVANTI INDIETRO --- ACTION');
            if(response.getState()=='SUCCESS'){
				console.log('***step Updated Properly');
            } else {
                console.log('***step NOT Updated Properly');
            }
			spinner.decreaseCounter();            
        });
        $A.enqueueAction(action);	
        this.changeCategoriaStepLavorazioneEvent(component,event);
 
	},
    
    changeCategoriaStepLavorazioneEvent: function (component, event){
        var spinner = component.find('spinnerComponent');
        spinner.incrementCounter();        
        var ifNavigate=component.get('v.ifNavigate');
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
                if(ifNavigate){
                    window.location.reload(true);
                }                
            }
            spinner.decreaseCounter();
		});
		$A.enqueueAction(action);         
    },    
    
})