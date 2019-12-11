({
  
    init: function(component, event, helper) {       
        var vAction = component.get("c.getAllNotes");
        var praticaId = component.get('v.recordId');
        vAction.setParams(
        {
            praticaId : praticaId
        });
        vAction.setCallback(this, function(pResponse) {
            var vState = pResponse.getState();
            if (vState === "SUCCESS") { 
                component.set('v.notes', pResponse.getReturnValue());
                console.log(pResponse.getReturnValue());
            } else {
                var vErrors = pResponse.getError();
                if (vErrors) {
                    if (vErrors[0] && vErrors[0].message) {
                        console.log("Error message: " + vErrors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(vAction);
        
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



  
  inserisciNota: function (component, event, helper) {        
          var praticaId=component.get('v.recordId');
          var body=component.get('v.bodyNote');
          var evento = event.getSource();

          var Vaction = component.get("c.insertNote");   
          Vaction.setParams(
              {            
                  body: body,
                  praticaId : praticaId
              });
          Vaction.setCallback(this,function(Vresponse){  
              var state = Vresponse.getState();
              console.log('state ' +state );
              if(state=='SUCCESS'){                       
                  var notes=Vresponse.getReturnValue();
                  component.set('v.notes', notes);   
                  component.set('v.bodyNote', "");
                  window.location.reload(true);
              }
          });  
          $A.enqueueAction(Vaction);        
           
      
  }
})