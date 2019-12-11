({
    MAX_FILE_SIZE: 750000, 
    
    doInit: function(component, event){
        var action = component.get("c.createRecordForUploadFile");
        action.setCallback(this, function(resp) {
            if(resp.getState()=='SUCCESS'){
                component.set("v.recordId",resp.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    
    handleUploadFinished : function(component, event){
        
         var uploadedFiles = event.getParam("files");
        var documentId = uploadedFiles[0].documentId;
        var fileName = uploadedFiles[0].name;
        
        var action = component.get("c.finishUploadFile");
         action.setParams({ 
            recordId : component.get("v.recordId"),
             documentId: documentId
         });

        action.setCallback(this, function(resp) {
            if(resp.getState()=='SUCCESS'){
                component.set("v.recordId",resp.getReturnValue());
            }
        });
        $A.enqueueAction(action);
        
       
       
    },
    
    save : function(component,event) {
        
        var file = component.find("file-input").get("v.files")[0];
        
        
        
        //var fr = new FileReader();
        
        this.upload(component, file);
        
        var fr = new FileReader();
        
        var self = this;
        fr.onload = function() {
            var fileContents = fr.result;
            var base64Mark = 'base64,';
            var dataStart = fileContents.indexOf(base64Mark) + base64Mark.length;
            
            fileContents = fileContents.substring(dataStart);
            
            self.upload(component, file, fileContents);
        };
        
        fr.readAsDataURL(file);
        
    },
    
    upload: function(component, file,fileContents) {
        var action = component.get("c.uploadFile");
        
        action.setParams({
            
            fileName: file.name,
            base64Data: encodeURIComponent(fileContents), 
            contentType: file.type
        });
        
        action.setCallback(this, function(resp) {
            
            
            if(resp.getState()=='SUCCESS'){
                var responseWrapper= JSON.parse(resp.getReturnValue());
                
                
                
                if(responseWrapper.length==0){
                    this.showToast("Errore: nessuna corrispondenza trovata",'error');
                }	
                if(resp.getReturnValue()===true){
                    this.showToast("Upload avvenuto con successo",'info');
                }else{
                    this.showToast("errore nell'upload del file excel",'error');
                }
                
            }
            var spinner = component.find("closedSinistriSpinner");
            $A.util.removeClass(spinner, "slds-show");
            $A.util.addClass(spinner, "slds-hide" );
        });
        
        $A.enqueueAction(action);
    },
    
    show: function (cmp, event) {
        var spinner = cmp.find("closedSinistriSpinner");
        $A.util.removeClass(spinner, "slds-hide");
        $A.util.addClass(spinner, "slds-show");
    },
    hide:function (cmp, event) {
        var spinner = cmp.find("closedSinistriSpinner");
        $A.util.removeClass(spinner, "slds-show");
        $A.util.addClass(spinner, "slds-hide");
    },
    
    showToast : function(message, type){
        var toastEvent = $A.get("e.force:showToast");
        console.log(' message, type '+message+ ' - '+type);
        toastEvent.setParams({
            message: message,
            type : type
        });
        toastEvent.fire();
    }
    
    
})