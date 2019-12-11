({
		getData : function(cmp,event, prod, ActionCode, codiceTelemarketing, tipoCamp) { 
		let obj = cmp.get('v.CampaignRecord');
		let action = cmp.get('c.scriptForCamapign'); 
            action.setParams({'prodId': prod,'codTMK': codiceTelemarketing, 'actionCode': ActionCode, 'tipoCamp': tipoCamp}); 
		action.setCallback(this, 
			$A.getCallback(function (response) { 
			var state = response.getState();
			console.log('stato ',state); 
			if (state == "SUCCESS") {
				let results = response.getReturnValue();
				console.log('risultati ',results);
				cmp.set('v.data', results);
				cmp.set('v.showButtonforNew', results.length <1); 
				
			} 
			 
		})); 
		 $A.enqueueAction(action);
		}
		
})