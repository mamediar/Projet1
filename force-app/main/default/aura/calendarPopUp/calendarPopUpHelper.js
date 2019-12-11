({
        saveSlot : function(cmp, event, helper) {
                var slot= cmp.get('v.slot');
                var draftSlotList= cmp.get("v.draftSlotList");
                if(cmp.get('v.activityType') === 'Filiale'){

                        slot.Type__c = slot.Type__c ? slot.Type__c : cmp.get('v.TypeSelectOptions')[0].value;
                        slot.typeLabel= cmp.get('v.TypeSelectOptions').find(option => {return option.value===slot.Type__c}).label; 
                        slot.XCS_Zone__c = null;
                        slot.XCS_Zone__r = null;
                }else{
                        var zoneList = cmp.get('v.zoneList');
                        if(!zoneList)
                                return;
                        slot.XCS_Zone__c = slot.XCS_Zone__c ? slot.XCS_Zone__c : zoneList[0].Id;
                        slot.typeLabel= null;
                        slot.Type__c = null;
                        slot.XCS_Zone__r = cmp.get('v.zoneList').find(zone => {return zone.Id===slot.XCS_Zone__c});
                }

                var customSlotList=cmp.get('v.slotList');
                var slotListIndex=cmp.get("v.slotListIndex");
                var slotListForAllUsers=cmp.get("v.slotListForAllUsers")[slotListIndex];
                var similarSlot= customSlotList.find(slotItem => {
                        return slot.XCS_Zone__c == slotItem.XCS_Zone__c &&
                        slot.Type__c == slotItem.Type__c});
                if(!similarSlot && slotListForAllUsers){
                        similarSlot= slotListForAllUsers.slotListForAllUsers.find(slotItem => {
                                return  slot.XCS_Zone__c 
                                        && slot.XCS_Zone__c == slotItem.XCS_Zone__c 
                                        && slotItem.Status__c!='Draft'  
                                        && slot.Date__c==slotItem.Date__c
                                        && slot.Time__c==slotItem.Time__c});
                        if(similarSlot){
                                helper.showToast('Pianificazione già presente in data '+cmp.get('v.dayOfThisSlot').formattedDate,'error');
                        }
                }
                if(!similarSlot){
                        similarSlot= draftSlotList.find(slotItem=> {
                                return  slot.XCS_Zone__c 
                                        && slot.XCS_Zone__c == slotItem.XCS_Zone__c 
                                        && slot.Date__c==slotItem.Date__c
                                        && slot.Time__c==slotItem.Time__c;
                        })
                }
                if(cmp.get('v.isNew') && !similarSlot){
                        customSlotList.push(slot);
                        draftSlotList.push(slot);
                }
                slot.Status__c = 'Draft';
                cmp.set('v.slotList', customSlotList);
                cmp.set('v.draftSlotList', draftSlotList);
                cmp.set('v.slot', {});
                cmp.set('v.activityType',null);
                cmp.find("theStaticModal").closeModal();
                if((cmp.get('v.isNew') && !similarSlot) || !cmp.get('v.isNew')){
                        cmp.set('v.unsavedAdd', cmp.get('v.unsavedAdd')+1);
                }
        },

        onChangeBranchSelect : function(cmp, event, helper) {
                var branchId = cmp.get('v.slot.Branch__c');
                var branch = cmp.get('v.branches').find(branch => {return branch.Id===branchId});
                if(branch){
                        var zoneList= cmp.get('v.zonePerFiliale')[branch.OCS_External_Id__c];
                }else{
                        cmp.set('v.activityType', '');    
                }
                cmp.set('v.branch',  branch);
                cmp.set('v.zoneList',zoneList);

        },

        showToast : function(message,type){
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			message: message,
			type: type
		});
		toastEvent.fire();
        }
})