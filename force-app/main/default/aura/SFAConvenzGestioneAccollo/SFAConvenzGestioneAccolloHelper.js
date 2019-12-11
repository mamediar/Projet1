({
	goToListaCase: function (component, event) {
		var navService = component.find("navService");
		var pageReference = component.get("v.pageReference");
       // console.log("*** goToListaCase.pageReference :: " + pageReference);
		//event.preventDefault();
		navService.navigate(pageReference);
	},
    
    initVerifyContest : function(component,event,helper){
    	var RecId = component.get("v.recordId"); 

            var action = component.get("c.RecuperaContesto");
            action.setParams({
			RecId: RecId
            }); 
            
            action.setCallback(this, function(response){
            if (response.getState() == 'SUCCESS'){
                    var initData = response.getReturnValue();
               	component.set("v.recordId", initData.CaseIdRec);
                helper.initPageReference(component, event);
                helper.callTipiAccollo(component, event);
                helper.callGetDossier(component, event); 
            }
        	});
        	$A.enqueueAction(action);
    	
        
    },

	initPageReference : function(component, event) {
        var navService = component.find("navService");
    //    console.log("*** initPageReference.navService :: " + navService);
        var pageReference = {
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Case',
                actionName: 'list'
            },
            state: {
                filterName: 'Gestione_Accolli' 
            }
        };
   //     console.log("*** initPageReference.pageReference :: " + pageReference);
        component.set("v.pageReference", pageReference);
        var defaultUrl = "#";
        navService.generateUrl(pageReference)
            .then($A.getCallback(function(url) {
                component.set("v.url", url ? url : defaultUrl);
            }), $A.getCallback(function(error) {
                component.set("v.url", defaultUrl);
            }));
	},
    
    callTipiAccollo: function (component, event){
    	var action = component.get("c.MostraTipologie");
         var caseId = component.get("v.recordId");
		action.setParams({
			caseId: caseId
		}); 
		action.setCallback(this, function(response){
    	if (response.getState() == 'SUCCESS'){
				var initData = response.getReturnValue();
            component.set("v.lstTipoAccollo", initData.Tipologie);
            component.set("v.lstSelectedTipoAccollo", initData.Selezione);
        }
            component.set("v.isInManoAFiliale", initData.isInManoAFiliale);
    });
	$A.enqueueAction(action);
	},
    
	callGetDossier: function (component, event) {
		var action = component.get("c.checkDossierEsistente");
		var caseId = component.get("v.recordId");
		console.log("*** callGetDossier.caseId :: " + caseId);
		var spinner = component.find('spinnerComponent');
        spinner.incrementCounter();

		action.setParams({
			caseId: caseId
		}); 

		action.setCallback(this, function(response){
			spinner.decreaseCounter();
			if (response.getState() == 'SUCCESS'){
				var initData = response.getReturnValue();
				console.log("*** initData.isInManoAFiliale :: " + initData.isInManoAFiliale);
                console.log('*** component.get(inManoaFiliale) :: ' + component.get('v.isInManoAFiliale'));
				if (initData.isInManoAFiliale == false) {
					component.set("v.messageNonLavorazione", "Accollo Gestito");
				}
				else {
                    if (initData.errorCode < 0) {
						component.set("v.errorCode", initData.errorCode);
					}
					else {
						component.set("v.dossier", initData.dossier);
						component.set("v.dealerId", initData.dealerId);
                        component.set("v.dealerMasterId", initData.dealerMasterId);
                        component.set("v.showButtonAvvisaIDM", initData.abilitaAvviso);	
                        component.set("v.tipoQuestionario", initData.tipoChecklist);
						console.log("*** initData :: " + JSON.stringify(initData));
						this.callGetListeDocumenti(component, event);
					}
				}
				component.set("v.isInManoAFiliale", initData.isInManoAFiliale);
			}
		});
		$A.enqueueAction(action);

	},
    
    CheckTypeEsistenti: function (component,event){
        var action = component.get("c.CheckTypeSelezionati");
		var dossier = component.get("v.dossier");
        var caseId = component.get("v.recordId");
        var TipoAccollo  = (component.get("v.lstSelectedTipoAccollo") != null) ? component.get("v.lstSelectedTipoAccollo")  : [];    
        var spinner = component.find('spinnerComponent');
        spinner.incrementCounter();

		action.setParams({
			dossier: dossier,
			TipoAccollo: TipoAccollo,
            caseId: caseId
		}); 
        action.setCallback(this, function(response){
			spinner.decreaseCounter();
			if (response.getState() == 'SUCCESS'){
                var initData = response.getReturnValue();
                console.log("*** initData.errorDesc :: " + initData.errorDesc);
                if (initData.errorDesc !='') {
						this.showToastKO(component, event, initData.errorDesc);
					}
                else{
                	this.callGetListeDocumenti(component, event);
                }
  			}	
		});

		$A.enqueueAction(action);

	},
    
	callGetListeDocumenti: function (component, event) {
		console.log('*** callGetListeDocumenti');
		var action = component.get("c.getListeDocumenti");
		var caseId = component.get("v.recordId");
		var dossier = component.get("v.dossier");
        var TipoAccollo  = component.get("v.lstSelectedTipoAccollo") != null ? component.get("v.lstSelectedTipoAccollo")  : [];
      
		console.log("*** dossier :: " + JSON.stringify(dossier));
		console.log("*** caseId :: " + caseId);
		console.log("*** TipoAccollo :: " + TipoAccollo);

		var spinner = component.find('spinnerComponent');
        spinner.incrementCounter();

		action.setParams({
			caseId: caseId,
			dossier: dossier,
			TipoAccollo: TipoAccollo
		}); 

		action.setCallback(this, function(response){
			spinner.decreaseCounter();
			if (response.getState() == 'SUCCESS'){
				var datiListaDocumenti = response.getReturnValue();
				if (datiListaDocumenti) {
					console.log("*** datiListaDocumenti :: " + JSON.stringify(datiListaDocumenti));
                    
					component.set("v.lstDossierDocumentoObbligatori", datiListaDocumenti.lstDocumentoObbligatori);
					//component.set("v.lstDossierDocumentoCollegati", datiListaDocumenti.lstDossierDocumentoCollegati);
					component.set("v.lstDossierDocumentoAddizionali", datiListaDocumenti.lstDocumentoAddizionali);
					component.set("v.lstSelectedRowsObbligatori", datiListaDocumenti.lstSelectedObbligatori);
					component.set("v.lstSelectedRowsAddizionali", datiListaDocumenti.lstSelectedAddizionali);
					component.set("v.mapIdRispostaDocumentoAddizionali", new Map());
					if (datiListaDocumenti.step == 'GestioneAccolloDealer_StampaCover')
							this.callGeneraCoverDossierUrl(component, event);
					component.set("v.step", datiListaDocumenti.step);
				}
			}
		});

		$A.enqueueAction(action);

	},

	handleSalvaSelezione: function (component, event, selectedDocumentIdsO,selectedDocumentIdsA) {
		var action = component.get("c.salvaSelezioneDocumenti");
		var dossierId = component.get("v.dossier") ? component.get("v.dossier").Id : null;
		var caseId = component.get("v.recordId");
		var step = component.get("v.step");

		var spinner = component.find('spinnerComponent');
        spinner.incrementCounter();

		action.setParams({
			dossierId: dossierId,
			caseId: caseId,
			lstIdDocumento: selectedDocumentIdsO,
            lstIdDocumentoA: selectedDocumentIdsA,
			step: step
		}); 

		action.setCallback(this, function(response){
			console.log("*** response.getReturnValue() :: " + response.getReturnValue());
			
			spinner.decreaseCounter();
			if (response.getState() == 'SUCCESS'){
				this.showToastOK(component, event);
			}
			else {
				this.showToastKO(component, event, 'Si è verificato un errore durante il salvataggio.');
			}
		});
		
		$A.enqueueAction(action);

	},

	
	callGeneraCoverDossierUrl: function (component, event) {
		var action = component.get("c.generaCoverDossierUrl");
		var dossierId = component.get("v.dossier") ? component.get("v.dossier").Id : null;

		action.setParams({
			dossierId: dossierId
		}); 

		action.setCallback(this, function(response){
			console.log("*** response.getReturnValue() :: " + response.getReturnValue());
			if (response.getState() == 'SUCCESS'){
				var dossierURL = response.getReturnValue();
				component.set("v.dossierURL", dossierURL);
			}
		});
		
		$A.enqueueAction(action);

	},

	callAssignToIDM: function (component, event) {
		var action = component.get("c.assignToIDM");
		var dossierId = component.get("v.dossier") ? component.get("v.dossier").Id : null;
		var caseId = component.get("v.recordId");

		var spinner = component.find('spinnerComponent');
        spinner.incrementCounter();

		action.setParams({
			dossierId: dossierId,
			caseId: caseId
		}); 

		action.setCallback(this, function(response){
			console.log("*** response.getReturnValue() :: " + response.getReturnValue());
			spinner.decreaseCounter();
			if (response.getState() == 'SUCCESS'){
                var obj = component.get("v.sObjectName"); 
                component.set("v.isInManoAFiliale", false);
                console.log('obj: '+obj);
                
                if(obj == 'Case'){
					this.goToListaCase(component, event);
                    }
                 else{
                     location.reload();
                     }
			}
            else
            {
                this.showToastWarning(component, event, 'Si è verificato un errore durante l\'invio a IDM');
            }
		});
		
		$A.enqueueAction(action);

	},
    
    callSendToIDM: function (component, event) {
		var action = component.get("c.SendToIDM");
		var dossierId = component.get("v.dossier") ? component.get("v.dossier").Id : null;
		var caseId = component.get("v.recordId");

		var spinner = component.find('spinnerComponent');
        spinner.incrementCounter();

		action.setParams({
			dossierId: dossierId,
			caseId: caseId
		}); 

		action.setCallback(this, function(response){
			console.log("*** response.getReturnValue() :: " + response.getReturnValue());
			spinner.decreaseCounter();
			if (response.getState() == 'SUCCESS'){
                var obj = component.get("v.sObjectName"); 
                component.set("v.isInManoAFiliale", false);
                if(obj == 'Case'){
					this.goToListaCase(component, event);
            	}
                else{
                   location.reload();
                }
			}
            else{
                this.showToastWarning(component, event, 'Si è verificato un errore durante l\'invio a IDM ');
            }
		});
		
		$A.enqueueAction(action);

	},

	handleProcedi: function (component, event) {
		var dossierId = component.get("v.dossier") ? component.get("v.dossier").Id : null;
		var caseId = component.get("v.recordId");

		var spinner = component.find('spinnerComponent');
        spinner.incrementCounter();

		console.log('*** caseId :: ' + caseId);
		console.log('*** step :: ' + component.get("v.step"));

		var action = component.get("c.updateStepLavorazione");

		action.setParams({
			dossierId: dossierId,
			caseId: caseId
		}); 

		action.setCallback(this, function(response){
			console.log("*** response.getReturnValue() :: " + response.getReturnValue());
			spinner.decreaseCounter();
			if (response.getState() == 'SUCCESS'){
				var result = response.getReturnValue();
				if (result) {
					
					if (result.errorMessage == 'M01' || result.errorMessage == 'I01') {
						this.showToastWarning(component, event, "E' necessario selezionare tutti i documenti.");
					}
		//			else if (result.errorMessage == 'A01') {
			//			this.showToastWarning(component, event, "E' necessario rispondere a tutte le domande.");
		//			}
					
					component.set("v.updateStepLavorazioneData", result.datiListaDocumenti);
					console.log("*** result.datiListaDocumenti :: " + JSON.stringify(result.datiListaDocumenti));
					
					if (result.newStep == 'GestioneAccolloDealer_StampaCover') {
						this.callGeneraCoverDossierUrl(component, event);
					}						
					component.set("v.step", result.newStep);
				}
				else {
					this.showToastKO(component, event, 'Si è verificato un errore durante il salvataggio.');
				}
			}
			else {
				this.showToastKO(component, event, 'Si è verificato un errore durante il salvataggio.');
			}
		});
		
		$A.enqueueAction(action);
	},
    
    
    goToStepIniziale: function (component, event){
        
        var spinner = component.find('spinnerComponent');
        spinner.incrementCounter();
       var caseId = component.get("v.recordId");       
       var action = component.get("c.TornaAdObbligatori");
       action.setParams({
			caseId: caseId
		}); 
        action.setCallback(this, function(response){
			console.log("*** response.getReturnValue() :: " + response.getReturnValue());
			spinner.decreaseCounter();
			if (response.getState() == 'SUCCESS'){
				var result = response.getReturnValue();
				
       			component.set("v.step", result.newStep);
                
            }});
		
		$A.enqueueAction(action);
    
	},
    AnnullaAccollo : function(component,event) {
        var spinner = component.find('spinnerComponent');
        spinner.incrementCounter();        
        var action = component.get("c.AnnullaAccollo"); 
        action.setParams({caseId: component.get("v.recordId"), note: component.get("v.note")});
        action.setCallback(this,function(response){  
            var state = response.getState();  
            if(state=='SUCCESS'){ 
                this.showToastOK(component, event);
                setTimeout(function(){ location.reload(); }, 3000);
                
            } else {
                console.log('Problema nell\'esecuzione dell\'action selezionata');
            }
            spinner.decreaseCounter();
        });  
        $A.enqueueAction(action);         
    }, 
  

	showToastOK: function(component, event) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title: "Operazione completata",
			type: "success",
			message: "Salvataggio completato con successo!"
		});
		toastEvent.fire();
	},
	
	showToastKO: function(component, event, message) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title: "Errore",
			type: "error",
			message: message
		});
		toastEvent.fire();
	},

	showToastWarning: function(component, event, message) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title: "Attenzione",
			type: "warning",
			message: message
		});
		toastEvent.fire();
	},
})