({
    doInit : function(component, event, helper) {
        
        if(!component.get('v.disabledInit')){
            helper.InitHelper(component);
        }    
    },
    reInit : function(component, event, helper) {
        
        helper.InitHelper(component);
        
    },
    
    handleClick : function (component, event, helper) {
        var spinner = component.find('spinnerComponent');
        spinner.incrementCounter();         
        
        var dispositionEvent = $A.get("e.c:XCS_DispositionReady"); 
        var mapDispositions=component.get('v.mapDispositions');
        var noteValue=component.get('v.noteValue');
        console.log('****v.mapDispositions component figlio:: '+JSON.stringify(mapDispositions));
        var disposition=mapDispositions[component.get('v.dispositionSelezionatoId')];
        component.set('v.dispositionSelezionato',disposition );          
        
        if(component.get('v.saveCase')){
            
            var action=component.get('c.handleCase');
            
            action.setParam('disposition',disposition);
            action.setParam('recordId',component.get('v.recordId'));
            action.setParam('note',noteValue);
            action.setCallback(this,function(response){
                if(response.getState()=='SUCCESS'){
                    console.log('@@@@@@@@@@@@@@@@@@òòcase esitato');
                    if (dispositionEvent) {
                        dispositionEvent.setParams({
                            'disposition':disposition,
                            'note':noteValue,
                            'apexClass' : disposition.Azione__c,
                            'apexResult' : response.getReturnValue()
                        });
                        dispositionEvent.fire();
                    }
                    if(component.get('v.showToastMessage')){
                        component.find('notifLib').showToast({
                            'variant':'success',
                            "title": "Operazione completata",
                            "message": "Caso esitato con successo."
                        });                        
                    }
                    
                    $A.get('e.force:refreshView').fire();
                }
                spinner.decreaseCounter();
            });
            $A.enqueueAction(action);
        }
        else{
            if(component.get('v.usesDispositionAction'))
            {
                var action=component.get('c.doDispositionAction');
                action.setParams({
                    'obj' :  component.get('v.dispositionActionSObject'),
                    'disposition' : disposition
                });
                action.setCallback(this,function(response){
                   if(response.getState()=='SUCCESS')
                   {
                       if (dispositionEvent) {
                           dispositionEvent.setParams({
                               'disposition' : disposition,
                               'note' : noteValue,
                               'apexClass' : disposition.Azione__c,
                               'apexResult' : response.getReturnValue()
                           });
                           dispositionEvent.fire();
                       }  	
                   }
                   spinner.decreaseCounter();
                });
                
            }
            else
            {
              if (dispositionEvent) {
                dispositionEvent.setParams({
                    'disposition' : disposition,
                    'note' : noteValue,
                    'apexClass' : disposition.Azione__c,
                });
                  console.log("Debug 30-09 :" + dispositionEvent);  
                dispositionEvent.fire();
            	}
               spinner.decreaseCounter();
            }
            
        }
        
        
        
    },
    
    handleSelezionaDisposition: function (component, event, helper) {
        var dispositionSelezionato = component.find("risultatoChiamata").get("v.value");
        component.set("v.dispositionSelezionato", dispositionSelezionato);
        console.log("*** dispositionSelezionato :: " + dispositionSelezionato);
    },
    
})