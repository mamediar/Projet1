({
    doInit : function(component, event) {
        var recordId = component.get("v.recordId");
        
        if(recordId==null || recordId==undefined || recordId.length <= 0) return;
        
        var action = component.get('c.getFiles');
       
        action.setParams({
            caseId : recordId
                         });
        action.setCallback(this, function(actionResult) {
            var s =  actionResult.getState();
            var x =  actionResult.getReturnValue();
            component.set('v.fileList', actionResult.getReturnValue());
        });
        $A.enqueueAction(action);
    }
    
})