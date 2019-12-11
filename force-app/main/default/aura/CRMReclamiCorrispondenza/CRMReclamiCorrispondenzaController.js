({
	 init : function(cmp, event, helper) {
        
        var action = cmp.get("c.getEmails");
        action.setParam('recordId',cmp.get('v.recordId'));
        action.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){
                
                JSON.stringify(console.log(resp.getReturnValue()));
                //cmp.set('v.feedTimeStamp',resp.getReturnValue()[0]);
               // console.log('feed = ' + cmp.get('v.feedTimeStamp'));
                console.log('email recuperato?');
                
                cmp.set('v.emailList',resp.getReturnValue());
            }
			else
                console.log('call back fail ');
        });
        $A.enqueueAction(action);
     }
})