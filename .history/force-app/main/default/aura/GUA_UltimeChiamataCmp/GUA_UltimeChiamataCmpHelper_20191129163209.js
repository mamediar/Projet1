({

    getTaskById: function(component) {
        var accountId = component.get("v.accountId");
        console.log('accountId ' + accountId);
        var action = component.get("c.getTaskByID");
        action.setParams({
            "accountId": accountId
        });
        action.setCallback(this, function(resp) {
            if (resp.getState() == 'SUCCESS') {
                var data = resp.getReturnValue();
                component.set("v.UltimeChimataDealerList", data.ultimeChiamateDealer);
                component.set('v.case', data.case);
                console.log('data', JSON.stringify(data));
                var devName = data.case.RecordType.DeveloperName;
                if (devName.toUpperCase() == 'GUA_Inbound'.toUpperCase()) {
                    component.set('v.isInbound', true);
                }
                component.set('v.operatore', data.operatore);
                console.log(a.getReturnValue());
                console.log("set list account", a.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    ShowHideAll: function(component, event) {
        let activeSections = component.get("v.activeSections");
        if (activeSections.length === 0) {
            component.set("v.activeSections", ["A", "B", "C"]);
        } else {
            component.set("v.activeSections", []);
        }
    },
})