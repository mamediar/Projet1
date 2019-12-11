({

	/*callGetDealerAcquisition: function (component, event) {
        console.log('***********callGetDealerAcquisition');
        //recupera dati CONVENZIONATO::        
		var action = component.get("c.getDealerCollegati");
		var caseId = component.get("v.recordId");
		console.log('HELPER NDA:: '+caseId);
		action.setParams({
			caseId: caseId
		}); 
		action.setCallback(this, function(response){
			if (response.getState() == 'SUCCESS'){
                console.log('VERIFICA ANAGRAFICA RESPONSE SUCCESS');
                var dati = response.getReturnValue();
				var dealer = dati.dealer;
                var collegati = dati.collegati;  
				component.set("v.dealerAcquisitionId", dealer.dealerId);
                component.set("v.reportCervedId", dealer.reportCervedId);
                component.set("v.OCSExternalFiliale", dealer.OCSExternalFiliale);
                component.set("v.disposition", dealer.disposition);   
                component.set("v.contactDiRiferimentoId", dealer.contactDiRiferimentoId);  
                component.set("v.provincia", dealer.dealerInfo.ShippingState);                                  
                component.set("v.citta", dealer.dealerInfo.ShippingCity);
                var picklistProvinceCollegato=component.find("ProvincePicklistDealer"); 
                picklistProvinceCollegato.inizializza(); 
                component.set("v.tipoIntermediario", dealer.dealerInfo.Tipo_Intermediario__c);
                var optionsTipoIntermediario2 = [];
                for(var i= 0 ; i < dati.optionsTipoIntermediario2.length ; i++){
                    optionsTipoIntermediario2.push(dati.optionsTipoIntermediario2[i]);
                }                    
                component.set("v.optionsTipoIntermediario2",optionsTipoIntermediario2);                                               
                if(dealer.dealerInfo.Tipo_Intermediario__c=='PV'){    //Se si tratta di PV --> P.IVA e C.F. non sono richiesti
                    component.set("v.PIVAeCFrequired",false);
                } else {
                    component.set("v.messagePIVA_CF_Required","P.IVA e CF sono obbligatori.");
                }
                var collegatiSoci = collegati.collegatiSoci;  
                var collegatiNonSoci = collegati.collegatiNonSoci;  
                var collegati = [];
                var mailingStreet,mailingCity,mailingPostalCode,mailingState;
                //collegati SOCI::
                for (var i=0; i< collegatiSoci.length; i++)
                {
                    mailingStreet= collegatiSoci[i].contactCollegato.MailingStreet==null?'':collegatiSoci[i].contactCollegato.MailingStreet+' -';
                    mailingCity= collegatiSoci[i].contactCollegato.MailingCity==null?'':collegatiSoci[i].contactCollegato.MailingCity;
                    mailingPostalCode= collegatiSoci[i].contactCollegato.MailingPostalCode==null?'':collegatiSoci[i].contactCollegato.MailingPostalCode;
                    mailingState= collegatiSoci[i].contactCollegato.MailingState==null?'':'('+collegatiSoci[i].contactCollegato.MailingState+')';
                    var Item = {
                        Id: collegatiSoci[i].contactCollegato.Id,
                        contactRelationId: collegatiSoci[i].accountContactCollegato.Id,
                        Roles: collegatiSoci[i].accountContactCollegato.Roles,
                        LastName: collegatiSoci[i].contactCollegato.LastName,
                        TipoAnagrafica: collegatiSoci[i].contactCollegato.Tipo_Anagrafica__c,
                        OCS_External_Id__c: collegatiSoci[i].contactCollegato.OCS_External_Id__c,
                        FirstName: collegatiSoci[i].contactCollegato.FirstName,
                        Sesso__c: collegatiSoci[i].contactCollegato.Sesso__c,
                        Luogo_Nascita__c: collegatiSoci[i].contactCollegato.Luogo_Nascita__c,
                        Provincia_Nascita__c: collegatiSoci[i].contactCollegato.Provincia_Nascita__c,
                        Birthdate: collegatiSoci[i].contactCollegato.Birthdate,
                        Codice_Fiscale__c: collegatiSoci[i].contactCollegato.Codice_Fiscale__c,
                        MailingAddress: mailingStreet+' '+mailingCity+' '+mailingPostalCode+' '+mailingState,
                        MailingState: collegatiSoci[i].contactCollegato.MailingState,
                        MailingCity: collegatiSoci[i].contactCollegato.MailingCity,
                        isCollegatoRappresentante: collegatiSoci[i].accountContactCollegato.isCollegatoRappresentante__c,
                        isCollegatoFirmatario: collegatiSoci[i].accountContactCollegato.isCollegatoFirmatario__c,
                        Email: collegatiSoci[i].contactCollegato.Email,
                    	Rimosso: 'NO'};
                    collegati.push(Item);
                }                               
                
                //collegati NON SOCI::
                for (var i=0; i< collegatiNonSoci.length; i++)
                {
                    var rimossoValue='NO';
                    if(collegatiNonSoci[i].accountContactCollegato.isCollegatoEliminato__c){
                        rimossoValue='Sì';
                    }
                    mailingStreet= collegatiNonSoci[i].contactCollegato.MailingStreet==null?'':collegatiNonSoci[i].contactCollegato.MailingStreet+' -';
                    mailingCity= collegatiNonSoci[i].contactCollegato.MailingCity==null?'':collegatiNonSoci[i].contactCollegato.MailingCity;
                    mailingPostalCode= collegatiNonSoci[i].contactCollegato.MailingPostalCode==null?'':collegatiNonSoci[i].contactCollegato.MailingPostalCode;
                    mailingState= collegatiNonSoci[i].contactCollegato.MailingState==null?'':'('+collegatiNonSoci[i].contactCollegato.MailingState+')';                    
                    var Item = {
                        Id: collegatiNonSoci[i].contactCollegato.Id,
                        contactRelationId: collegatiNonSoci[i].accountContactCollegato.Id,
                        Roles: collegatiNonSoci[i].accountContactCollegato.Roles,
                        LastName: collegatiNonSoci[i].contactCollegato.LastName,
                        TipoAnagrafica: collegatiNonSoci[i].contactCollegato.Tipo_Anagrafica__c,
                        OCS_External_Id__c: collegatiNonSoci[i].contactCollegato.OCS_External_Id__c,
                        FirstName: collegatiNonSoci[i].contactCollegato.FirstName,
                        Sesso__c: collegatiNonSoci[i].contactCollegato.Sesso__c,
                        Luogo_Nascita__c: collegatiNonSoci[i].contactCollegato.Luogo_Nascita__c,
                        Provincia_Nascita__c: collegatiNonSoci[i].contactCollegato.Provincia_Nascita__c,
                        Birthdate: collegatiNonSoci[i].contactCollegato.Birthdate,
                        Codice_Fiscale__c: collegatiNonSoci[i].contactCollegato.Codice_Fiscale__c,
                        MailingAddress: mailingStreet+' '+mailingCity+' '+mailingPostalCode+' '+mailingState,
                        MailingState: collegatiNonSoci[i].contactCollegato.MailingState,
                        MailingCity: collegatiNonSoci[i].contactCollegato.MailingCity,                        
                        isCollegatoRappresentante: collegatiNonSoci[i].accountContactCollegato.isCollegatoRappresentante__c,
                        isCollegatoFirmatario: collegatiNonSoci[i].accountContactCollegato.isCollegatoFirmatario__c,
                        Email: collegatiNonSoci[i].contactCollegato.Email,
                        Rimosso: rimossoValue};
                    collegati.push(Item);
                }                                
                component.set("v.collegati",collegati);
            } else {
                console.log('VERIFICA ANAGRAFICA RESPONSE NOT SUCCESS');
            }
            });		
        $A.enqueueAction(action);

	},*/


	callGetDealerAcquisition: function (component, event) {
        console.log('***********callGetDealerAcquisition');
        //recupera dati CONVENZIONATO::        
		var action = component.get("c.getDealerCollegati");
		var caseId = component.get("v.recordId");
		console.log('HELPER NDA:: '+caseId);
		action.setParams({
			caseId: caseId
		}); 
		action.setCallback(this, function(response){
			if (response.getState() == 'SUCCESS'){
                console.log('VERIFICA ANAGRAFICA RESPONSE SUCCESS');
                var dati = response.getReturnValue();
				var dealer = dati.dealer;
                var collegatiSoci = dati.collegati;  
				component.set("v.dealerAcquisitionId", dealer.dealerId);
                component.set("v.reportCervedId", dealer.reportCervedId);
                component.set("v.OCSExternalFiliale", dealer.OCSExternalFiliale);
                component.set("v.disposition", dealer.disposition);   
                component.set("v.contactDiRiferimentoId", dealer.contactDiRiferimentoId);  
                component.set("v.provincia", dealer.dealerInfo.ShippingState);                                  
                component.set("v.citta", dealer.dealerInfo.ShippingCity);
                
                var picklistProvinceCollegato=component.find("ProvincePicklistDealer"); 
                picklistProvinceCollegato.inizializza(); 
                component.set("v.tipoIntermediario", dealer.dealerInfo.Tipo_Intermediario__c);
                var optionsTipoIntermediario2 = [];
                for(var i= 0 ; i < dati.optionsTipoIntermediario2.length ; i++){
                    optionsTipoIntermediario2.push(dati.optionsTipoIntermediario2[i]);
                }                    
                component.set("v.optionsTipoIntermediario2",optionsTipoIntermediario2); 
                console.log('***dealer.dealerInfo.Tipo_Intermediario__c: '+dealer.dealerInfo.Tipo_Intermediario__c);
                if(dealer.dealerInfo.Tipo_Intermediario__c=='PV'){    //Se si tratta di PV --> P.IVA e C.F. non sono richiesti
                    component.set("v.PIVAeCFrequired",false);
                } else {
                    component.set("v.PIVAeCFrequired",true);
                    component.set("v.messagePIVA_CF_Required","P.IVA e CF sono obbligatori.");
                }
                var collegati = [];
                var mailingStreet,mailingCity,mailingPostalCode,mailingState;
                //collegati SOCI::
                for (var i=0; i< collegatiSoci.length; i++)
                {
                    var rimossoValue='NO';
                    if(collegatiSoci[i].accountContactCollegato.isCollegatoEliminato__c){
                        rimossoValue='Sì';
                    }                    
                    mailingStreet= collegatiSoci[i].contactCollegato.MailingStreet==null?'':collegatiSoci[i].contactCollegato.MailingStreet+' -';
                    mailingCity= collegatiSoci[i].contactCollegato.MailingCity==null?'':collegatiSoci[i].contactCollegato.MailingCity;
                    mailingPostalCode= collegatiSoci[i].contactCollegato.MailingPostalCode==null?'':collegatiSoci[i].contactCollegato.MailingPostalCode;
                    mailingState= collegatiSoci[i].contactCollegato.MailingState==null?'':'('+collegatiSoci[i].contactCollegato.MailingState+')';
                    var Item = {
                        Id: collegatiSoci[i].contactCollegato.Id,
                        contactRelationId: collegatiSoci[i].accountContactCollegato.Id,
                        Roles: collegatiSoci[i].accountContactCollegato.Roles,
                        LastName: collegatiSoci[i].contactCollegato.LastName,
                        TipoAnagrafica: collegatiSoci[i].contactCollegato.Tipo_Anagrafica__c,
                        OCS_External_Id__c: collegatiSoci[i].contactCollegato.OCS_External_Id__c,
                        FirstName: collegatiSoci[i].contactCollegato.FirstName,
                        Sesso__c: collegatiSoci[i].contactCollegato.Sesso__c,
                        Luogo_Nascita__c: collegatiSoci[i].contactCollegato.Luogo_Nascita__c,
                        Provincia_Nascita__c: collegatiSoci[i].contactCollegato.Provincia_Nascita__c,
                        Birthdate: collegatiSoci[i].contactCollegato.Birthdate,
                        Codice_Fiscale__c: collegatiSoci[i].contactCollegato.Codice_Fiscale__c,
                        MailingAddress: mailingStreet+' '+mailingCity+' '+mailingPostalCode+' '+mailingState,
                        MailingState: collegatiSoci[i].contactCollegato.MailingState,
                        MailingCity: collegatiSoci[i].contactCollegato.MailingCity,
                        isCollegatoRappresentante: collegatiSoci[i].accountContactCollegato.isCollegatoRappresentante__c,
                        isCollegatoFirmatario: collegatiSoci[i].accountContactCollegato.isCollegatoFirmatario__c,
                        Email: collegatiSoci[i].contactCollegato.Email,
                    	Rimosso: rimossoValue};
                    collegati.push(Item);
                }            
                component.set("v.collegati",collegati);
            } else {
                console.log('VERIFICA ANAGRAFICA RESPONSE NOT SUCCESS');
            }
            });		
        $A.enqueueAction(action);

	},     
    
	controllaSeAndareAvantiPossibile: function(component, event) {
		console.log('controllaSeAndareAvantiPossibile!!');
        
        var spinner = component.find('spinnerComponent');
        spinner.incrementCounter();     
        
        var action = component.get("c.segnalaErroreSalvataggio");   
        action.setParams({
        dealerAcquisitionId: component.get("v.dealerAcquisitionId"),
        Partita_IVA: component.find("Partita_IVA__c").get("v.value"),
        Codice_Fiscale: component.find("Codice_Fiscale__c").get("v.value"),
        PIVAeCFrequired: component.get("v.PIVAeCFrequired"),
        telefonoSede: component.find("Phone").get("v.value"),   
		ShippingStreet: component.find("ShippingStreet").get("v.value"),            
        ShippingPostalCode: component.find("ShippingPostalCode").get("v.value"),
        provincia: component.get("v.provincia"),
        citta: component.get("v.citta"),
        MobilePhone: component.find("MobilePhone").get("v.value"),
        tipoIntermediarioDealer: component.get("v.tipoIntermediario"),
        tipoIntermediarioDealer2Selezionato: component.get("v.tipoIntermediario2Selezionato")            
        });        
        action.setCallback(this, function(response){
            if (response.getState() == 'SUCCESS'){
                var datiVerifica = response.getReturnValue();
                if(datiVerifica.errorSave){
                    component.set("v.erroreSalvataggioDatiMancanti", true); 
                    var messages=datiVerifica.message;
                    var messageDatiMancanti = [];
                    for(var i= 0 ; i < messages.length ; i++){
                        messageDatiMancanti.push(messages[i]);
                    }                     
                    component.set("v.messageDatiMancanti",messageDatiMancanti);
                    console.log('messageDatiMancanti:: '+component.get("v.messageDatiMancanti"));
                    console.log('Errore');      
                    console.log('operazione di salvataggio non andata a buon fine');  
                    //spinner.decreaseCounter();
                } else {  
                    component.set("v.messageDatiMancanti","");   
                    component.set("v.erroreSalvataggioDatiMancanti",false);
                    
                    if(datiVerifica.datiChiamataOCS.chiamataOK){
                        component.set("v.showButtonTravasaSuOCS",true);
                        var indirizziElenco = datiVerifica.datiChiamataOCS.indirizziElenco;  
                        var indirizziDealerList = [];                
                        if(indirizziElenco.length==1){
                            component.find("ShippingStreet").set("v.value",indirizziElenco[0].indirizzo);   
                            component.find("ShippingPostalCode").set("v.value",indirizziElenco[0].cap);
                            component.set("v.provincia",indirizziElenco[0].provincia);
                            component.set("v.citta",indirizziElenco[0].localita);
                            component.find('FormDealer1').submit();    //salva i dati inseriti nel form solo nel caso il servizio mi restituisce un unico indirizzo, altrimenti opero il salvataggio una volta che la modale è stata chiusa in seguito alla selezione della riga di indirizzo corretta
                            component.find('FormDealer2').submit();
                            component.find('FormContactDiRiferimento').submit();   
                            this.salvaProvinciaECitta(component, event);
                        } else if(indirizziElenco.length==0){
                            this.showToast(component,event,"","error","Nessun indirizzo corrispondente trovato.","500"); 
                            //spinner.decreaseCounter();
                        } else {
                             for (var i=0; i< indirizziElenco.length; i++)
                             {
                                 console.log('**********indirizziElenco[i].Indirizzo:: '+ indirizziElenco[i].indirizzo);
                                 var Item = {
                                     Indirizzo: indirizziElenco[i].indirizzo,
                                     Localita: indirizziElenco[i].localita,
                                     CAP: indirizziElenco[i].cap,
                                     Provincia: indirizziElenco[i].provincia,
                                     Nazione: indirizziElenco[i].nazione};
                                 indirizziDealerList.push(Item);
                                 console.log('indirizziDealerList Item:: '+ Item); 
                             }                         
                             component.set("v.openModaleIndirizzoDealer",true);
                             component.set("v.indirizziDealerList",indirizziDealerList);
                             component.set("v.disableButtonChiudiModaleIndirizzoDealer",true);
                             //spinner.decreaseCounter();
                         }                                    
                    } else {
                        this.showToast(component,event,"","error",datiVerifica.datiChiamataOCS.message,"50000");
                        //spinner.decreaseCounter();
                    }
                    //spinner.decreaseCounter();
                    console.log('operazione di salvataggio andata a buon fine');
                }
                spinner.decreaseCounter();
            }
        });
        $A.enqueueAction(action);         
	},    

    aggiornaDatiCollegato : function (component, event){
        //component.set("v.showSpinnerModale",true);
        var spinner = component.find('spinnerComponent');
        spinner.incrementCounter();     
        
        component.find('FormCollegato').submit();
        
		var action = component.get("c.salvaDatiAggiuntiviCollegato");
		console.log('HELPER salvaProvinciaECittaCollegato');
		action.setParams({
			collegatoId: component.get("v.selectedAccountId"),
            provincia: component.get("v.provinciaCollegato"),
            citta: component.get("v.cittaCollegato"),
            provinciaNascita: component.get("v.provinciaNascitaCollegato"),
            cittaNascita: component.get("v.cittaNascitaCollegato"),            
            isCollegatoRappresentante : component.get("v.isCollegatoRappresentante"),
            isCollegatoFirmatario : component.get("v.isCollegatoFirmatario"),
            selectedcontactRelationId : component.get("v.selectedcontactRelationId"),
            indirizzo : component.find("MailingStreet").get("v.value")
		}); 
		action.setCallback(this, function(response){
			if (response.getState() == 'SUCCESS'){
                console.log('HELPER "aggiornaDatiCollegato" CHIAMATA SUCCESS');
                var datiVerifica = response.getReturnValue();
                var datiChiamataOCS =datiVerifica.datiChiamataOCS;
                if(datiChiamataOCS.chiamataOK){
                    console.log('HELPER "aggiornaDatiCollegato" CHIAMATA OK');
                    if(datiChiamataOCS.indirizziElenco.length==1){
                        component.find("MailingPostalCode").set("v.value",datiChiamataOCS.indirizziElenco[0].cap);
                        component.find("MailingStreet").set("v.value",datiChiamataOCS.indirizziElenco[0].indirizzo);
                        console.log('HELPER "aggiornaDatiCollegato" ELENCO 1');
                        this.showToast(component,event,"","success","Dati aggiornati correttamente.","500");
                    } else if(datiChiamataOCS.indirizziElenco.length==0){
                        this.showToast(component,event,"","error","Nessun indirizzo corrispondente trovato.","500");
                    } else {
                        console.log('HELPER "aggiornaDatiCollegato" ELENCO > 1');
                        component.set("v.showTableMutipleAddressesCollegati",true); 
                        component.set("v.isOpen",false);
                        var indirizziElenco = datiChiamataOCS.indirizziElenco;  
                        var indirizziList = [];                
                        //collegati SOCI::
                        for (var i=0; i< indirizziElenco.length; i++)
                        {
                            console.log('**********indirizziElenco[i].Indirizzo:: '+ indirizziElenco[i].indirizzo);
                            var Item = {
                                Indirizzo: indirizziElenco[i].indirizzo,
                                Localita: indirizziElenco[i].localita,
                                CAP: indirizziElenco[i].cap,
                                Provincia: indirizziElenco[i].provincia,
                            	Nazione: indirizziElenco[i].nazione};
                            indirizziList.push(Item);
                            console.log('indirizziList Item:: '+ Item); 
                        }
                        console.log('indirizziList: '+indirizziList);
                        component.set("v.indirizziList",indirizziList);
                    }
                } else {
                    console.log('HELPER "aggiornaDatiCollegato" CHIAMATA NOT OK');
                    this.showToast(component,event,"","error",datiChiamataOCS.message,"50000");
                }
            } else {
                this.showToast(component,event,"","error","Errore nell\'aggiornamento dei dati.","50000");
                console.log('HELPER "aggiornaDatiCollegato" CHIAMATA NOT SUCCESS');
            }
            spinner.decreaseCounter();
            //component.set("v.showSpinnerModale",false);
		});
		
		$A.enqueueAction(action);
        
        
    },    
    
    salvaProvinciaECitta: function(component, event) {
        
        var spinner = component.find('spinnerComponent');
        spinner.incrementCounter();
        
		var action = component.get("c.salvaProvinciaECitta");
		console.log('HELPER salvaProvinciaECitta');
		action.setParams({
			dealerAcquisitionId: component.get("v.dealerAcquisitionId"),
            provincia: component.get("v.provincia"),
            citta: component.get("v.citta"),            
            
		}); 

		action.setCallback(this, function(response){
			if (response.getState() == 'SUCCESS'){
                console.log('VERIFICA ANAGRAFICA citta e provincia salvati');
            } else {
                console.log('VERIFICA ANAGRAFICA citta e provincia non salvati');
            }
            spinner.decreaseCounter();
		});
		
		$A.enqueueAction(action);        
    },
   
    handleDeleteCollegato: function(component, row) {
		var action = component.get("c.rimuoviRipristinaCollegato");
		console.log('HELPER rimuoviRipristinaCollegato');
		action.setParams({
			accountContactRelationCollegatoId: row.contactRelationId                       
		});   

		action.setCallback(this, function(response){
			if (response.getState() == 'SUCCESS'){
                console.log('collegato eliminato/ripristinato con successo');
                this.callGetDealerAcquisition(component, event);
            } else {
                console.log('collegato eliminato/ripristinato senza successo');
            }
		});		
		$A.enqueueAction(action);        
    },    

    travasaSuOCS: function(component, event){
        var spinner = component.find('spinnerComponent');
        spinner.incrementCounter();        
		var action1 = component.get("c.travasaSuOCSPrimoServizio");
        //Chiamata primo servizio
		action1.setParams({
			dealerAcquisitionId: component.get("v.dealerAcquisitionId")
		});   
		action1.setCallback(this, function(response1){
			if (response1.getState() == 'SUCCESS'){
                //Processa dati primo servizio
                var responsePrimoServizio = response1.getReturnValue();
                console.log('BEFORE processaRispostaPrimoServizio');
                this.processaRispostaPrimoServizio(component, event,responsePrimoServizio);
				console.log('AFTER processaRispostaPrimoServizio');                
            } else {
                console.log('dati NON travasasti su OCS correttamente');
                component.set("v.isChiamataOCSNotOK",true);
                component.set("v.showButtonTravasaSuOCS",false);
                console.log('BEFORE MESSAGES responsePrimoServizioProcessata');
                var messageOCS = [];
                messageOCS.push('Chiamata dei servizi di travaso informazioni su OCS non andata a buon fine. Rivolgersi all\'amministratore di sistema.');                        
                component.set("v.errorMessagesOCS",messageOCS);                
                component.set("v.showSpinner",false); 
            }
            spinner.decreaseCounter();
		});
		$A.enqueueAction(action1);        
    },
    
	processaRispostaPrimoServizio: function(component, event,responsePrimoServizio){
		var action = component.get("c.processaRispostaPrimoServizio");
        var spinner = component.find('spinnerComponent');
        spinner.incrementCounter();        
        //Processa dati primo servizio
        console.log('INSIDE processaRispostaPrimoServizio');
		action.setParams({
			dealerAcquisitionId: component.get("v.dealerAcquisitionId"),
            responsePrimoServizio: responsePrimoServizio
		});   
		action.setCallback(this, function(response){
			if (response.getState() == 'SUCCESS'){
                var responsePrimoServizioProcessata = response.getReturnValue();
                console.log('INSIDE processaRispostaPrimoServizio  responsePrimoServizioProcessata:: '+responsePrimoServizioProcessata);
                component.set("v.collegatiList",responsePrimoServizioProcessata.collegati);
                if(responsePrimoServizioProcessata.chiamataOK){
                   console.log('BEFORE OCSSecondoTerzoQuartoServizio');
                   this.OCSSecondoTerzoQuartoServizio(component, event,responsePrimoServizioProcessata.collegati); 
                   console.log('AFTER OCSSecondoTerzoQuartoServizio');
                } else {
                    component.set("v.isChiamataOCSNotOK",true);
                    component.set("v.showButtonTravasaSuOCS",false);
                    console.log('BEFORE MESSAGES responsePrimoServizioProcessata');
                    var messages=responsePrimoServizioProcessata.message;
                    var messageOCS = [];
                    for(var i= 0 ; i < messages.length ; i++){
                        messageOCS.push(messages[i]);
                    }                    
                    component.set("v.errorMessagesOCS",messageOCS);
                    console.log('AFTER MESSAGES responsePrimoServizioProcessata:: '+messageOCS);
                    component.set("v.showSpinner",false); 
                }               
                
                var dealer=responsePrimoServizioProcessata.dealer; 
                console.log('dati travasasti su OCS correttamente PRIMO SERVIZIO');
            } else {
                console.log('dati NON travasasti su OCS correttamente');
                component.set("v.isChiamataOCSNotOK",true);
                component.set("v.showButtonTravasaSuOCS",false);
                console.log('BEFORE MESSAGES responsePrimoServizioProcessata');
                var messageOCS = [];
                messageOCS.push('Chiamata dei servizi di travaso informazioni su OCS non andata a buon fine. Rivolgersi all\'amministratore di sistema.');                        
                component.set("v.errorMessagesOCS",messageOCS);                
                component.set("v.showSpinner",false);                 
            }
            spinner.decreaseCounter();
		});
		$A.enqueueAction(action);        
        
    },
    
    OCSSecondoTerzoQuartoServizio: function(component, event, collegatiList){
		var action = component.get("c.travasaSuOCSSecondoTerzoQuartoServizio");
		console.log('INSIDE OCSSecondoTerzoQuartoServizio');
        var spinner = component.find('spinnerComponent');
        spinner.incrementCounter();        
        //Chiamata altri servizi
		action.setParams({
			dealerAcquisitionId: component.get("v.dealerAcquisitionId"),
            collegatiList:collegatiList
		});   
		action.setCallback(this, function(response){
			if (response.getState() == 'SUCCESS'){
                //Processa dati altri servizi
                var responseServizi = response.getReturnValue();
                if(!responseServizi.chiamataOK){
                    component.set("v.isChiamataOCSNotOK",true); 
                    component.set("v.showButtonTravasaSuOCS",false);
                    var messages=responseServizi.message;
                    var messageOCS = [];
                    for(var i= 0 ; i < messages.length ; i++){
                        messageOCS.push(messages[i]);
                    }
					console.log('INSIDE OCSSecondoTerzoQuartoServizio MESSAGES:: '+messageOCS);                    
                    component.set("v.errorMessagesOCS",messageOCS); 
                    component.set("v.showSpinner",false); 
                } else {
                    component.set("v.showSpinner",false); 
                    console.log('INSIDE OCSSecondoTerzoQuartoServizio tutti i servizi andati a buon fine');
                    //CAMBIO STEP ATTIVITà E PASSAGGIO AD "RECUPERO INTESE E DOCUMENTI"
                        var action2 = component.get("c.passaAStepRecuperoIntese");
                        console.log('INSIDE OCSSecondoTerzoQuartoServizio');
                        //Chiamata altri servizi
                        action2.setParams({
                            caseId: component.get("v.recordId")
                        });   
                        action2.setCallback(this, function(response2){
                            console.log('"""""""""step aggiornato');
                            if (response2.getState() == 'SUCCESS'){
                                this.changeCategoriaStepLavorazioneEvent(component,event);
                            }
                        });
                    	$A.enqueueAction(action2);   
                }
            } else {
                console.log('INSIDE OCSSecondoTerzoQuartoServizio problema nella chiamata della classe "travasaSuOCSSecondoTerzoQuartoServizio"');
                component.set("v.isChiamataOCSNotOK",true);
                component.set("v.showButtonTravasaSuOCS",false);
                console.log('BEFORE MESSAGES responsePrimoServizioProcessata');
                var messageOCS = [];
                messageOCS.push('Chiamata dei servizi di travaso informazioni su OCS non andata a buon fine. Rivolgersi all\'amministratore di sistema.');                        
                component.set("v.errorMessagesOCS",messageOCS);                
                component.set("v.showSpinner",false);            
            }
            spinner.decreaseCounter();
		});
		$A.enqueueAction(action);       
    },
    
    changeCategoriaStepLavorazioneEvent: function (component, event){
		var action = component.get("c.getCategoriaEStepLavorazione");
        var spinner = component.find('spinnerComponent');
        spinner.incrementCounter();        
        var changeStepEvent = $A.get("e.c:ChangeCaseStepEvent");         
		action.setParams({
			caseId: component.get("v.recordId"),
		}); 
		action.setCallback(this, function(response){
			if (response.getState() == 'SUCCESS'){
                var dati=response.getReturnValue();
                console.log('!!!!!!!!!!EVENTO LANCIATO');
                if (changeStepEvent) {
                    changeStepEvent.setParams({
                        'categoria' : dati.categoria,
                        'stepLavorazione' : dati.stepLavorazione
                    });
                    changeStepEvent.fire();
                }                 
            } else {
                console.log('!!!!!!!!!!EVENTO NON LANCIATO');
            }
            spinner.decreaseCounter();
		});
		$A.enqueueAction(action);         
    },     
    
    salvaIndirizzoDealerDaDatatable: function(component, event) {   //mi salva la riga di indirizzo slelezionata nella modale, e allo stesso tempo mi va a fare il submit dei vari form perchè a questo punto vuol dire che tutti i dati vanno bene
		var action = component.get("c.salvaIndirizzoDealerDaDatatable");
        var indirizzoRow=component.get("v.selectedIndirizzoDealer");
		action.setParams({
			dealerId: component.get("v.dealerAcquisitionId"),
            indirizzo: indirizzoRow.Indirizzo,
            localita: indirizzoRow.Localita,
            cap: indirizzoRow.CAP,
            provincia: indirizzoRow.Provincia,
            nazione: indirizzoRow.Nazione
		});    
		action.setCallback(this, function(response){
			if (response.getState() == 'SUCCESS'){
                component.set("v.disableButtonChiudiModaleIndirizzoDealer",false);
                component.set("v.provincia",indirizzoRow.Provincia);
                component.set("v.citta",indirizzoRow.Localita);
                
                component.find("ShippingStreet").set("v.value",indirizzoRow.Indirizzo);   
                component.find("ShippingPostalCode").set("v.value",indirizzoRow.CAP);    
                component.find('FormDealer1').submit();    //salva i dati inseriti nel form solo nel caso il servizio mi restituisce un unico indirizzo, altrimenti opero il salvataggio una volta che la modale è stata chiusa in seguito alla selezione della riga di indirizzo corretta
                component.find('FormDealer2').submit();
                component.find('FormContactDiRiferimento').submit();     
                
                console.log('VERIFICA ANAGRAFICA citta e provincia salvati');
            } else {
                console.log('VERIFICA ANAGRAFICA citta e provincia non salvati');
            }
		});		
		$A.enqueueAction(action);        
    },        
        
    salvaIndirizzoCollegatoDaDatatable: function(component, event) {
        console.log('^^^^^^^^^^^^salvaIndirizzoCollegatoDaDatatable');
		var action = component.get("c.salvaIndirizzoCollegatoDaDatatable");
        var indirizzoRow=component.get("v.selectedIndirizzoCollegati");
		action.setParams({
			collegatoId: component.get("v.selectedAccountId"),
            indirizzo: indirizzoRow.Indirizzo,
            localita: indirizzoRow.Localita,
            cap: indirizzoRow.CAP,
            provincia: indirizzoRow.Provincia,
            nazione: indirizzoRow.Nazione
		});    
 
		action.setCallback(this, function(response){
			if (response.getState() == 'SUCCESS'){
                console.log('^^^^^^^^^^^^salvaIndirizzoCollegatoDaDatatable  RESPONSE SUCCESS');
            } else {
                console.log('^^^^^^^^^^^^salvaIndirizzoCollegatoDaDatatable  RESPONSE NOT SUCCESS');
            }
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
    
    
    getRowActions: function(component, row, cb) {
        var actions = [];
        actions.push({
            label: "Modifica", 
            iconName: 'utility:edit',
            name: "edit"});
        actions.push({
            label: "Elimina/Ripristina Collegato", 
            iconName: 'utility:delete',
            name: "delete",
        	disabled: row.Roles.includes('SOC')});        
        cb(actions);
    },    


    
})