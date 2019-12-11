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
                component.set("v.MasterDealerId", dati.MasterDealerId);
    			component.set("v.tipoIntermediario", dati.tipoIntermediario);
                component.set("v.disableButtonConferma", dati.disableButtonConferma);
                component.set("v.isInManoAdIDM", dati.isInManoAdIDM);
                component.set("v.messageNonLavorazione", dati.message);
                component.set("v.dataCreazioneDossier", dati.caseAttivita.DataCreazioneDossier__c);
                console.log("***v.dataCreazioneDossier:: "+component.get("v.dataCreazioneDossier"));
                console.log("***v.MasterDealerId:: "+ component.get("v.MasterDealerId:"));
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
               /* var numeroAllegati=dati.dossier.NumeroAllegati__c==null?"0":dati.dossier.NumeroAllegati__c;
                var Item = {
                    Id: component.get("v.dossierId"),
                    Tipo: "additional",
                    Documento: "Documentazione Aggiuntiva",
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
            label: "Aggiungi/Visualizza file", 
            iconName: 'utility:edit',
            name: "edit",
            disabled: row.Risposta == 'No' });
        cb(actions);
    },
	
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
    
    getAttachments : function(component,event) {  
        var spinner = component.find('spinnerComponent');
        spinner.incrementCounter();          
        var action = component.get("c.getFileAllegati"); 
        var isCreato = component.get("v.isDocCreato");
        action.setParams({"recordId": component.get("v.selectedDossierDocumentId"),IsCreato : isCreato});  
        action.setCallback(this,function(response){  
            var state = response.getState();  
            if(state=='SUCCESS'){ 
                var files=response.getReturnValue();
                component.set('v.filesDossierDocumentSelezionato', files);
                //(string IdDossierDoc, string IdDossier, string IdDoc ,list<ContentDocument> Document)
                console.log('Result Returned: ' +files); 
                if(isCreato == true){
    
                    this.AggiornaRecordNascosto(component, event);
                }
            }
            spinner.decreaseCounter();
        });  
        $A.enqueueAction(action);         
    },


 AggiornaRecordNascosto : function(component,event) {            
        var action = component.get("c.AggiornaRecordNascosto"); 
        var isCreato = component.get("v.isDocCreato");
       	var uploadedFiles = event.getParam("files");
     	console.log("Files uploaded : " + JSON.stringify(uploadedFiles)); 
        action.setParams({
            IdDossierDoc : component.get("v.selectedDossierDocumentId"),
            //Document : component.get('v.filesDossierDocumentSelezionato'),
            idDoc : uploadedFiles[0].documentId
        });  
        action.setCallback(this,function(response){  
            var state = response.getState();  
            if(state=='SUCCESS'){ 
                console.log('Result AggiornaRecordNascosto OK'); 
                
            }
            else
                 console.log('Result AggiornaRecordNascosto KO'); 
            
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
                console.log('riassegnato alla filiale con successo');                        
            }
            spinner.decreaseCounter();
        });  
        $A.enqueueAction(action);         
    },
    
})