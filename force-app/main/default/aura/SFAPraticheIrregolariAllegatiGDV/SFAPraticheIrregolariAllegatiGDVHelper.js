({  
     UpdateDocument : function(component,event,Id) {  
     var action = component.get("c.UpdateFiles");   
     action.setParams({"documentId":Id,                
              "recordId": component.get("v.recordId")  
              });  
     action.setCallback(this,function(response){  
       var state = response.getState();  
       if(state=='SUCCESS'){ 
         var files=response.getReturnValue();
         component.set('v.filesNuovi', files.nuovi);
         component.set('v.filesVecchi', files.vecchi);
		 console.log('Result Returned: ' +files);                        
       }
     });  
     $A.enqueueAction(action);  
   },  
 })