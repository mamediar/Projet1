({
    loadComuni : function (cmp,event,helper) {
//        console.log("INIT comuni: " + cmp.get("v.provinciaSelection"));
        helper.loadComuni(cmp,event,helper);
    },
    
    onChangeProvincia : function (cmp,event,helper) {
//        console.log("onChangeProvincia : " + cmp.get("v.provinciaSelection"));
        helper.loadComuni(cmp,event,helper);
    },    
})