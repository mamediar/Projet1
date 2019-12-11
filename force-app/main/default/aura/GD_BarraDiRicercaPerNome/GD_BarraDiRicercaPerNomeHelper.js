({
    search : function(component) {
        var action = component.get("c.searchByName");
        var text = component.get("v.searchText");
        console.log('searchText >>', text);
        if(text){
            action.setParam("searchText", text);
            action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
            var data = response.getReturnValue();
            console.log('data >>', data);
            if (data.error) {
                var message = "Salvataggio non effettuato!";
                if (data.message.includes("duplicate")) {
                message = "Insert failed, duplicate value found";
                }
                this.showToast(message, "ERROR");
            } else {
                component.set("v.results", data.results);
                this.showToast(data.message, "SUCCESS");
                console.log('results >>', component.get("v.results"));
            }
            } else {
                this.showToast("Salvataggio non effettuato!", "ERROR");
            }
            });
            $A.enqueueAction(action);  
        }else{
            this.showToast("Campo di ricerca vuoto", "ERROR");
        }
                  
    },
    showToast  : function(message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
          message: message,
          type: type
        });
        toastEvent.fire();
    }
})