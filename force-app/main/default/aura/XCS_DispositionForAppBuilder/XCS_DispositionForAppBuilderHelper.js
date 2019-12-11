({
	InitHelper : function(component) 
    {
		var visibility = component.get('v.visibility');
		var spinner = component.find('spinnerComponent');
        spinner.incrementCounter();
		var action = component.get("c.getDispositionApex");
        action.setParams({
            "rootExternalId": component.get('v.rootExternalId')
        });
        action.setCallback(this, function(response) {
			var state = response.getState();
			if ( state == 'SUCCESS' ) { 
				spinner.decreaseCounter();
				var mapDispositions=response.getReturnValue();
				var rootDispositionList=mapDispositions[component.get('v.rootExternalId')];
				component.set('v.mapDispositions',mapDispositions);
				if (visibility) {
					rootDispositionList = this.filterDispVisibility(component, rootDispositionList, visibility);
				}
				component.set('v.listaDispositions1',rootDispositionList);
				for(var i=1; i<7; i++){
					var previousDispositionList=component.get("v.listaDispositions"+i); 
					var dispositionKey=component.get("v.disposition"+i+"Preselection")
					var disposition=undefined;
					var nextDispositionList=undefined;
					if(dispositionKey && previousDispositionList){
						disposition=previousDispositionList.find((disp)=>{
							return disp.External_Id__c==dispositionKey;
						})
						nextDispositionList=mapDispositions[dispositionKey];
					
					}
					if(disposition){
						component.set('v.dispositionSelezionatoIdLevel'+(i), disposition);
						if(nextDispositionList){
							if (visibility) {
								nextDispositionList = this.filterDispVisibility(component, nextDispositionList, visibility);
							}
							component.set('v.listaDispositions'+(i+1), nextDispositionList);
                            component.set('v.showListaDispositions'+(i+1), true)
						}
						else{
							component.set('v.lastDispositionSelected', true);
							component.set("v.lastDisposition", disposition);
							i=8;
						}						
	
					}
				}

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

	handleSelezionaDisposition: function (component, event, helper) {
		var visibility = component.get('v.visibility');
		var value= event.getSource().get('v.value');
		var index= parseInt(event.getSource().get('v.class'));
		var listname='v.listaDispositions'+(index+1);
		var mapDispositions=component.get('v.mapDispositions');
		var nextDispositionList= mapDispositions[value]; 
		if (visibility) {
			nextDispositionList = this.filterDispVisibility(component, nextDispositionList, visibility);
		}
		component.set(listname, nextDispositionList);
		if(nextDispositionList || !value){
			!value ? component.set('v.showListaDispositions'+(index+1),false): component.set('v.showListaDispositions'+(index+1),true);
			component.set('v.lastDispositionSelected', false);
			component.set("v.lastDisposition", null);
		}
		else{
			component.set('v.lastDispositionSelected', true);
			var lastDispositionSelectedList=component.get("v.listaDispositions"+index);
			var lastDisposition=lastDispositionSelectedList.find(disposition =>{
				return disposition.External_Id__c==value;
			});
			component.set("v.lastDisposition", lastDisposition);
		}
		for(var i=index+2; i<7; i++){
			component.set('v.listaDispositions'+i, null);
			component.set('v.dispositionSelezionatoIdLevel'+i, null);
			component.set('v.showListaDispositions'+i,false);
		}
	},

	handleClickConfirm : function (cmp, event, helper) {
		this.disableCloseFocusedTab(cmp, event, helper);
		let eventoForTab =  $A.get("e.c:eventTelemarketingForTab");
		var esito= '';
		var caseStatus= '';
		var idDisposition = null;
		var disposition = null;
		for(var i=1; i<7; i++){
			var lista= cmp.get('v.listaDispositions'+i);
			var value= cmp.get('v.dispositionSelezionatoIdLevel'+i);
			if(lista && value){
				disposition= lista.find(x=> {
                    return value.External_Id__c? x.External_Id__c==value.External_Id__c : x.External_Id__c==value;
				});
				if(disposition){
					esito= esito+ (esito==''? '' : ' - ') +disposition.Name;
					caseStatus= disposition.CaseStatus__c;
					idDisposition = disposition.External_Id__c;
				}
				
			}
		}
		//chiamata verso il servizio back-end
		if ( !idDisposition )
			helper.showToast("Valorizzare una disposition", "error");
		else
		{
		console.log( 'esito: ' + esito + ' - status: ' + caseStatus + ' lastDisposition: ' + cmp.get('v.lastDisposition'));
		var spinner = cmp.find('spinnerComponent');
        spinner.incrementCounter();
		var action = cmp.get("c.updateObject");
        action.setParams({
			'sObjectId': cmp.get('v.recordId'),
			'esito': esito,
			'note': cmp.get('v.noteValue'),
			'status': caseStatus,
			'lastDisposition': idDisposition
			//cmp.get('v.lastDisposition')
        });
        action.setCallback(this, function(response) {
			var state = response.getState();
			spinner.decreaseCounter();
            if ( state == 'SUCCESS' ) {
				helper.showToast("Esito aggiornato con successo", "success")
				eventoForTab.setParams({'boolTab': true});
				eventoForTab.fire();
				if(cmp.get("v.doRefresh")){
					$A.get('e.force:refreshView').fire();
				}
				var dispositionEvent = $A.get("e.c:XCS_DispositionReady");
				if (dispositionEvent) {
					dispositionEvent.setParams({
						'disposition': cmp.get('v.lastDisposition'),
						'note':cmp.get('v.noteValue'),
						'apexClass' : cmp.get('v.lastDisposition').Azione__c,
						'apexResult' : response.getReturnValue()
					});
					dispositionEvent.fire();
				}
				
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
		}
		
	},

	refreshHandler: function(component, event, helper){
		for(var index=1; index<7; index++){
			component.set('v.listaDispositions'+index, null);
			component.set('v.dispositionSelezionatoIdLevel'+index, null);
			if(index!=1)
				component.set('v.showListaDispositions'+index,false);
			component.set('v.lastDispositionSelected', false);
			component.set('v.lastDisposition', null);
		}
		helper.InitHelper(component);
        
	},

	showToast : function(message,type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "message": message,
            "type" : type
        });
        toastEvent.fire();
	},
	
	filterDispVisibility: function(component, dispList, visibility) {
		debugger;
		for (var i=0; i<dispList.length; i++) {
			if (dispList[i].Visibility__c != visibility || dispList[i].Visibility__c === undefined) {
				dispList.splice(i, 1);
			}
		}
		return dispList;
	},
	disableCloseFocusedTab : function(component, event, helper) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.disableTabClose({
                tabId: focusedTabId,
                disabled: false
        })
        .then(function(tabInfo) {
            console.log(tabInfo);
        })
        .catch(function(error) {
            console.log(error);
        });
    })
    .catch(function(error) {
        console.log(error);
    });
    }
})