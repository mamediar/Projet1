({
    doInit: function(component) {
        var action = component.get("c.getProfiles");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                console.log("data >>", data);
                if (data.error) {
                    console.log("data error>>", data.message);
                    //this.showToast(data.message, "ERROR");
                } else {
                    var profiles = data.profiles;
                    var options = [];
                    var pr = {}
                    profiles.forEach(function(profile) {
                        pr = { 'label': profile.Name, 'value': profile.Id };
                        options.push(pr);
                    });
                    component.set("v.profiles", options);
                    console.log("data >>", data);
                    //this.showToast(data.message, "SUCCESS");
                }
            } else {
                console.log("data >>", data);
                //this.showToast("Salvataggio non effettuato!", "ERROR");
            }
        });
        $A.enqueueAction(action);
    },
    sendMail: function(component) {
        var action = component.get("c.sendingMail");
        var profileIds = component.get('v.value');
        var message = component.find("noteText").get('v.value');
        console.log('profileIds >>', profileIds);
        console.log('message >>', message);
        action.setParams({ 'profileIds': profileIds, 'message': message });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                console.log("data >>", data);
                if (data.error) {
                    console.log("data error>>", data.message);
                    //this.showToast(data.message, "ERROR");
                } else {
                    var users = data.message;
                    console.log("users >>", users);
                    component.set('v.value', []);
                    component.find("noteText").set('v.value', '');
                    this.showToast(data.message, "SUCCESS");
                }
            } else {
                console.log("data >>", data);
                this.showToast("Email not send!", "ERROR");
            }
        });
        $A.enqueueAction(action);
    },
    showToast: function(message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            message: message,
            type: type
        });
        toastEvent.fire();
    },
})