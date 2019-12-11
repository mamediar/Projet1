({
	showToastWarning : function(component, event, message) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title : "Attenzione",
			type : "warning",
			message : message,
		});
		toastEvent.fire();
	}
})