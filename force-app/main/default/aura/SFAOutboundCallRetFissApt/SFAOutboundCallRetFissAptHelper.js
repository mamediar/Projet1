({
	helperInit : function(cmp) {
		var action = cmp.get("c.doInit");
        action.setParams({"taskId" : cmp.get("v.recordId")});
        action.setCallback(this, function(response)
                           {
                               if(response.getState() == 'SUCCESS' ) 
                               {
                                   var res = response.getReturnValue();
                                   cmp.set("v.currentTask",res.currentTask);
                                   cmp.set("v.parentCase",res.caseOfTask);
                                   cmp.set("v.seeComponent",true);  
                               }
                           });
        $A.enqueueAction(action);
	},
    helperEvent : function(cmp) {
        var appointment = evt.getParam('appuntamento');
        var action = cmp.get("c.esitaTask");
        action.setParams({"taskId" : cmp.get("v.recordId"),
                          "app"	: appointment
                         });
        action.setCallback(this, function(response)
                           {
                               if(response.getState() == 'SUCCESS' ) 
                               {
                                   $A.get('e.force:refreshView').fire()
                               }
                           });
      	$A.enqueueAction(action);  
    }
})