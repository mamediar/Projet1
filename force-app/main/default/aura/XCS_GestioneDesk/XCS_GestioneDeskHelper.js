({
	onInit: function (cmp, event, helper) {
		
		cmp.set('v.columns', [{label: 'Desk', fieldName: 'DeskName__c', type: 'text'},
		{label: 'Attivo', fieldName: 'isActive__c', type: 'boolean', editable: true}]);

		cmp.set('v.columnsDeskItem', [{label: 'Orario di apertura', fieldName: 'timeInizio', type: 'text', editable: true},
		{label: 'Orario di chiusura', fieldName: 'timeFine', type: 'text', editable: true},
		{label: 'Lunedì', fieldName: 'Monday__c', type: 'boolean', editable: true},
		{label: 'Martedì', fieldName: 'Tuesday__c', type: 'boolean', editable: true},
		{label: 'Mercoledì', fieldName: 'Wednesday__c', type: 'boolean', editable: true},
		{label: 'Giovedì', fieldName: 'Thursday__c', type: 'boolean', editable: true},
		{label: 'Venerdì', fieldName: 'Friday__c', type: 'boolean', editable: true},
		{label: 'Sabato', fieldName: 'Saturday__c', type: 'boolean', editable: true},
		{label: 'Domenica', fieldName: 'Sunday__c', type: 'boolean', editable: true},
		{label: '', type: 'button',initialWidth:80, typeAttributes:{title: 'Cancella',name:'delete',iconName: 'utility:delete'}}
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

	aggiungiDesk : function(cmp, event, helper) {
		
		var spinner = cmp.find('spinnerComponent');
		spinner.incrementCounter();
		var action=cmp.get('c.addDesk');
		var deskNumber=cmp.get('v.filialeSelected.XCS_Desk__r') ? cmp.get('v.filialeSelected.XCS_Desk__r').length+1 : '1';
		var deskName = 'Desk' + deskNumber;
		action.setParams({filialeSelected : cmp.get('v.filialeSelected'),deskName : deskName});
		action.setCallback(this,function(resp){
			spinner.decreaseCounter();
            if(resp.getState()=='SUCCESS'){
				var newDesk = resp.getReturnValue();
				var deskList = cmp.get('v.filialeSelected.XCS_Desk__r');
				if(deskList)	
					deskList.push(newDesk);
				else
					deskList = [newDesk];
				cmp.set('v.filialeSelected.XCS_Desk__r',deskList);
			}
			else if(resp.getState()=='ERROR'){
				var errors = resp.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
							helper.showToast("Errore: " + errors[0].message,'error');
					}else {
						helper.showToast('Massimo numero di desk raggiunti','error');
					}
				} else {
					helper.showToast('Errore generico','error');
				}
			}
		});
		$A.enqueueAction(action);
	},


	aggiungiDeskItem : function(cmp, event, helper) {
		
		var spinner = cmp.find('spinnerComponent');
		spinner.incrementCounter();
		var action=cmp.get('c.addDeskItem');
		action.setParams({deskSelected : cmp.get('v.deskSelezionato')});
		action.setCallback(this,function(resp){
			spinner.decreaseCounter();
            if(resp.getState()=='SUCCESS'){
				var newDeskItem = resp.getReturnValue();
				var deskItemList = cmp.get('v.deskItemList');
				if(deskItemList)	
					deskItemList.push(newDeskItem);
				else
					deskItemList = [newDeskItem];
				helper.populateExtraFields(deskItemList,helper);
				cmp.set('v.deskItemList',deskItemList);

				helper.updateItemPerDesk(cmp, event, helper);
				
			}
			else if(resp.getState()=='ERROR'){
				var errors = resp.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
							helper.showToast("Errore: " + errors[0].message,'error');
					}else {
						helper.showToast('Massimo numero di desk raggiunti','error');
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
		cmp.set('v.deskSelezionato', null);
	},
	
	onChangeAreaSelect: function(cmp, event, helper) {
        var areaSelected = cmp.get('v.areaSelected');
        var filialeList = cmp.get('v.initWrapper.branchListPerArea')[areaSelected];
		cmp.set('v.filialeList',filialeList);
		cmp.set('v.filialeSelected',filialeList[0]);
		cmp.set('v.deskSelezionato', null);
	},
	
	onChangeFilialeSelect: function(cmp, event, helper) {
		var filialeSelectedOCScode = event.getSource().get('v.value');
		if(filialeSelectedOCScode){
			var filialeSelected = cmp.get('v.filialeList').find(x=>{
				return x.OCS_External_Id__c == filialeSelectedOCScode;
			});
			cmp.set('v.filialeSelected',filialeSelected);
		}else{
			var filialeSelected = cmp.get('v.filialeSelected');
		}

		cmp.set('v.deskSelezionato', null);
		
		var spinner = cmp.find('spinnerComponent');
        spinner.incrementCounter();
		var action = cmp.get("c.initDeskItemPerDesk");
        action.setParams({filialeSelected: cmp.get("v.filialeSelected")})
        action.setCallback(this, function(response) {
			spinner.decreaseCounter();
            var state = response.getState();
            if (state === "SUCCESS") {
				cmp.set("v.deskItemPerDesk",response.getReturnValue());
            }
            else if(response.getState()=='ERROR'){
                var errors = response.getError();
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

	selectDesk: function(cmp, event, helper){

		if(event.getParam('selectedRows').length != 0){

			var selRow=event.getParam('selectedRows')[0];
			cmp.set('v.deskSelezionato', selRow);
			var map = cmp.get("v.deskItemPerDesk");
			if(map[selRow.Id])
				helper.populateExtraFields(map[selRow.Id], helper);
			cmp.set("v.deskItemList",map[selRow.Id]);
		}
    },

	updateDesk: function (cmp, event, helper) {
		
		var spinner = cmp.find('spinnerComponent');
		spinner.incrementCounter();
        var action = cmp.get("c.updateDeskApex");
		var draftValues = event.getParam('draftValues');
		
        action.setParams({ deskList : draftValues}); 
        action.setCallback(this, function(response) {
            spinner.decreaseCounter();
            var state = response.getState();
            if (state === "SUCCESS") {
				var data = cmp.get("v.filialeSelected.XCS_Desk__r");
				data.filter( x=>{
					draftValues.filter(y=>{
						if(x.Id === y.Id){
							x.isActive__c = y.isActive__c;
						} 
					});
				});
				cmp.set("v.filialeSelected.XCS_Desk__r",data);
				helper.showToast("SALVATAGGIO RIUSCITO","success");
				cmp.find('deskTable').set('v.draftValues',[]);
				helper.refreshdMsg();
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                        helper.showToast("Error message: " + errors[0].message,"error");
                    }
                    else
                    { helper.showToast("Errore generico","error");}
                } else {
                    helper.showToast("Errore generico:","error");
                }
            }
        });
        $A.enqueueAction(action);
        
	},
	
	saveDeskItemTable: function (cmp, event, helper) {
		
		var draftValues = event.getParam('draftValues');
		var isError = false;

		draftValues.forEach(x=>{

			
			if(helper.checkTimePattern(x.timeInizio,helper))
				x.StartTime__c = helper.timeToMs(x.timeInizio);
			else
				isError = true;
			
			if(helper.checkTimePattern(x.timeFine,helper))
				x.EndTime__c = helper.timeToMs(x.timeFine);
			else
				isError = true;

			if(!isError && x.StartTime__c != undefined && x.EndTime__c != undefined && x.EndTime__c <= x.StartTime__c){
				isError = true;
				helper.showToast("Orario di Chiusura deve essere maggiore di orario Apertura","error");
			}else if(!isError && x.StartTime__c != undefined && x.EndTime__c == undefined){
				var endTime;
				cmp.get("v.deskItemList").forEach(y=>{
					if(y.Id == x.Id){
						endTime = y.EndTime__c;
					}
				});

				if(endTime <= x.StartTime__c){
					isError = true;
					helper.showToast("Orario di Chiusura deve essere maggiore di orario Apertura","error");
				}
			}else if(!isError && x.StartTime__c == undefined && x.EndTime__c != undefined){
				var startTime;
				cmp.get("v.deskItemList").forEach(y=>{
					if(y.Id == x.Id){
						startTime = y.StartTime__c;
					}
				});

				if(x.EndTime__c <= startTime){
					isError = true;
					helper.showToast("Orario di Chiusura deve essere maggiore di orario Apertura","error");
				}
			}
			
		});

		if(isError)
			return;

		var action = cmp.get("c.updateDeskItemApex");
		var spinner = cmp.find('spinnerComponent');
		spinner.incrementCounter();

        action.setParams({ deskItemList : draftValues}); 
        action.setCallback(this, function(response) {
            spinner.decreaseCounter();
            var state = response.getState();
            if (state === "SUCCESS") {
				var data = cmp.get("v.deskItemList");
				
				draftValues.filter(y=>{
					data.filter( x=>{
						if(x.Id === y.Id){
							x.StartTime__c = y.StartTime__c != undefined ? y.StartTime__c : x.StartTime__c;
							x.timeInizio = y.timeInizio != undefined ? y.timeInizio : x.timeInizio;
							x.EndTime__c = y.EndTime__c != undefined ? y.EndTime__c : x.EndTime__c;
							x.timeFine = y.timeFine != undefined ? y.timeFine : x.timeFine;
							x.Monday__c = y.Monday__c != undefined ? y.Monday__c : x.Monday__c;
							x.Tuesday__c = y.Tuesday__c != undefined ? y.Tuesday__c : x.Tuesday__c;
							x.Wednesday__c = y.Wednesday__c != undefined ? y.Wednesday__c : x.Wednesday__c;
							x.Thursday__c = y.Thursday__c != undefined ? y.Thursday__c : x.Thursday__c;
							x.Friday__c = y.Friday__c != undefined ? y.Friday__c : x.Friday__c;
							x.Saturday__c = y.Saturday__c != undefined ? y.Saturday__c : x.Saturday__c;
							x.Sunday__c	 = y.Sunday__c != undefined ? y.Sunday__c : x.Sunday__c;
						} 
					});
				});
				cmp.set("v.deskItemList",data);
				helper.showToast("SALVATAGGIO RIUSCITO","success");
				cmp.find('deskItemTable').set('v.draftValues',[]);
				helper.refreshdMsg();
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                        helper.showToast("Error message: " + errors[0].message,"error");
                    }
                    else
                    { helper.showToast("Errore generico","error");}
                } else {
                    helper.showToast("Errore generico:","error");
                }
            }
        });
        $A.enqueueAction(action);
        
	},
	
	handleRowAction: function (cmp, event, helper) {
        var action = event.getParam('action');
        var deskItemList = cmp.get("v.deskItemList");
         
        var deskItemRow = deskItemList.find(function( obj ) {
           return obj.Id === event.getParam('row').Id;
        });

        switch (action.name) {
            case 'delete':
                helper.deleteDeskItem(cmp, event, helper,deskItemRow);
                break;
            default:
                break;
        }
    },

    deleteDeskItem: function (cmp, event, helper,deskItemRow) {
        var spinner = cmp.find('spinnerComponent');
        spinner.incrementCounter();
        var action = cmp.get("c.deleteDeskItemApex");
        action.setParams({deskItemRow : deskItemRow}); 
        action.setCallback(this, function(response) {
			spinner.decreaseCounter();
            var state = response.getState();
            if (state === "SUCCESS") {
				helper.showToast("Disponibilità cancellata","success");
				var deskItemList = cmp.get("v.deskItemList");
				var newDeskItemList = [];
				deskItemList.filter(x =>{
					if(x.Id != deskItemRow.Id){
						newDeskItemList.push(x);
					}
				});

				cmp.set("v.deskItemList",newDeskItemList);
				helper.updateItemPerDesk(cmp, event, helper);
				
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

	updateItemPerDesk : function(cmp, event, helper){
		let selRow = cmp.get('v.deskSelezionato');
		let map = cmp.get("v.deskItemPerDesk");
		map[selRow.Id] = cmp.get("v.deskItemList");
		cmp.set('v.deskItemPerDesk',map);
	},
	
	populateExtraFields:function(inputList,helper){
		inputList.forEach(x=>{
			x.timeInizio =helper.msToTime(x.StartTime__c);
			x.timeFine =helper.msToTime(x.EndTime__c);
		})
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

	timeToMs: function(time){
		if(time == undefined)
			return undefined;
		var timeParts = time.split(":");
		var msCount=((+timeParts[0] * (60000 * 60)) + (+timeParts[1] * 60000));
		return msCount;
	},

	checkTimePattern: function(element, helper) {
		if(element == undefined)
			return true;
		var re = new RegExp("^(0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]$");
		var result= re.test(element);
		if(!result){
			helper.showToast("Orario inserito in formato non corretto, utilizzare il formato HH:MM", "error");
		}
		return result;
	},
	
	showToast : function(message,type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "message": message,
            "type" : type,
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