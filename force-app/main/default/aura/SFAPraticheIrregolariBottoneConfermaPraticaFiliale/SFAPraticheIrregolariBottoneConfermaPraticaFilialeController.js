({
    init: function(component, event, helper) {
        var praticaId = component.get("v.recordId");
        var action = component.get("c.visualizzaBottone");      
        action.setParams({
        praticaId: praticaId
        }); 
        action.setCallback(this, function(response){
            if (response.getState() == 'SUCCESS'){
                var datiPratica = response.getReturnValue();
                var disabilita = !(datiPratica.visualizza);
                component.set("v.isVisualizeButton", datiPratica.visualizza); 
                component.set("v.isNotaFilialeInserita", datiPratica.isNotaFilialeInserita);
                component.set("v.disableButton", disabilita);  
            }
        });
        $A.enqueueAction(action);
		},


  changeStatus: function (component, event, helper) {
          var isNotaFilialeInserita = component.get("v.isNotaFilialeInserita"); 
      	  if (isNotaFilialeInserita == false) {
              helper.showToastWarning(component, event, "Per procedere è necessario inserire una nota.");
          }
      	  else {
              var praticaId = component.get("v.recordId");
              var evento = event.getSource();                        
              var action = component.get("c.praticaGestitaFiliale"); 
              action.setParams({
                  praticaId: praticaId
              });       
              action.setCallback(this, function(response){
                  if (response.getState() == 'SUCCESS'){  
                      component.set("v.disableButton", true);  
                      $A.get("e.force:refreshView").fire();                    
                      var toastEvent = $A.get("e.force:showToast");                     
                      toastEvent.setParams({  
                          "type":"success",
                          "message": "La pratica è stata confermata per GDV!"  
                      });  
                      toastEvent.fire();   
                      console.log('response.getState()' + response.getState());
                  } else {
                      var toastEvent = $A.get("e.force:showToast");                     
                      toastEvent.setParams({  
                          "type":"error",
                          "message": "La procedura di conferma pratica per GDV e relativo invio mail non sono andati a buon fine."  
                      });  
                      toastEvent.fire();                            
                  }
              });
              $A.enqueueAction(action);
  		  }
  }
    

	
})