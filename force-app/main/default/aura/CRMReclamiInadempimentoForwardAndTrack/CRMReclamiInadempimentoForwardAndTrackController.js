({
	init : function(component, event, helper) {
        helper.getData(component);    
        //helper.loadFiles(component);
        helper.getToken(component);
	},
    
    inviaRisposta : function(component,event,helper){
      var action = component.get("c.updateCount");
      action.setParams({
        recordId: component.get('v.objectId'),
        messaggio: component.get('v.messaggio'),
        allegati: component.get('v.staticFileList'),
        firma: component.get('v.firmaDigitale'),
          token: component.get('v.token')
      });
        //action.setParam('recordId', component.get('v.objectId'));
        //action.setParam('messaggio', component.get('v.messaggio'));
        action.setCallback(this,function(response){
            if(response.getState() == 'SUCCESS'){
                console.log('Invio risposta avvenuto correttamente');
               component.set("v.isCompleted", true);
            }
            else{
                console.log('risposta non andata a buon fine: ' + response.getState() );
            }
            component.set("v.spinner", false);
        });
       component.set("v.spinner", true);
      $A.enqueueAction(action);
    },
    
    handleUploadFinished: function (cmp, event) {
        // Get the list of uploaded files
        var uploadedFiles = event.getParam("files");
        alert("Files uploaded : " + uploadedFiles.length);
    },
    
    OpenFile :function(component,event,helper){  
   
     var rec_id = event.currentTarget.id;  
     console.log('REC ID = ' + rec_id);
     $A.get('e.lightning:openFiles').fire({ //Lightning Openfiles event    
       recordIds: [rec_id] //file id  
     });  
   }
})