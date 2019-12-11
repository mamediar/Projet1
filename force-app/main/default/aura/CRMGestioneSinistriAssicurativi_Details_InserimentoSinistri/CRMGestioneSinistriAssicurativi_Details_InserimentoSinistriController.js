({

    recuperaAnagrafica : function(component, event, helper) {
  	  helper.recuperaAnagrafica(component, event); 
    },
    
    selectedPratica : function(component, event, helper) {
        var index = event.target.value;
        var lista = component.get("v.elencoPratiche");
        
        var pratica = lista[index];
        var dataInizio = new Date();
        
        component.set("v.pratica", lista[index]);    
        
    },
    
    inserisci : function(component, event, helper){
        helper.inserisci(component, event);
    }
})