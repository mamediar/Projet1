({
	doInit: function (component, event) {
		var action = component.get("c.getDati");
        console.log("dossierId: "+component.get("v.recordId"));
		action.setParams({
			dossierId: component.get("v.recordId")
		}); 
		action.setCallback(this, function(response){
			if (response.getState() == 'SUCCESS'){
				var dati = response.getReturnValue();
                var documenti=dati.documentiList;
				component.set("v.dealerId", dati.dealerId);
                component.set("v.MasterDealerId", dati.MasterDealerId);
                component.set("v.tipoIntermediario", dati.tipoIntermediario);
                component.set("v.OCSExternalDealer", dati.OCSExternalDealer);
                component.set("v.caseId", dati.caseId);
                component.set("v.OCSExternalD",dati.OCSExternalFiliale);
                component.set("v.dossierId", dati.dossierId);
                component.set("v.isInManoAdMD", dati.isInManoAdMD);
                component.set("v.dataRiconsegnaAFiliale", dati.dataRiconsegnaAFiliale);
                console.log('***MD dati.dataRiconsegnaAFiliale: '+dati.dataRiconsegnaAFiliale);
                component.set("v.isInManoAdUtenteConnesso", dati.actualUserOwnerCase);
                component.set("v.messageNonLavorazione", dati.message);
                component.set("v.showButtonApprova", dati.showButtons.showButtonApprova);
                component.set("v.showButtonRichiediMaggioriInformazioni", dati.showButtons.showButtonRichiediMaggioriInformazioni);
                component.set("v.showButtonSospendi", dati.showButtons.showButtonSospendi);
                component.set("v.showButtonRespingi", dati.showButtons.showButtonRespingi);
                component.set("v.showButtonCambiaStato", dati.showButtons.showButtonCambiaStato);
                component.set("v.showButtonCambiaStato", dati.showButtons.showButtonCambiaStato);
                component.set("v.showButtonVisualizzaMotivo", dati.isAutonomiaSede);
                component.set("v.showButtonPrendiCase", !dati.caseUtenteAppropriato);
                component.set("v.showButtonAnnulla", dati.showButtons.showButtonAnnulla);
               	var listGDO = dati.ListGDO;
                if(dati.VisualizzaGDO)
                	listGDO.unshift({'MasterLabel' : 'Seleziona Elemento...' , 'Flag_Rientro__c' : ''});
                component.set("v.firmaListGDO", listGDO);
                component.set("v.PresenzaGDO", dati.VisualizzaGDO);
               
                var documentiList = [];
                for (var i=0; i< documenti.length; i++){
                    var numeroAllegati=documenti[i].NumeroAllegati__c==null?"0":documenti[i].NumeroAllegati__c;
                    var Item = {
                        Id: documenti[i].Id,
                        Tipo: documenti[i].DocumentType__c,
                        Documento: documenti[i].Document__c,
                        Risposta: documenti[i].RispostaDocumentiAddizionali__c,
                        NomeContatto: documenti[i].NomeCollegato__c,
                        NumeroAllegati: numeroAllegati.toString()
                    };
                    documentiList.push(Item);  
                }
         /*       var numeroAllegati=dati.dossier.NumeroAllegati__c==null?"0":dati.dossier.NumeroAllegati__c;
                var Item = {
                    Id: component.get("v.dossierId"),
                    Tipo: "Documento aggiuntivo",
                    Documento: "additional",
                    Risposta: "No ", //No+" " così non viene disabilitata la sua action
                    NomeContatto: "",
                    NumeroAllegati: numeroAllegati.toString()
                };
                documentiList.push(Item);                 
                */
                component.set("v.documentiList",documentiList); 
            } else {
                console.log('dealerId NOT SUCCESS');
            }
		});
		
		$A.enqueueAction(action);       

	},
    
    getRowActions: function(component, row, cb) {
        var actions = [];
        actions.push({
            label: "Visualizza/Elimina file", 
            iconName: 'utility:edit',
            name: "edit",
            disabled: row.Risposta == 'No' });
        cb(actions);
    },     
    
    getAttachments : function(component,event) {
        var spinner = component.find('spinnerComponent');
        spinner.incrementCounter();        
        var action = component.get("c.getFileAllegati");   
        action.setParams({"recordId": component.get("v.selectedDossierDocumentId")});  
        action.setCallback(this,function(response){  
            var state = response.getState();  
            if(state=='SUCCESS'){ 
                var files=response.getReturnValue();
                component.set('v.filesDossierDocumentSelezionato', files);
                console.log('Result Returned: ' +files);                        
            }
            spinner.decreaseCounter();
        });  
        $A.enqueueAction(action);         
    },
    
	
    callDeleteFile : function(component,event,rec_id) {
        var spinner = component.find('spinnerComponent');
        spinner.incrementCounter();        
        var action = component.get("c.deleteFile"); 
        action.setParams({fileId: rec_id});
        action.setCallback(this,function(response){  
            var state = response.getState();  
            if(state=='SUCCESS'){ 
                this.getAttachments(component,event);
                this.doInit(component,event);
                console.log('File cancellato con successo');
            }
            spinner.decreaseCounter();
        });  
        $A.enqueueAction(action);         
    },    
    
    
    approva : function(component,event) {
        var spinner = component.find('spinnerComponent');
        spinner.incrementCounter();        
        var action = component.get("c.approva"); 
    //    var DealerC = 
        action.setParams({
            caseId: component.get("v.caseId"), 
            note: component.get("v.note"),
            GDOSelezionato :component.get("v.RientroGDO"),
            DealerCode : component.get("v.OCSExternalD")
        });
        console.log('GDOSelezionatoHELP : '+component.get("v.RientroGDO"));
        console.log('DealerCode2222 : ' + component.get("v.OCSExternalD"));
       
        action.setCallback(this,function(response){  
           
            var state = response.getState();  
            console.log('RispostaApprovaaaaaa: '+ state);
            if(state=='SUCCESS')
            { 
               var approvato = response.getReturnValue();
                if(approvato)
                	location.reload();
                else
                    this.showToast(component,event,'Errore','error','RicevutoKO OCS su firma GDO');
            } else {
                console.log('Problema nell\'esecuzione dell\'action selezionata');
            }
            spinner.decreaseCounter();
        });  
        $A.enqueueAction(action);         
    }, 
    
 /*  CallWsGDO : function(component,event){
        var GDOSelezionato=component.get("v.RientroGDO");
        var DealerCode =  component.get("v.OCSExternalDealer");
        var action = component.get("c.GetResopnseGDO");
        console.log("DealerCode: "+DealerCode);
        
		action.setParams({
			DealerCode: DealerCode,
            GDOSelezionato: GDOSelezionato
		}); 
        
		action.setCallback(this, function(response){
			if (response.getState() == 'SUCCESS'){
                this.approva(component,event);
            }
            else{
                this.showToast(component,event,'Errore','error','RicevutoKO OCS su firma GDO');
            }
        });  
        $A.enqueueAction(action);     
                           
    },*/
    
    AnnullaAccollo : function(component,event) {
        var spinner = component.find('spinnerComponent');
        spinner.incrementCounter();        
        var action = component.get("c.AnnullaAccollo"); 
        action.setParams({caseId: component.get("v.caseId"), note: component.get("v.note")});
        action.setCallback(this,function(response){  
            var state = response.getState();  
            if(state=='SUCCESS'){ 
                location.reload();
            } else {
                console.log('Problema nell\'esecuzione dell\'action selezionata');
            }
            spinner.decreaseCounter();
        });  
        $A.enqueueAction(action);         
    },   
    
    richiediMaggioriInformazioni : function(component,event) {
        var spinner = component.find('spinnerComponent');
        spinner.incrementCounter();        
        var action = component.get("c.richiediMaggioriInformazioni"); 
        action.setParams({caseId: component.get("v.caseId"), note: component.get("v.note")});
        action.setCallback(this,function(response){  
            var state = response.getState();  
            if(state=='SUCCESS'){ 
                location.reload();
            } else {
                console.log('Problema nell\'esecuzione dell\'action selezionata');
            }
            spinner.decreaseCounter();
        });  
        $A.enqueueAction(action);         
    },    
    
    sospendi : function(component,event) {
        var spinner = component.find('spinnerComponent');
        spinner.incrementCounter();        
        var action = component.get("c.sospendi"); 
        action.setParams({caseId: component.get("v.caseId"), note: component.get("v.note")});
        action.setCallback(this,function(response){  
            var state = response.getState();  
            if(state=='SUCCESS'){ 
                location.reload();
            } else {
                console.log('Problema nell\'esecuzione dell\'action selezionata');
            }
            spinner.decreaseCounter();
        });  
        $A.enqueueAction(action);         
    },    
    
    respingi : function(component,event) {
        var spinner = component.find('spinnerComponent');
        spinner.incrementCounter();        
        var action = component.get("c.respingi"); 
        action.setParams({caseId: component.get("v.caseId"), note: component.get("v.note")});
        action.setCallback(this,function(response){  
            var state = response.getState();  
            if(state=='SUCCESS'){ 
                location.reload();
            } else {
                console.log('Problema nell\'esecuzione dell\'action selezionata');
            }
            spinner.decreaseCounter();
        });  
        $A.enqueueAction(action);         
    },    
    
     cambiaStato : function(component,event) {
        var spinner = component.find('spinnerComponent');
        spinner.incrementCounter();         
        var action = component.get("c.cambiaStato"); 
        action.setParams({caseId: component.get("v.caseId"), note: component.get("v.note")});
        action.setCallback(this,function(response){  
            var state = response.getState();  
            if(state=='SUCCESS'){ 
                location.reload();
            } else {
                console.log('Problema nell\'esecuzione dell\'action slezionata');
            }
            spinner.decreaseCounter();
        });  
        $A.enqueueAction(action);         
    },   

     prendiCase : function(component,event) {
        var spinner = component.find('spinnerComponent');
        spinner.incrementCounter();         
        var action = component.get("c.prendiCase"); 
        action.setParams({caseId: component.get("v.caseId")});
        action.setCallback(this,function(response){  
            var state = response.getState();  
            if(state=='SUCCESS'){ 
                console.log('OK AGGIORNAMENTO USER');
                location.reload();
            } else {
                console.log('Problema nell\'esecuzione dell\'action slezionata');
            }
            spinner.decreaseCounter();
        });  
        $A.enqueueAction(action);         
    },
    
    
    
    showToast: function(component,event,title,type,message){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: title,
            type: type,
            message: message,
          
        });
        toastEvent.fire();         
    }
    
})