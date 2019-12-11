({
    
	callGetDealerAcquisition: function (component, event) {    
        //recupera dati CONVENZIONATO:: 
		var action = component.get("c.getDealerCollegati");
		var caseId = component.get("v.recordId");
		console.log('HELPER NDA:: '+caseId);
		action.setParams({
			caseId: caseId
		}); 
		action.setCallback(this, function(response){
			if (response.getState() == 'SUCCESS'){
                var dati = response.getReturnValue();
				var dealer = dati.dealer;
				component.set("v.dealerAcquisitionId", dealer.dealerId);
                console.log('****SUCCESS');
            } else {
                console.log('****NOT SUCCESS');
            }
        });		
        $A.enqueueAction(action);

	},
    
    ricercaTitolareDatabase :  function (component, event) { 
        var spinner = component.find('spinnerComponent');
        spinner.incrementCounter();        
        
		var action = component.get("c.ricercaTitolareDatabase");
		action.setParams({
			codFiscale: component.get("v.cercaTitolarePerCF"),
            OCS: component.get("v.cercaTitolarePerOCS")
            
		}); 
		action.setCallback(this, function(response){
			if (response.getState() == 'SUCCESS'){
                var titolari = response.getReturnValue();  
                var titolariTrovatiDatabase=[];
                if(titolari.length>0){
                    for (var i=0; i< titolari.length; i++){
                        titolariTrovatiDatabase.push({'label': titolari[i].titolareDescrizione, 'value': titolari[i].titolareId});
                    }
					component.set("v.titolariTrovatiDatabase",titolariTrovatiDatabase);       
                    component.set("v.isTitolariTrovatiDatabase",true);
                    component.set("v.isRicercaEffettuataENessunTitTrovato",false);
                } else {
                    component.set("v.messageNessunTitolareTrovato","Nessun contatto trovato con i parametri inseriti. \nProcedere all\'inserimento di una nuova anagrafica.");
                    component.set("v.isTitolariTrovatiDatabase",false);
                    component.set("v.isRicercaEffettuataENessunTitTrovato",true);   
                    component.set("v.disableButtonDocID",true);
                    component.set("v.titolareId","");
                }
                console.log('titolariTrovatiDatabase:: '+titolari);
            } else {
                console.log('****NOT SUCCESS');
            }
            spinner.decreaseCounter();
        });		
        $A.enqueueAction(action);        
        
    },
    
    salvaRuoloTitolareSuDatabaseEOCS : function (component, event) {
        var spinner = component.find('spinnerComponent');
        spinner.incrementCounter();         
		var action = component.get("c.salvaRuoloTitolareSuDatabaseEOCS");
        console.log('HELPER titolareId:: '+component.get("v.titolareId"));
		action.setParams({
            dealerId: component.get("v.dealerAcquisitionId"),
			titolareId: component.get("v.titolareId")
		}); 
		action.setCallback(this, function(response){
			if (response.getState() == 'SUCCESS'){
                var dati = response.getReturnValue();
                console.log('HELPER CHIAMATA CENSIME TIT OK');
                if(dati.chiamataOK){
                    console.log('HELPER CHIAMATA CENSIME TIT salvaRuoloTitolareSuDatabaseEOCS: '+dati.chiamataOK);                    
                    component.set("v.chiamataOCSCensimRuoloTitOK", true);
                    component.set("v.chiamataOCSCensimRuoloTitEffettuataKO", false);   
                    component.set("v.recordIDDocId", component.get("v.titolareId"));    
                    component.set("v.disableButtonDocID", false);
                } else {
                   console.log('HELPER CHIAMATA CENSIME TIT salvaRuoloTitolareSuDatabaseEOCS NOT: '+dati.chiamataOK); 
                   component.set("v.chiamataOCSCensimRuoloTitOK", false);
                   this.showToast(component,event,"","error",dati.message,"50000");                 
                   component.set("v.chiamataOCSCensimRuoloTitEffettuataKO", true);
                }
            } else {
                console.log('HELPER CHIAMATA CENSIME TIT NOT OK');
            }
            spinner.decreaseCounter();
        });		
        $A.enqueueAction(action);
        
    },
    
    salvaAnagraficaNuovoTitolareSuOCS : function (component, event) {
        var spinner = component.find('spinnerComponent');
        spinner.incrementCounter();        
		var action = component.get("c.salvaNuovoTitolareSuOCS");
        console.log('HELPER titolareId:: '+component.get("v.titolareId"));
		action.setParams({
			titolareId: component.get("v.titolareId")
		}); 
		action.setCallback(this, function(response){
			if (response.getState() == 'SUCCESS'){
                var dati = response.getReturnValue();
                if(dati.chiamataOK){
                    console.log('**** salvaAnagraficaNuovoTitolareSuOCS chiamataOK: '+dati.chiamataOK);
                    component.set("v.chiamataOCSCensimNuovoTitOK", true);
                    component.set("v.chiamataOCSCensimNuovoTitEffettuataKO", false);   
                    component.set("v.recordIDDocId", component.get("v.titolareId"));
                    this.salvaRuoloTitolareSuDatabaseEOCS(component, event);
                } else {
                   console.log('**** salvaAnagraficaNuovoTitolareSuOCS NOT chiamataOK: '+dati.chiamataOK);
                   component.set("v.chiamataOCSCensimNuovoTitOK", false);
                   this.showToast(component,event,"","error",dati.message,"50000");
                   component.set("v.chiamataOCSCensimNuovoTitEffettuataKO", true);
                }
            } else {
                console.log('****NOT SUCCESS');
            }
            spinner.decreaseCounter();
        });		
        $A.enqueueAction(action);
        
    },
        
    aggiornaDatiIDTitolare: function (component, event){
        var spinner = component.find('spinnerComponent');
        spinner.incrementCounter();        
        component.find('FormID').submit();
		var action = component.get("c.salvaProvinciaECittaRilascioIDTitolare");
		console.log('HELPER salvaProvinciaECitta');
		action.setParams({
			titolareId: component.get("v.titolareId"),
            provinciaRilascio: component.get("v.provinciaRilascioDocumento"),
            luogoRilascio: component.get("v.cittaRilascioDocumento"),            
		}); 
		action.setCallback(this, function(response){
			if (response.getState() == 'SUCCESS'){
                this.aggiornaDatiIDTitolareSuOCS(component, event);
                console.log('VERIFICA ANAGRAFICA citta e provincia salvati');
            } else {
                console.log('VERIFICA ANAGRAFICA citta e provincia non salvati');
            }
            spinner.decreaseCounter();
		});
		
		$A.enqueueAction(action);         
    },    
    
    aggiornaDatiIDTitolareSuOCS : function (component, event){
        var spinner = component.find('spinnerComponent');
        spinner.incrementCounter();        
		var action = component.get("c.aggiornaDatiIDTitolareSuOCS");
		action.setParams({
			titolareId: component.get("v.titolareId"),
		}); 
		action.setCallback(this, function(response){
			if (response.getState() == 'SUCCESS'){
                var datiChiamataOCS=response.getReturnValue();
                if(datiChiamataOCS.chiamataOK){
                    this.showToast(component,event,"","success","Dati aggiornati correttamente.","500"); 
                    console.log('chiamata OCS andata a buon fine');
                    component.set("v.disableButtonAvanti",false);
                } else {
                    this.showToast(component,event,"","error","Errore nel salvataggio! Controllare i dati inseriti.","5000");                 
                    console.log('OCS chiamato ma problema nei dati passati');
                    component.set("v.disableButtonAvanti",true);
                       
                }
                console.log('dati ID aggiornati');
            } else {
                this.showToast(component,event,"","error","Problema nel salvataggio dei dati su OCS (servizio \"Variazione Doc Identità\"). \n Rivolgersi al proprio amministratore di sistema.","5000");                 
            }
            spinner.decreaseCounter();
		});
		
		$A.enqueueAction(action);        
        
    },
    
    setProvinciaEluogoRilascioDocumentoTitolare : function (component, event) {
        var spinner = component.find('spinnerComponent');
        spinner.incrementCounter();        
		var action = component.get("c.getProvinciaECittaRilascioIDTitolare");
		console.log('HELPER salvaProvinciaECitta');
		action.setParams({
			titolareId: component.get("v.titolareId")           
		}); 
		action.setCallback(this, function(response){
			if (response.getState() == 'SUCCESS'){
				var dati = response.getReturnValue();
                component.set("v.provinciaRilascioDocumento",dati.provinciaRilascioDocumento);
                component.set("v.cittaRilascioDocumento",dati.cittaRilascioDocumento);
                var picklistProvinceCollegato=component.find("provinciaRilascioDocumento"); 
                picklistProvinceCollegato.inizializza();                
                this.salvaRuoloTitolareSuDatabaseEOCS(component, event);  //setto la provincia e luogo rilascio documento e poi salvo su OCS sul database
            }
            spinner.decreaseCounter();
		});
		
		$A.enqueueAction(action);         
    },    

    valutaSeSalvareTitolare : function (component, event) {
        console.log('*******valutaSeSalvareTitolare');
        var LastName=component.find("LastName").get("v.value");
        console.log('*******LastName: '+LastName);
        var FirstName=component.find("FirstName").get("v.value");
		var Codice_Fiscale__c=component.find("Codice_Fiscale__c").get("v.value");
		var Birthdate=component.find("Birthdate").get("v.value");
		var Provincia_Nascita__c=component.get("v.provinciaNascitaTitolare");
		var Luogo_Nascita__c=component.get("v.cittaNascitaTitolare");
		var Sesso__c=component.find("Sesso__c").get("v.value");
		var Email=component.find("Email").get("v.value");
		var MailingStreet=component.find("MailingStreet").get("v.value");
		var MailingPostalCode=component.find("MailingPostalCode").get("v.value");
        var MailingState=component.get("v.provinciaResidenzaTitolare");
        var MailingCity=component.get("v.cittaResidenzaTitolare");       
        if(!LastName || !FirstName || !Codice_Fiscale__c || !Birthdate || !Provincia_Nascita__c || !Luogo_Nascita__c || !Sesso__c || !Email || !MailingStreet || !MailingPostalCode ||!MailingState ||!MailingCity){
            this.showToast(component,event,"","error","Attenzione: completare tutti i dati per poter salvare il titolare.","500");                 
        } else {
            if(Codice_Fiscale__c.length!=16 && Codice_Fiscale__c.length!=11){
                this.showToast(component,event,"","error","Formato codice fiscale non corretto.","500"); 
            } else {
                component.find('FormNewTitolare').submit();
            }
            //component.find('FormNewTitolare').submit(); 
        }
    },
      
    aggiornaProvinciaCittaNascitaResidenzaNewTitolare: function (component, event){
        var spinner = component.find('spinnerComponent');
        spinner.incrementCounter();        
		var action = component.get("c.aggiornaProvinciaCittaNascitaResidenzaNewTitolare");
		console.log('HELPER salvaProvinciaECitta');
		action.setParams({
			titolareId: component.get("v.titolareId"),
            provinciaResidenzaTitolare: component.get("v.provinciaResidenzaTitolare"),
            cittaResidenzaTitolare: component.get("v.cittaResidenzaTitolare"), 
            provinciaNascitaTitolare: component.get("v.provinciaNascitaTitolare"),
            cittaNascitaTitolare: component.get("v.cittaNascitaTitolare"),          
		}); 
		action.setCallback(this, function(response){
			if (response.getState() == 'SUCCESS'){
                this.salvaAnagraficaNuovoTitolareSuOCS(component, event);
                console.log('VERIFICA ANAGRAFICA citta e provincia salvati');
            } else {
                console.log('VERIFICA ANAGRAFICA citta e provincia non salvati');
            }
            spinner.decreaseCounter();
		});
		
		$A.enqueueAction(action);         
    },    

    avanti: function(component, event) {
        var spinner = component.find('spinnerComponent');
        spinner.incrementCounter();        
		var action = component.get("c.valutaNextStepLavorazione");
		action.setParams({
            caseId: component.get("v.recordId")
		}); 
		action.setCallback(this, function(response){
			if (response.getState() == 'SUCCESS'){
				console.log('nuovo step aggiornato.');                 
            } else {
                console.log('problema nell\'aggiornamento dello step.');    
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
    },     
   
})