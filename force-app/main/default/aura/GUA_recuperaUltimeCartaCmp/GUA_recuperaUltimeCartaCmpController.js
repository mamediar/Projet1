({
    init : function(component, event, helper) {
        helper.getAllPratiche(component,event);
    },

    //GET PRATICHE BY FILTER CRITERA
    filterBy : function(component, event, helper) {
        var radioValue = component.get("v.filterValue");
        if(radioValue === "Tutti"){
            helper.getAllPratiche(component,event);
        }else{
            helper.doFilter(component,event);
        }
    }

})