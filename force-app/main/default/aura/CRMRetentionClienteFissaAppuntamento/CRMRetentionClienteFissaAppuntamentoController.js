({
	init : function(component, event, helper) {
		helper.initHelper(component,event,helper);
	},
    handleChange : function(component, event, helper) {
        helper.helperHandleChange(component,event,helper);
    },
    completaAttivita : function(cmp, event, helper)  {
        console.log("STAMPA :" + cmp.get("v.tassoSelected") + "--" + cmp.get("v.obiezioneSelected"));
    },
    setVisible : function(cmp, event, helper){
        cmp.set("v.isVisibleAppoitmentComponent","true");
    },
    handleComponentEvent : function(cmp, event, helper){
        helper.helperHandleComponentEvent(cmp, event, helper);
	}
})