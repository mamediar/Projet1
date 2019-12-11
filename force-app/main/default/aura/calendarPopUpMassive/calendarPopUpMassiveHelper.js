({
	saveSlot : function(cmp, event, helper) {
                var slot= cmp.get('v.slot');
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
                slot.Status__c = 'Draft';

                var moment= cmp.get('v.moment')
                if(moment == "AM" || moment == "AMPM"){
                        slot.Time__c= "AM";
                        var newSlotListsAM= helper.addSlotsMassive(slot, cmp, helper);
                        cmp.set('v.slotListsAM', newSlotListsAM);
                }

                if(moment == "PM" || moment == "AMPM"){
                        slot.Time__c= "PM";
                        var newSlotListsPM= helper.addSlotsMassive(slot, cmp, helper);
                        cmp.set('v.slotListsPM', newSlotListsPM);
                }

                cmp.set('v.slot', {});
                cmp.set('v.activityType',null);
                cmp.find("theStaticModal").closeModal();
        },

        addSlotsMassive: function(slot, cmp, helper){
                var draftSlotList= cmp.get("v.draftSlotList");
                var oldSlotList = [];
                var oldSlotListForAllUsers= [];
                if(slot.Time__c=="AM"){
                        oldSlotList = cmp.get('v.slotListsAM');
                        oldSlotListForAllUsers = cmp.get("v.slotListAMForAllUsers");
                }
                if(slot.Time__c=="PM"){
                        oldSlotList = cmp.get('v.slotListsPM');
                        oldSlotListForAllUsers = cmp.get("v.slotListPMForAllUsers");
                }
                var days= cmp.get('v.weekDays');
                var selectedDaysSet= helper.getSelectedDays(slot, cmp, helper);
                for(let i=0; i<days.length; i++) {
                        if(selectedDaysSet.has(days[i]) && helper.notElapsedDateHour(cmp, helper, days[i].theDate, slot.Time__c) && !(oldSlotList[i].assenzeList.length)){
                                var cloned= Object.assign({}, slot);
                                cloned.Date__c=days[i].theDate;
                                var similarSlot= oldSlotList[i].slotList.find(slotItem => {
                                        return cloned.XCS_Zone__c == slotItem.XCS_Zone__c &&
                                        cloned.Type__c == slotItem.Type__c});
                                //verifica caso filialisti diversi assegnati alla stessa filiale
                                if(!similarSlot){
                                        similarSlot= oldSlotListForAllUsers[i].slotListForAllUsers.find(slotItem =>{
                                                return cloned.XCS_Zone__c 
                                                        && cloned.XCS_Zone__c == slotItem.XCS_Zone__c
                                                        && cloned.Date__c==slotItem.Date__c
                                                        && cloned.Time__c==slotItem.Time__c
                                                        && slotItem.Status__c!='Draft';
                                        })
                                        if(similarSlot){
                                                helper.showToast('Pianificazione già presente in data '+days[i].formattedDate,'error');
                                        }
                                }
                                if(!similarSlot){
                                        similarSlot= draftSlotList.find(slotItem=>{
                                                return  cloned.XCS_Zone__c 
                                                        && cloned.XCS_Zone__c == slotItem.XCS_Zone__c 
                                                        && cloned.Date__c==slotItem.Date__c
                                                        && cloned.Time__c==slotItem.Time__c
                                        })
                                }
                                if(!similarSlot){
                                        oldSlotList[i].slotList.push(cloned);
                                        draftSlotList.push(cloned);
                                        cmp.set('v.unsavedAdd', cmp.get('v.unsavedAdd')+1); 
                                }
                        }
                }
                cmp.set("v.draftSlotList", draftSlotList);
                return oldSlotList;
        },

        getSelectedDays : function(slot, cmp, helper){
                
                var box;

                if(slot.Time__c=="AM")
                        box = cmp.find('dayCheckBoxAM');
                if(slot.Time__c=="PM")
                        box = cmp.find('dayCheckBoxPM');
               
                var days = cmp.get('v.weekDays');
                var selectedDays = new Set();

		if(box){
		        box.forEach(element => {
                                if(element.get('v.checked')){
                                        var day = days.find(x => {
                                               return x.theDate == element.get('v.class');
                                        });
                                        selectedDays.add(day);
                                }
			});
                }
                return selectedDays;
		
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
        
        notElapsedDateHour: function(cmp, helper, day, moment){
		var nowDate= new Date();
		var clockTime= nowDate.getHours() >= 12 ? 'PM' : 'AM';
		if(day < cmp.get('v.today') ||
		(day === cmp.get('v.today') && clockTime==='PM' && moment==='AM')
		){
                        return false;
		}
		else{
			return true;
		}
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