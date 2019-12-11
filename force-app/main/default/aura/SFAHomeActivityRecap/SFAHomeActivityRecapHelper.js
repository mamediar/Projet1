({
    doInit : function(component, event, helper) {
        helper.addLoadingCounter(component, event, helper);
        var action = component.get("c.doInitApex");
        action.setParams({ configurationName : component.get("v.configurationName") });
        action.setCallback(this, function(response){
            helper.decreaseLoadingCounter(component, event, helper);
            var state = response.getState();
            if (state === "SUCCESS") {
                var title = response.getReturnValue().title;
                var total = response.getReturnValue().total;
                var activityList = response.getReturnValue().activityReturnList;
                var rowsNumber = component.get('v.rowsNumber');
                component.set('v.ActivityList',activityList.slice(0, rowsNumber));
                
                component.set('v.ActivityComplete',activityList);
                component.set('v.ActivityReduced',activityList.slice(0, rowsNumber));
                component.set('v.title',title);
                component.set('v.total',total);
            }
        });
        $A.enqueueAction(action);
    },
    gotoList : function (component, event, helper) {
        var listViewId =event.target.id;
        
        var navEvent = $A.get("e.force:navigateToList");
        navEvent.setParams({
            "listViewId": listViewId,
            //"listViewName": null,
            "scope": "Case"
        });
        navEvent.fire();
    },
    addLoadingCounter : function (component, event, helper) {
        component.set("v.loadingCounter",component.get("v.loadingCounter")+1);
    },
    decreaseLoadingCounter : function (component, event, helper) {
        component.set("v.loadingCounter",component.get("v.loadingCounter")-1);
    }
})