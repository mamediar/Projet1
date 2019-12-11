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
                    component.set("v.setFlags", flags.setFlags); 
                    component.set("v.disabilitaFlags", flags.disabilitaFlags);
                    console.log('flags.disabilitaFlags'+flags.disabilitaFlags);
                }   
            }
        });
         $A.enqueueAction(action);
                                      
    },
    
	onFlagTargaTelaio: function(component, event, helper) {
         var checkedCheckboxTargaTelaio = event.getSource().get('v.value');    
         var praticaId = component.get("v.recordId");
         if(checkedCheckboxTargaTelaio){             
             var action = component.get("c.checkFlagTargaTelaio");
             action.setParams({
                praticaId: praticaId
             });                  
         } else{
             var action = component.get("c.uncheckFlagTargaTelaio");
             action.setParams({
                praticaId: praticaId
             });                    
        }
        $A.enqueueAction(action);
             
     },        
 
	onFlagModuloInterazione: function(component, event, helper) {
         var checkedCheckboxModInterazione = event.getSource().get('v.value');    
         var praticaId = component.get("v.recordId");
         if(checkedCheckboxModInterazione){             
             var action = component.get("c.checkFlagModuloInterazione");
             action.setParams({
                praticaId: praticaId
             });                  
         } else{
             var action = component.get("c.uncheckFlagModuloInterazione");
             action.setParams({
                praticaId: praticaId
             });                    
        }
        $A.enqueueAction(action);    
    }         
})