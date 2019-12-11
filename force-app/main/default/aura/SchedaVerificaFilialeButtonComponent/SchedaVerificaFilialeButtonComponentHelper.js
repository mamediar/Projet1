({	openModalExtension : function(component, event, helper) {
		var popup = component.find('ModalboxExtension');
		var back  = component.find('ModalbackdropExtension');
		$A.util.addClass(popup,'slds-fade-in-open');
		$A.util.addClass(back,'slds-backdrop--open');
	},

	closeModal : function (component, event, helper) {
		
		var popup = component.find('ModalboxExtension');
		var back  = component.find('ModalbackdropExtension');
		$A.util.removeClass(popup,'slds-fade-in-open');
		$A.util.removeClass(back,'slds-backdrop--open');
	},
	checkQuestionnaire : function(component, event, helper) {
		var check = component.get("c.checkRequired");
		component.set('v.showSpinner',true);
		check.setParams({
			"schedaFilialeId" : component.get("v.recordId")
		});
		check.setCallback(this,function (response) {
			this.closeModal(component, event, helper);
			var state = response.getState();
			if(state == 'SUCCESS'){
				var result = response.getReturnValue();
				
				if(result == '[]'){
					console.log('Invio in approvazione');
					this.callApprovers(component), event, helper;
				}else{
					if(result == 'questionario'){
						this.showToast('Questionario Incompleto','error','Rispondi a tutte le domande e riprova.');
					} else {
						
							this.showToast('Attenzione mancano dei dati obbligatori','error',JSON.parse(result).join());
						
					}
					
					component.set('v.showSpinner',false);
				}
			}else{
				//error
				this.showToast('Errore','error','Errore: si è verificato un\'errore, riprovare nuovamente oppure contattare l\'amministratore del sistema.');
				console.log(response.getReturnValue());
				component.set('v.showSpinner',false);
			}
			component.set('v.showSendApprovers',false);
		});

		$A.enqueueAction(check);
	},

	callApprovers : function (component, event, helper) {
		var approvals = component.get('c.sendApprovalUser');
		approvals.setParams({
			"schedaFilialeId" : component.get('v.recordId')
		});
		
		approvals.setCallback(this, function (response) {
			var state = response.getState();
			if(state == 'SUCCESS'){
				var result = response.getReturnValue();
				if(result){
					this.showToast('Errore','error',result);
				} else {
					this.showToast('Approvazione Richiesta','success','La tua approvazione è stata richiesta con successo.');
					
					setTimeout(function(){ location.reload(true); }, 1500);
				}
			}else{
				//error
				console.log(response.getReturnValue);
				this.showToast('Errore','error',response.getReturnValue);
			}
			component.set('v.showSpinner',false);
			
			
		});

		$A.enqueueAction(approvals);
	},

	showToast : function(title,type,message){
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
				"title":title,
				"message":message,
				"type":type
			}
		);
		toastEvent.fire();

	},
	getSchedaPrecedente : function (component) {
		var method = component.get('c.getSchedaFilialePrecedente');
		method.setParams({
			'filialeId' : component.get('v.simpleRecord.Filiale__c'),
			"schedaFilialeId" : component.get("v.recordId")
		});

		method.setCallback(this, function (response) {
			var state = response.getState();
			if(state == 'SUCCESS'){
				var result = response.getReturnValue();
				if (result){
					var navEvt = $A.get("e.force:navigateToSObject");
					navEvt.setParams({
					"recordId": result,
					"slideDevName": "detail"
					});
					navEvt.fire();
				} else {
					this.showToast('Errore','error','Nessuna scheda precedente Completata o Chiusa trovata');
				}
			} else {
				var result = response.getReturnValue();
			}
		});
		$A.enqueueAction(method);
	}
})