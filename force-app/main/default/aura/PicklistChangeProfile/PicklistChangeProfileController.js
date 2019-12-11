({
	loadOptions : function(component) {
		var options = [];
        var action = component.get("c.getPickListValuesProfile"); 
        action.setCallback(this,function(response)	{
            var state = response.getState();
            if (state === "SUCCESS")
            {
               	var arr = response.getReturnValue();   
                arr.forEach(function(element) {  
                    options.push({ value: element.Id, label: element.Name });   
                });
                component.set("v.Lista_Profili", options);
            } 
        });
        $A.enqueueAction(action);
	},
    changeProf: function (cmp, event) {
        console.log("Dentro Onchange");
        var action = cmp.get("c.changeProfile");
        action.setParams({profileid:event.getParam("value")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('DENTRO LO STATE'); 
            }
        });
        $A.enqueueAction(action); 
    }
})