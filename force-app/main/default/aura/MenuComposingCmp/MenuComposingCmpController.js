({
	doInit : function(cmp) {
		var itemMenu = cmp.get('v.menuItem');
        var viewName = cmp.get('v.viewName');
        console.log('itemMenu:'+itemMenu);
        console.log('viewName:'+viewName);
        var action = cmp.get('c.loadMenuItems');

        action.setParams({
            "menuItem": itemMenu,
            "viewName" : viewName
        });
        
        action.setCallback(this, function(response) {
            if ( response.getState() == 'SUCCESS' ){   
                cmp.set('v.itemList', response.getReturnValue());
            }
        });
        
        $A.enqueueAction(action);
	},
    
    doClick : function(cmp, event, helper){
        var cmpParam = event.getSource().get("v.value");
        
        var evt = cmp.getEvent("openFlow");   
		evt.setParam("cmpName", cmpParam);
        evt.fire();
        
        
    }
})