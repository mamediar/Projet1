({
	showToast : function(message, type){
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			message: message,
			type : type
		});
		toastEvent.fire();
	},

	getComodityCheck: function (component) {
		//alert('intervista: '+JSON.stringify(component.get("v.nuovaIntervista")));
		var action = component.get('c.getCommodityCheck');
		action.setParam('InterviewObj', component.get("v.nuovaIntervista"));
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				//alert("ok");
				component.set('v.comodityCheklist', response.getReturnValue());
				console.log('success' + JSON.stringify(component.get('v.comodityCheklist')));
			} else {
				helper.showToast('Non successo', 'ERROR');

			}
		});
		$A.enqueueAction(action);
	},

	/**
	 * @description: method for Save Risposta
	 * @date::28/03/2019
	 * @author: Mamadou Lamine CAMARA
	 * @params: component, event
	 * @return: none
	 * @modification:
	 */
	saveRisposta: function (component, risposta, intervista) {

		risposta.Intervista__c = intervista;
		console.log('risposte',risposta);
		var action = component.get('c.addResponseAssicurativo');
		action.setParams({
			"respdomanda":risposta
		});
		action.setCallback(this, function(response){
			//store state of response

			var state = response.getState();
			if (state === "SUCCESS") {
				console.log('19-03.2019');
				// component.set('v.risposta', JSON.stringify(response.getReturnValue()));
				console.log('response.getReturnValue()'+ JSON.stringify(response.getReturnValue()));
				// var eventToRisposta=$A.get("e.c:eventNavigateToIntervistaRisposteComp");
				// eventToRisposta.setParams({'riposta':risposte});
				// eventToRisposta.fire();
				helper.showToast('Salvataggio con successo!', 'SUCCESS');

			} else {
				var errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						console.log("Error message: " +errors[0].message);
					}
				} else {
					console.log("Unknown error");
				}
			}
		});
		$A.enqueueAction(action);

		component.set('v.risposta',{'sobjectType':'Risposte__c',
			'RecordTypeId':'Assicurativo',
			'D0__c':'',
			'D1__c':'',
			'D2__c':'',
			'D3__c':'',
			'D4__c':'',
			'D5__c':'',
			'Intervista__c':''});
	},

	convertDateBeforeToString : function (inputFormat,numberDayBefor) {
		function pad(s) { return (s < 10) ? '0' + s : s; }
		var d = new Date(inputFormat);
		var yesterday = new Date(d.getTime());
		yesterday.setDate(d.getDate() - numberDayBefor);

		return [pad(yesterday.getDate()), pad(yesterday.getMonth()+1), yesterday.getFullYear()].join('/');
	},

	changeStato: function (component,stato) {

		var intervista=component.get('v.nuovaIntervista');
		intervista.COM_Stato_Avanzamento_IntervistaASS__c =stato;
		var action = component.get('c.updateIntervista');
		action.setParam('param',intervista);
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				component.set('v.nuovaIntervista', response.getReturnValue());
				console.log('in success',response.getReturnValue());
				this.showToast('Stato aggiornato in '+stato+'.Salvataggio con successo', 'SUCCESS');
				component.set('v.nonRisposta',false);
			} else {
				this.showToast('Salvataggio non successo', 'ERROR');
			}
		});
		$A.enqueueAction(action);

	},
	getTextListAssicurativos: function(component){
		var data=component.get("v.comodityCheklist");
		if(data.length>0){
		var stringData=''+data[0].COM_CRMDefinizione__c;
		if(data.length>1){
		data.forEach(function(element) {
			console.log(element);
			stringData=stringData+', '+ element.COM_CRMDefinizione__c;
		  });
		}
		component.set("v.TextListAssicuratico",stringData);
		}
	}

})