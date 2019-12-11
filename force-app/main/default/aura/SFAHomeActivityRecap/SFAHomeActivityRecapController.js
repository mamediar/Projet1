({
	doInit : function(component, event, helper) {
		helper.doInit(component, event, helper);
	},
    gotoList : function(component, event, helper) {
		helper.gotoList(component, event, helper);
	},
    refresh : function(component, event, helper) {
		helper.doInit(component, event, helper);
	},
    showMore : function(component, event, helper) {
		component.set('v.ActivityList',component.get('v.ActivityComplete'));
        component.set('v.showMore',true);
	},
    showLess : function(component, event, helper) {
		component.set('v.ActivityList',component.get('v.ActivityReduced'));
        component.set('v.showMore',false);
	}
    
})