({
	init: function(cmp, event, helper) {
        helper.initZoneList(cmp, event, helper);
        /*
        var branch = event.getParam("branch");
        // set the handler attributes based on event data
        cmp.set("v.branchFromEvent", branch); 
        console.log('DP branchFromEvent INIT: '+branch);*/
    },

    onChangeBranchSelect: function (cmp, event, helper) {
        helper.onChangeBranchSelect(cmp, event, helper);
    },
    
    handleSave: function(cmp, event, helper){
        helper.handleSave(cmp, event, helper);
    },
    
    deleteZone: function(cmp, event, helper){
        helper.deleteZone(cmp, event, helper);
    },
    
    addZone: function(cmp, event, helper){
        helper.addZone(cmp, event, helper);
    },
    
    saveZone: function (cmp, event, helper) {
        helper.saveZone(cmp, event, helper);
    },
    /*
    handleApplicationEvent : function(cmp, event, helper) {
        var branch = event.getParam("branch");
        // set the handler attributes based on event data
        cmp.set("v.branchFromEvent", branch);
        console.log('DP branchFromEvent: '+branch);
    },*/
    
    handleRowAction: function (cmp, event, helper) {
        helper.handleRowAction(cmp, event, helper);
    },    
})