({
    doInit : function(component, event, helper) {
        var caseId = component.get('v.recordId');
        
        var action = component.get("c.getEsiti");
        action.setParams({
            "caseId": caseId
        });
        action.setCallback(this, function(response) {
            if ( response.getState() == 'SUCCESS' ) {
                console.log(response.getReturnValue());
                component.set('v.listaEsiti', response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    
    handleClick : function (cmp, event, helper) {
        var esitoEvent = $A.get("e.c:EsitoReady");
        
        if(cmp.get('v.saveCase')){
            var esito=cmp.get('v.esitoSelezionato');
            var action=cmp.get('c.handleCase');
            
            action.setParam('esito',esito);
            action.setParam('recordId',cmp.get('v.recordId'));
            action.setCallback(this,function(response){
                if(response.getState()=='SUCCESS'){
                    if (esitoEvent) {
                        esitoEvent.setParams({
                            'esito':cmp.get('v.esitoSelezionato'),
                            'note':cmp.get('v.noteValue')
                        });
                        esitoEvent.fire();
                    }
                    
                    cmp.find('notifLib').showToast({
                        'variant':'success',
                        "title": "Successo",
                        "message": "Caso esitato con successo."
                    });
                    $A.get('e.force:refreshView').fire();
                }
            });
            $A.enqueueAction(action);
        }
        else{
            if (esitoEvent) {
                esitoEvent.setParams({
                    'esito' : cmp.get('v.esitoSelezionato'),
                    'note' : cmp.get('v.noteValue')
                });
                esitoEvent.fire();
            }
        }
    }
})