({
    init : function(cmp, event, helper) {
      
        var action = cmp.get("c.getFeedItem");
        action.setParam('recordId',cmp.get('v.ident'));
        action.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){
                cmp.set('v.feedData',resp.getReturnValue());
            }
			
                
        });
        $A.enqueueAction(action);
    }    
    
})