({
	doInit : function(component, event, helper) {
		helper.addLoadingCounter(component);
        var action = component.get("c.doInitApex");
        action.setParams({ configurationName : component.get("v.configurationName") });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                helper.addTab(component, event, helper,response.getReturnValue());
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                        helper.showToast("Error message: " + 
                                 errors[0].message,'error');
                    }
                } else {
                    //console.log("Unknown error");
                    helper.showToast(error,'error');
                }
            }
            helper.decreaseLoadingCounter(component);
        });
        $A.enqueueAction(action);
	},
    addTab: function(component, event, helper, tabList) {
        var cmqRequest =[];
        tabList.forEach(function(element,i){
            cmqRequest.push(
            ["lightning:tab",{
                "class": 'c:'+element.DeveloperName.replace(/[_]+\d+$/,''),
                "id":i,
                "onactive": component.getReference("c.initTab")
            }],
                ["aura:text",{"value":element.MasterLabel}]);
        });
        
        helper.addLoadingCounter(component);
        $A.createComponents(
            cmqRequest
            , function (components, status, error) {
                helper.decreaseLoadingCounter(component);
                if (status === "SUCCESS") {
                    var newTabList = [];
                    for (var i = 0; i < components.length; i=i+2){
                        var newTab = components[i];
                    	newTab.set('v.label',components[i+1])
                        newTabList.push(newTab);
                    }
                    
                    component.set("v.moretabs", newTabList);
                } else {
                    //throw new Error(error);
                    helper.showToast(error,'error');
                }
            });
        

    },
    /*
    addTab: function(component, event, helper, tabList) {
        var detail = component.get("v.moretabs");
        var newlst =[];
        newlst.push(detail);
        tabList.forEach(function(element,i){
            helper.addLoadingCounter(component);
            $A.createComponents(
                
                [
                    ["lightning:tab",{
                        "class": 'c:'+element.DeveloperName,
                        "id":i,
                        "onactive": component.getReference("c.initTab")
                    }],
                    ["aura:text",{"value":element.MasterLabel}]
                ], function (components, status, error) {
                    helper.decreaseLoadingCounter(component);
                    if (status === "SUCCESS") {
                        var newTab = components[0];
                        newTab.set('v.label',components[1])
                        newlst.push(newTab);
                        component.set("v.moretabs", newlst);
                    } else {
                        //throw new Error(error);
                        helper.showToast(error,'error');
                    }
                });
        });

    },*/
    initTab : function(component, event, helper) {
        var tab = event.getSource();
        var componentName = tab.get('v.class');
        
        if(componentName && !componentName.includes("disabled")){
            tab.set('v.class','');
            helper.addLoadingCounter(component);
            $A.createComponent(componentName, 
                               {tabName : tab.get("v.label")[0].get('v.value'),branchSel:component.getReference("v.branchSel")},
                               function (newContent, status, error) {
                                   helper.decreaseLoadingCounter(component);
                                   if (status === "SUCCESS") {
                                       
                                       tab.set('v.body', newContent);
                                       
                                   } else {
                                       //throw new Error(error);
                                       helper.showToast(error,'error');
                                   }
                               });
        }
        if(componentName && componentName.includes("disabled")){
            helper.showToast('Tab non disponibile','error');
        }
            
  
    },
    addLoadingCounter : function(component) {
        component.set("v.loadingCounter",component.get("v.loadingCounter")+1);
    },
	decreaseLoadingCounter : function(component) {
        component.set("v.loadingCounter",component.get("v.loadingCounter")-1);
    },
    showToast : function(message,type){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            message: message,
            type: type
        });
        toastEvent.fire();
    },
})