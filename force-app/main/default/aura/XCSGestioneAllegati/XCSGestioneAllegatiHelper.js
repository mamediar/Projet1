({
    showSpinner : function(cmp, event){
        cmp.set("v.showSpinner", cmp.get("v.showSpinner")+1);
    },
    
    hideSpinner : function(cmp, event){
        cmp.set("v.showSpinner", cmp.get("v.showSpinner")-1);
    },
    salvaComeGestita : function(component, event, helper){

        var caseId = component.get('v.recordId');
        

        var action = component.get('c.salvaReclamoComeGestito');

        action.setParams({
            caseId : caseId
        });

        action.setCallback(this,function(response){
            if (response.getState()== 'SUCCESS'){
                var resp = response.getReturnValue();
                if(resp){
                    component.set('v.isGestito',resp);
                }
                

            }else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Errore",
                    "type" : "error",
                    "message": "Non è stato possibile chiudere il reclamo come gestito."
                });
                toastEvent.fire();
            }

        });
        $A.enqueueAction(action);
    }

})