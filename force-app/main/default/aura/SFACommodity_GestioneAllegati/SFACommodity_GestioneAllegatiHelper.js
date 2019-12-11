({
    doinit : function(component, event){
         console.log('-------------------------------------------------------');
         console.log('-- Controller JS: COM_CheckFilialeSFA_GestioneAllegatiHelper - Method: doinit');         
 
 /*
        var uploadedFiles = event.getParam("files");
         var documentId = uploadedFiles[0].documentId;
         var fileName = uploadedFiles[0].name;
         
         var action = component.get("c.finishUploadFile");
         action.setParams({ 
 //            recordId : component.get("v.recordId"),
 //            recordId : component.get("v.selectedDiniego.Caseid__c"),
             recordId : "5005E000005Vd3yQAC",
             documentId: documentId,
             nameFile : fileName
         });
         
         action.setCallback(this, function(resp) {
             if(resp.getState()=='SUCCESS'){
                 component.set("v.elencoFile",resp.getReturnValue());
                 component.set("v.refresh", false);
                 component.set("v.refresh", true);
 //                $A.get("e.force:refreshView").fire();
             }
         });
         $A.enqueueAction(action);
 */
     },
 
 
     handleUploadFinished : function(component, event){
         console.log('-------------------------------------------------------');
         console.log('-- Controller JS: COM_CheckFilialeSFA_GestioneAllegatiHelper - Method: handleUploadFinished');         
 
         var uploadedFiles = event.getParam("files");
         var documentId = uploadedFiles[0].documentId;
         var fileName = uploadedFiles[0].name;
         
         var action = component.get("c.finishUploadFile");
         action.setParams({ 
 //            recordId : component.get("v.recordId"),
 //            recordId : component.get("v.selectedDiniego.Caseid__c"),
             recordId : "5005E000005Vd3yQAC",
             documentId: documentId,
             nameFile : fileName
         });
         
         action.setCallback(this, function(resp) {
             if(resp.getState()=='SUCCESS'){
 //                component.set("v.elencoFile",resp.getReturnValue());
 //                component.set("v.refresh", false);
 //                component.set("v.refresh", true);
 //                $A.get("e.force:refreshView").fire();
             }
         });
         $A.enqueueAction(action);
     }
 })