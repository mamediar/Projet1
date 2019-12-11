({
    init: function(component, event, helper) {
        var praticaId = component.get("v.recordId");
        var action = component.get("c.disabilitaBottone");     
        action.setParams({
        praticaId: praticaId
        }); 
        action.setCallback(this, function(response){
            if (response.getState() == 'SUCCESS'){
                var disabilita = response.getReturnValue();
                component.set("v.disableButton", disabilita);   
            }
        });
        $A.enqueueAction(action);
	},



    
	inviaDataPosticipo : function(component, event, helper) {
         var praticaId = component.get("v.recordId");
        
         var dataPosticipoRichiesta = component.get("v.dataPosticipo");
         var dataPosticipoRichiestaDate = new Date(new Date(dataPosticipoRichiesta).toDateString());
         var dataPosticipoRichiestaString = new Date(dataPosticipoRichiestaDate.getTime() - (dataPosticipoRichiestaDate.getTimezoneOffset() * 60000)).toJSON();
                 
         var evento = event.getSource();                        
         var action = component.get("c.salvaDataPosticipoRichiestaFiliale");

         action.setParams({
             praticaId: praticaId, dataPosticipoRichiestaString: dataPosticipoRichiestaString
         });        
        action.setCallback(this, function(response){
            console.log('*** response:' + JSON.stringify(response));
            if (response.getState() == 'SUCCESS'){
                if (evento){                  
                    var testoConferma=response.getReturnValue();
                    component.set("v.myText",testoConferma);  
                    console.log(testoConferma);
                    if(testoConferma=='Non è più possibile richiedere una data di posticipo.'){
                    	component.set("v.disableButton", true);
                        component.set("v.dataPosticipo","");
                    	$A.get("e.force:refreshView").fire();   
                    }
                    
                }                
            } else {
                    var toastEvent = $A.get("e.force:showToast");                     
                    toastEvent.setParams({  
                        "type": "error",
                        "message": "La procedura di richiesta di data posticipo per GDV non è stata correttamente inoltrata."  
                    });                 
            }
        });
		 $A.enqueueAction(action);         
     }        
		
	
})