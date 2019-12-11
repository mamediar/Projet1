/**
 * @File Name          : PV1766CancellazionePraticaHelper.js
 * @Description        : 
 * @Author             : Andrea Vanelli
 * @Group              : 
 * @Last Modified By   : Andrea Vanelli
 * @Last Modified On   : 4/7/2019, 11:10:53
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    4/7/2019, 11:08:27   Andrea Vanelli     Initial Version
**/
({
    Init: function (cmp, event, helper) {
        this.mostraErrori(cmp, "");
        this.showMarkup(cmp,true);
    },

    /********************/
    /* EVENTI           */
    /********************/

    onPraticaSelected: function (cmp) {
        console.log('cliente : ' + JSON.stringify(cmp.get('v.PVForm.cliente')));    
        console.log('pratiche : ' + JSON.stringify(cmp.get('v.PVForm.cliente.pratiche')));    


		var messaggi = ""; // = this.checkPraticaSelezionata(cmp);
		if (this.checkPraticaSelezionata(cmp) == "") {
            var pratica = cmp.get("v.PVForm.pratica");
            var stato = pratica.statoPratica.substring(0, 2);
            var tipoPratica = pratica.tipoPratica;
            if (tipoPratica == "CAcc") {
                messaggi = "Selezionare la pratica di origine. La carta congiunta non può essere cancellata singolarmente.";
            } else if (tipoPratica == "CAcp") {
                messaggi = "Selezionare il conto di pagamento. La carta sarà aggiunta automaticamente insieme al conto.";
            } else if (tipoPratica == "BEcp") {
                messaggi = "Selezionare il conto di pagamento. Il borsellino sarà aggiunto automaticamente insieme al conto.";
            } 
            else if (cmp.get("v.PVForm.userData.user.Branch_Or_Office__c") != 'Reclami') {
                //filiale
                if (tipoPratica == "CA" && stato >= 50) {
                    messaggi = "La posizione deve essere in uno stato inferiore al 50.";
                } else if (tipoPratica == "CO" && stato > 30) {
                    messaggi = "La posizione non può essere in uno stato superiore al 30.";
                } else if (stato > 20 && (stato != 30 && stato != 35 && stato != 40)) {
                    messaggi = "La posizione deve essere in uno stato inferiore al 20, oppure in stato 30, 35 e 40.";
                }
            }
            if (messaggi == "") {
                //verifico se la pratica non è già presente in lista
                var pratiche = cmp.get("v.praticheList");
                for (var i = 0; i < pratiche.length; i++) {
                    if (pratica.numPratica == pratiche[i]['numPratica']) {
                        messaggi = "Pratica già inserita";
                        break;
                    }
                }
                if (messaggi == "") {
                    var cliente = cmp.get("v.PVForm.cliente");
                    //aggiungo i dati del cliente
                    cmp.set("v.PVForm.pratica.cognome", cliente.cognome);
                    cmp.set("v.PVForm.pratica.nome", cliente.nome);
                    cmp.set('v.praticheList', cmp.get('v.praticheList').concat(cmp.get("v.PVForm.pratica")));

                    var clienti = cmp.get("v.clientiList");
                    var newCliente = "S";
                    for (var c = 0; c < clienti.length; c++) {
                        if (cliente.codCliente == clienti[c]['codCliente']) {
                            newCliente = "N"
                            break;
                        }
                    }
                    if (newCliente == "S") {
                        cmp.set('v.clientiList', cmp.get('v.clientiList').concat(cliente));
                        //clienti = cmp.get("v.clientiList");
                        //cmp.set('v.clientiList', clienti);
                    }

/*                    //VERIFICO EVENTUALI PRATICHE CONGIUNTE!
                    var altrePratiche = cmp.get('v.PVForm.cliente.pratiche');
                    if(altrePratiche.length>1){
                        console.log("Elenco pratiche : " + JSON.stringify(altrePratiche));
                    }
*/

                    //per i conti, cancello anche carte e borsellini associati 
                    if(pratica.tipoPratica=='CP'){
                        var praticaOrigineCP = pratica.numPratica;
                        for (var i = 0; i < cliente.pratiche.length; i++) {    
                            var praticaDest = cliente.pratiche[i];
                            if (praticaOrigineCP == praticaDest['numPraticaOrigine']) {
                                //aggiungo i dati del cliente
                                praticaDest.cognome = cliente.cognome;
                                praticaDest.nome = cliente.nome;
                                cmp.set('v.praticheList', cmp.get('v.praticheList').concat(praticaDest));
                            }
                        }
                    }
                }
            }
        }    
        if(messaggi != ""){
            this.mostraToast(cmp, '', messaggi, 'warning', '');
        } 
    },


    /************************/
    /* Gestione Inserimento */
    /************************/

    validateUserInput: function(cmp, event, helper) {
        //this.clearFields(cmp);
        var messaggi = ''; 
        //verifico se tutte le pratiche sono state esitate
        var pratiche = cmp.get("v.praticheList");
        if (pratiche.length == 0) {
            messaggi ="Selezionare almeno una pratica.";
        }
        else {
            for (var i = 0; i < pratiche.length; i++) {
                if ($A.util.isUndefinedOrNull(pratiche[i]['motivo'])) {
                    messaggi = "Indicare la motivazione per ogni pratica.";
                    break;
                }
            }
        }
        return messaggi;
    },

    completaPVForm: function(cmp, event, helper, PVForm) {
        PVForm.praticheList = cmp.get("v.praticheList");
        PVForm.clientiList = cmp.get("v.clientiList");
        return PVForm;
    },

    /*********************************/
	/* metodi CUSTOM del singolo PV */
    /*********************************/

	verificaSelezione: function (cmp, event, helper) {
        var selectedRows = event.getParam('selectedRows');
        var tutte = cmp.get("v.praticheList");
        for(var i=0;i<selectedRows.length;i++){
            if(selectedRows[i].tipoPratica == "BEcp" || selectedRows[i].tipoPratica == "CAcp"){
                //deseleziono la riga
                selectedRows[i] = 0;    
                cmp.find("pratiche").set("v.selectedRows", selectedRows);    
                this.mostraToast(cmp, '', "Operare sul conto di pagamento.", 'warning', '');
                break;
            }
        }
    },

    associaMotivo: function (cmp, event, helper) {
        var selezionate = cmp.find('pratiche').getSelectedRows();
        var reason = cmp.get("v.PVForm.reasonMdt");
        var messaggi = "";

        if (selezionate.length == 0) {
            messaggi = "Selezionare le pratiche da esitare";
        }
        else if ($A.util.isUndefinedOrNull(reason) || reason == "") {
            messaggi = "Selezionare un motivo";
        }
        else if ((cmp.find("radioContratto") != undefined || cmp.find("radioFirma") != undefined || cmp.find("radioDoppioCaricamento") != undefined)
            && cmp.get("v.valueRadio")==""){
            messaggi = "Dare una risposta al questionario";
        }
        else if ((reason.uniqueId__c == 26 && cmp.get("v.valueRadio") == "Si")) {
            messaggi = "Il cliente ha firmato l'informativa privacy: la pratica non può essere cancellata.";
        }
        else if ((reason.uniqueId__c == 3 && cmp.get("v.valueRadio") == "Si")) {
            messaggi = "Il cliente ha firmato il contratto che autorizza il trattamento dei dati: la pratica non può essere cancellata.";
        }
        else if ((reason.uniqueId__c == 4 && cmp.get("v.valueRadio") == "2")) {
            messaggi = "La pratica non può essere cancellata perchè il cliente ha firmato 2 fogli privacy.";
        }
        else if (reason.uniqueId__c == 5 && ($A.util.isUndefinedOrNull(cmp.get("v.PVForm.motivazione")) || cmp.get("v.PVForm.motivazione") == "")){
            messaggi = "Descrivere la motivazione";
        }
        else {
            var tutte = cmp.get("v.praticheList");
            var questionario = cmp.get("v.valueRadio");
            var domandaQuestionario = "";
            
            if (reason.uniqueId__c == 26) {
                domandaQuestionario = "Ha firmato l'informativa privacy?";
            }
            else if (reason.uniqueId__c == 3) {
                domandaQuestionario = "Ha firmato il contratto?";
            }
            else if (reason.uniqueId__c == 4) {
                domandaQuestionario = "Quanti fogli privacy ha firmato il cliente?";
            }
            
            for (var i = 0; i < selezionate.length; i++) {
                for (var x = 0; x < tutte.length; x++) {
                    if (selezionate[i]['numPratica'] == tutte[x]['numPratica'] || selezionate[i]['numPratica'] == tutte[x]['numPraticaOrigine']) {
                        tutte[x]['questionario'] = questionario;
                        tutte[x]['domandaQuestionario'] = domandaQuestionario;
                        tutte[x]['descrizioneMotivo'] = cmp.get("v.PVForm.motivazione");
                        //verificare reason
                        tutte[x]['reasonMdt'] = reason;
                        //tutte[x]['dispositionId'] = reason.dispositionId__c;
                        tutte[x]['motivo'] = reason.Descrizione__c;
                    }
                }
            //nice to have: deselezionare la reason    
            
            }
            cmp.set("v.praticheList", tutte);
            cmp.set("v.PVForm.motivazione", "");
            cmp.set("v.valueRadio", "");
            //cmp.set("v.PVForm.reasonMdt", []);
            this.deseleziona(cmp);
        }
        if(messaggi != ""){
            cmp.set("v.PVForm.motivazione", "");
            cmp.set("v.valueRadio", "");
            //cmp.set("v.PVForm.reasonMdt", []);
            this.mostraToast(cmp, '', messaggi, 'warning', '');
        } 
    },


    rimuoviSelezionati: function (cmp, event, helper) {
        var selezionate = cmp.find('pratiche').getSelectedRows();
        if(selezionate.length>0){
            var tutte = cmp.get("v.praticheList");
            cmp.set("v.praticheList",[]);
            var cancella = true;
            for (var x = 0; x < tutte.length; x++) {
                if(!cancella){
                    //console.log("mantengo " + tutte[x-1]['numPratica']);
                    cmp.set('v.praticheList', cmp.get('v.praticheList').concat(tutte[x-1]));
                }
                var cancella = false;
                for (var i = 0; i < selezionate.length; i++) {
                    if (selezionate[i]['numPratica'] == tutte[x]['numPratica'] || tutte[x]['numPraticaOrigine'] == selezionate[i]['numPratica']) {
                        cancella = true;
                        break;
                    }
                }
            }    
        }    
    },    

    deseleziona: function (cmp) {
        //deseleziona tutto
        var praticheDT = cmp.find("pratiche");
        if(praticheDT){
            var selectedRows = praticheDT.get("v.selectedRows");
            selectedRows.length = 0;
            praticheDT.set("v.selectedRows",selectedRows);
        }
    },

})