({
	removeItemAction : function(cmp, event, helper) {
		helper.removeItemAction(cmp, event, helper); 
	},
	removeAllAction: function(cmp, event, helper){
		helper.removeAllAction(cmp, event, helper);
	},
	addElement: function(cmp, event, helper){
		if(helper.notElapsedDateHour(cmp, helper)){
			var popUp= cmp.find('popUpComponent');
			var branch = cmp.get('v.isFilialista') ? cmp.get('v.branch.Id'): '';
			if(branch== '' && cmp.get('v.branches').length==1){
				branch= cmp.get('v.branches')[0].Id;
			}
			var newSlotForPopUp={Branch__c: branch, 
								Date__c: cmp.get('v.dayOfThisSlot.theDate'), 
								Id: null,
								Status__c: "Valido",
								Time__c: cmp.get('v.moment'), 
								User__c: cmp.get('v.user.Id')
								//Dealer__c:""
								};
			cmp.set('v.newSlotForPopUp', newSlotForPopUp);
			cmp.set('v.isNew', true);
			popUp.openPopUp();
		}
	},
	modifyElement: function(cmp, event, helper){
		helper.modifyElement(cmp, event, helper); 
	} 

	

})