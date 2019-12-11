({
  
    init: function(component, event, helper) {
        var spinner = component.find('spinnerComponent');
        spinner.incrementCounter();     
        console.log('v.recordId : '+component.get('v.recordId'));
        console.log('v.filterOnTitle : '+component.get('v.filterOnTitle'));
        console.log('v.filterOnDate : '+component.get('v.filterOnDate'));
        console.log('v.noFilter : '+component.get('v.noFilter'));
        console.log('v.filterNotesTitle : '+component.get('v.filterNotesTitle'));
        console.log('v.filterStartDate : '+component.get('v.filterStartDate'));
        console.log('v.filterEndDate : '+component.get('v.filterEndDate'));        
        var vAction = component.get("c.getAllNotes");
        vAction.setParams(
        {
            recordId : component.get('v.recordId'),
            filterOnTitle: component.get('v.filterOnTitle'),
            filterOnDate: component.get('v.filterOnDate'),
            noFilter: component.get('v.noFilter'),
            titleFilter: component.get('v.filterNotesTitle'),
            startDateFilter: component.get('v.filterStartDate'),
            endDateFilter: component.get('v.filterEndDate')  
        });
        vAction.setCallback(this, function(pResponse) {
            var vState = pResponse.getState();
            if (vState === "SUCCESS") { 
                component.set('v.notes', pResponse.getReturnValue());
            }
            spinner.decreaseCounter();
        });
        $A.enqueueAction(vAction);     
    },

  
  inserisciNota: function (component, event, helper) {
          var spinner = component.find('spinnerComponent');
          spinner.incrementCounter();      
          var Vaction = component.get("c.insertNote");   
          Vaction.setParams(
              {            
                  body: component.get('v.bodyNote'),
                  recordId : component.get('v.recordId'),
                  title : component.get('v.noteTitle')
                  
              });
          Vaction.setCallback(this,function(Vresponse){  
              var state = Vresponse.getState();  
              if(state=='SUCCESS'){                       
                  var notes=Vresponse.getReturnValue();
                  component.set('v.notes', notes);   
                  component.set('v.bodyNote', "");    
              } else {
                  var toastEvent = $A.get("e.force:showToast");  
                  toastEvent.setParams({  
                      "title": "Unsuccess!",  
                      "type": "error",
                      "message": "Errore nell'inserimento della nota."  
                  });  
                  toastEvent.fire();                   
              }
              spinner.decreaseCounter();
          });  
          $A.enqueueAction(Vaction);              
  }
})