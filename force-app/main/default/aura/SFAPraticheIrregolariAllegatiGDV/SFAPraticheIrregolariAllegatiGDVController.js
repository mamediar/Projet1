({  
   doInit:function(component,event,helper){  
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
		 console.log('Result Returned: ' +files);  
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
     /*var toastEvent = $A.get("e.force:showToast");  
     toastEvent.setParams({  
       "title": "Success!",  
       "message": "File "+fileName+" caricato con successo."  
     });  
     //toastEvent.fire();*/  
   },  
     
    eliminaFile: function(component, event, helper) {
        var documentId = event.getSource().get("v.value");
        var recordId = component.get("v.recordId");
        console.log("è stato cliccato");
        console.log(documentId);
        
        var Action = component.get("c.eliminaFilePassato");
        Action.setParams(
            {
                documentId : documentId,
                recordId : component.get("v.recordId")  
            });
        Action.setCallback(this, function(pResponse) {
            var vState = pResponse.getState();
            if (vState === "SUCCESS") { 
                 /*var toastEvent = $A.get("e.force:showToast");  
                 toastEvent.setParams({  
                   "title": "Success!",  
                   "message": "File eliminato con successo."  
                 });  
                 //toastEvent.fire(); */                
                console.log("il file è stato eliminato");
                var files=pResponse.getReturnValue();
                component.set('v.filesNuovi', files.nuovi);
                component.set('v.filesVecchi', files.vecchi);
                console.log('Result Returned: ' +files);   
                $A.enqueueAction(action);  
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
        $A.enqueueAction(Action);
    }
     
     
 })