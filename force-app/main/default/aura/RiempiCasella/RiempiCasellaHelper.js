({
	createCmp : function(cmp, componentName) {
        $A.createComponent(
            componentName,
            {},
            function(newButton, status, errorMessage){
                if (status === "SUCCESS") {
                    var body = cmp.get("v.body");
                    body.push(newButton);
                    cmp.set("v.body", body);
                }
            }
        );
	}
})