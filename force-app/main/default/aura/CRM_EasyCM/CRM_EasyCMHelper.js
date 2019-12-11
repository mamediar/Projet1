({
	doInit: function(cmp, event, helper) {
        var spinner = cmp.find('spinnerComponent');
        spinner.incrementCounter();
        var action = cmp.get("c.initApex");
        action.setParams({caseId : cmp.get("v.recordId")})
        action.setCallback(this, function(response) {
            var state = response.getState();
            spinner.decreaseCounter();
            if (state === "SUCCESS") {
                var initWrapper= response.getReturnValue();
               
                if(initWrapper.account){
                    cmp.set('v.initWrapper',initWrapper);
                    cmp.set('v.accordionSectionName',['Dati','InformazioniPratiche']);
                    helper.checkFido(cmp,event,helper);
                    $A.get('e.force:refreshView').fire();

                }
                else{
                    cmp.set('v.accordionSectionName',['Ricerca','InformazioniPratiche']);
                    if(initWrapper.telephoneNumber){
                        var inputWrapper={
                            'Telefono': initWrapper.telephoneNumber
                        }
                        cmp.find("easyCmResearch").researchExternalCall(inputWrapper);
                    }
                }
                
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

	recordUpdated: function(cmp, event, helper) {
        var changeType = event.getParams().changeType;
        if (changeType === "ERROR") { 
			console.log('error');
			helper.showToast(cmp.find("theCaseRecordDataID").CaseError);
		 }
        else if (changeType === "LOADED") {
			 console.log('loaded'); 
			
			}
        else if (changeType === "REMOVED") {
			 console.log('removed'); 
			}
        else if (changeType === "CHANGED") { 
            console.log('changed'); 
		}
		var newSectionName;
		if(cmp.get('v.CaseRecord.AccountId') == undefined){
			newSectionName= ['Ricerca','InformazioniPratiche'];
		}
		else{
			newSectionName= ['Dati','InformazioniPratiche'];
		}
		cmp.find('accordion').set('v.activeSectionName', newSectionName);
	},
	
	onChangeAccount: function(cmp, event, helper){
        cmp.set('v.fidoMessage',[]);
        var spinner = cmp.find('spinnerComponent');
        spinner.incrementCounter();
        var action = cmp.get("c.initFromAccount");
        action.setParams({caseId : cmp.get("v.recordId"), theAccount : cmp.get("v.accountSelezionato")})
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var initWrapper= response.getReturnValue();
                cmp.set('v.initWrapper',initWrapper);
                if(!initWrapper.datiCliente.codCliente){
                    helper.showToast('Codice OCS non riconosciuto o non presente','warning');
                }
                
                cmp.set('v.accordionSectionName',['Dati','InformazioniPratiche']);
                helper.checkFido(cmp,event,helper);
                spinner.decreaseCounter();
                $A.get('e.force:refreshView').fire();
            
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

    checkFido : function(cmp,event,helper) {
        var praticheList = cmp.get('v.initWrapper.praticheList');
        
        if(praticheList){
            praticheList.forEach(pratica => {
                if(pratica.tipoPratica === 'CA'){
                    helper.checkFidoApex(cmp,event,helper,pratica);
                }
            });
        }
            
    },
    
    checkFidoApex : function(cmp,event,helper,row) {
        
        var praticheList = cmp.get('v.initWrapper.praticheList');
        var spinner = cmp.find('dettaglioPraticheId').find('spinnerCounterDettaglioPratiche');
        spinner.incrementCounter();
        praticheList.forEach(pratica => {
            if(pratica.numPratica === row.numPratica){
                //pratica = row;
                var action = cmp.get("c.getFidoWrapper");
                action.setParams({thePratica : row})
                action.setCallback(this, function(response) {
                spinner.decreaseCounter(); 
                var state = response.getState();
                if (state === "SUCCESS") {
                    var fidoWrapper= response.getReturnValue();
                    row.disponibilita = fidoWrapper.disponibilita;
                    
                    if(fidoWrapper.toastType === "Success"){
                        row.status='textFidoOk';
                        row.icon = 'utility:success';
                        row.infoComm = 'Fido Disponibile';
                    }
                    else{
                        row.status='textFidoKo';
                        row.icon = 'utility:error';
                        row.infoComm = fidoWrapper.messaggioErroreShort;
                    }
                    //MANTIS 0002096
                    //helper.showToast(fidoWrapper.messaggioErrore,fidoWrapper.toastType);
                    var fidoMessage = cmp.get('v.fidoMessage');
                    var color = fidoWrapper.toastType == 'Error'? 'custom-red' : 'custom-green';
                    var json = {descrizione:fidoWrapper.messaggioErrore, colore: color};
                    fidoMessage.push(json);
                    cmp.set('v.fidoMessage',fidoMessage);
                    cmp.set('v.initWrapper.praticheList',praticheList);
                
                    
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
        });
        
    },  
    
    showToast : function(message,type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "message": message,
            "type" : type,
            "mode" : "sticky"
        });
        toastEvent.fire();
    },
    disableCloseFocusedTab : function(component, event, helper) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.disableTabClose({
                tabId: focusedTabId,
                disabled: true
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