({
    init: function(component, event, helper) {
        var praticaId = component.get("v.recordId");  
        var action = component.get("c.recuperaDataPosticipoRichiestaDaFiliale");   
        action.setParams({
        praticaId: praticaId
        }); 
        action.setCallback(this, function(response){
            if (response.getState() == 'SUCCESS'){
                var dataPosticipo = response.getReturnValue();
                component.set("v.dataPosticipoDaFiliale", dataPosticipo);   
            }
        });
        $A.enqueueAction(action);
	},



    
	inviaDataPosticipo : function(component, event, helper) {
         var praticaId = component.get("v.recordId");
        
         var dataPosticipoDaSalvare = component.get("v.dataPosticipoDaSalvare");
         var dataPosticipoDaSalvareDate = new Date(new Date(dataPosticipoDaSalvare).toDateString());
         var dataPosticipoDaSalvareString = new Date(dataPosticipoDaSalvareDate.getTime() - (dataPosticipoDaSalvareDate.getTimezoneOffset() * 60000)).toJSON();
                 
         var evento = event.getSource();                 
         var action = component.get("c.salvaDataPosticipo");

         action.setParams({
             praticaId: praticaId, dataPosticipoDaSalvareString: dataPosticipoDaSalvareString
         });      
        action.setCallback(this, function(response){
            console.log('*** response:' + JSON.stringify(response));
            if (response.getState() == 'SUCCESS'){
                if (evento){
                    var testoConferma='La data posticipo richiesta è stata salvata.';
                    component.set("v.myText",testoConferma);    
                }                
            }
        });
		 $A.enqueueAction(action);         
     }        
		
	
})