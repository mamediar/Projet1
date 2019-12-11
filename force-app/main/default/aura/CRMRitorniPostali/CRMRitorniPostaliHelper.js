({
    showToast : function(message, type){
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			message: message,
			type : type
		});
		toastEvent.fire();
	},
	handleAddressSubmit: function(cmp){			
				var addrForm=cmp.find('addressForm')		
				if(!addrForm) return; // no address form available

				var lista=['NewAddress__c','NewCap__c','NewProv__c','NewCity__c'];
				var objFields={};
				lista.forEach(function(el,idx){
						console.log("-- KEY "+el);
						var value=cmp.find(el).get("v.value");
						objFields[lista[idx]]=value;
				});
				console.log(JSON.stringify(objFields));
				//fields.Street = '32 Prince Street';
				
				addrForm.submit(objFields);
	},
	eventManager: function (cmp) {
		var action2=cmp.get('c.eventManager'); 
		action2.setParams({ caseId:cmp.get("v.recordId")})       
		action2.setCallback(this, function(response) {
						var state = response.getState();
						if (state === "SUCCESS") {
								// Alert the user with the value returned 
								// from the server
								//alert("From server: " + response.getReturnValue());
								cmp.set("v.eventManagerResult",response.getReturnValue());		
								var idx = response.getReturnValue();
								if(idx==0) cmp.set("v.finalResultMessage", "Cliente già contattato con esito positivo");
								else if (idx==2){
									 cmp.set("v.inviaDoc2System",true);
									 cmp.set("v.radioGroupResultValue","OK");
								}
								//alert("EVENT MANAGER "+response.getReturnValue())						;
								// You would typically fire a event here to trigger 
								// client-side notification that the server-side 
								// action is complete
						}
						else if (state === "INCOMPLETE") {
								// do something
						}
						else if (state === "ERROR") {
								var errors = response.getError();
								if (errors) {
										if (errors[0] && errors[0].message) {
												console.log("Error message: " + 
																 errors[0].message);
												alert("Error message: " + errors[0].message)
										}
								} else {
										console.log("Unknown error");
										alert("GENERIC ERROR on INIT");
								}
						}
				});
			$A.enqueueAction(action2);    
	}
})