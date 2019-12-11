({
	doInit: function (component, event) {
		var action = component.get("c.getDati");
        console.log("dossierId: "+component.get("v.recordId"));
        var spinner = component.find('spinnerComponent');
        spinner.incrementCounter();
		action.setParams({
			dossierId: component.get("v.recordId")
		}); 
		action.setCallback(this, function(response){
            spinner.decreaseCounter();
			if (response.getState() == 'SUCCESS'){
				var dati = response.getReturnValue();
                var documenti=dati.documentiList;
				component.set("v.dealerId", dati.dealerId);
                component.set("v.OCSExternalDealer", dati.OCSExternalDealer);
                component.set("v.caseId", dati.caseId);
                component.set("v.dossierId", dati.dossierId);
                component.set("v.disableButtonConferma", dati.disableButtonConferma);
                component.set("v.isInManoAdIDM", dati.isInManoAdIDM);
                component.set("v.messageNonLavorazione", dati.message);
                component.set("v.dataCreazioneDossier", dati.caseAttivita.DataCreazioneDossier__c);
                console.log("***v.dataCreazioneDossier:: "+component.get("v.dataCreazioneDossier"));
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
                console.log('dati.dossier.NumeroAllegati__c: '+dati.dossier.NumeroAllegati__c);
                var numeroAllegati=dati.dossier.NumeroAllegati__c==null?"0":dati.dossier.NumeroAllegati__c;
                var Item = {
                    Id: component.get("v.dossierId"),
                    Tipo: "additional",
                    Documento: "Documentazione Aggiuntiva",
                    Risposta: "No ", //No+" " così non viene disabilitata la sua action
                    NomeContatto: "",
                    NumeroAllegati: numeroAllegati.toString()
                };
                documentiList.push(Item);                 
                
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
            label: "Aggiungi/Visualizza file", 
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


    
    actionButtonDocumentiNonCompleti : function(component,event) {  
        var spinner = component.find('spinnerComponent');
        spinner.incrementCounter();          
        component.find('FormDossierCheckbox').submit();
        console.log('BUTTON caseId: '+component.get("v.caseId"));
        var action = component.get("c.assignToFiliale"); 
        action.setParams({"caseId": component.get("v.caseId"), "dossierId": component.get("v.dossierId"), "note": component.get("v.note")});  
        action.setCallback(this,function(response){  
            var state = response.getState();  
            if(state=='SUCCESS'){ 
                console.log('riassegnato alla filiale con successo');
                location.reload();
            } else {
                console.log('riassegnato alla filiale NOT successo');  
            }
            spinner.decreaseCounter();
        });  
        $A.enqueueAction(action);         
    },
    
    actionButtonConferma : function(component,event) {
        var spinner = component.find('spinnerComponent');
        spinner.incrementCounter();          
        component.find('FormDossierCheckbox').submit();
        var action = component.get("c.assignToMD"); 
        action.setParams({"caseId": component.get("v.caseId"), "dossierId": component.get("v.dossierId"), "note": component.get("v.note")});
        action.setCallback(this,function(response){  
            var state = response.getState();  
            if(state=='SUCCESS'){ 
                location.reload();
                console.log('riassegnato alla filialecon successo');                        
            }
            spinner.decreaseCounter();
        });  
        $A.enqueueAction(action);         
    },
    
})