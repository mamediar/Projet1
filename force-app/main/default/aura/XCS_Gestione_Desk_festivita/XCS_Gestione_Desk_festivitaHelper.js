({
	onInit : function(cmp,event,helper) {
		var spinner = cmp.find('spinnerComponent');
		spinner.incrementCounter();
		var action = cmp.get("c.initApex");
		action.setCallback(this, function(response) {
			var state = response.getState();
			spinner.decreaseCounter();
			if (state === "SUCCESS") {
				var wrapperReturned=response.getReturnValue();
				var initwrapper=wrapperReturned.gestioneDeskWrapper;
				var regionList=Object.keys(initwrapper.areaListPerRegion);
				regionList.reverse();
				cmp.set("v.regionOptions",regionList);
				cmp.set("v.regionSelected",regionList[0]);
				var areaList = initwrapper.areaListPerRegion[regionList[0]].sort((a, b) => a - b);
				cmp.set("v.areaMap",initwrapper.areaListPerRegion);
				cmp.set("v.areaOptions", areaList);
				cmp.set("v.areaSelected",areaList[0]);
				var filiali= initwrapper.branchListPerArea[areaList[0]];
				cmp.set("v.filialiMap", initwrapper.branchListPerArea);
				helper.createCustomList(cmp,event,helper,filiali);
				cmp.set("v.dateToday", wrapperReturned.today);
				cmp.set("v.baseFestivita", {
					'Date__c': wrapperReturned.today,
					'EndTime__c': '18:00:00.000',
					'StartTime__c':'09:00:00.000'});
				var festivities= helper.populateExtraFields(wrapperReturned.allFestivities,cmp, helper);
				cmp.set("v.allFestivities", festivities);
				cmp.set("v.unavailabilities", wrapperReturned.unavailabilities);
				cmp.set("v.appointments", wrapperReturned.eventList);
			}
			else if(response.getState()=='ERROR'){
				var errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						helper.showToast("Errore: " + errors[0].message,'error');
					}else {
						helper.showToast('Errore generico','error');
					}
				} else {
					helper.showToast('Errore generico','error');
				}
			}
		}); 
		$A.enqueueAction(action);
	},
	

	changeArea: function(cmp,event,helper){
		var area=cmp.get("v.areaSelected");
		var filiali=cmp.get("v.filialiMap")[area];
		cmp.set("v.filialiValues", []);
		helper.createCustomList(cmp,event,helper,filiali);
	},

	changeRegion: function(cmp,event,helper){
		var region=cmp.get("v.regionSelected");
		var aree=cmp.get("v.areaMap")[region].sort((a, b) => a - b);
		cmp.set("v.areaOptions", aree);
		cmp.set("v.areaSelected",aree[0]);
		helper.changeArea(cmp,event,helper);
	},

	sendFestivityrecord: function(cmp,event,helper){
		var allFiliali=cmp.get("v.allFiliali");
		var branchList= cmp.get("v.filialiValues");
		var baseFestivita= cmp.get("v.baseFestivita");
		var errorFound=false;
		if(baseFestivita.StartTime__c && baseFestivita.EndTime__c && baseFestivita.StartTime__c>=baseFestivita.EndTime__c){
            helper.showToast("Orario inizio festività deve essere maggiore dell'orario di fine festività","error");
            errorFound=true;
		}
		if(branchList.length==0 && !allFiliali){
			helper.showToast("Nessuna filiale selezionata","error");
            errorFound=true;
		}
		var inputs=cmp.find("requiredField");
		var errorInputs=false;
		inputs.forEach(field =>{
            field.reportValidity();
			if(!field.checkValidity()){
				errorFound=true;
				errorInputs=true;
			}
		})
		if(errorInputs){
			helper.showToast("Campi di input non corretti o vuoti", "error");
		}
		if(cmp.get("v.dateToday")>baseFestivita.Date__c){
			helper.showToast("Data selezionata già trascorsa", "error");
			errorFound=true;
		}

		var allFestivities= cmp.get("v.allFestivities");
		var unavailabilities=cmp.get("v.unavailabilities");
		var appointments=cmp.get("v.appointments");

		var festivityDateError=allFestivities.find( festivity =>{
			if(baseFestivita.Date__c==festivity.Date__c){
				var filialeAlreadySelected=branchList.find(filiale =>{
					return filiale==festivity.external_Id;
				})
				if(filialeAlreadySelected)
					return true;
			}
			return false;
		})
		if(festivityDateError){
			helper.showToast("Festività già pianificata in una filiale selezionata", "error");
			errorFound=true;
		}
		var appointmentsDateError=unavailabilities.find(appointment=>{ //check indisponibilità
			if(appointment.Date__c==baseFestivita.Date__c
			&& baseFestivita.StartTime__c<helper.msToTime(appointment.EndTime__c)
			&& baseFestivita.EndTime__c>helper.msToTime(appointment.StartTime__c)){
				var appointmentAlreadyPlanned=branchList.find(filiale=>{
					return filiale==appointment.Branch__r.OCS_External_Id__c;
				})
				if(appointmentAlreadyPlanned)
					return true;
			}
			return false;
		})
		if(!appointmentsDateError){//check appuntamenti
			appointmentsDateError=appointments.find(appointment=>{
				if(appointment.Date_c==baseFestivita.Date__c
				&& baseFestivita.StartTime__c<helper.msToTime(appointment.EndTime_c)+':00.000'
				&& baseFestivita.EndTime__c>helper.msToTime(appointment.StartTime_c)+':00.000'){
					var appointmentAlreadyPlanned=branchList.find(filiale=>{
						return filiale==appointment.BranchOcsCode;
					})
					if(appointmentAlreadyPlanned)
						return true;
				}
				return false;
			})
		}

		if(appointmentsDateError){
			helper.showToast("Data e orario già selezionati per uno o più appuntamenti", "error");
			errorFound=true;
		}

		if(!errorFound){
			var spinner = cmp.find('spinnerComponent');
			spinner.incrementCounter();
			var action = cmp.get("c.insertNewfestivities");
			action.setParams({
				"branchList": branchList,
				"appuntamentoBase": baseFestivita,
				"allFiliali": allFiliali
			})
			action.setCallback(this, function(response) {
				var state = response.getState();
				spinner.decreaseCounter();
				if (state === "SUCCESS") {
					helper.showToast("Inserimento avvenuto con successo", "success");
					var allFestivities=cmp.get("v.allFestivities");
					var returnArray=response.getReturnValue();
					helper.populateExtraFields(returnArray,cmp, helper);
					allFestivities= allFestivities.concat(returnArray);
					cmp.set("v.allFestivities", allFestivities);
					helper.refreshdMsg();
				}
				else if(response.getState()=='ERROR'){
					var errors = response.getError();
					if (errors) {
						if (errors[0] && errors[0].message) {
							helper.showToast("Errore: " + errors[0].message,'error');
						}else {
							helper.showToast('Errore generico','error');
						}
					} else {
						helper.showToast('Errore generico','error');
					}
				}
			}); 
			$A.enqueueAction(action);
		}
	},

	handleSave: function(cmp,event,helper){
		var draftValues=event.getParam('draftValues');
		var data=cmp.get("v.allFestivities");
		var errorInizio=false;
		var errorFine= false;
		for(var dataIndex=0; dataIndex<data.length && !errorInizio && !errorFine; dataIndex++){
			for(var draftValueIndex=0; draftValueIndex<draftValues.length && !errorInizio && !errorFine; draftValueIndex++){
				if(data[dataIndex].Id == draftValues[draftValueIndex].Id){
					if(draftValues[draftValueIndex].inizio != undefined){
						errorInizio= !helper.checkPattern(draftValues[draftValueIndex].inizio,helper);
						if(!errorInizio){
							draftValues[draftValueIndex].StartTime__c=helper.timeToMs(draftValues[draftValueIndex].inizio);
						}
					}
					else{
						draftValues[draftValueIndex].StartTime__c=data[dataIndex].StartTime__c;
						draftValues[draftValueIndex].inizio=data[dataIndex].inizio;
					}
					if(draftValues[draftValueIndex].fine != undefined){
						errorFine= !helper.checkPattern(draftValues[draftValueIndex].fine, helper);
						if(!errorFine){
							draftValues[draftValueIndex].EndTime__c=helper.timeToMs(draftValues[draftValueIndex].fine);
						}
					}
					else{
						draftValues[draftValueIndex].EndTime__c=data[dataIndex].EndTime__c;
						draftValues[draftValueIndex].fine=data[dataIndex].fine;
					}

					if(draftValues[draftValueIndex].Date__c == undefined){
						draftValues[draftValueIndex].Date__c=data[dataIndex].Date__c;
					}
					
					if(draftValues[draftValueIndex].StartTime__c>draftValues[draftValueIndex].EndTime__c){
						
						helper.showToast("Orario di fine antecedente all'orario di inizio", "error");
						errorInizio=true;
					}
					if(!errorInizio && !errorFine ){
						data[dataIndex].Date__c=draftValues[draftValueIndex].Date__c;
						data[dataIndex].StartTime__c=draftValues[draftValueIndex].StartTime__c;
						data[dataIndex].inizio=draftValues[draftValueIndex].inizio;
						data[dataIndex].EndTime__c=draftValues[draftValueIndex].EndTime__c;
						data[dataIndex].fine=draftValues[draftValueIndex].fine;
						helper.updateValues(cmp,event,helper, data);
					}
				}
			}
		}
	},
	
	updateValues: function(cmp,event,helper,data){
		var spinner = cmp.find('spinnerComponent');
		spinner.incrementCounter();
		var action = cmp.get("c.updateFestivities");
		action.setParams({
			"festivityData": data
		})
		action.setCallback(this, function(response) {
			var state = response.getState();
			spinner.decreaseCounter();
			if (state === "SUCCESS") {
				helper.showToast("Modifica avvenuta con successo", "success");
				cmp.set("v.allFestivities", data);
				cmp.set("v.draftValues", []);
				helper.refreshdMsg();
			}
			else if(response.getState()=='ERROR'){
				var errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						helper.showToast("Errore: " + errors[0].message,'error');
					}else {
						helper.showToast('Errore generico','error');
					}
				} else {
					helper.showToast('Errore generico','error');
				}
			}
		}); 
		$A.enqueueAction(action);
	},
	timeToMs: function(time){
		var timeParts = time.split(":");
		var msCount=((+timeParts[0] * (60000 * 60)) + (+timeParts[1] * 60000));
		return msCount;
	},
	
	populateExtraFields:function(festivitaList,cmp,helper){
		var allFiliali=cmp.get("v.filialiOptions");
		festivitaList.forEach(festivita=>{
			if(festivita.Branch__r){
				if(!festivita.Branch__r.Name){
					var festivitaFiliale=allFiliali.find( filiale=>{
						return filiale.value==festivita.Branch__r.OCS_External_Id__c;
					})
					festivita.filiale=festivitaFiliale.label;
				}
				else{
					festivita.filiale=festivita.Branch__r.Name;
				}
				festivita.external_Id=festivita.Branch__r.OCS_External_Id__c;
			}
			else{
				festivita.filiale="";
			}
			festivita.inizio=helper.msToTime(festivita.StartTime__c);
			festivita.fine=helper.msToTime(festivita.EndTime__c);
			festivita.Branch__r=undefined; //evita problemi durante l'update degli appuntamenti appena aggiunti
		})
		return festivitaList;
	},
	
	msToTime:function(ms) {
		var seconds = (ms/1000);
        var minutes = parseInt(seconds/60, 10);
        seconds = seconds%60;
        var hours = parseInt(minutes/60, 10);
        minutes = minutes%60;
		hours = ('0' + hours).slice(-2)
		minutes = ('0' + minutes).slice(-2)
		var willBeReturned=hours + ':' + minutes;
		return willBeReturned;
	},
	
	checkPattern: function(element, helper) {
		var re = new RegExp("^(0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]$");
		var result= re.test(element);
		if(!result){
			helper.showToast("Orario inserito in formato non corretto, utilizzare il formato HH:MM", "error");
		}
		return result;
	},
	
	createCustomList: function(cmp,event,helper, branchList){
		var filiali=[];
		branchList.forEach(branch => {
			filiali.push({label: branch.Name, value: branch.OCS_External_Id__c});
		});
		cmp.set("v.filialiOptions", filiali);
	},
	
	handleRowAction: function (cmp, event, helper) {
		var action = event.getParam('action');
		var row = event.getParam('row');
		var rows=[];
		rows.push({"Id":row.Id});
        switch (action.name) {
			case 'delete':
                helper.deleteFestivita(cmp, event, helper,rows);
                break;
				default:
                break;
			}
	},

	handleCancelMultiRow: function(cmp,event,helper){
		var filiali=cmp.find("tabFestivita").getSelectedRows();
		if(filiali.length!=0){
			helper.deleteFestivita(cmp,event,helper,filiali);
		}
		else{
			helper.showToast("Nessuna filiale selezionata","error");
		}
	},
	
	deleteFestivita: function (cmp, event, helper,rows) {
		var listaFestivita = cmp.get("v.allFestivities");
		var listaFestivitaToDelete= [];
		
		rows.forEach(row =>{
			var FestivitaToDelete = listaFestivita.find(function( obj ) {
				return obj.Id === row.Id; 
			});
			if(FestivitaToDelete.Id && !FestivitaToDelete.Id.includes("row-"))
			{
				listaFestivitaToDelete.push(FestivitaToDelete);
			}
			listaFestivita = listaFestivita.filter(function( obj ) {
				return obj.Id !== row.Id;
			});
		})
		 
		helper.deleteValues(cmp, event, helper, listaFestivitaToDelete,listaFestivita);
	},

	deleteValues: function(cmp,event,helper,data,listaFestivita){
		var spinner = cmp.find('spinnerComponent');
		spinner.incrementCounter();
		var action = cmp.get("c.deleteFestivities");
		action.setParams({
			"toDeleteData": data
		})
		action.setCallback(this, function(response) {
			var state = response.getState();
			spinner.decreaseCounter();
			if (state === "SUCCESS") {
				helper.showToast("Cancellazione avvenuta con successo", "success");
				cmp.set("v.allFestivities",listaFestivita);
				helper.refreshdMsg();
			}
			else if(response.getState()=='ERROR'){
				var errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						helper.showToast("Errore: " + errors[0].message,'error');
					}else {
						helper.showToast('Errore generico','error');
					}
				} else {
					helper.showToast('Errore generico','error');
				}
			}
		}); 
		$A.enqueueAction(action);
	},
	sortData: function (cmp, fieldName, sortDirection) {
        var data = cmp.get("v.allFestivities");
        var reverse = sortDirection !== 'asc';
        //sorts the rows based on the column header that's clicked
        data.sort(this.sortBy(fieldName, reverse))
        cmp.set("v.allFestivities", data);
    },
    sortBy: function (field, reverse, primer) {
        var key = primer ? function(x) {return primer(x[field])} : function(x) {return x[field]};
        //checks if the two rows should switch places
        reverse = !reverse ? 1 : -1;
        return function (a, b) {
			return a = key(a), b = key(b), reverse * ((a > b || !a) - (b > a || !b));
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
	refreshdMsg: function() { 
		var sendRefreshIndisponibilita = $A.get("e.ltng:sendMessage"); 
        if (sendRefreshIndisponibilita){
			sendRefreshIndisponibilita.setParams({
				"message": "refresh", 
                     "channel": "XCS_GestioneIndisponibilita" 
            }); 
        	sendRefreshIndisponibilita.fire(); 
        }
        
    },
	
})