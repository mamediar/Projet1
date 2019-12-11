({
	
	onInit: function (cmp, event, helper) {
		
		cmp.set('v.columnsAppointment', [{label: 'Inizio', fieldName: 'StartTime', type: 'date',typeAttributes: {hour: '2-digit',minute: '2-digit',timeZone:"UTC"}},
		{label: 'Fine', fieldName: 'EndTime', type: 'date',typeAttributes: {hour: '2-digit',minute: '2-digit',timeZone:"UTC"}},
		{label: 'Tipo Appuntamento', fieldName: 'Type', type: 'text'},
		{label: '', type: 'button',initialWidth:80,typeAttributes:{title: 'Cancella',name:'delete',iconName: 'utility:delete'},cellAttributes:{class: { fieldName: 'buttonClass' }}}
		]);

		var spinner = cmp.find('spinnerComponent');
        spinner.incrementCounter();
        var action = cmp.get("c.initApex");
        action.setCallback(this, function(response) {
            var state = response.getState();
            spinner.decreaseCounter();
            if (state === "SUCCESS") {
                
                var initWrapper= response.getReturnValue();
				cmp.set('v.initWrapper',initWrapper);
				var regionList = Object.keys(initWrapper.areaListPerRegion);		
				regionList.reverse();
				cmp.set('v.regionList',regionList);
				cmp.set('v.regioneSelected',regionList[0]); 
				var areaList = initWrapper.areaListPerRegion[regionList[0]];
				cmp.set('v.areaList',areaList);
				cmp.set('v.areaSelected',areaList[0]);
				var filialeList = initWrapper.branchListPerArea[areaList[0]];
				cmp.set('v.filialeList',filialeList);
				cmp.set('v.filialeSelected',filialeList[0]);
				cmp.set('v.targetDate',initWrapper.today);
				cmp.set('v.today',initWrapper.today);
				

				helper.onChangeFilialeSelect(cmp, event, helper);

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

	onChangeRegionSelect: function(cmp, event, helper) {
        var regioneSelected = cmp.get('v.regioneSelected');
        var areaList = cmp.get('v.initWrapper.areaListPerRegion')[regioneSelected];
        cmp.set('v.areaList',areaList);
		cmp.set('v.areaSelected',areaList[0]);
		var filialeList = cmp.get('v.initWrapper.branchListPerArea')[areaList[0]];
		cmp.set('v.filialeList',filialeList);
		cmp.set('v.filialeSelected',filialeList[0]);
		helper.setDeskTable(cmp, event, helper);
	},
	
	onChangeAreaSelect: function(cmp, event, helper) {
        var areaSelected = cmp.get('v.areaSelected');
        var filialeList = cmp.get('v.initWrapper.branchListPerArea')[areaSelected];
		cmp.set('v.filialeList',filialeList);
		cmp.set('v.filialeSelected',filialeList[0]);
		helper.setDeskTable(cmp, event, helper);
	},
	
	onChangeFilialeSelect: function(cmp, event, helper) {
		var filialeSelectedOCScode = event.getSource().get('v.value');
		var filialeSelected;
		if(filialeSelectedOCScode){
			filialeSelected = cmp.get('v.filialeList').find(x=>{
				return x.OCS_External_Id__c == filialeSelectedOCScode;
			});
			cmp.set('v.filialeSelected',filialeSelected);
		}

		helper.setDeskTable(cmp, event, helper);
	},

	
	onChangeTargetDate: function(cmp, event, helper) {

		helper.setDeskTable(cmp, event, helper);
	},

	setDeskTable: function(cmp, event, helper) {
		
		var spinner = cmp.find('spinnerComponent');
        spinner.incrementCounter();
		var action = cmp.get("c.getAppointmentWrapper");
        action.setParams({filialeSelected: cmp.get("v.filialeSelected"),targetDate: cmp.get("v.targetDate")});
        action.setCallback(this, function(response) {
			spinner.decreaseCounter();
            var state = response.getState();
            if (state === "SUCCESS") {
				var appointmentWrapper = response.getReturnValue();
				helper.buildDeskStructure(helper,appointmentWrapper);
				cmp.set("v.deskList",appointmentWrapper.deskList);
				

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

	buildDeskStructure: function(helper,appointmentWrapper){

		appointmentWrapper.deskList.forEach(x=>{
			x.Appuntamenti = x.Appuntamenti ? x.Appuntamenti :[];
			x.Appuntamenti = x.Appuntamenti.concat(appointmentWrapper.appuntamentiAllDeskList);
			helper.riempiSpaziVuoti(x.Appuntamenti);
			helper.populateExtraFields(x.Appuntamenti);
		})

		


	},

	/*riempiSpaziVuoti: function(appointmentList){

		var startTime = 32400000;
		var endTime = 64800000;
		var slotTime = 1800000;

		for(var targetTime = startTime; targetTime < endTime; targetTime = targetTime + slotTime){

			var searchTime = appointmentList.find(x=>{
				
				return x.StartTime__c <= targetTime && targetTime < x.EndTime__c;

			})

			if(!searchTime){
				appointmentList.push({
					StartTime__c:targetTime,
					EndTime__c: targetTime+slotTime,
					Type__c : ''
				});
			}

			appointmentList.sort(function(a, b){return a.StartTime__c - b.EndTime__c});
		}	
		
	},*/

	riempiSpaziVuoti: function(appointmentList){

		var startTime = 32400000;
		var endTime = 64800000;
		var slotTime = 1800000;

		for(var targetTime = startTime; targetTime < endTime; targetTime = targetTime + slotTime){

			var searchTime = appointmentList.find(x=>{
				
				return x.StartTime <= targetTime && targetTime < x.EndTime;

			})

			if(!searchTime){
				var lastAppointment = appointmentList.slice(-1)[0]; 
				if(lastAppointment && lastAppointment.Type == '' && lastAppointment.EndTime == targetTime){
					lastAppointment.EndTime = targetTime+slotTime;
				}
				else{
					appointmentList.push({
						StartTime:targetTime,
						EndTime: targetTime+slotTime,
						Type : ''
					});
				}
			}

			if((targetTime+slotTime) == endTime)
				appointmentList.sort(function(a, b){return a.StartTime - b.EndTime});
		}	
		
	},

	addIndisponibilita: function(cmp, event, helper){
		
		if(!cmp.find("inputOraInizio").checkValidity() || !cmp.find("inputOraFine").checkValidity()){
			helper.showToast("Compilare i campi orario correttamente","error");
			return;
		}

		var spinner = cmp.find('spinnerComponent');
		var myAppointment = {
			Type__c : 'Ind',
			StartTime__c : helper.timeToMs(cmp.get("v.inputOraInizio")),
			EndTime__c : helper.timeToMs(cmp.get("v.inputOraFine")),
			Note__c : cmp.get("v.inputNote"), 
			Branch__c : cmp.get("v.filialeSelected.Id"),
			Date__c : cmp.get("v.targetDate")
		}

		if(!cmp.get("v.inputCheckAllDesk"))
			myAppointment.XCS_Desk__c = cmp.get("v.selectedDesk.Id");

		if(!helper.checkValidIndisponibilita(cmp,helper,myAppointment)){
			helper.showToast("Non è possibile inserire l'indisponibilità perchè ci sono appuntamenti presenti","error");
			return;
		}

        spinner.incrementCounter();
		var action = cmp.get("c.insertIndisponibilitaApex");
        action.setParams({theAppointment : myAppointment});
        action.setCallback(this, function(response) {
			spinner.decreaseCounter();
            var state = response.getState();
            if (state === "SUCCESS") {
				helper.showToast("Indisponibilità inserita con successo","success");
				helper.setDeskTable(cmp, event, helper);
				helper.closePopUp(cmp, event, helper);
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

	deleteIndisposizione: function (cmp, event, helper,indisponibilitaRow) {
		
		var spinner = cmp.find('spinnerComponent');
        spinner.incrementCounter();
        var action = cmp.get("c.deleteIndisponibilitaApex");
        action.setParams({theAppointmentToDelete : indisponibilitaRow}); 
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                spinner.decreaseCounter();
                helper.showToast("Indisponibilità eliminata con successo","success");
				helper.setDeskTable(cmp, event, helper);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        helper.showToast("Error message: " + errors[0].message,"error");
                    }
                    else helper.showToast("Errore generico","error");
                } else helper.showToast("Errore generico:","error");
                
            }
        });
        $A.enqueueAction(action);
		

	},

	liberaDeskSelected: function(cmp, event, helper) {

		var deskSelected = event.getSource().get("v.class");
		var deskList = cmp.get("v.deskList");
		var newAppointmentList = [];

		for(var i = 0; i < deskList.length && deskSelected.Appuntamenti.length > 0;i++){
			var desk = deskList[i];
			if(desk.Id != deskSelected.Id){

				deskSelected.Appuntamenti = deskSelected.Appuntamenti.filter(appuntamento =>{
					if(appuntamento.Type == 'App'){
						if(helper.checkEmptySpace(appuntamento,desk.Appuntamenti)){
							appuntamento.XCS_Desk = desk.Id;
							desk.Appuntamenti.push(appuntamento);
							newAppointmentList.push(appuntamento);
						}else	
							return true;
					}

				});
			}
		};

		if(newAppointmentList.length == 0)
			helper.showToast("Non è stato possibile spostare nessun appuntamento","error");
		else
			helper.updateAppointmentList(cmp, event, helper,newAppointmentList,deskSelected.Appuntamenti__r);

	},

	updateAppointmentList: function (cmp, event, helper,newAppointmentList,oldAppointmentList) {
		
		var spinner = cmp.find('spinnerComponent');
        spinner.incrementCounter();
        var action = cmp.get("c.updateAppointmentListApex");
        action.setParams({theAppointmentListToUpdate : newAppointmentList}); 
        action.setCallback(this, function(response) {
			spinner.decreaseCounter();
            var state = response.getState();
            if (state === "SUCCESS") {
				if(oldAppointmentList.length > 0)
					helper.showToast("Non è stato possibile spostare tutti gli appuntamenti, contattare la filiale","error");
				else
                	helper.showToast("Tutti gli appuntamenti sono stati correttamente spostati","success");
				helper.setDeskTable(cmp, event, helper);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        helper.showToast("Error message: " + errors[0].message,"error");
                    }
                    else helper.showToast("Errore generico","error");
                } else helper.showToast("Errore generico:","error");
                
            }
        });
        $A.enqueueAction(action);
		

	},

	checkValidIndisponibilita: function(cmp,helper,indisponibilita){
		
		var deskList = cmp.get("v.deskList");

		if(indisponibilita.XCS_Desk__c){
			
			var deskSelected = deskList.find(desk =>{
				return desk.Id === indisponibilita.XCS_Desk__c;
			});

			return helper.checkEmptySpace(indisponibilita,deskSelected.Appuntamenti);
		}else{

			var esitoCheck = true;

			for(var i = 0; i < deskList.length && esitoCheck; i++){

				esitoCheck = helper.checkEmptySpace(indisponibilita,deskList[i].Appuntamenti);
			};
			
			return esitoCheck;
		}
		
	},

	checkEmptySpace: function(indisponibilita,appointmentList){
		
		var overlappingAppointment = appointmentList.find(app =>{
			
			return app.Type != '' && !(indisponibilita.EndTime__c <= app.StartTime || app.EndTime <= indisponibilita.StartTime__c);
		});
		
		return overlappingAppointment ? false : true;
	},
	
	populateExtraFields:function(inputList){
		inputList.forEach(x=>{
			if(x.Type != "Ind")
				x.buttonClass = 'deleteButton';
		})
	},

	openPopUp: function(cmp, event, helper){
		cmp.set("v.inputOraInizio","09:00");
		cmp.set("v.inputOraFine","18:00");
		cmp.set("v.inputCheckAllDesk",false);
		cmp.set("v.inputNote","");
		cmp.find("inputOraInizio").reportValidity();
		cmp.find("inputOraFine").reportValidity();

		cmp.find("addIndisponibilitaModal").openModal();
		var desk = event.getSource().get("v.class");
		cmp.set("v.selectedDesk",desk);
	},

	closePopUp: function(cmp, event, helper){
		cmp.find("addIndisponibilitaModal").closeModal();
	},

	handleRowAction: function (cmp, event, helper) {
        var action = event.getParam('action');
		var clickedRow = event.getParam('row');

        switch (action.name) {
            case 'delete':
                helper.deleteIndisposizione(cmp, event, helper,clickedRow);
                break;
            default:
                break;
        }
    },

	sendMessageHandler: function(cmp, event, helper){
		if(event.getParam("message") === "refresh" && event.getParam("channel") === "XCS_GestioneIndisponibilita"){
			helper.onChangeFilialeSelect(cmp, event, helper);
		}
	},

	timeToMs: function(time){
		if(time == undefined)
			return undefined;
		var timeParts = time.split(":");
		var msCount=((+timeParts[0] * (60000 * 60)) + (+timeParts[1] * 60000));
		return msCount;
	},
	
	showToast : function(message,type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "message": message,
            "type" : type,
        });
        toastEvent.fire();
    },  

})