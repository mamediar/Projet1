({
    hideButton : function(cmp, event, helper) {
        
        var workspaceAPI = cmp.find("workspace");
    workspaceAPI.getFocusedTabInfo().then(function(response) {
        var focusedTabId = response.tabId;
        workspaceAPI.setTabLabel({
            tabId: focusedTabId,
            label: "Post Vendita" }); })
        
        
    },

    redirect : function(cmp,event,helper){
        let nav = cmp.find("navService");
        let pageReference = {    
            "type": "standard__recordPage",
            "attributes": {
                "recordId": cmp.get('v.caseId'),
                "objectApiName": "Case",
                "actionName": "view"
            }
        };
        nav.navigate(pageReference);
		var workspaceAPI = cmp.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.closeTab({tabId: focusedTabId});
        })
        .catch(function(error) {
            console.log(error);
        });    
        
    }
})