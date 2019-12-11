({   
    
    init: function(component, event, helper) {   

        var praticaId = component.get("v.recordId");
		var action = component.get("c.getFlags");
        action.setParams({
          praticaId: praticaId
        });                            
        action.setCallback(this, function(response){
            if (response.getState() == 'SUCCESS'){
                var flags = response.getReturnValue();             
                if (flags) {
                    component.set("v.flagTargaTelaioDiversi", flags.flagTargaTelaioDiversi);
                    component.set("v.flagModuloInterazioneVeicoliMI", flags.flagModuloInterazioneVeicoliMI);
                    component.set("v.flagImportante", flags.flagImportante);
                    component.set("v.flagSospensioneAttivitaTemporaneaGDV", flags.flagSospensioneAttivitaTemporaneaGDV);
                }   
            }
        });
         $A.enqueueAction(action);
                                      
    },
    
	onFlagImp: function(component, event, helper) {
         var checkedCheckboxImp = event.getSource().get('v.value');    
         var praticaId = component.get("v.recordId");
         if(checkedCheckboxImp){             
             var action = component.get("c.checkFlagImportante");
             action.setParams({
                praticaId: praticaId
             });                  
         } else{
             var action = component.get("c.uncheckFlagImportante");
             action.setParams({
                praticaId: praticaId
             });                    
        }
        $A.enqueueAction(action);
             
     },        
 
	onFlagSosp: function(component, event, helper) {
         var checkedCheckboxSosp = event.getSource().get('v.value');    
         var praticaId = component.get("v.recordId");
         if(checkedCheckboxSosp){             
             var action = component.get("c.checkFlagSosp");
             action.setParams({
                praticaId: praticaId
             });                  
         } else{
             var action = component.get("c.uncheckFlagSosp");
             action.setParams({
                praticaId: praticaId
             });                    
        }
        $A.enqueueAction(action);    
    }         
})