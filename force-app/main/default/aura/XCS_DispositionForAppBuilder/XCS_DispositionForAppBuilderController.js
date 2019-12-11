({
    doInit : function(component, event, helper) {    
        helper.InitHelper(component);
    },
    
    handleClickConfirm : function (cmp, event, helper) {
		helper.handleClickConfirm(cmp, event, helper)
    },
    
    handleSelezionaDisposition: function (component, event, helper) {  
      console.log(component.get("v.observedAttribute"));
		  helper.handleSelezionaDisposition(component, event, helper);
    },

    refreshHandler:function(component,event,helper){
      helper.refreshHandler(component,event,helper);
    }
    
})