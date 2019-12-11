({
	removeAllAction: function(cmp, event, helper){
		if(helper.notElapsedDateHour(cmp, helper)){
			var trashSlots = cmp.get('v.slotList');
			var trashSlotList = cmp.get('v.trashSlotList');
			var draftSlotList= cmp.get("v.draftSlotList");
			var slotListForAllUsers=cmp.get("v.slotListForAllUsers");
			var slotListIndex=cmp.get("v.slotListIndex");
			var allUsersSlotListObject= slotListForAllUsers[slotListIndex];
			var allUsersSlotList;
			var allUsersSlotListIndex;
			if(allUsersSlotListObject){
				allUsersSlotList=allUsersSlotListObject.slotListForAllUsers;
			}
			trashSlots.forEach(slot => {
				if(slot.Id){
					trashSlotList.push(slot);
				}
				else{
					cmp.set('v.unsavedAdd', cmp.get('v.unsavedAdd')-1);
				}
				if(allUsersSlotList){
					allUsersSlotListIndex= allUsersSlotList.indexOf(slot);
					if(allUsersSlotListIndex!=(-1)){
						allUsersSlotList.splice(allUsersSlotListIndex, 1);
						allUsersSlotListIndex=undefined;
					}
				}
				if(slot.Status__c = 'Draft'){
					var draftSlotIndex=draftSlotList.indexOf(slot);
					draftSlotList.splice(draftSlotIndex, 1);
					cmp.set("v.draftSlotList", draftSlotList);
				}
			});
			if(allUsersSlotList){
				cmp.set("v.slotListForAllUsers", allUsersSlotList);
			}
			cmp.set("v.draftSlotList", draftSlotList);
			cmp.set('v.trashSlotList', trashSlotList);
			cmp.set('v.slotList', []);
		}
	},

	removeItemAction : function(cmp, event, helper) {
		if(helper.notElapsedDateHour(cmp, helper)){
			event.preventDefault();
			var draftSlotList= cmp.get("v.draftSlotList");
			var slotListForAllUsers=cmp.get("v.slotListForAllUsers");
			var slotListIndex=cmp.get("v.slotListIndex");
			var mySlots= cmp.get('v.slotList');
			var trashSlotList= cmp.get('v.trashSlotList');
			var throwableSlotIndex= event.getSource().get('v.name');
			var throwableSlot= mySlots[throwableSlotIndex];
			var allUsersSlotListObject= slotListForAllUsers[slotListIndex]
			var allUsersSlotList;
			var allUsersSlotListIndex;
			if(allUsersSlotListObject){
				allUsersSlotList=allUsersSlotListObject.slotListForAllUsers;
			}
			if(throwableSlot.Id){
				trashSlotList.push(throwableSlot);
				cmp.set('v.trashSlotList', trashSlotList);
			}
			else{
				cmp.set('v.unsavedAdd', cmp.get('v.unsavedAdd')-1);
			}
			if(allUsersSlotList){
				allUsersSlotListIndex= allUsersSlotList.indexOf(throwableSlot);
				if(allUsersSlotListIndex!=(-1)){
					allUsersSlotList.splice(allUsersSlotListIndex, 1);
					cmp.set('v.slotListForAllUsers', slotListForAllUsers);
				}
			}
			if(throwableSlot.Status__c = 'Draft'){
				var draftSlotIndex=draftSlotList.indexOf(throwableSlot);
				draftSlotList.splice(draftSlotIndex, 1);
				cmp.set("v.draftSlotList", draftSlotList);
			}			
			mySlots.splice(throwableSlotIndex, 1);
			cmp.set('v.slotList', mySlots);
		}
	},

	modifyElement: function(cmp, event, helper){
		if(cmp.get('v.assenzeProlungateUserList').length){
			helper.showToast("Errore: assenza prolungata presente",'error');
		}
		else if(helper.notElapsedDateHour(cmp, helper)){
			var popUp= cmp.find('popUpComponent');
			
			var newSlotForPopUp = cmp.get('v.slotList')[event.getSource().get('v.name')];
			cmp.set('v.newSlotForPopUp', newSlotForPopUp);
			cmp.set('v.isNew', false);
			popUp.openPopUp();
		}
	},

	showToast : function(message,type){
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			message: message,
			type: type
		});
		toastEvent.fire();
	},
	
	notElapsedDateHour: function(cmp, helper){
		var nowDate= new Date();
		var clockTime= nowDate.getHours() >= 12 ? 'PM' : 'AM';
		if(cmp.get('v.dayOfThisSlot').theDate < cmp.get('v.today') ||
		(cmp.get('v.dayOfThisSlot').theDate === cmp.get('v.today') && clockTime==='PM' && cmp.get('v.moment')==='AM')
		){
					helper.showToast("Errore: data già superata",'error');
					return false;
		}
		else{
			return true;
		}
	}
})