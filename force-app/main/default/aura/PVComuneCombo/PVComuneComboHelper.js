({
    loadComuni : function (cmp,event,helper) {
        
//        console.log("INIT2 comuni: " + cmp.get("v.provinciaSelection"));
        var action = cmp.get('c.loadComuniApex');
        action.setParam('provincia',cmp.get("v.provinciaSelection"));
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                cmp.set('v.comuniList', response.getReturnValue());
//                console.log('v.comuniList' + JSON.stringify(cmp.get("v.comuniList")));
            }
        });
        $A.enqueueAction(action);
        
    },
    
})