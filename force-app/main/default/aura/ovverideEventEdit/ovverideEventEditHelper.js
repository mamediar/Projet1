({
	getFiliale: function(component){
        var detailEvent= component.get("v.eventRecord.Desk__r.Branch__c");
        var action = component.get('c.getAccountById');
        var result;
        console.log('DP getFiliale');
        
        action.setParams({"idAccount":detailEvent}); 
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                result = response.getReturnValue();
                console.log('DP filiale : '+ JSON.stringify(result));
                if (!result.erreur) {
                    component.set("v.filialeEvent", result.account);
                } else {
                    console.log('message', "Error");
                }
            }
        });
        $A.enqueueAction(action); 
    },
    
    getValuesProduct : function (component){
        var result;
        var detailEvent =component.get("v.eventRecord.Product__c");
        console.log('DP Product__c : '+detailEvent);
        var action = component.get('c.getProduct'); 
        
        action.setParams({"IdProdotto":detailEvent}); 
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                result = response.getReturnValue();
                console.log('DP result : ', +JSON.stringify(result));

                if (result.erreur===false) {
                    component.set('v.DataglioProductValues',result.product);
                    console.log('DP result getValuesProduct: ', component.get('v.DataglioProductValues'));
                } else {
                	console.log('error to check product'); 
                }
            }
            else{
            	console.log(response.getError());
            }
        });
        $A.enqueueAction(action); 
    },
    setIconAndNameTab: function(cmp,event,helper){
        var workspaceAPI = cmp.find("workspace");
        workspaceAPI.isConsoleNavigation().then(function(response) {
            workspaceAPI.getFocusedTabInfo().then(function(response) {
                var focusedTabId = response.tabId;
                //Cambio Label
                workspaceAPI.setTabLabel({
                    tabId: focusedTabId,
                    label: "Modifica Appuntamento"
                });
                //Cambio icona
                workspaceAPI.setTabIcon({
                    tabId: focusedTabId,
                    icon: "action:edit",
                    iconAlt: "Modifica Appuntamento"
                });
                
  
            })
            .catch(function(error) {
                console.log(error);
            });
            
        })
        .catch(function(error) {
            console.log(error);
        });
    }
})