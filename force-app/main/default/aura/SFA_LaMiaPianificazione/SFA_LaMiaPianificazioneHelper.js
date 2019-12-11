({
	initList: function (cmp, event, helper) {
        var spinner = cmp.find('spinnerComponent');
		spinner.incrementCounter();
        var action = cmp.get("c.initApex");
        action.setParams({ theDate : cmp.get("v.targetDate")});
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            spinner.decreaseCounter();
            if (state === "SUCCESS") {
                if(!cmp.get('v.today')){
                    cmp.set('v.today',response.getReturnValue().targetDate);  
                }
                
                if(response.getReturnValue().targetDate >= cmp.get('v.today'))
                {
                    var attivitaList = response.getReturnValue().WrapperRowList;
                    cmp.set('v.WrapperRowListAM', attivitaList.filter(WrapperRow => {return WrapperRow.slot.Time__c==="AM"}));
                    cmp.set('v.WrapperRowListPM', attivitaList.filter(WrapperRow => {return WrapperRow.slot.Time__c==="PM"}));  
                    cmp.set('v.targetDate',response.getReturnValue().targetDate);
                    cmp.set('v.previusDate',response.getReturnValue().targetDate);
                }else{
                    helper.showToast('Selezionare una data maggiore o uguale ad oggi','error');
                    cmp.set('v.targetDate',cmp.get('v.previusDate'));

                }
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
            
        }); 
        $A.enqueueAction(action); 
	
	},
    navigateToPianifica : function(cmp, event, helper) {
        var slotId =event.target.id;
		var WrapperRow;
        WrapperRow = cmp.get('v.WrapperRowListAM').find(WrapperRow => {return WrapperRow.slot.Id===slotId});
        WrapperRow = WrapperRow ? WrapperRow : cmp.get('v.WrapperRowListPM').find(WrapperRow => {return WrapperRow.slot.Id===slotId});
        
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:SFA_PianificaAttivita",
            componentAttributes: {
                'slot' : WrapperRow.slot
            }
        });
        evt.fire();
    },
    
    showToast : function(message,type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "message": message,
            "type" : type
        });
        toastEvent.fire();
    },    

})