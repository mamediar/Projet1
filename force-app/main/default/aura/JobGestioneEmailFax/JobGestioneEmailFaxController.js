({
    lanciaJobs : function(cmp, event, helper) {
        var action = cmp.get("c.lanciaJobsApex");
        action.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){                    
                helper.toastSchedulazioniAvviate();
            } 
            else
                helper.toastSchedulazioniNonAvviate();
        });
        $A.enqueueAction(action); 
    },
        
    lanciaAlgoritmo : function(cmp, event, helper) {
        var action = cmp.get("c.lanciaAlgoritmoApex");
        action.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){                    
                helper.toastAlgoritmoLanciato();
            }            
            else
                helper.toastAlgoritmoNonLanciato();
        });
        $A.enqueueAction(action); 
    }
})