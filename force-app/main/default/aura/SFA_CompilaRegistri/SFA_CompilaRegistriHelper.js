({
	sendExpenseReport: function(cmp,event,helper){
		var inputs=cmp.find("timbraturaId");
        inputs=inputs.concat(cmp.find("rifornimentoFillsId"));
		
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
        if(notaSpeseInput.KmInizioUscita__c && notaSpeseInput.KmFineUscita__c && Number(notaSpeseInput.KmInizioUscita__c)>=Number(notaSpeseInput.KmFineUscita__c)){
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
            var action=cmp.get('c.insertNotaSpese');
            action.setParams({
                notaSpese: notaSpeseInput
            })
            action.setCallback(this,function(resp){
                spinner.decreaseCounter();
                if(resp.getState()=='SUCCESS'){
                    helper.showToast("Nota spese inserita correttamente", "success");
                    cmp.set("v.notaSpese.OraInizioUscita__c","");
                    cmp.set("v.orarioInizioMyHr","manuale");
                    cmp.set("v.orarioFineMyHr","manuale");
                    cmp.set("v.notaSpese.OraFineUscita__c","");
                    cmp.set("v.notaSpese.Tratta__c","");
                    cmp.set("v.notaSpese.KmInizioUscita__c","");
                    cmp.set("v.notaSpese.KmFineUscita__c","");
                    cmp.set("v.notaSpese.TargaVeicolo__c","");
                    cmp.set("v.notaSpese.Note__c","");
                    cmp.set("v.notaSpese.KmRifornimento__c","");
                    cmp.set("v.notaSpese.LuogoRifornimento__c","");
                    cmp.set("v.notaSpese.ImportoRifornimento__c","");
                    helper.refreshdMsg();
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
		}

	},
	checkRifornimentoFills: function(cmp,event,helper){
		var cmpList= cmp.find("rifornimentoFillsId");
		cmpList.forEach(element => {
			element.reportValidity();
		});
	},

	showToast : function(message,type){
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			message: message,
			type: type
		});
		toastEvent.fire();
	},
	
	init: function(cmp, event, helper){
		var spinner = cmp.find('spinnerComponent');
		spinner.incrementCounter();
		var action=cmp.get('c.onInitGetDate');
        action.setCallback(this,function(resp){
            spinner.decreaseCounter();
            if(resp.getState()=='SUCCESS'){
                cmp.set("v.notaSpese.Date__c", resp.getReturnValue());
                helper.getSchedules(cmp, event,helper);
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

	getSchedules: function(cmp, event, helper){
        if(cmp.find("dataTimbratureId").checkValidity()){
            var spinner = cmp.find('spinnerComponent');
            spinner.incrementCounter();
            var action=cmp.get('c.getTimbrature');
            action.setParams({dataTimbrature: cmp.get("v.notaSpese.Date__c")});
            action.setCallback(this,function(resp){
                spinner.decreaseCounter();
                if(resp.getState()=='SUCCESS'){
                    var response=resp.getReturnValue();
                    var orariMyHr=[];
                    if(response){
                        response.forEach(print =>{
                            orariMyHr.push(helper.msToTime(print.ora));
                        })
                    }
                    cmp.set("v.orariMyHr", orariMyHr);
                    cmp.set("v.notaSpese.OraInizioUscita__c", "");
                    cmp.set("v.notaSpese.OraFineUscita__c", "");
                    cmp.set("v.orarioInizioMyHr", "manuale");
                    cmp.set("v.orarioFineMyHr", "manuale");
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
        }
        else{
            helper.showToast("Compilare correttamente la data", "error");
        }
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

    refreshdMsg: function() { 
        var sendMsgEventSlot = $A.get("e.ltng:sendMessage"); 
        if(sendMsgEventSlot){
            sendMsgEventSlot.setParams({
                     "message": "refresh", 
                     "channel": "GestioneRegistri" 
            }); 
            sendMsgEventSlot.fire(); 
        }
    },

	showToast : function(message,type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "message": message,
            "type" : type
        });
        toastEvent.fire();
    }
})