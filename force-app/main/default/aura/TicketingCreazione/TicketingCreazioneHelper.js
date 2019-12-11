({
    
    // function automatic called by aura:waiting event  
    showSpinner: function(component, event) {
        // make Spinner attribute true for displaying loading spinner 
        component.set("v.spinner", true); 
    },
     
    // function automatic called by aura:doneWaiting event 
    hideSpinner : function(component,event){
        // make Spinner attribute to false for hiding loading spinner    
        component.set("v.spinner", false);
    },
    
    createCase : function(component, event) {
        this.showSpinner(component, event);
        var action = component.get("c.createRecord");      
        var cod = component.get("v.CodiciFiliale");
        var prefisso = cod;
        var tic = component.get("v.Ticket");
        var CodDealer = component.get("v.CodDealerFromApex");
        var RagSociale = component.get("v.RagioneSociale");
        var nome = component.get("v.Nome");
        var cognome = component.get("v.Cognome");
        var codiceCliente = component.get("v.CodiceCliente");
        var codiceCarta = component.get("v.CodiceCarta");
        var profilo = component.get("v.Profilo");
        var numeroProtocollo = component.get("v.NumeroProtocollo");
        var canaleAcquisizione1 = component.get("v.CanaleAcquisizione1");
        var canaleAcquisizione2 = component.get("v.CanaleAcquisizione2");
        var partitaIva = component.get("v.PartitaIva");
        var codiceFiscale = component.get("v.CodiceFiscale");
        var numPratica = tic.NumeroPratica__c;
        var prod = component.get("v.Prodotto");
        var dataSott = component.get("v.DataSott");
        var livFirma = component.get("v.LivelloFirma");
        var dataUltimaDel = component.get("v.DataUltimaDelibera");
        var MapFiles2 = component.get("v.MapAttach");
        var catIdSalesForce = tic.Categoria_Riferimento__c;
        var catIdComp = component.get("v.CatId");
        console.log("Dentro Helper createCase - CATID: " + catIdComp);
        
        console.log("v.Ticket.AccountId : " + component.get("v.Ticket.AccountId"));
        
        // START - Settaggio contenuto del subject e della descrezione del caso
        
        var checkCmp = component.find("CheckboxGroup");
        console.log("value : " + checkCmp.get("v.value"));
        component.set("v.Ticket.ShareCaseteam__c",checkCmp.get("v.value"));
        component.set("v.Ticket.Subject",prefisso+tic.Subject);

        if(component.get("v.Cat_COD_DEALER") == true){
            component.set("v.Ticket.Subject",tic.Subject+' - '+CodDealer+' - '+RagSociale);
			component.set("v.Ticket.Description",tic.Description
                                              + ' \n ' + 'Codice Dealer: ' +CodDealer
                                              + ' \n ' + 'Ragione Sociale: ' +RagSociale);
		}
        /*if(component.get("v.Cat_COD_PRT") == true){
            component.set("v.Ticket.Subject",prefisso+tic.Subject+' - '+numPratica+' - '+cognome+' - '+nome);
        }*/
        if(component.get("v.Cat_COD_CLIENTE") == true){
            component.set("v.Ticket.Subject",tic.Subject+' - C'+codiceCliente+' - '+cognome+' - '+nome);
            component.set("v.Ticket.Description",tic.Description
                                              + ' \n ' + 'Codice Cliente: C' +codiceCliente
                                              + ' \n ' + 'Profilo: ' +profilo);
        }
      
        if(component.get("v.Cat_COD_CA") == true){ // non trovando una categoria nel metadata ne ho creata una di test
            component.set("v.Ticket.Description",tic.Description
                                              + ' \n ' + 'Codice Carta: ' +codiceCarta);
        }
        if(component.get("v.Cat_NUM_PROTC") == true){
            component.set("v.Ticket.Description",tic.Description
                                              + ' \n ' + 'Numero Protocollo: ' +numeroProtocollo);
        }
        if(component.get("v.Cat_CHN_ACQ") == true){
            component.set("v.Ticket.Description",tic.Description
                                              + ' \n ' + 'Canale Acquisizione: ' +canaleAcquisizione1);
        }
        if(component.get("v.Cat_CHN_MAP") == true){
            component.set("v.Ticket.Description",tic.Description
                                              + ' \n ' + 'Canale Acquisizione: ' +canaleAcquisizione2);
        }
        if(component.get("v.Cat_P_IVA") == true){
            component.set("v.Ticket.Description",tic.Description
                                              + ' \n ' + 'Partita Iva: ' +partitaIva);
        }
        if(component.get("v.Cat_COD_FISCALE") == true){
            component.set("v.Ticket.Description",tic.Description
                                              + ' \n ' + 'Codice Fiscale: ' +codiceFiscale);
        }
        if(component.get("v.Cat_COD_PRT") == true){
            component.set("v.Ticket.Subject",tic.Subject+' - '+numPratica+' - '+cognome+' - '+nome);
            component.set("v.Ticket.NumeroPratica__c",numPratica);
        }
        if(component.get("v.Cat_COD_PRT_WS") == true){
            component.set("v.Ticket.Subject",tic.Subject+' - '+numPratica+' - '+cognome+' - '+nome);
            component.set("v.Ticket.NumeroPratica__c",numPratica);
            component.set("v.Ticket.Description",tic.Description
                                              + ' \n ' + 'Data sottoscrizione: ' +dataSott
                                              + ' \n ' + 'Livello di firma: ' +livFirma
                                              + ' \n ' + 'Codice Cliente: C' +codiceCliente
                                              + ' \n ' + 'Numero Pratica: ' +numPratica
                                              + ' \n ' + 'Prodotto: ' +prod);
        }
        if(component.get("v.Cat_COD_PRT_DELIB") == true){
            //component.set("v.Ticket.Subject",tic.Subject+' - '+numPratica+' - '+cognome+' - '+nome);
            component.set("v.Ticket.NumeroPratica__c",numPratica);
            component.set("v.Ticket.Description",tic.Description                                             
                                              + ' \n ' + 'Data ultima delibera: ' +dataUltimaDel);
        }
        // FINE - Settaggio contenuto del subject e della descrezione del caso

        action.setParams({
            Ticket : tic,
            MapFiles: MapFiles2,
            catIdS: catIdComp
            
        });
        
        action.setCallback(this,function(a){
            var state = a.getState();            
            if(state == "SUCCESS"){                
                this.showToast('Ticket creato con successo.','success');                
                var homeEvent = $A.get("e.force:navigateToObjectHome");
                homeEvent.setParams({
                    "scope": "Case"
                });
                homeEvent.fire();                
            } else if(state == "ERROR"){
                this.showToast('Errore nella creazione del Ticket','error');   
                //alert('Error in calling server side action');
            }
            this.hideSpinner(component, event);
        });        
        
        $A.enqueueAction(action);
    },
    
    showToast : function(message, type){
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			message: message,
			type : type
		});
		toastEvent.fire();
	},
    
    SearchLivelloFirma: function (component, event) {
        var action = component.get("c.recuperaLivelloFirma");
        var tipoDocComp = component.get("v.TipoDocMT");
        var numeroPraticaComp = component.get("v.Ticket.NumeroPratica__c").trim();            
        action.setParams({
            numeroPratica : numeroPraticaComp,
            tipoDoc : tipoDocComp
        });
        
        if(numeroPraticaComp!=''){
            this.showSpinner(component, event);
            action.setCallback(this, function(data) {
                if(data.getState()=='SUCCESS'){
                    var retVal = data.getReturnValue();  
                    var LivelloFirma;
                  
                    if(retVal!=null){
                        LivelloFirma = retVal.out_3 != null ? retVal.out_3 : '';
                        component.set("v.LivelloFirma",LivelloFirma);                       
                    }else{
						component.set("v.LivelloFirma",null);
                    }
                }else{
                    this.showToast('La ricerca del Livello Firma ha dato errore!','error');
                }
            	this.hideSpinner(component, event);
            });
            $A.enqueueAction(action);
        }else{
            this.showToast('Inserire il numero pratica da ricercare.','error');
        }        
    },
    
    controllCategory : function(component, event) {
        var action = component.get("c.getTKTForm");
        var TypeForm;
        
        action.setParam('CatId',component.get('v.CatId'));
        action.setCallback(this, function(data) {
            
            let retVal = data.getReturnValue();
            var lengMetadata = retVal.length;

                    retVal.forEach(function(entry) {
                    TypeForm = entry.FormType__c;
                
                    if(TypeForm =="ATTACH"){
                        component.set("v.Cat_ATTACH", true);
                        component.set("v.Err_ATTACH", entry.ErrorMessage__c);
                        component.set("v.Scrypt_ATTACH", entry.Script__c);
                        
                    }
                    if(TypeForm =="ATTACH_INSTRUCTION"){
                        component.set("v.Cat_ATTACH_INSTRUCTION", true);
                        component.set("v.Err_ATTACH_INSTRUCTION", entry.ErrorMessage__c);
                        component.set("v.Scrypt_ATTACH_INSTRUCTION", entry.Script__c);
                       
                    }
                    if(TypeForm == "COD_DEALER"){
                        component.set("v.Cat_COD_DEALER", true);
                        component.set("v.Err_COD_DEALER", entry.ErrorMessage__c);
                        component.set("v.Scrypt_COD_DEALER", entry.Script__c);
                        
                    }
                    if(TypeForm == "COD_CA"){
                        component.set("v.Cat_COD_CA", true);
                        component.set("v.Err_COD_CA", entry.ErrorMessage__c);
                        component.set("v.Scrypt_COD_CA", entry.Script__c);
                        
                    }
                    if(TypeForm == "NUM_PROTC"){
                        component.set("v.Cat_NUM_PROTC", true);
                        component.set("v.Err_NUM_PROTC", entry.ErrorMessage__c);
                        component.set("v.Scrypt_NUM_PROTC", entry.Script__c);
                        
                    }
                    if(TypeForm == "CHN_ACQ"){
                        component.set("v.Cat_CHN_ACQ", true);
                        component.set("v.Err_CHN_ACQ", entry.ErrorMessage__c);
                        component.set("v.Scrypt_CHN_ACQ", entry.Script__c);
                        
                    }
                    if(TypeForm == "CHN_MAP"){
                        component.set("v.Cat_CHN_MAP", true);
                        component.set("v.Err_CHN_MAP", entry.ErrorMessage__c);
                        component.set("v.Scrypt_CHN_MAP", entry.Script__c);
                        
                    }
                    if(TypeForm == "COD_PRT"){
                        component.set("v.SearchPratica", true);
                        component.set("v.Cat_COD_PRT", true);
                        component.set("v.Err_COD_PRT", entry.ErrorMessage__c);
                        component.set("v.Scrypt_COD_PRT", entry.Script__c);
                        component.set("v.TipoDocMT",entry.DocType__c);
                        
                    }
                    if(TypeForm == "COD_PRT_WS"){
                        component.set("v.SearchPratica", true);
                        component.set("v.SearchPraticaWSDEL", true);
                        component.set("v.Cat_COD_PRT_WS", true);
                        component.set("v.Err_COD_PRT_WS", entry.ErrorMessage__c);
                        component.set("v.Scrypt_COD_PRT_WS", entry.Script__c);
                        component.set("v.TipoDocMT",entry.DocType__c);
                        
                    }
                    if(TypeForm == "COD_PRT_DELIB"){
                        component.set("v.SearchPratica", false);
                        component.set("v.SearchDataDel", true);
                        component.set("v.SearchPraticaWSDEL", true);
                        component.set("v.Cat_COD_PRT_DELIB", true);
                        component.set("v.Err_COD_PRT_DELIB", entry.ErrorMessage__c);
                        component.set("v.Scrypt_COD_PRT_DELIB", entry.Script__c);
                        component.set("v.TipoDocMT",entry.DocType__c);
                        
                    }
                    if(TypeForm == "P_IVA"){
                        component.set("v.Cat_P_IVA", true);
                        component.set("v.Err_P_IVA", entry.ErrorMessage__c);
                        component.set("v.Scrypt_P_IVA", entry.Script__c);
                        
                    }
                    if(TypeForm == "COD_CLIENTE"){
                        component.set("v.Cat_COD_CLIENTE", true);
                        component.set("v.Err_COD_CLIENTE", entry.ErrorMessage__c);
                        component.set("v.Scrypt_COD_CLIENTE", entry.Script__c);
                        
                    }
                    if(TypeForm == "COD_FISCALE"){
                        component.set("v.Cat_COD_FISCALE", true);
                        component.set("v.Err_COD_FISCALE", entry.ErrorMessage__c);
                        component.set("v.Scrypt_COD_FISCALE", entry.Script__c);
                        
                    }                
            	});    
           
        });
        $A.enqueueAction(action);               
    }
    
    
        
})