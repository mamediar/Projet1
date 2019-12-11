({
	initHelper:function(cmp){
		var action=cmp.get('c.getAttribuz');
        action.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){
                cmp.set('v.options',resp.getReturnValue());
            }
        });
        $A.enqueueAction(action);
	}
})