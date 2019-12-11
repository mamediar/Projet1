({

	onInit: function(cmp, event, helper) {

		var notaSpese = cmp.get('v.notaSpese');
		var comuniVisitati = '';
		var spinner = cmp.find('spinnerComponent');
		spinner.incrementCounter();
		var action=cmp.get('c.initApex');
        action.setParams({theNotaSpese : notaSpese,dataTimbrature: cmp.get("v.notaSpese.Date__c")});
        action.setCallback(this,function(resp){
            
            if(resp.getState()=='SUCCESS'){
				spinner.decreaseCounter();
				var initWrapper = resp.getReturnValue();
				initWrapper.dealerList.forEach(dealer => {
					if(dealer.ShippingCity)
					{
						comuniVisitati = comuniVisitati + dealer.ShippingCity;
						var count = +1;
						if(initWrapper.dealerList.length != count) 
						comuniVisitati = comuniVisitati + ',';
					}
				});
					
				var orariMyHr=[];
				if(initWrapper.timbratureList){
					initWrapper.timbratureList.forEach(print =>{
						orariMyHr.push(helper.msToTime(print.ora));
					})
				}
				cmp.set("v.orariMyHr", orariMyHr);

				notaSpese.Tratta__c = comuniVisitati;
				cmp.set('v.notaSpese',notaSpese);
				cmp.set('v.notaSpese.TipoAuto__c',initWrapper.autoPicklist[0].value);
				cmp.set('v.initWrapper',initWrapper);
            }
            else if(resp.getState()=='ERROR'){
				spinner.decreaseCounter();
                var errors = resp.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
							helper.showToast("Errore: " + errors[0].message,'error');
                    }else {
                        helper.showToast('Errore getDealers Apex','error');
                    }
                } else {
                    helper.showToast('Errore getDealers Apex','error');
                }
            }
        });
		$A.enqueueAction(action);
	
	},

	confermaNotaSpese: function(cmp,event,helper){
		var inputs=cmp.find("timbraturaId");
		var rifornimentoFillsId = cmp.find("rifornimentoFillsId");
		if(rifornimentoFillsId)
        	inputs=inputs.concat(rifornimentoFillsId);
		
		var emptyInputRequired=!cmp.find("dataTimbratureId").checkValidity();
		inputs.forEach(field =>{
            field.reportValidity();
			if(!field.checkValidity()){
				emptyInputRequired=true;
			}
		})
        var notaSpeseInput=cmp.get("v.notaSpese");
        var errorFound=false;
		if(emptyInputRequired==true){
            helper.showToast("Errore: campi di input obbligatori non compilati correttamente",'error');
            errorFound=true;
        }
        if(notaSpeseInput.KmInizioUscita__c && notaSpeseInput.KmFineUscita__c && notaSpeseInput.KmInizioUscita__c>=notaSpeseInput.KmFineUscita__c){
            helper.showToast("Errore: Km fine deve essere maggiore di Km inizio","error");
            errorFound=true;
        }
        if(notaSpeseInput.OraInizioUscita__c && notaSpeseInput.OraFineUscita__c && notaSpeseInput.OraInizioUscita__c>=notaSpeseInput.OraFineUscita__c){
            helper.showToast("Errore: orario inizio uscita deve essere maggiore dell'orario di fine uscita","error");
            errorFound=true;
        }
		if(!errorFound){
			var spinner = cmp.find('spinnerComponent');
			spinner.incrementCounter();
			var theWrapper = cmp.get('v.initWrapper');
			theWrapper.timbratureList = null;
            var action=cmp.get('c.sendNotaSpese');
            action.setParams({theNotaSpese: notaSpeseInput,theWrapperJson: JSON.stringify(theWrapper)})
            action.setCallback(this,function(resp){
                spinner.decreaseCounter();
                if(resp.getState()=='SUCCESS'){
					helper.showToast("Nota spese inserita correttamente", "success");
					helper.refreshdMsg();
					cmp.set('v.step','step0');
				}
                else if(resp.getState()=='ERROR'){
                    var errors = resp.getError();
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

	refreshdMsg: function() { 
        var sendMsgEventSlot = $A.get("e.ltng:sendMessage"); 
        if (sendMsgEventSlot){
            sendMsgEventSlot.setParams({
                     "message": "refresh", 
                     "channel": "GestioneRegistri" 
            }); 
        	sendMsgEventSlot.fire(); 
        }
        var sendMsgEventCapComune = $A.get("e.ltng:sendMessage"); 
        if(sendMsgEventCapComune){
            sendMsgEventCapComune.setParams({
                     "message": "refresh", 
                     "channel": "VisualizzaRichieste" 
            }); 
            sendMsgEventCapComune.fire(); 
        }
    },

	showToast : function(message,type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "message": message,
            "type" : type,
            "mode" : 'dismissible'
        });
        toastEvent.fire();
    }, 

	insertInizioHR: function(cmp, event, helper) {
		var orario=cmp.get("v.orarioInizioMyHr");
		if(orario!="manuale"){
			cmp.set("v.notaSpese.OraInizioUscita__c", orario);
			var inputs=cmp.find("timbraturaId");
			inputs.forEach(field =>{
				field.reportValidity();
			})
		}
	},
	insertFineHR: function(cmp, event, helper) {
		var orario=cmp.get("v.orarioFineMyHr");
		if(orario!="manuale"){
			cmp.set("v.notaSpese.OraFineUscita__c", orario);
			var inputs=cmp.find("timbraturaId");
			inputs.forEach(field =>{
				field.reportValidity();
			})
		}
	},

	checkRifornimentoFills: function(cmp,event,helper){
		var cmpList= cmp.find("rifornimentoFillsId");
		
		cmpList.forEach(element => {
			element.reportValidity();
		});
	},

	evaluateKmFine: function(cmp,event,helper){
		 
		cmp.set('v.notaSpese.KmFineUscita__c',parseFloat(cmp.get('v.notaSpese.KmInizioUscita__c')) + parseFloat(cmp.get('v.initWrapper.kmPercorsi')));
	},

	msToTime:function(ms) {
        var seconds = (ms/1000);
        var minutes = parseInt(seconds/60, 10);
        seconds = seconds%60;
        var hours = parseInt(minutes/60, 10);
        minutes = minutes%60;
		hours = ('0' + hours).slice(-2)
		minutes = ('0' + minutes).slice(-2)
        return {label:hours + ':' + minutes,
                value:hours + ':' + minutes + ':00.000'};
	},
	
	upperCaseConverter: function(cmp,event,helper){
		var targa= cmp.get("v.notaSpese.TargaVeicolo__c");
		cmp.set("v.notaSpese.TargaVeicolo__c", targa.toUpperCase());
	},
})