({
	initApex : function(component, event, helper) {
        var spinner = component.find('spinnerComponent');
		spinner.incrementCounter();
		var action=component.get('c.initApex');
        action.setCallback(this,function(resp){
            spinner.decreaseCounter();
            if(resp.getState()=='SUCCESS'){
                var initWrapper= resp.getReturnValue();
                component.set('v.initWrapper',initWrapper);
                component.set('v.today', initWrapper.targetDate);
                component.set('v.filialistiPerFiliale', initWrapper.filialistiPerFiliale);               
                component.set('v.slotList', initWrapper.slotList);
                component.set('v.allZoneSlotList', initWrapper.allZoneSlotList);
                component.set('v.assenzeProlungateList', initWrapper.assenzeProlungateList);
                component.set('v.user', initWrapper.manager);
                component.set('v.weekDays', initWrapper.dataWrapperList);
	 			//component.set('v.users', initWrapper.filialistiPerFiliale[initWrapper.branches[0].OCS_External_Id__c]);               
                //console.log('DP v.users: '+JSON.stringify(component.get('v.users')));
                component.set('v.targhetDate', initWrapper.targetDate);
                
                //DP                
                var regionList = Object.keys(initWrapper.areaListPerRegion);
				regionList.reverse();
				component.set('v.regionList',regionList);
				component.set('v.regioneSelected',regionList[0]); 
                console.log('DP regioneSelected: '+regionList[0]);
				var areaList = initWrapper.areaListPerRegion[regionList[0]];
				component.set('v.areaList',areaList);
				component.set('v.areaSelected',areaList[0]);
                console.log('DP areaSelected: '+areaList[0]);
                // END DP               
                var filialeList = component.get('v.initWrapper.branchListPerArea')[areaList[0]];
                console.log('DP filialeList: '+JSON.stringify(filialeList));                
                component.set('v.branches',filialeList);
                console.log('DP filialeList.lenght: '+filialeList.length);
                if(filialeList.length == 1){
                    component.set('v.ImpFiliale', true);
                }                
                //component.set('v.branches', initWrapper.branches);   //Mod DP           
                component.set('v.branch', filialeList[0]);
                console.log('DP v.branch: '+JSON.stringify(component.get('v.branch')));
                //Aggiunta DP
                component.set('v.branchSel', component.get('v.branch'));
                console.log('DP v.branchSel: '+JSON.stringify(component.get('v.branchSel')));
                var filialeSelezionata =  component.get('v.branches');
                component.set('v.branchOCSExternalId', filialeSelezionata[0].OCS_External_Id__c);
                console.log('DP filialeSelezionata: '+filialeSelezionata[0].OCS_External_Id__c);
                //Fine aggiunta
                //component.set('v.branchOCSExternalId', initWrapper.branches[0].OCS_External_Id__c);
                component.set('v.zonePerFiliale', initWrapper.zonePerFiliale);
                component.set('v.TypeSelectOptions', initWrapper.TypeSelectOptions.filter(typeSelectOption => typeSelectOption.active == 'true'));
                component.set("v.draftSlotList", []);
                component.set('v.unsavedAdd', 0);
                var branchOCSExternalId = component.get('v.branchOCSExternalId');
                component.set('v.users', component.get('v.filialistiPerFiliale')[branchOCSExternalId]);
                console.log('DP v.users: '+JSON.stringify(component.get('v.users')));
            }
            else if(resp.getState()=='ERROR'){
                var errors = resp.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                                 helper.showToast("Errore: " + 
                                 errors[0].message,'error');
                    }else {
                        console.log("Unknown error");
                        helper.showToast('Errore generico','error');
                    }
                } else {
                    console.log("Unknown error");
                    helper.showToast('Errore generico','error');
                }
            }
        });
        $A.enqueueAction(action);
    },
    submitNewTargetDate : function(component, event, helper, checkAppointments) {
        var spinner = component.find('spinnerComponent');
		spinner.incrementCounter();
        
		var action=component.get('c.changeTargetDate');
        action.setParams({targetDate: component.get('v.targhetDate'), 
                            manager: component.get('v.user'), 
                            filialistiPerFiliale: component.get('v.filialistiPerFiliale')});
        action.setCallback(this,function(resp){
            spinner.decreaseCounter();
            if(resp.getState()=='SUCCESS'){
                var initWrapper= resp.getReturnValue();
                //component.set('v.branchSel', component.get('v.branch'));
                console.log('DP v.branchSel: '+JSON.stringify(component.get('v.branchSel')));
                component.set('v.initWrapper',initWrapper);
                component.set('v.targhetDate', initWrapper.targetDate);
                component.set('v.slotList', initWrapper.slotList);
                component.set('v.allZoneSlotList', initWrapper.allZoneSlotList);
                component.set('v.assenzeProlungateList', initWrapper.assenzeProlungateList);
                component.set('v.weekDays', initWrapper.dataWrapperList);
                component.set('v.zonePerFiliale', initWrapper.zonePerFiliale);
                component.set('v.trashSlotList', []);
                component.set("v.draftSlotList", []);
                component.set('v.unsavedAdd', 0);

                var branchOCSExternalId = component.get('v.branchOCSExternalId');
        		component.set('v.users', component.get('v.filialistiPerFiliale')[branchOCSExternalId]);
                //component.set('v.branchSel', component.get('v.branch'));
                //console.log('DP v.branchSel: '+JSON.stringify(component.get('v.branchSel')));
                component.set('v.mapOfAppointmentsPerDesk', initWrapper.mapOfAppointmentsPerDesk);
                if(checkAppointments)
                    helper.getCaseOpenOnDealer(component, event, helper);
                if(checkAppointments && !helper.isEmpty(initWrapper.mapOfAppointmentsPerDesk)){
                    helper.checkAllAppointmentsAreCovered(component,helper,initWrapper.dataWrapperList,initWrapper.slotList);
                }

                component.set('v.ImpFiliale', true);
                
                
            }
            else if(resp.getState()=='ERROR'){
                var errors = resp.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                                 helper.showToast("Errore: " + 
                                 errors[0].message,'error');
                    }else {
                        console.log("Unknown error");
                        helper.showToast('Errore generico','error');
                    }
                } else {
                    console.log("Unknown error");
                    helper.showToast('Errore generico','error');
                }
            } 
        });
        $A.enqueueAction(action);
        
    },
    
    onChangeRegionSelect: function(component, event, helper) {
        component.set('v.ImpFiliale', false);
		var regioneSelected = component.get('v.regioneSelected');
        var areaList = component.get('v.initWrapper.areaListPerRegion')[regioneSelected];
        component.set('v.areaList',areaList);
		component.set('v.areaSelected',areaList[0]);
        var filialeList = component.get('v.initWrapper.branchListPerArea')[areaList[0]];
        //component.set('v.branch',filialeList);
		component.set('v.branches',filialeList);
		component.set('v.filialeSelected',filialeList[0]);
        component.set('v.branchSel', filialeList[0]);
        
        var filialeSelezionata =  component.get('v.branches');
                component.set('v.branchOCSExternalId', filialeList[0].OCS_External_Id__c);
        
        console.log('DP branchOCSExternalId in RegionSelect: '+component.get('v.branchOCSExternalId'));
        var branchOCSExternalId = component.get('v.branchOCSExternalId');
        component.set('v.users', component.get('v.filialistiPerFiliale')[branchOCSExternalId]);
        console.log('DP v.users RegionSelect: '+JSON.stringify(component.get('v.users')));
	},
	
	onChangeAreaSelect: function(component, event, helper) {
        component.set('v.ImpFiliale', false);
		var areaSelected = component.get('v.areaSelected');
        console.log('DP areaSelected: '+JSON.stringify(areaSelected));
        var filialeList = component.get('v.initWrapper.branchListPerArea')[areaSelected];
        console.log('DP filialeList: '+JSON.stringify(filialeList));
		//component.set('v.branch',filialeList);
        component.set('v.branches',filialeList);
		component.set('v.filialeSelected',filialeList[0]);
        component.set('v.branchSel', filialeList[0]);
         component.set('v.branchOCSExternalId', filialeList[0].OCS_External_Id__c);
        var branchOCSExternalId = component.get('v.branchOCSExternalId');
        component.set('v.users', component.get('v.filialistiPerFiliale')[branchOCSExternalId]);
        console.log('DP v.users AreaSelect: '+JSON.stringify(component.get('v.users')));
    },
    
    onChangeBranchSelect: function(component, event, helper) {
        component.set('v.ImpFiliale', false);
        var branchOCSExternalId = component.get('v.branchOCSExternalId');
        component.set('v.users', component.get('v.filialistiPerFiliale')[branchOCSExternalId]);
		console.log('DP v.users', component.get('v.users'));

        component.set('v.branch', component.get('v.branches')
                    .find(branch => {return branch.OCS_External_Id__c===branchOCSExternalId}) );

        component.set('v.branchSel', component.get('v.branch'));
        console.log('DP sono in onChangeBranchSelect del Pianifica Slot e il mio branch è: '+component.get('v.branchSel'));
        var filialeSelezionata =  component.get('v.branches');
        console.log('DP v.users BranchSelect: '+JSON.stringify(component.get('v.users')));
    },

    saveSlotList: function(component, event, helper) {

        var allSlots= [];
        var managerSlotList= component.find('CalendarBoxContainerManagerId');
        var allFilialistiSlotList= component.find('CalendarBoxContainerFilialistiId');

        allSlots= helper.getAllSlotsFromComponents(allSlots, managerSlotList);
        if(allFilialistiSlotList){
            if(Array.isArray(allFilialistiSlotList)){
                allFilialistiSlotList.forEach(filialistiSlotList => {
                    allSlots= helper.getAllSlotsFromComponents(allSlots, filialistiSlotList);
                });
            }
            else{
                allSlots= helper.getAllSlotsFromComponents(allSlots, allFilialistiSlotList);
            }
        }


        allSlots.forEach(slot => {
            if(slot.Status__c == 'Draft'){
                slot.Status__c = 'Valido';
            }
        })
        

        helper.saveApex(component, event, helper, allSlots, component.get('v.trashSlotList'));
    },

    checkAllAppointmentsAreCovered: function(cmp,helper,weekDays,slotList){
        var mapOfAppointmentsPerDesk=cmp.get('v.mapOfAppointmentsPerDesk');
        var branchOCSExternalId=cmp.get('v.branchOCSExternalId');
        weekDays.forEach(day =>{
            var frontOfficersPerDayAM= [];
            var frontOfficersPerDayPM= [];
            frontOfficersPerDayAM=slotList.filter(selectedSlot=>{
                return selectedSlot.Date__c==day.theDate
                        &&selectedSlot.typeLabel=='Front Office'
                        &&selectedSlot.Time__c=="AM"
                        &&selectedSlot.Branch__r.OCS_External_Id__c==branchOCSExternalId;
            })
            frontOfficersPerDayPM=slotList.filter(selectedSlot=>{
                return selectedSlot.Date__c==day.theDate
                        &&selectedSlot.typeLabel=='Front Office'
                        &&selectedSlot.Time__c=="PM"
                        &&selectedSlot.Branch__r.OCS_External_Id__c==branchOCSExternalId;
            })
            var activeDesksAM=0;
            var activeDesksPM=0;
            for(var key in mapOfAppointmentsPerDesk){
                var appointmentList= mapOfAppointmentsPerDesk[key];
                var appointmentAM;
                var appointmentPM;
                for(var appointmentIndex=0; appointmentIndex<appointmentList.length&&(!appointmentAM || !appointmentPM); appointmentIndex++){
                    var appointment=appointmentList[appointmentIndex];
                    if(appointment.Date__c==day.theDate&&appointment.Branch__r.OCS_External_Id__c==branchOCSExternalId){
                        if(appointment.StartTime__c <43200000){
                            appointmentAM=appointment;
                        }
                        if(appointment.EndTime__c>43200000){
                            appointmentPM=appointment;
                        }
                    }
                }
                activeDesksAM= appointmentAM ? activeDesksAM+1 : activeDesksAM;
                activeDesksPM= appointmentPM ? activeDesksPM+1 : activeDesksPM;
            }
            var AMPlanNecessary= activeDesksAM-frontOfficersPerDayAM.length;
            var PMPlanNecessary= activeDesksPM-frontOfficersPerDayPM.length;
        if(AMPlanNecessary>0){
            helper.showToast("Nella mattina del giorno "+day.formattedDate +" necessitano di persone "+AMPlanNecessary+" desk attivi" , 'error');
        }
        if(PMPlanNecessary>0){
            helper.showToast("Nella pomeriggio del giorno "+day.formattedDate +" necessitano di persone "+PMPlanNecessary+" desk attivi" , 'error');
        }
        })
    },

    getAllSlotsFromComponents: function(allSlots, CalendarBoxContainer ){
        var slotListAM= CalendarBoxContainer.get('v.slotListsAM');
        var slotListPM= CalendarBoxContainer.get('v.slotListsPM');

        slotListAM.forEach(dayItem =>{
            allSlots= allSlots.concat(dayItem.slotList);
        });

        slotListPM.forEach(dayItem =>{
            allSlots= allSlots.concat(dayItem.slotList);
        });

        return allSlots;
        
    },

    showToast : function(message,type){
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			message: message,
			type: type
		});
		toastEvent.fire();
    },
    
    saveApex: function(component, event, helper, allSlots, trashSlotList){
        var spinner = component.find('spinnerComponent');
        //spinner.incrementCounter();
        
        var allZoneFiliale = component.get("v.zonePerFiliale")[component.get("v.branchOCSExternalId")]
        if(!allZoneFiliale){
            helper.showToast('Prima di pianificare creare almeno una Zona per la seguente Filiale.', 'warning');
            return;
        }
        spinner.incrementCounter();
		var action = component.get ('c.saveSlotsApex');
		action.setParams({
            upsertList: allSlots,
            deleteList: trashSlotList
		});
		action.setCallback(this, function(response){
            spinner.decreaseCounter();
            var state = response.getState();
            if (state === "SUCCESS") {
                helper.submitNewTargetDate(component, event, helper, true);
                helper.showToast('Salvataggio riuscito', 'success');
                component.set('v.trashSlotList', []);
                component.set("v.draftSlotList", []);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                                 helper.showToast("Error message: " + 
                                 errors[0].message,'error');
                    }else {
                        console.log("Unknown error");
                        helper.showToast('Errore generico','error');
                    }
                } else {
                    console.log("Unknown error");
                    helper.showToast('Errore generico','error');
                }
            }
		});
		$A.enqueueAction(action);
    },

    getCaseOpenOnDealer: function(cmp, event, helper){
        var spinner = cmp.find('spinnerComponent');
        var zoneMancantiList = [];
        var allZoneFiliale = cmp.get("v.zonePerFiliale")[cmp.get("v.branchOCSExternalId")]

        console.log('DP getCaseOpenOnDealer allZoneFiliale: '+allZoneFiliale);
        var allZoneSlotList = cmp.get("v.allZoneSlotList");
        console.log('DP getCaseOpenOnDealer allZoneSlotList: '+allZoneSlotList);
        allZoneFiliale.filter((a_item) => {
            if(!allZoneSlotList.find((b_item) => b_item.XCS_Zone__c === a_item.Id))
                zoneMancantiList.push(a_item.Id);
        });

        spinner.incrementCounter();
		var action = cmp.get ('c.getCaseOpenOnZone');
		action.setParams({
            listIdZone: zoneMancantiList,
		});
		action.setCallback(this, function(response){
            spinner.decreaseCounter();
            var state = response.getState();
            if (state === "SUCCESS") {

                var zonePerCaseMap = response.getReturnValue();
                var filialeNameList = Object.keys(zonePerCaseMap);
                var caseList = [];

                filialeNameList.forEach(filiale =>{
                    caseList = zonePerCaseMap[filiale];
                    helper.showToast('Esiste almeno un attività nella zona '+filiale+' con  priorita alta ed una data di scadenza '+caseList[0].Cases[0].CreatedDate.substr(0, 10),'error'); 
                });
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors && errors[0] && errors[0].message){
                    helper.showToast("Error message: " + errors[0].message,'error');
                }
            }else{
                helper.showToast('Errore generico','error');
            }
            
		});
		$A.enqueueAction(action);
    },

    sendMessageHandler: function(component, event, helper){
        if(event.getParam("message") === "refresh" && event.getParam("channel") === "PianificaSlot"){
            helper.submitNewTargetDate(component, event, helper);
        }
    },
    
    isEmpty: function(obj) {
        for(var key in obj) {
            if(obj.hasOwnProperty(key))
                return false;
        }
        return true;
    }

})