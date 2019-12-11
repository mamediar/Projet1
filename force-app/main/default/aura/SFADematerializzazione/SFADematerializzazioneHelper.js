({
    doInit : function(component, event) {
        
        var recordId = component.get('v.recordId');     
		var action = component.get('c.getDematerializzazione');        
        action.setParams({
			caseId: recordId
        });                           
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            console.log('doInit state: '+state);
            if (state === "SUCCESS") {
                
                var dematerializzazioneSelected = response.getReturnValue();
                console.log('dematerializzazioneSelected: '+dematerializzazioneSelected);
                component.set('v.dematerializzazioneSelected',dematerializzazioneSelected);
                component.set('v.dealerSelectedId',dematerializzazioneSelected.AccountId);    
                if (dematerializzazioneSelected.Esito__c != null && dematerializzazioneSelected.Esito__c!='') {
                    component.set('v.senzaEsito',false);
                } else {
                    component.set('v.senzaEsito',true);
                }  
                if (dematerializzazioneSelected!=null && dematerializzazioneSelected.Status == 'Closed') {
                    // le attività chiuse non possono essere riprocessate
                    component.set('v.disableCompleta',true);  
                }
            }         
        }));       
        $A.enqueueAction(action);
    },
    flag : function(component, event) {
        var flagFormazione = component.find("flagFormazione").get("v.value");
        console.log('flagFormazione:'+flagFormazione);
        if (flagFormazione) {
            component.set('v.disabledProsegui', false);
        } else {
            component.set('v.disabledProsegui', true);
        }
    },
    inserimentoDem : function(component, event) {
        var action = component.get('c.insertRichiestaDem'); 
        var dealerSelectedId = component.get('v.dealerSelectedId');     
        console.log('processActivity dealerSelectedId : '+dealerSelectedId);
        action.setParams({
			idDealer: dealerSelectedId
        });                
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            console.log('processActivity state: '+state);
            if (state === "SUCCESS") {          
                var error = response.getReturnValue();    
                if (error == null || error == '') { 
                    component.set('v.msg', 'Inserimento Richiesta Dematerializzazione Effettuato');
                    this.showSuccessToast(component);
                } else {
                    component.set('v.errormsg', 'Errore nella richiesta di inserimento:'+error);
                    this.showErrorToast(component);

                }
            }  else {
                component.set('v.errormsg', 'Errore Generico');
                this.showErrorToast(component);
            }      
        }));       
        $A.enqueueAction(action);
    },
    processActivity : function(component, event){
        var action = component.get('c.process'); 
        var dematerializzazioneSelected = component.get('v.dematerializzazioneSelected');     
        console.log('processActivity dematerializzazioneSelected: '+dematerializzazioneSelected.Id);
        action.setParams({
			caseId: dematerializzazioneSelected.Id
        });                
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            console.log('processActivity state: '+state);
            if (state === "SUCCESS") {               
                var errorecompletamento = response.getReturnValue();
                // check errore errorecompletamento da mostrare
                if (errorecompletamento!=null && errorecompletamento!='') {
                    component.set('v.errormsg', ' Errore Chisusura:'+errorecompletamento);
                    this.showErrorToast(component);
                }
                component.set('v.msg', 'Chisura Attività di dematerializzazione');
                this.showSuccessToast(component);
                component.set('v.disableCompleta',true);  
            }  else {
                component.set('v.errormsg', 'Errore Generico');
                this.showErrorToast(component);
            }      
        }));       
        $A.enqueueAction(action);
    },   
    showSuccessToast : function(component) {
        component.find('notifLib').showToast({
            "variant": "success",
            "title": "Success!",
            "message": component.get('v.msg')
        });
    },
    showErrorToast : function(cmp) {
        cmp.find('notifLib').showToast({
            "variant": "error",
            "title": "Error!",
            "message": cmp.get('v.errormsg')
        });
    } 
})