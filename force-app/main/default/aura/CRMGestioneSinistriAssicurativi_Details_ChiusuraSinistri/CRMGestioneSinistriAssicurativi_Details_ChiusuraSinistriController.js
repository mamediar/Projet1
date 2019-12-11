({
    doInit : function(component, event, helper)    {
        helper.doInit(component, event);
    },
    
     onFileUploaded:function(component,event,helper){
       
        helper.show(component,event);
       
      helper.save(component,event);
         
    },
    
      handleUploadFinished: function (component, event, helper) {
		helper.handleUploadFinished(component, event);
        
    }

})