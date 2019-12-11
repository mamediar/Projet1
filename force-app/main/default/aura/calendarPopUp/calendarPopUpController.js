({
	
	openPopUp: function(cmp, event, helper){
		
		cmp.set('v.activityType', null);
		if(cmp.get('v.slot').Type__c){
				cmp.set('v.activityType', 'Filiale');
		}else if(cmp.get('v.slot').XCS_Zone__c){
			cmp.set('v.activityType', 'Zona');
            helper.onChangeBranchSelect(cmp, event, helper);
		}
		cmp.find("theStaticModal").openModal();
	
	},
     
	closePopUp : function(cmp, event, helper) {
	cmp.find("theStaticModal").closeModal();
	},

	saveSlot : function(cmp, event, helper) {
	helper.saveSlot(cmp, event, helper);
	},
	
	onChangeBranchSelect : function(cmp, event, helper) {
		helper.onChangeBranchSelect(cmp, event, helper);
	}
})