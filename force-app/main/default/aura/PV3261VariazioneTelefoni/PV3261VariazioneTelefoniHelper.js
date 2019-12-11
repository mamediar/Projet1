/**
 * @File Name          : PV3261VariazioneTelefoniHelper.js
 * @Description        : 
 * @Author             : Federico Negro
 * @Group              : 
 * @Last Modified By   : Federico Negro
 * @Last Modified On   : 22/10/2019, 14:36:37
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    22/10/2019   Federico Negro     Initial Version
**/
({

    /********************/
    /* EVENTI           */
    /********************/

    onClienteSelected: function (cmp) {
        this.clearFields(cmp);
		var messaggi = this.checkClienteSelezionato(cmp);
		if (messaggi == "") {
            this.mostraClessidra(cmp);
            //controllo le pratiche e recupero i dati di recapito
            var action = cmp.get('c.recuperaDatiCliente');
            action.setParams({
                "codCliente": cmp.get('v.PVForm.cliente.codCliente')
            });
            // Imposto la Callback
            action.setCallback(this, function (response, helper) {
                console.log("verificaPratiche : response : " + JSON.stringify(response));
                if (response.getState() == 'SUCCESS') {
                    var result = response.getReturnValue();
                    console.log("result : " + JSON.stringify(result));
                    cmp.set('v.variazioneTelefoniCheckOutput',result);
                    cmp.set('v.telCellulareOrig', result.datiCliente.telCellulare);
                    cmp.set('v.telefonoAlternativoOrig', result.datiCliente.telefonoAlternativo);
                    cmp.set('v.telefonoCasaOrig', result.datiCliente.telefonoCasa);
                    cmp.set('v.faxOrig', result.datiCliente.fax);
                    messaggi = result.messaggioNoVariazione;
                    if(result.isErroreBloccante){
                        this.showMarkup(cmp,false);
                    }
                    if(messaggi != ""){
                        this.mostraErrori(cmp, messaggi);
                    }
                }
                else if (response.getState() === "ERROR") {
                    this.mostraToast(cmp, '', response.getError(), 'error', '');
                }       
                this.nascondiClessidra(cmp);
            });
            $A.enqueueAction(action);
        }
    },

    /************************/
    /* Gestione Inserimento */
    /************************/


    validateUserInput: function(cmp, event, helper) {
        var messaggi = "";
        var telCasa = cmp.get("v.variazioneTelefoniCheckOutput.datiCliente.telefonoCasa");
        var telCell = cmp.get("v.variazioneTelefoniCheckOutput.datiCliente.telCellulare");
        var telAlt = cmp.get("v.variazioneTelefoniCheckOutput.datiCliente.telefonoAlternativo");
        var telFax = cmp.get("v.variazioneTelefoniCheckOutput.datiCliente.fax");

        messaggi = this.checkClienteSelezionato(cmp);
        if(messaggi == ""){
            //Indicizzo le variabili necessarie al test di validazione
            if(!cmp.find("checkbox").checkValidity()){
                cmp.find('checkbox').showHelpMessageIfInvalid();
                messaggi += "confermare di aver comunicato al cliente la PRIVACY.\n";
            }
            if(!cmp.find("abitazione").checkValidity()){
                cmp.find('abitazione').showHelpMessageIfInvalid();
                messaggi += "telefono abitazione : formato non corretto.\n";
            }
            if(!cmp.find("cellulare").checkValidity()){
                cmp.find('cellulare').showHelpMessageIfInvalid();
                messaggi += "telefono cellulare : formato non corretto.\n";
            }
            if(!cmp.find("alternativo").checkValidity()){
                cmp.find('alternativo').showHelpMessageIfInvalid();
                messaggi += "telefono alternativo : formato non corretto.\n";
            }
            if(!cmp.find("fax").checkValidity()){
                cmp.find('fax').showHelpMessageIfInvalid();
                messaggi += "fax : formato non corretto.\n";
            }
            if(cmp.get("v.telCellulareOrig") == telCell
                && cmp.get("v.telefonoAlternativoOrig") == telAlt
                && cmp.get("v.telefonoCasaOrig") == telCasa
                && cmp.get("v.faxOrig") == telFax)
            {
                messaggi += "Effettuare almeno una variazione.\n";
            }
            else if(telCell == "" && telCasa == "")
            {
                messaggi += "Inserire almeno un recapito tra abitazione e cellulare.\n";
            }  
            else if (!$A.util.isUndefinedOrNull(telCell) 
                && telCell != ""
                && cmp.get("v.telCellulareOrig") != telCell
                && cmp.get("v.operatoreTelefonico") == ""
            ){
                messaggi += "Selezionare l'operatore telefonico del nuovo cellulare.\n";
            }
        }
        if(messaggi == ""){
            var variazioni = "";
            // controlli e settaggio variabili
            if(cmp.get("v.telCellulareOrig") != telCell){
                cmp.set("v.variazioneCel","S");
            }
            if(cmp.get("v.variazioneTelefoniCheckOutput.richiestaFaxShow") 
                && !$A.util.isUndefinedOrNull(cmp.find('checkboxFax')) 
                && !cmp.find('checkboxFax').get('v.checked')
                && cmp.get("v.variazioneCel") == "S"
                ){
                //se il fax fosse richiesto ma non è stato checkato, a fronte della variazione cellulare, il Case sarà annullato     
                cmp.set("v.annulla","S");
                variazioni = "\nRichiesta non ammissibile. Comunicato necessario invio del fax.\n";
            }
            if(cmp.get("v.annulla") != "S"){
                if (!$A.util.isUndefinedOrNull(cmp.find('checkboxForzaPrefissi')) && cmp.find('checkboxForzaPrefissi').get('v.checked')) {
                    cmp.set("v.forzatura","S");
                }
                //imposto i flag per il servizio e preparo la stringa con la lista delle variazioni
                if(telCasa != cmp.get("v.telefonoCasaOrig") && telCasa == ""){
                    cmp.set("v.flagFisso","A");
                }else if(telCasa != cmp.get("v.telefonoCasaOrig")){
                    cmp.set("v.flagFisso","M");
                }
                if(telAlt != cmp.get("v.telefonoAlternativoOrig") && telAlt == ""){
                    cmp.set("v.flagAlternativo","A");
                }else if(telAlt != cmp.get("v.telefonoAlternativoOrig")){
                    cmp.set("v.flagAlternativo","M");
                }
                if(telCell != cmp.get("v.telCellulareOrig") && telCell == ""){
                    cmp.set("v.flagCellulare","A");
                }else if(telCell != cmp.get("v.telCellulareOrig")){
                    cmp.set("v.flagCellulare","M");
                }
                if(telFax != cmp.get("v.faxOrig") && telFax == ""){
                    cmp.set("v.flagFax","A");
                }else if(telFax != cmp.get("v.faxOrig")){
                    cmp.set("v.flagFax","M");
                }
                //setto la nota specifica
                if(cmp.get("v.flagFisso") != ""){    
                    variazioni += "\nTelefono abitazione precedente: ";
                    variazioni +=  !$A.util.isUndefinedOrNull(cmp.get("v.telefonoCasaOrig"))?cmp.get("v.telefonoCasaOrig"):'';
                    variazioni +=  "\nNuovo telefono abitazione: " + telCasa;
                }
                if(cmp.get("v.flagCellulare") != ""){        
                    variazioni += "\nCellulare precedente: ";
                    variazioni +=  !$A.util.isUndefinedOrNull(cmp.get("v.telCellulareOrig"))?cmp.get("v.telCellulareOrig"):'';
                    variazioni +=  "\nNuovo cellulare: " + telCell;
                }
                if(cmp.get("v.flagAlternativo") != ""){    
                    variazioni += "\nTelefono alternativo precedente: ";
                    variazioni +=  !$A.util.isUndefinedOrNull(cmp.get("v.telefonoAlternativoOrig"))?cmp.get("v.telefonoAlternativoOrig"):'';
                    variazioni +=  "\nNuovo telefono alternativo: " + telAlt;
                }
                if(cmp.get("v.flagFax") != ""){    
                    variazioni += "\nFax abitazione precedente: ";
                    variazioni +=  !$A.util.isUndefinedOrNull(cmp.get("v.faxOrig"))?cmp.get("v.faxOrig"):'';
                    variazioni +=  "\nNuovo fax: " + telFax;
                }
                variazioni += "\nI prefissi sono stati forzati: " + cmp.get("v.forzatura");
                if(!$A.util.isUndefinedOrNull(cmp.find('checkboxFax')) && !cmp.find('checkboxFax').get('v.checked')){
                    variazioni += "\nRicevuta richiesta scritta tramite fax."
                }
            } 
            cmp.set("v.variazioni",variazioni);
        }
        return messaggi;
    },

    completaPVForm: function (cmp, event, helper, PVForm) {
        PVForm.datiCliente = cmp.get('v.variazioneTelefoniCheckOutput.datiCliente');
        PVForm.praticheCA = cmp.get('v.variazioneTelefoniCheckOutput.praticheCA');
        PVForm.operatoreTel = cmp.get("v.operatoreTelefonico");
        PVForm.variazioneCel = cmp.get("v.variazioneCel");
        PVForm.annulla = cmp.get("v.annulla");
        PVForm.forzatura = cmp.get("v.forzatura");
        PVForm.flagCellulare = cmp.get("v.flagCellulare");
        PVForm.flagFisso = cmp.get("v.flagFisso");
        PVForm.flagFax = cmp.get("v.flagFax");
        PVForm.flagAlternativo = cmp.get("v.flagAlternativo");
        PVForm.variazioni = cmp.get("v.variazioni");
        return PVForm;
    },

    clearFields: function (cmp) {
        //cmp.find("abitazione").set("v.value","");
        //cmp.find("cellulare").set("v.value","");
        //cmp.find("alternativo").set("v.value","");
        //cmp.find("fax").set("v.value","");
        this.mostraErrori(cmp, "");
        this.showMarkup(cmp,true);
    },

    
})