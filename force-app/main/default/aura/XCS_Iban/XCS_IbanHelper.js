({

    calcolaIBAN : function(component, event) {
        console.log('calcolaIBAN');
        var spinner = component.find('spinnerComponent');
        spinner.incrementCounter();
        
		var action = component.get("c.calcolaIBAN");
		action.setParams({
            abi: component.find('ABI__c').get('v.value'),
            cab: component.find('CAB__c').get('v.value'),
			numConto: component.find('ContoCorrente__c').get('v.value')
            
		}); 
        console.log('calcolaIBAN action');
		action.setCallback(this, function(response){
			if (response.getState() == 'SUCCESS'){
                console.log('CALCOLA IBAN SUCCESS');
                var datiChiamataOCS=response.getReturnValue();
                if(datiChiamataOCS.chiamataOK){
                    if(datiChiamataOCS.iban==null || datiChiamataOCS.iban==''){
                        this.showToast(component,event,"error","Errore nel calcolo dell'iban.","5000");
                    } else {
                    	component.find('IBAN__c').set('v.value', datiChiamataOCS.iban);
                    }
                } else {
                    this.showToast(component,event,"error",datiChiamataOCS.message,"50000");
                }
            } else {
                console.log('CALCOLA IBAN NOT SUCCESS');
            }
            spinner.decreaseCounter();
        });		
        $A.enqueueAction(action);
	},
    
    verificaIBAN : function(component, event) {
        
		var action = component.get("c.verificaIBAN");
        var iban = component.find('IBAN__c').get('v.value');
        if(iban!=null){
            var spinner = component.find('spinnerComponent');
            spinner.incrementCounter();            
            action.setParams({
                iban: iban            
            }); 
            action.setCallback(this, function(response){
                if (response.getState() == 'SUCCESS'){
                    var ibanValido=response.getReturnValue();
                    if(ibanValido){ 
                        this.showToast(component,event,"success","Formato IBAN valido.","500");
                        component.set("v.isIBANvalido",true);
                    } else {
                        this.showToast(component,event,"error","Formato IBAN NON valido.","50000");
                        component.set("v.isIBANvalido",false);
                    }
                }
                spinner.decreaseCounter();
            });		
            $A.enqueueAction(action);
        } else {
            this.showToast(component,event,"error","Formato IBAN NON valido.","50000");  
        }
	},
    
    
    evaluateIfSaveCC : function(component, event) {
        event.preventDefault(); // stop form submission
        var eventFields = event.getParam("fields");
        eventFields["AccountId__c"] = component.get("v.accountId");
        var iban=component.find("IBAN__c").get("v.value");
        var action = component.get("c.verificaIBAN");
        if(iban!=null){  //prima di salvare l'iban devo accertarmi che è stato inserito ed è in formato valido
            var spinner = component.find('spinnerComponent');
            spinner.incrementCounter();            
            action.setParams({
                iban: iban            
            }); 
            action.setCallback(this, function(response){
                if (response.getState() == 'SUCCESS'){
                    var ibanValido=response.getReturnValue();
                    if(ibanValido){
                        component.find('FormCC').submit(eventFields);
                    } else {
                        this.showToast(component,event,"error","Formato IBAN NON valido.","50000");
                        component.set("v.isIBANvalido",false);
                    }
                }
                spinner.decreaseCounter();
            });		
            $A.enqueueAction(action);            
        } else {
            this.showToast(component,event,"error","Inserire o calcolare l'Iban prima di procedere.","50000");
        }
        
	},    
    
    
    inserisciAggiornaCC : function(component, event) {
        var ibanEvent = $A.get("e.c:XCS_IbanReady"); 
        if(component.get("v.salvaCCsuOCS")){
            var spinner = component.find('spinnerComponent');
            spinner.incrementCounter();            
            //TRAVASA SU OCS::
            var action = component.get("c.inserisciAggiornaCCSuOCS");
            action.setParams({
                CCId: component.get("v.CCId"),
                accountId: component.get("v.accountId")
            }); 
            action.setCallback(this, function(response){
                if (response.getState() == 'SUCCESS'){
                    console.log('CHIAMATA OK');
                    var datiChiamataOCS=response.getReturnValue();
                    if(datiChiamataOCS.chiamataOK){
                        this.showToast(component,event,"success","Dati aggiornati correttamente.","500"); 
                        //restituisco l'evento:
                        if (ibanEvent) {
                            ibanEvent.setParams({
                                'metodoAccreditoId':component.get("v.CCId")
                            });
                            ibanEvent.fire();
                        }                          
                    } else {
                        this.showToast(component,event,"error",datiChiamataOCS.message,"50000");
                    }
                }
                spinner.decreaseCounter();
            });		
            $A.enqueueAction(action);               
        } else { //restituisco l'evento senza salvare il CC su OCS
            if (ibanEvent) {
                ibanEvent.setParams({
                    'metodoAccreditoId':component.get("v.CCId")
                });
                ibanEvent.fire();
            }            
        }

	}, 
    
    
    showToast: function(component,event,type,message,duration){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            type: type,
            message: message,
            duration: duration
        });
        toastEvent.fire();         
    }    
    
})