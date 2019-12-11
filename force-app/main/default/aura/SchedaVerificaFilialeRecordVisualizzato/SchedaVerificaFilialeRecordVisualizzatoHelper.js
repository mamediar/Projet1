({
	updateLetta : function(component,campo) {
		var method = component.get('c.updateLetta');
		method.setParams({
			'schedaFilialeId': component.get('v.recordId'),
			'campo':campo
		});
		method.setCallback(this,function(response){
			var state = response.getState();
			if(state == 'SUCCESS'){
				var result = response.getReturnValue();
			}else{
				//error
				var result = response.getReturnValue();
			}
		});

		$A.enqueueAction(method);
	}
})