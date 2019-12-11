({
	callGetDealerAcquisition: function (component, event) {
		var action = component.get("c.getDealerAcquisition");

		action.setParams({
			caseId: component.get("v.recordId")
		}); 

		action.setCallback(this, function(response){
            console.log('******HERE BEFORE HELPER :: ');
			if (response.getState() == 'SUCCESS'){
				var dati = response.getReturnValue();
				component.set("v.dealerAcquisitionId", dati.sfaConvezionamentoDati.dealerId);
                component.set("v.reportCervedId", dati.sfaConvezionamentoDati.reportCervedId);
                component.set("v.dealerRecordTypeId", dati.sfaConvezionamentoDati.recordTypeId);
                component.set("v.listaTipiAccordo", dati.lstSelectOption);
           		component.set("v.listaTipiAccordo", dati.lstSelectOption);
                if(dati.MacroAr != '' && dati.MacroAr != null)
                	component.set("v.SelMacroArea", dati.MacroAr);
                
 				if(dati.ProdDominant != '' && dati.ProdDominant != null)
                	component.set("v.SelProdDom", dati.ProdDominant);
            } 
            else {
                console.log('@@@@@@@@@@@@NOT SUCCESS');
            }
		});		
		$A.enqueueAction(action);
		
	},
	
	updateFields: function (component, event) {
        console.log('HELPER updateFields');
        var spinner = component.find('spinnerComponent');
        spinner.incrementCounter();        
		var action = component.get("c.updateAssicurazione");
		action.setParams({
			dealerAcquisitionId: component.get("v.dealerAcquisitionId"),
            TipoAccordo: component.get("v.tipoAccordoSelezionato")
		}); 
		action.setCallback(this, function(response){
			if (response.getState() == 'SUCCESS'){
                var assicuraz_H3G = response.getReturnValue();
                console.log('SUCCESS updateFields');
                component.find("IsConvenzioneAssicurativo__c").set("v.value",assicuraz_H3G.assicurazione);
                component.find("IsConvenzioneH3G__c").set("v.value",assicuraz_H3G.h3g);
            } else {
                console.log('NOT SUCCESS updateFields');
            }
            spinner.decreaseCounter();
		});		
		$A.enqueueAction(action);

	},    

	initializeFlagProforma: function (component, event) {
        var TipoIntermediario = component.find("Tipo_Intermediario__c").get("v.value");    
        var checkboxCodiceAgente=component.get("v.checkboxCodiceAgente");
        console.log('TipoIntermediario:: '+TipoIntermediario);
        if (TipoIntermediario=='SA' && checkboxCodiceAgente){  
            var action = component.get("c.updateFlagProforma");
            action.setParams({
                dealerAcquisitionId: component.get("v.dealerAcquisitionId"),
                CodiceAgente: component.find("CodiceAgente__c").get("v.value")
            }); 
            
            action.setCallback(this, function(response){
                if (response.getState() == 'SUCCESS'){
                    var prevalorizeFlags = response.getReturnValue();
                    if(prevalorizeFlags){
                        component.find("FlagProforma__c").set("v.value", "");
                        component.find("FlagProfRist__c").set("v.value", "");
                        component.find("FlagAllProforma__c").set("v.value", "N");
                        component.find("FlagAllProfRist__c").set("v.value", "N"); 
                    } else {
                        console.log('Flags NON da prevalorizzare');
                    }
                }
            });
            
            $A.enqueueAction(action);            
        }

	},     
    
    
	controllaSeAndareAvantiPossibile: function(component, event) {
        var reportOpened=component.get("v.reportOpened");
        if(reportOpened){
            var spinner = component.find('spinnerComponent');
            spinner.incrementCounter();
            component.find('FormDealer').submit();
            component.find('FormCerved').submit();        
            var action = component.get("c.segnalaErroreSalvataggio");  
            action.setParams({
            dealerAcquisitionId: component.get("v.dealerAcquisitionId"),
            Type_Anag: component.find("Type_Anag__c").get("v.value"),
            Tipo_Intermediario: component.find("Tipo_Intermediario__c").get("v.value"),
            Macro_Area :  component.get("v.SelMacroArea"),
            Prodotto_Dominante:  component.get("v.SelProdDom")
            });        
            action.setCallback(this, function(response){
                if (response.getState() == 'SUCCESS'){
                    var errorMessage = response.getReturnValue();
                    console.log('errorMessage:: '+errorMessage);
                    if(errorMessage!="0"){
                        this.showToast(component,event,"","error",errorMessage,"50000");                    
                        console.log('operazione di salvataggio non andata a buon fine');
                    } else {
                        console.log('operazione di salvataggio andata a buon fine'); 
                        this.valutaAutonomiaAttivita(component, event)                  
                    }
                    spinner.decreaseCounter();
                }
                console.log('response.getState():: '+response.getState());
            });
            $A.enqueueAction(action);  
        } else {
           this.showToast(component,event,"","error","Per poter procedere è necessario visualizzare il report.","500");  
        }
	},


	valutaAutonomiaAttivita: function(component, event) {
        var spinner = component.find('spinnerComponent');
        spinner.incrementCounter();        
        var action = component.get("c.valutaAutonomia");   
        action.setParams({
            caseId: component.get("v.recordId"),
            dealerAcquisitionId: component.get("v.dealerAcquisitionId"),
            Macro_Area :  component.get("v.SelMacroArea"),
            Prodotto_Dominante:  component.get("v.SelProdDom")
        });        
        action.setCallback(this, function(response){
            if (response.getState() == 'SUCCESS'){                
				this.showToast(component,event,"","success","Dati aggiornati correttmente.","500");                 
                console.log('HELPER operazione di assegnazione andata a buon fine');
            } else {
                this.showToast(component,event,"","error","Errore nell\'aggiornamento dei dati.","500"); 
                console.log('HELPER operazione di assegnazione form NON andata a buon fine')
            }
            spinner.decreaseCounter();
        });
        $A.enqueueAction(action); 
        this.changeCategoriaStepLavorazioneEvent(component,event);
        
    },
    
    changeCategoriaStepLavorazioneEvent: function (component, event){
        var spinner = component.find('spinnerComponent');
        spinner.incrementCounter();        
		var action = component.get("c.getCategoriaEStepLavorazione");
        var changeStepEvent = $A.get("e.c:ChangeCaseStepEvent");         
		action.setParams({
			caseId: component.get("v.recordId"),
		}); 
		action.setCallback(this, function(response){
			if (response.getState() == 'SUCCESS'){
                var dati=response.getReturnValue();
                if (changeStepEvent) {
                    changeStepEvent.setParams({
                        'categoria' : dati.categoria,
                        'stepLavorazione' : dati.stepLavorazione
                    });
                    changeStepEvent.fire();
                } 
				spinner.decreaseCounter();                
            }
		});
		$A.enqueueAction(action); 
		window.location.reload(true);        
    },     
    
    showToast: function(component,event,title,type,message,duration){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: title,
            type: type,
            message: message,
            duration: duration
        });
        toastEvent.fire();         
    },    
    
})