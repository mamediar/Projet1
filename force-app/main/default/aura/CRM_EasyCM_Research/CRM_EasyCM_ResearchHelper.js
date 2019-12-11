({
	//var data= {'LastName': 'Test', 'FirstName': 'TestName', 'Data_Nascita__c': '11-03-1996', 'Luogo_Nascita__pc': 'TestCity', 'Codice_Fiscale__pc': 'testCode', 'OCS_External_Id__c': 'testOCSId'}

	searchAction : function(component, event, helper) {
		var firstName= component.get('v.searchFirstName');
		if(firstName){
			firstName=firstName.trim();
		}
		var lastName= component.get('v.searchLastName');
		if(lastName){
			lastName=lastName.trim();
		}
		var birthDate= component.get('v.searchBornDate');
		if(birthDate){
			birthDate=birthDate.trim();
		}
		var fiscalCode= component.get('v.searchFiscalCode');
		if(fiscalCode){
			fiscalCode=fiscalCode.trim();
		}
		var telephoneNumber= component.get('v.searchTelephoneNumber');
		if(telephoneNumber){
			telephoneNumber=telephoneNumber.trim();
		}
		var CIP= component.get('v.searchCIP');
		if(CIP){
			CIP='C'+CIP.trim();
		}
		if((firstName&&lastName) || fiscalCode || telephoneNumber || CIP){
			var inputWrapper={
				'FirstName': firstName,
				'LastName': lastName,
				'Data_Nascita': birthDate,
				'Codice_Fiscale': fiscalCode,
				'Telefono_Casa': telephoneNumber,
				'OCS_External_Id': CIP
			}
			var spinner = component.find('spinnerComponent');
			spinner.incrementCounter();
			var action=component.get('c.searchAccounts');
			action.setParams({
				'inputWrapper': inputWrapper
			});
			action.setCallback(this,function(resp){
				if(resp.getState()=='SUCCESS'){
					var responseWrapper= resp.getReturnValue();
					responseWrapper.forEach(element => {
						if(element.OCS_External_Id__c){
							element.CIP_Compass=element.OCS_External_Id__c.replace(/C/g, "");
						}
					});
					component.set('v.accountList', responseWrapper);
					if(responseWrapper.length==0){
						helper.showToast("Errore: nessuna corrispondenza trovata",'error');
					}
					else{
						if(responseWrapper.length==1){
							component.set('v.accountSelezionato', responseWrapper[0]);
							var table=component.find('accountTable');
							component.set('v.idAccSelezionato', responseWrapper[0]);
							table.set('v.selectedRows',component.get('v.idAccSelezionato')[0]);
						}
					}
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
				spinner.decreaseCounter();
			});
			$A.enqueueAction(action);
		}
		else{
			if(firstName && !lastName){
				helper.showToast("Errore: Cognome obbligatorio",'error');
			}
			if(!firstName && lastName){
				helper.showToast("Errore: Nome obbligatorio",'error');
			}
			if(!firstName && !lastName && !fiscalCode && !telephoneNumber && !CIP){
				helper.showToast("Errore: compilare nome e cognome oppure il codice fiscale oppure il numero di telefono oppure il CIP",'error');
			}
		}
			
		//accounts= [SELECT LastName, firstName, Data_Nascita__c, Luogo_Nascita__pc, Codice_Fiscale__pc, OCS_External_Id__c FROM Account WHERE OCS_External_Id__c=: CIP]
		
	},

	externalCallAction: function(component, event, helper) {
		var data= event.getParam('arguments').externalResearch;
		console.log(data);
		component.set('v.searchFirstName', data.firstName);
		component.set('v.searchLastName', data.lastName);
		component.set('v.searchBornDate', data.birthDate);
		component.set('v.searchFiscalCode', data.fiscalCode);
		component.set('v.searchTelephoneNumber', data.Telefono);
		component.set('v.searchCIP', data.CIP);
		helper.searchAction(component, event, helper);
	},

	showToast : function(message,type){
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			message: message,
			type: type,
			mode: 'sticky'
		});
		toastEvent.fire();
	}
})