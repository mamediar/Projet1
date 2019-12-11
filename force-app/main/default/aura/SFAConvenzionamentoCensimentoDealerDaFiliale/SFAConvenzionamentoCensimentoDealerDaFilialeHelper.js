({
    salvaDatiConvenzione: function(component, event) {
        
        
        var action = component.get("c.salvaDatiDealer");   
        action.setParams({
            ragioneSociale: component.get("v.ragioneSociale"),
            personaDiRiferimento: component.get("v.personaDiRiferimento"),
            partitaIVA: component.get("v.partitaIVA"),
            codiceFiscale: component.get("v.codiceFiscale"),
            indirizzo: component.get("v.indirizzo"),
            citta: component.get("v.citta"),
            CAP: component.get("v.cap"),
            provincia: component.get("v.provincia"),
            telefono: component.get("v.telefono"),
            telefonoCellulare: component.get("v.telefonoCellulare"),
            emailPersonaDiRiferimento: component.get("v.email"),
            preferenze: component.get("v.preferenze"),
            note: component.get("v.note")            
        }); 
        action.setCallback(this, function(response){
            if (response.getState() == 'SUCCESS'){
                var datiCensimento = response.getReturnValue();
                console.log('dealerAttivitaInseriti:: '+datiCensimento.dealerAttivitaInseriti);
                console.log('erroreTecnico:: '+datiCensimento.erroreTecnico);
                if(datiCensimento.erroreTecnico > 0){
                                   
                    if(datiCensimento.dealerAttivitaInseriti){
                          component.set("v.buttonClicked", true);
                          this.showToast(component,event,"","success","L'anagrafica del convenzionato e la relativa attività di tipo \'Nuovo Prospect Convenzionato\' sono stati inseriti correttamente.","500");
                            var navService = component.find("navService");
                            var pageReference = {
                                "type": "standard__recordPage",
                                "attributes": {
                                    "recordId": datiCensimento.attivitaId,
                                    "objectApiName": "Case",
                                    "actionName": "view"
                                }
                            };
                            
                            component.set("v.pageReference", pageReference);
                            var defaultUrl = "#";
                            navService.generateUrl(pageReference)
                            .then($A.getCallback(function (url) {
                                component.set("v.url", url ? url : defaultUrl);
                            }), $A.getCallback(function (error) {
                                component.set("v.url", defaultUrl);
                            })); 
                        	console.log('url: '+component.get("v.url"));
                            //window.location.href =component.get("v.url");
                            //window.open(component.get("v.url"));
                        
                            /*var navEvt = $A.get("e.force:navigateToSObject");
                            navEvt.setParams({
                                "recordId": datiCensimento.attivitaId
                            });
                            navEvt.fire();*/                         
                        
                                             
                    } else {

                        this.showToast(component,event,"Errore nel salvataggio dei dati","error","Completare i seguenti campi obbligatori: Ragione Sociale, Contatto e P.IVA e/o C.F.","50000");
                    }
  
            	} else if(datiCensimento.erroreTecnico == 0){
                    this.showToast(component,event,"","error","Inserire un email valida","5000");
                } else if(datiCensimento.erroreTecnico < 0){
                    this.showToast(component,event,"","error",datiCensimento.messaggioErrore,"10000");
                }
            }
        });
        $A.enqueueAction(action);
        
    },
    
    showToast: function(component,event,title,type,message,duration){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "type": type,
            "message": message,
            "duration": duration
        });
        toastEvent.fire();         
    }    
})