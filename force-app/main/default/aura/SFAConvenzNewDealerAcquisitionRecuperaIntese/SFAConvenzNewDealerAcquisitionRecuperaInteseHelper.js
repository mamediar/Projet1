({
	callGetInteseNomi: function (component, event) {
        var spinner = component.find('spinnerComponent');
        spinner.incrementCounter();         
		var action = component.get("c.getIntesePDFpathEDatiConvenzione");
		action.setParams({
			caseId: component.get("v.recordId")
		}); 
		action.setCallback(this, function(response){
			if (response.getState() == 'SUCCESS'){
                var results = response.getReturnValue();
                var dati = results.dati;
                component.set("v.dealerId",dati.dealerId);
                component.set("v.dealerInfo",dati.dealerInfo);   
                component.set("v.caseAttivita",dati.caseAttivita);
                
                //intese statiche
                var inteseRecuperate = [];                
                var inteseName = results.intesePDFbase64;
                
                for(var key in inteseName){
                    inteseRecuperate.push({value:inteseName[key], key:key});
                    console.log('statica: '+key);
                }                
                component.set("v.inteseRecuperate",inteseRecuperate); 
            } else {
                console.log('chiamata non success');
            }
            spinner.decreaseCounter();
            
        });
        $A.enqueueAction(action);
        
    },
    
    parseBase64toFile : function(component, event,base64) {
        
        /*var base64 = 'JVBERi0xLjcKCjEgMCBvYmogICUgZW50cnkgcG9pbnQKPDwKICAvVHlwZSAvQ2F0YWxvZwog' +
          'IC9QYWdlcyAyIDAgUgo+PgplbmRvYmoKCjIgMCBvYmoKPDwKICAvVHlwZSAvUGFnZXMKICAv' +
          'TWVkaWFCb3ggWyAwIDAgMjAwIDIwMCBdCiAgL0NvdW50IDEKICAvS2lkcyBbIDMgMCBSIF0K' +
          'Pj4KZW5kb2JqCgozIDAgb2JqCjw8CiAgL1R5cGUgL1BhZ2UKICAvUGFyZW50IDIgMCBSCiAg' +
          'L1Jlc291cmNlcyA8PAogICAgL0ZvbnQgPDwKICAgICAgL0YxIDQgMCBSIAogICAgPj4KICA+' +
          'PgogIC9Db250ZW50cyA1IDAgUgo+PgplbmRvYmoKCjQgMCBvYmoKPDwKICAvVHlwZSAvRm9u' +
          'dAogIC9TdWJ0eXBlIC9UeXBlMQogIC9CYXNlRm9udCAvVGltZXMtUm9tYW4KPj4KZW5kb2Jq' +
          'Cgo1IDAgb2JqICAlIHBhZ2UgY29udGVudAo8PAogIC9MZW5ndGggNDQKPj4Kc3RyZWFtCkJU' +
          'CjcwIDUwIFRECi9GMSAxMiBUZgooSGVsbG8sIHdvcmxkISkgVGoKRVQKZW5kc3RyZWFtCmVu' +
          'ZG9iagoKeHJlZgowIDYKMDAwMDAwMDAwMCA2NTUzNSBmIAowMDAwMDAwMDEwIDAwMDAwIG4g' +
          'CjAwMDAwMDAwNzkgMDAwMDAgbiAKMDAwMDAwMDE3MyAwMDAwMCBuIAowMDAwMDAwMzAxIDAw' +
          'MDAwIG4gCjAwMDAwMDAzODAgMDAwMDAgbiAKdHJhaWxlcgo8PAogIC9TaXplIDYKICAvUm9v' +
          'dCAxIDAgUgo+PgpzdGFydHhyZWYKNDkyCiUlRU9G'*/
        var url = 'data:application/octet-stream;base64,' + base64;
        var urlEvent = $A.get('e.force:navigateToURL');
        urlEvent.setParams({
            "url": url
        });
        urlEvent.fire();
    },    
    
    getCollegati: function (component, event){
        var spinner = component.find('spinnerComponent');
        spinner.incrementCounter();        
		var action = component.get("c.getCollegati");
		action.setParams({
			dealerId: component.get("v.dealerId")
		}); 
		action.setCallback(this, function(response){
			if (response.getState() == 'SUCCESS'){
                	var collegatiRoles = response.getReturnValue();
                	var collegati = collegatiRoles.collegati;
                	console.log('collegati:: '+JSON.stringify(collegati));
                    var collegatiList = [];
                	var mailingStreet,mailingCity,mailingPostalCode,mailingState;
                    //collegati
                    for (var i=0; i< collegati.length; i++){
                        mailingStreet= collegati[i].contactCollegato.MailingStreet==null?'':collegati[i].contactCollegato.MailingStreet+' -';
                        mailingCity= collegati[i].contactCollegato.MailingCity==null?'':collegati[i].contactCollegato.MailingCity;
                        mailingPostalCode= collegati[i].contactCollegato.MailingPostalCode==null?'':collegati[i].contactCollegato.MailingPostalCode;
                        mailingState= collegati[i].contactCollegato.MailingState==null?'':'('+collegati[i].contactCollegato.MailingState+')';                    
                        var Item = {
                            Id: collegati[i].contactCollegato.Id,
                            OCS_External_Id__c: collegati[i].contactCollegato.OCS_External_Id__c,
                            LastName: collegati[i].contactCollegato.LastName,
                            FirstName: collegati[i].contactCollegato.FirstName,
                            Sesso__c: collegati[i].contactCollegato.Sesso__c,
                            Luogo_Nascita__c: collegati[i].contactCollegato.Luogo_Nascita__c,
                            Provincia_Nascita__c: collegati[i].contactCollegato.Provincia_Nascita__c,
                            Birthdate: collegati[i].contactCollegato.Birthdate,
                            Codice_Fiscale__c: collegati[i].contactCollegato.Codice_Fiscale__c,
                            MailingAddress: mailingStreet+' '+mailingCity+' '+mailingPostalCode+' '+mailingState,
                            Luogo_Rilascio__c: collegati[i].contactCollegato.Luogo_Rilascio__c,
                            Provincia_Rilascio__c: collegati[i].contactCollegato.Provincia_Rilascio__c,
                            Roles: collegati[i].Ruolo};
                        collegatiList.push(Item);  
                        
                    } 
                	console.log('collegatiList:: '+collegatiList);
                	component.set("v.collegatiList",collegatiList);
            } else {
                console.log('chiamata non success');
            }
            spinner.decreaseCounter();
        });
        $A.enqueueAction(action);                
	},
    
    aggiornaDatiIDCollegato: function (component, event){
        var spinner = component.find('spinnerComponent');
        spinner.incrementCounter();   
        
        component.find('FormCollegato').submit(); 
		var action = component.get("c.salvaProvinciaECittaRilascioIDCollegato");
		console.log('HELPER salvaProvinciaECitta');
		action.setParams({
			collegatoId: component.get("v.selectedCollegatoId"),
            provinciaRilascio: component.get("v.provinciaRilascio"),
            luogoRilascio: component.get("v.luogoRilascio"),            
		}); 
		action.setCallback(this, function(response){
			if (response.getState() == 'SUCCESS'){
                this.aggiornaDatiIDCollegatoSuOCS(component, event);
                console.log('VERIFICA ANAGRAFICA citta e provincia salvati');
            } else {
                console.log('VERIFICA ANAGRAFICA citta e provincia non salvati');
            }
            spinner.decreaseCounter();
		});
		$A.enqueueAction(action);        
        
    },   
    
    aggiornaDatiIDCollegatoSuOCS: function (component, event){
        var spinner = component.find('spinnerComponent');
        spinner.incrementCounter();        
        
		var action = component.get("c.aggiornaDatiIDCollegatoSuOCS");
		action.setParams({
			collegatoId: component.get("v.selectedCollegatoId"),
		}); 
		action.setCallback(this, function(response){
			if (response.getState() == 'SUCCESS'){
                var datiChiamataOCS=response.getReturnValue();
                if(datiChiamataOCS.chiamataOK){                 
                    this.showToast(component,event,"","success","Dati aggiornati correttamente.","500");
                    console.log('chiamata OCS anadata a buon fine');
                } else {
                    this.showToast(component,event,"Problema nel salvataggio dei dati su OCS (servizio \"Variazione Doc Identita\")","error",datiChiamataOCS.message,"50000");
                    console.log('OCS chiamato ma problema nei dati passati');  
                }
            } else {
                this.showToast(component,event,"Problema nella chiamata del servizio OCS \"Variazione Doc Identita\"","error",datiChiamataOCS.message,"50000");
            }
            spinner.decreaseCounter();
		});
		
		$A.enqueueAction(action);        
        
    },    

    prosegui: function(component, event) {
        var spinner = component.find('spinnerComponent');
        spinner.incrementCounter();        
		var action = component.get("c.valutaNextStepLavorazione");
        var dealerInfo=component.get("v.dealerInfo");
        var chiamataOK;
		action.setParams({
			dealerInfo: dealerInfo,
            caseId: component.get("v.recordId")
		}); 
		action.setCallback(this, function(response){
			if (response.getState() == 'SUCCESS'){
                var datiChiamataOCS=response.getReturnValue();
                chiamataOK=datiChiamataOCS.chiamataOK; 
                if(dealerInfo.Type_Anag__c=='G' && !chiamataOK){
                    this.showToast(component,event,"Problema nella chiamata del servizio OCS \"Recupera Titolari Effettivi\"","error",dealerInfo.message,"50000");
                }                
            } else {
                console.log('problema nell\'aggiornamento dello step oppure nella chiamata del servizio');    
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
            }
            spinner.decreaseCounter();
		});
		$A.enqueueAction(action);         
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
    }
})