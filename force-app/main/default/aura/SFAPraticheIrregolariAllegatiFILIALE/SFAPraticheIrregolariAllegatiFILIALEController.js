({  
   doInit:function(component,event,helper){ 
       console.log('disabilita1:: ');
     var action = component.get("c.getFiles");  
     action.setParams({  
       "recordId":component.get("v.recordId")  
     });      
     action.setCallback(this,function(response){  
       var state = response.getState();  
       if(state=='SUCCESS'){  
         var files=response.getReturnValue();
         component.set('v.filesNuovi', files.nuovi);
         component.set('v.filesVecchi', files.vecchi);
       }  
     });  
     $A.enqueueAction(action);  
       
     var action = component.get("c.disabilitaBottoneElimina");   
     action.setParams({
         recordId: component.get("v.recordId")
     }); 
     action.setCallback(this, function(response){
         if (response.getState() == 'SUCCESS'){
             var disabilita = response.getReturnValue();
             component.set("v.disableButtonElimina", disabilita);   
         }
     });
     $A.enqueueAction(action);      
       
     var action = component.get("c.verificaSeFileCaricabile");      
     action.setParams({
         recordId: component.get("v.recordId")
     }); 
     action.setCallback(this, function(response){
         if (response.getState() == 'SUCCESS'){
             var disabilita = response.getReturnValue();
             console.log('disabilita:: '+disabilita);
             component.set("v.disableButtonCarica", disabilita);   
         }
     });
     $A.enqueueAction(action);     
       
       
       
       
   } ,  
   //Open File onclick event  
   OpenFile :function(component,event,helper){  
     var rec_id = event.currentTarget.id;  
     $A.get('e.lightning:openFiles').fire({ //Lightning Openfiles event    
       recordIds: [rec_id] //file id  
     });  
   },  
    
    
   UploadFinished : function(component, event, helper) {  
     var uploadedFiles = event.getParam("files");  
     var documentId = uploadedFiles[0].documentId;  
     var fileName = uploadedFiles[0].name;  
     helper.UpdateDocument(component,event,documentId);  
      $A.get("e.force:refreshView").fire();
   },    
    
    

    
    eliminaFile: function(component, event, helper) {
        var documentId = event.getSource().get("v.value");
        var recordId = component.get("v.recordId");
        
        var action = component.get("c.disabilitaBottoneElimina");   
        action.setParams({
            recordId: component.get("v.recordId")
        }); 
        action.setCallback(this, function(response){
            if (response.getState() == 'SUCCESS'){
                var disabilita = response.getReturnValue();
                component.set("v.disableButtonElimina", disabilita);
                if (!disabilita){                     
                    console.log('è entrato qui riga 127');
                    var Action = component.get("c.eliminaFilePassato");
                    Action.setParams(
                        {
                            documentId : documentId,
                            recordId : component.get("v.recordId")  
                        });
                    Action.setCallback(this, function(pResponse) {
                        var vState = pResponse.getState();
                        if (vState === "SUCCESS") {                      
                            console.log("il file è stato eliminato riga 143");
                            var files=pResponse.getReturnValue();
                            component.set('v.filesNuovi', files.nuovi);
                            component.set('v.filesVecchi', files.vecchi);
                        } else {
                            var vErrors = pResponse.getError();
                            if (vErrors) {
                                if (vErrors[0] && vErrors[0].message) {
                                    console.log("Error message riga 152: " + vErrors[0].message);
                                }
                            } else {
                                console.log("Unknown error");
                            }
                        }                
                    });
                    $A.enqueueAction(Action);          

                    
                    
                }

            }
        });
        $A.enqueueAction(action); 

   
    }

     
 })