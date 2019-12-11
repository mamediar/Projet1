({
    doInit : function(component) {
        console.log("INIZIO DO INIT");
        this.showSpinner(component);
        var sUser = component.get("v.userIsBO");
        var sUserId = component.get("v.userId");
        var sProfile = component.get("v.userProfile");
        var sFiliale = component.get("v.userFiliale");
        var action = component.get("c.getCases");

        action.setParams({
            userId: sUserId,
            sProfile: sProfile,
            sFiliale: sFiliale
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
       
            if (state === "SUCCESS") {
                component.set("v.mapDinieghi", response.getReturnValue());
                var mappa = component.get('v.mapDinieghi');
                component.set("v.elencoDinieghi",mappa.All);

                if (Object.keys(mappa).length===0) {
                    component.set("v.showDiniegoNotFound", true); 
                }                
            }
            else if (state === 'ERROR') {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        component.set('v.msg', errors[0].message);
                        this.showErrorToast(component);
                    }
                } else {
                    component.set('v.msg', 'Unknown error');
                    this.showErrorToast(component);
                }
            }
            this.hideSpinner(component);
        })
        
        $A.enqueueAction(action);
    },
    
    doUser : function(component) {
        
        this.showSpinner(component);
        var action = component.get("c.getUserMap");
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.mapUser", response.getReturnValue());
                var mappa = component.get('v.mapUser');

                component.set('v.userId',mappa.idUser);
                component.set('v.userProfile',mappa.Profile);
                component.set('v.userFiliale',mappa.Filiale);
                var vProfile = component.get('v.userProfile');
            
                if (vProfile=='Branch Employee'||vProfile=='Branch Manager'){
                    component.set('v.userIsBO', false);
                }else if(vProfile=='BackOffice'){
                    component.set('v.userIsBO', true);
                }
                this.doInit(component);
            }
            else if (state === 'ERROR') {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        component.set('v.msg', errors[0].message);
                        this.showErrorToast(component);
                    }
                } else {
                    component.set('v.msg', 'Unknown error');
                    this.showErrorToast(component);
                }
            }
            this.hideSpinner(component);
        })
        
        $A.enqueueAction(action);
    },

    handleChangeInterlocutore: function(component) {
        console.log('-- Controller JS: CRMDinieghiSDDHelper - Method: handleChangeInterlocutore');         
        var interValue = component.get('v.interlocutoreValue');
        if (interValue == 'nessunInterlocutore') {
            component.find('esito-telefonata').set('v.value', 'nonChiamare');
        }
    },

    handleChangeEsitoTelefonata: function(component,esitoTelefonata) {
        console.log('-------------------------------------------------------');
        console.log('-- Controller JS: CRMDinieghiSDDHelper - Method: handleChengeEsitoTelefonata');         
        console.log('-- handleChangeEsitoTelefonata :'+esitoTelefonata);
        if (esitoTelefonata == 'nonTrovato' || esitoTelefonata == 'richiamare') {
            // reset 
            component.set('v.contAvvenutoValue', 'selezionare');
            console.log('reset');
        }
    },
    
    resetModalValues: function(component) {
        component.set('v.interlocutoreValue', 'selezionare');
        component.set('v.esitoTelefonataValue', 'selezionare');
        component.set('v.contAvvenutoValue', 'selezionare');
        component.set('v.nonTrovatoValue', 'selezionare');
    },
    
    searchNotes: function(component, caseId) {
 
        var action = component.get("c.getNotes");
        
        action.setParams({
            caseId: caseId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var notes = response.getReturnValue();
/*                for (var i=0; i<notes.length; i++) {
                    var d = new Date(notes[i].CreatedDate);
                    var minute;
                    if(d.getMinutes()<10){
                        minute = '0'+d.getMinutes();
                    }else{
                        minute = d.getMinutes();
                    }
//                    notes[i].CreatedDate = d.getFullYear()+'-'+(d.getMonth()+1)+'-'+d.getDate()+' '+d.getHours()+':'+d.getMinutes()+':'+d.getSeconds();
                    notes[i].CreatedDate = d.getDate()+'/'+(d.getMonth()+1)+'/'+d.getFullYear()+' '+d.getHours()+':'+minute;//+':'+d.getSeconds();
                }*/
                component.set("v.elencoNote", notes);
                
            }
            else if (state === 'ERROR') {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        component.set('v.msg', errors[0].message);
                        this.showErrorToast(component);
                    }
                } else {
                    component.set('v.msg', 'Unknown error');
                    this.showErrorToast(component);
                }
            }
            this.hideSpinner(component);
        })
        this.showSpinner(component);
        $A.enqueueAction(action);
    },
    
    searchAccount: function(component, manId) {
        console.log('-----------------------------------------------------------------');
        console.log('-- Controller JS: CRMDinieghiSDDHelper.js - Method: searchAccount'); 
        var action = component.get("c.getAccounts");
        
        action.setParams({
            manId: manId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            //            alert(state);
            if (state === "SUCCESS") {
                component.set("v.selectedAccount", response.getReturnValue());
                var st = component.get("v.selectedAccount");
                var codCliente = component.get("v.selectedAccount[0].OCS_External_Id__c");
                var codCliente2 = codCliente.substring(1,codCliente.length-1);
                
                if(component.get("v.selectedAccount[0].Phone")==undefined){
	                var tel = "";
                }else{
	                var tel = component.get("v.selectedAccount[0].Phone");
                }

                if(component.get("v.selectedAccount[0].Telefono_Cellulare__c")==undefined){
	                var cel = "";
                }else{
	                var cel = component.get("v.selectedAccount[0].Telefono_Cellulare__c");
                }
                
                var sTelefono = '1: Tel. ' + tel + ' 2: Cell: ' + cel;
                component.set("v.stringaTelefono", sTelefono);
                component.set('v.codiceCliente', codCliente2 );

                //                var cf = component.get("v.selectedAccount.Codice_Fiscale_pc");
                //                alert(cf);
            }
            else if (state === 'ERROR') {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        component.set('v.msg', errors[0].message);
                        this.showErrorToast(component);
                    }
                } else {
                    component.set('v.msg', 'Unknown error');
                    this.showErrorToast(component);
                }
            }
            this.hideSpinner(component);
        })
        this.showSpinner(component);
        $A.enqueueAction(action);
    },
    
    searchContact: function(component, manId) {
        console.log('-----------------------------------------------------------------');
        console.log('-- Controller JS: CRMDinieghiSDDHelper.js - Method: searchContact'); 
        var action = component.get("c.getContacts");
        
        action.setParams({
            manId: manId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            //            alert(state);
            if (state === "SUCCESS") {
                component.set("v.selectedContatto", response.getReturnValue());
            }
            else if (state === 'ERROR') {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        component.set('v.msg', errors[0].message);
                        this.showErrorToast(component);
                    }
                } else {
                    component.set('v.msg', 'Unknown error');
                    this.showErrorToast(component);
                }
            }
            this.hideSpinner(component);
        })
        this.showSpinner(component);
        $A.enqueueAction(action);
    },

    handleRiassegna: function(component, event, manId, idU) {
        console.log('-------------------------------------------------------------------');
        console.log('-- Controller JS: CRMDinieghiSDDHelper.js - Method: handleRiassegna'); 
        
        if (idU =='' || idU == null || idU==undefined){
            component.set('v.msg', 'ATTENZIONE SE SI RIASSEGNA UN DINIEGO SELEZIONARE UN UTENTE');
            this.showErrorToast(component);
            return;
        }
        
        var action = component.get("c.getRiassegna");
        action.setParams({
            manId: manId,
            idU: idU
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.riassegnato", response.getReturnValue());
                component.set('v.msg', 'Assegnazione Mandato effettuata correttamente');
                this.showSuccessToast(component);
                $A.get("e.force:refreshView").fire();
            }
            else if (state === 'ERROR') {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        component.set('v.msg', errors[0].message);
                        this.showErrorToast(component);
                    }
                } else {
                    component.set('v.msg', 'Unknown error');
                    this.showErrorToast(component);
                }
            }
            this.hideSpinner(component);
        })
        this.showSpinner(component);
        $A.enqueueAction(action);
    },
    
    searchUser: function(component) {
        console.log('--------------------------------------------------------------');
        console.log('-- Controller JS: CRMDinieghiSDDHelper.js - Method: searchUser'); 
        var action = component.get("c.getUserRole");
        
//        action.setParams({
//            manId: manId
//        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
//            alert(state);
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                var items = [];
                var items2 = [];
                items = response.getReturnValue();
                console.log(items[0].Name);
                console.log(items[1].Name);
                for(var i = 0; i<items.length;i++){
//					alert(items[i].Name + ' ' + items[i].Id);
                    var item = {
                        "label" : items[i].Name,
                        "value" : items[i].Id
                    };
                    items2.push(item);
                }
//                component.set("v.listUser", response.getReturnValue());
//				alert(items2[0].label);
                component.set("v.listUser", items2);
            }
            else if (state === 'ERROR') {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        component.set('v.msg', errors[0].message);
                        this.showErrorToast(component);
                    }
                } else {
                    component.set('v.msg', 'Unknown error');
                    this.showErrorToast(component);
                }
            }
            this.hideSpinner(component);
        })
        this.showSpinner(component);
        $A.enqueueAction(action);
    },

    searchFiliale: function(component, filId) {
        console.log('-----------------------------------------------------------------');
        console.log('-- Controller JS: CRMDinieghiSDDHelper.js - Method: searchFiliale'); 
        var action = component.get("c.getFiliale");
        
        action.setParams({
            filId: filId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            //            alert(state);
            if (state === "SUCCESS") {
                component.set("v.selectedFiliale", response.getReturnValue());
            }
            else if (state === 'ERROR') {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        component.set('v.msg', errors[0].message);
                        this.showErrorToast(component);
                    }
                } else {
                    component.set('v.msg', 'Unknown error');
                    this.showErrorToast(component);
                }
            }
            this.hideSpinner(component);
        })
        this.showSpinner(component);
        $A.enqueueAction(action);
    },
    
    handleAggiornaTelefono: function(component, diniego ,event) {
        console.log('-------------------------------------------------------');
        console.log('-- Controller JS: CRMDinieghiSDDHelper - Method: handleAggiornaTelefono');         

        var action = component.get("c.upgradeTelNumber");
        var telefono = component.find('nuovo-telefono').get('v.value');
        
        var cab = diniego.Cab__c;// component.find('nuovo-telefono').get('v.value');
        var abi = diniego.Abi__c;

        action.setParams({
            // caseId: caseId
            abi: abi,
            cab: cab,
            telefono: telefono,
            idMandati: diniego.Id 
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();
                if (resp == true) {
                    component.set('v.msg', 'Aggiornamento telefono effettuato correttamente');
                     //component.set('nuovo-telefono',telefono);
                    this.showSuccessToast(component);
                    component.set('v.selectedDiniego.Telefono_Banca__c', telefono);
                    // MODIFICA PER AGGIORNARE LA PAGINA                    
                   // $A.get("e.force:refreshView").fire();
                    //                    component.refr();
                    
                }else{
                    component.set('v.msg', 'Qualcosa è andato storto, il numero di telefono non è stato aggiornato');
                    this.showErrorToast(component);
                }
                
            }
            else if (state === 'ERROR') {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        component.set('v.msg', errors[0].message);
                        this.showErrorToast(component);
                    }
                } else {
                    component.set('v.msg', 'Unknown error');
                    this.showErrorToast(component);
                }
            }
            this.hideSpinner(component);
        })
        this.showSpinner(component);
        $A.enqueueAction(action);
    },
    
    handleAggiornaDiniego: function(component, diniego, event) {
        console.log('-------------------------------------------------------------------------');
        console.log('-- Controller JS: CRMDinieghiSDDHelper.js - Method: handleAggiornaDiniego'); 

		var esitoOk = false;
        var interlocutore = component.get('v.interlocutoreValue');
        var esitoTelefonata = component.get('v.esitoTelefonataValue');
        var contattoAvvenuto = component.get('v.contAvvenutoValue');
        var nonTrovatoValue = component.get('v.nonTrovatoValue');
        var userIsBO = component.get('v.userIsBO');
        if(interlocutore=='altro'){
	        var altroInput = component.find('altro-input').get('v.value');
        }
        if(esitoTelefonata =='richiamare'){
	        var dataTimeInput = component.get('v.recallDataTime');
//	        var timeInput = component.find('time-input').get('v.value');
        }
        var optDinRisValue = component.get('v.optDinRisValue');
        var optDinNonRisValue = component.get('v.optDinNonRisValue');
        var sNota = "";
        var sNota1 = " cc - : " + interlocutore;
		var sNota2 = " Chiede di essere richiamato il ";
        var sNota3 = " alle ";
        var sNota4 = " Diniego risolto - Esito : ";
        var sNota5 = " Diniego NON risolto - Esito : ";
        var sNota6 = " - Note : ";
//        var newDataScad = diniego.Caseid__r.recallDateTime__c;
        var newDataScad = dataTimeInput;
        var esitoMan = "";
		var cTentativiChiamata = diniego.Numero_Tentativi__c;
        var chiudiIn = false;
		var filiale = false;
		var sNote = component.find('note').get('v.value');


        console.log('-- Interlocutore: ' + interlocutore); 
        console.log('-- esitoTelefonata: ' + esitoTelefonata); 
        console.log('-- contattoAvvenuto: ' + contattoAvvenuto); 
        console.log('-- nonTrovatoValue: ' + nonTrovatoValue); 
        console.log('-- altroInput: ' + altroInput); 
        console.log('-- dataInput: ' + dataTimeInput); 
//        console.log('-- timeInput: ' + timeInput); 

        
// SEZIONE CONTROLLI

        if(userIsBO == true){ // UTENTE CRM
            if(interlocutore =='selezionare'){
                component.set('v.msg', 'ATTENZIONE - Interlocutore - è OBBLIGATORIO');
                this.showErrorToast(component);
                return;
            }
            
            if(interlocutore =='altro'){
                if (altroInput =='' || altroInput == null){
                    component.set('v.msg', 'Inserire interlocutore della telefonata');
                    this.showErrorToast(component);
                    return;
                }
            }
            if(interlocutore =='nessunInterlocutore'){
                if (esitoTelefonata !='nonchiamare'){
                    component.set('v.msg', 'Nessun interlocutore è un\'opzione valida solo se l\'esito della telefonata è Nessuna telefonata necessaria');
                    this.showErrorToast(component);
                    return;
                }
            }
            
            if(esitoTelefonata =='selezionare'){
                component.set('v.msg', 'ATTENZIONE - Esito Telefonata - è OBBLIGATORIO');
                this.showErrorToast(component);
                return;
            }
            
            if(esitoTelefonata=='richiamare'){
                if(dataTimeInput ==null || dataTimeInput == '' ){
                    component.set('v.msg', 'Attenzione se esito telefonata è - Chiede di essere richiamato - i campi data e ora devono essere compilati.');
                    this.showErrorToast(component);
                    return;
                }else{
                    esitoOk = true;
                    //var sData = dataInput.substring(8,10) + "/" + dataInput.substring(5,7)+"/"+dataInput.substring(0,4);
                    esitoMan = esitoTelefonata;
                    newDataScad = dataTimeInput; // +" "+ timeInput;
                    sNota = sNota1 +" " + sNota2 +" "+newDataScad;//+ " "+ sNota3;//+" "+timeInput.substring(0,5);
                    //console.log('-- sData: ' + sData); 
                    console.log('-- sNota: ' + sNota);
                    console.log('-- newDataScad: ' + newDataScad);
                    console.log('-- esitoMan: ' + esitoMan); 
                }
            }
            
            if(esitoTelefonata=='nonTrovato'){
                if(nonTrovatoValue=="selezionare"){
                    component.set('v.msg', 'Attenzione se esito telefonata è - KO non trovato - KO non trovato è OBBLIGATORIO.');
                    this.showErrorToast(component);
                    return;
                }else{
                    esitoOk = true;
                    esitoMan = component.get("v.nonTrovatoValue");
                    cTentativiChiamata = cTentativiChiamata + 1;
                    sNota = sNota1 +" " + esitoMan;
                    var dataOggi = new Date();
                    //            debugger;
                    if(diniego.Caseid__r.RecallDate__c!=null){
                        dataOggi=diniego.diniego.Caseid__r.RecallDate__c;
                    }
                    //                var dataOk = this.aumentaData(dataOggi,12);
                    newDataScad = this.aumentaData(dataOggi,12);
                    console.log('esitoMan: ' + esitoMan); 
                    console.log('sNota: ' + sNota);
                    console.log('newDataScad --> '+ newDataScad);
                }
            }
            
            console.log("-- esitoTelefonata - > " + esitoTelefonata);
            if(esitoTelefonata=="contattoAvvenuto" || esitoTelefonata=="nonChiamare"){
                var sAusilio;
                sAusilio = ((esitoTelefonata=="contattoAvvenuto") ? "contattoAvvenuto" : "nonChiamare" );
                esitoOk = true;
                console.log("-- passo qui esito doppio");
                console.log("-- sAusilio -> " + sAusilio)
                if (contattoAvvenuto=='risolto'){
                    if(component.get("v.optDinRisValue")!="selezionare"){
                        console.log("passo qui 2");
                        esitoMan = component.get("v.optDinRisValue");
                        chiudiIn = true;
                        sNota = sNota1 +" Diniego Risolto - Esito: " + esitoMan;
                    }else{
                        component.set('v.msg', 'Attenzione se OK Contatto Avvenuto è Risolto - Esito è OBBLIGATORIO.');
                        this.showErrorToast(component);
                        return;
                    }
                }else if(contattoAvvenuto=='nonRisolto'){
                    if(component.get("v.optDinNonRisValue")=="chiuVarBP"){
                        console.log("passo qui3");
                        esitoMan = component.get("v.optDinNonRisValue");
                        chiudiIn = true;
                        sNota = sNota1 + " " + "Diniego NON Risolto - Esito : "+ esitoMan;
                    }else if(component.get("v.optDinNonRisValue")=="verificheFil"){ // VERIFICHE FILIALE
                        console.log("passo qui4");
                        esitoMan = component.get("v.optDinNonRisValue");
                        filiale = true;
                        sNota = sNota1 + " " + "Diniego NON Risolto - Esito : "+ esitoMan;
                    }else{
                        component.set('v.msg', 'Attenzione se OK Contatto Avvenuto è NON Risolto - Sono necessarie verifiche con la filiale è OBBLIGATORIO.');
                        this.showErrorToast(component);
                        return;
                        
                    }
                }else{
                    component.set('v.msg', 'Attenzione se esito telefonata è - OK Contatto Avvenuto o Nessuna telefonata necessaria - OK Contatto Avvenuto è OBBLIGATORIO.');
                    this.showErrorToast(component);
                    return;
                }
                //            debugger;
                console.log('esitoMan: ' + esitoMan); 
                console.log('snota: ' + sNota);
            }
            
            if(sNote!=null){
                esitoOk = true;
                sNota = sNota +" - Note : " + sNote;
                //            debugger;
                console.log('sNota: ' + sNota);
            }
            
            if(esitoMan=="verificheFil"){
                if(diniego.Filiale__c==null){
                    component.set('v.msg', 'Filiale Virtuale, impossibile inoltrare');
                    this.showErrorToast(component);
                    return;
                }else{
                    esitoOk = true;
                }
            }
        }else if(userIsBO == false){ // UTENTE SFA
            if(contattoAvvenuto=="selezionare"){
                component.set('v.msg', 'ATTENZIONE - Inserire un valore nella combo - è OBBLIGATORIO');
                this.showErrorToast(component);
                return;
            }else{
                esitoMan = component.get("v.contAvvenutoValue");
            }
        }        
        
        console.log("Esito finale -> " + esitoMan);
//        alert("Esito finale -> " + esitoMan);
        console.log("Nota finale ->" + sNota);
        console.log("Id Diniego -> " + diniego.Id);

        if(esitoOk = true){
            var action = component.get("c.upgradeMandato");

            this.showSpinner(component);
            action.setParams({
                // caseId: caseId 
                sAusilio: sAusilio,
                esito: esitoMan,
                nota: sNota,
                idMandato: diniego.Id,
                nData: newDataScad,
                interlocutore: interlocutore,
                altroInterlocutore: altroInput,
                sUser: userIsBO
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var resp = response.getReturnValue();
                    if (resp == true) {
                        component.set('v.msg', 'Aggiornamento Mandato effettuato correttamente');
                        this.showSuccessToast(component);
                        // MODIFICA PER AGGIORNARE LA PAGINA                    
                        $A.get("e.force:refreshView").fire();

                    }else{
                        component.set('v.msg', 'Aggiornamento Mandato NON effettuato');
                        this.showErrorToast(component);
                    }
                    
                }
                else if (state === 'ERROR') {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            component.set('v.msg', errors[0].message);
                            this.showErrorToast(component);
                        }
                    } else {
                        component.set('v.msg', 'Unknown error');
                        this.showErrorToast(component);
                    }
                }
                this.hideSpinner(component);

            })
            
//            this.showSpinner(component);
            $A.enqueueAction(action);
        }

    },
 
    openElementDisposition: function(component,disp,sAusilio) {

        console.log('-------------------------------------------------------');
        console.log('-- Controller JS: CRMDinieghiSDDHelper - Method: openElementDisposition');         
        console.log('-- openElementDisposition disp:'+disp);
        if (disp!=null) {
            var sAusilio;
            switch(disp) {
                case "DP3492":
                    if (sAusilio=='contattoAvvenuto'){
                        component.set('v.esitoTelefonataValue', 'contattoAvvenuto');  
                    }else if (sAusilio=='nonChiamare'){
                        component.set('v.esitoTelefonataValue', 'nonChiamare');  
                    }
                    component.set('v.contAvvenutoValue', 'risolto'); 
                    component.set('v.optDinRisValue ', 'variatoAbi'); 
                    break;
                case "DP3493":
                        if (sAusilio=='contattoAvvenuto'){
                            component.set('v.esitoTelefonataValue', 'contattoAvvenuto');  
                        }else if (sAusilio=='nonChiamare'){
                            component.set('v.esitoTelefonataValue', 'nonChiamare');  
                        }
                        component.set('v.contAvvenutoValue', 'risolto');  
                    component.set('v.optDinRisValue ', 'variatoCab'); 
                    break;
                case "DP3494":
                        if (sAusilio=='contattoAvvenuto'){
                            component.set('v.esitoTelefonataValue', 'contattoAvvenuto');  
                        }else if (sAusilio=='nonChiamare'){
                            component.set('v.esitoTelefonataValue', 'nonChiamare');  
                        }
                        component.set('v.contAvvenutoValue', 'risolto');  
                    component.set('v.optDinRisValue ', 'variatoCc'); 
                    break;
                case "DP3495":
                        if (sAusilio=='contattoAvvenuto'){
                            component.set('v.esitoTelefonataValue', 'contattoAvvenuto');  
                        }else if (sAusilio=='nonChiamare'){
                            component.set('v.esitoTelefonataValue', 'nonChiamare');  
                        }
                        component.set('v.contAvvenutoValue', 'risolto');  
                    component.set('v.optDinRisValue ', 'variatoInt'); 
                    break;
                case "DP3496":
                        if (sAusilio=='contattoAvvenuto'){
                            component.set('v.esitoTelefonataValue', 'contattoAvvenuto');  
                        }else if (sAusilio=='nonChiamare'){
                            component.set('v.esitoTelefonataValue', 'nonChiamare');  
                        }
                        component.set('v.contAvvenutoValue', 'risolto');  
                    component.set('v.optDinRisValue ', 'variatoIban'); 
                    break;
                case "DP3497":
                        if (sAusilio=='contattoAvvenuto'){
                            component.set('v.esitoTelefonataValue', 'contattoAvvenuto');  
                        }else if (sAusilio=='nonChiamare'){
                            component.set('v.esitoTelefonataValue', 'nonChiamare');  
                        }
                        component.set('v.contAvvenutoValue', 'risolto');  
                    component.set('v.optDinRisValue ', 'inviatoNuoMan'); 
                    break;
                case "DP3495":
                        if (sAusilio=='contattoAvvenuto'){
                            component.set('v.esitoTelefonataValue', 'contattoAvvenuto');  
                        }else if (sAusilio=='nonChiamare'){
                            component.set('v.esitoTelefonataValue', 'nonChiamare');  
                        }
                        component.set('v.contAvvenutoValue', 'risolto');  
                    component.set('v.optDinRisValue ', 'variatoInt'); 
                    break;
                case "DP3496":
                        if (sAusilio=='contattoAvvenuto'){
                            component.set('v.esitoTelefonataValue', 'contattoAvvenuto');  
                        }else if (sAusilio=='nonChiamare'){
                            component.set('v.esitoTelefonataValue', 'nonChiamare');  
                        }
                        component.set('v.contAvvenutoValue', 'risolto');  
                    component.set('v.optDinRisValue ', 'variatoIban'); 
                    break;
                case "DP3497":
                        if (sAusilio=='contattoAvvenuto'){
                            component.set('v.esitoTelefonataValue', 'contattoAvvenuto');  
                        }else if (sAusilio=='nonChiamare'){
                            component.set('v.esitoTelefonataValue', 'nonChiamare');  
                        }
                        component.set('v.contAvvenutoValue', 'risolto');  
                    component.set('v.optDinRisValue ', 'inviatoNuoMan'); 
                    break;
                case "DP3498":
                        if (sAusilio=='contattoAvvenuto'){
                            component.set('v.esitoTelefonataValue', 'contattoAvvenuto');  
                        }else if (sAusilio=='nonChiamare'){
                            component.set('v.esitoTelefonataValue', 'nonChiamare');  
                        }
                        component.set('v.contAvvenutoValue', 'risolto');  
                    component.set('v.optDinRisValue ', 'attivatoStatoMan'); 
                    break;
                case "DP3500":
                        if (sAusilio=='contattoAvvenuto'){
                            component.set('v.esitoTelefonataValue', 'contattoAvvenuto');  
                        }else if (sAusilio=='nonChiamare'){
                            component.set('v.esitoTelefonataValue', 'nonChiamare');  
                        }
                        component.set('v.contAvvenutoValue', 'risolto');  
                    component.set('v.optDinRisValue ', 'gestitoAltroUte'); 
                    break;
                case "DP3501":
                        if (sAusilio=='contattoAvvenuto'){
                            component.set('v.esitoTelefonataValue', 'contattoAvvenuto');  
                        }else if (sAusilio=='nonChiamare'){
                            component.set('v.esitoTelefonataValue', 'nonChiamare');  
                        }
                        component.set('v.contAvvenutoValue', 'risolto');  
                    component.set('v.optDinRisValue ', 'altro'); 
                    break;                
                case "DP3503":
                        if (sAusilio=='contattoAvvenuto'){
                            component.set('v.esitoTelefonataValue', 'contattoAvvenuto');  
                        }else if (sAusilio=='nonChiamare'){
                            component.set('v.esitoTelefonataValue', 'nonChiamare');  
                        }
                        component.set('v.contAvvenutoValue', 'nonRisolto');  
                    component.set('v.optDinNonRisValue ', 'verificheFil'); 
                    break;
               case "DP3505":
                    if (sAusilio=='contattoAvvenuto'){
                        component.set('v.esitoTelefonataValue', 'contattoAvvenuto');  
                    }else if (sAusilio=='nonChiamare'){
                        component.set('v.esitoTelefonataValue', 'nonChiamare');  
                    }
                    component.set('v.contAvvenutoValue', 'nonRisolto');  
                    component.set('v.optDinNonRisValue ', 'chiuVarBP'); 
                    break;
               case "DP3507":
                    component.set('v.esitoTelefonataValue', 'nonTrovato');  
                    component.set('v.nonTrovatoValue', 'noRecapito');  
                    break;
                case "DP3508":
                    component.set('v.esitoTelefonataValue', 'nonTrovato');  
                    component.set('v.nonTrovatoValue', 'numErrato');  
                    break;
                case "DP3509":
                    component.set('v.esitoTelefonataValue', 'nonTrovato');  
                    component.set('v.nonTrovatoValue', 'nonRisponde');  
                    break;
                case "DP3510":
                    component.set('v.esitoTelefonataValue', 'nonTrovato');  
                    component.set('v.nonTrovatoValue', 'irraggiungibile');  
                    break;
                case "DP3533":
                    component.set('v.esitoTelefonataValue', 'nonTrovato');  
                    component.set('v.nonTrovatoValue', 'noInfo');  
                    break;
                case "DP3511":
                    component.set('v.esitoTelefonataValue', 'richiamare');  
                    break;                                              
                case "DP3502":
                    if (sAusilio=='contattoAvvenuto'){
                        component.set('v.esitoTelefonataValue', 'contattoAvvenuto');  
                    }else if (sAusilio=='nonChiamare'){
                        component.set('v.esitoTelefonataValue', 'nonChiamare');  
                    }
                    component.set('v.contAvvenutoValue', 'nonRisolto');  
                    break;                                              
                case "DP3491":
                    if (sAusilio=='contattoAvvenuto'){
                        component.set('v.esitoTelefonataValue', 'contattoAvvenuto');  
                    }else if (sAusilio=='nonChiamare'){
                        component.set('v.esitoTelefonataValue', 'nonChiamare');  
                    }
                    component.set('v.contAvvenutoValue', 'risolto');  
                    break;                                              
                default:
              } 
        }
    },

    getDispositions: function(component, disp, sAusilio) {
        console.log('-------------------------------------------------------');
        console.log('-- Controller JS: CRMDinieghiSDDHelper - Method: getDisposition');         
        console.log('-- sAusilio --> '+ sAusilio);

        var action = component.get("c.valDisposition");
        action.setParams({
            vId: disp
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var respDisp = response.getReturnValue();
                component.set('v.disposition', respDisp);
                this.openElementDisposition(component,respDisp,sAusilio);
            }
            else if (state === 'ERROR') {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        component.set('v.msg', errors[0].message);
                        this.showErrorToast(component);
                    }
                } else {
                    component.set('v.msg', 'Unknown error');
                    this.showErrorToast(component);
                }
            }
            this.hideSpinner(component);

        })
        this.showSpinner(component);
        $A.enqueueAction(action);
    },

    doShowModal: function(component) {

        component.set('v.showModal', true);
    },
    
    doHideModal: function(component) {

        component.set('v.showModal', false);
    },
    
    showSuccessToast : function(component) {

        component.find('notifLib').showToast({
            "variant": "success",
            "title": "Success!",
            "message": component.get('v.msg')
        });
    },
    
    showErrorToast : function(component) {

        component.find('notifLib').showToast({
            "variant": "error",
            "title": "Error!",
            "message": component.get('v.msg')
        });
    },
    
    showInfoToast : function(component) {

        component.find('notifLib').showToast({
            "variant": "info",
            "title": "Info",
            "message": component.get('v.msg')
        });
    },
    
    showWarningToast : function(component) {

        component.find('notifLib').showToast({
            "variant": "warning",
            "title": "Warning!",
            "message": component.get('v.msg')
        });
    },
    
    showNotice : function(component) {

        component.find('notifLib').showNotice({
            "variant": "info",
            "header": "Info",
            "message": component.get("v.notifMsg"),
            closeCallback: function() {
                
            }
        });
    },
    
    showSpinner: function(component) {

        var x = component.get('v.showSpinner')+1;
        component.set('v.showSpinner', x);
    },

    filtraListaMandati: function(component) {
       var labelButton = component.get('v.labelButton');
        
        
       var mappa = component.get('v.mapDinieghi');
        if (labelButton=='Assegnate a me'){
            component.set("v.elencoDinieghi", mappa.User);
            component.set('v.labelButton', 'Visualizza tutte');
        }else{
            component.set("v.elencoDinieghi", mappa.All);
            component.set('v.labelButton', 'Assegnate a me');
        }
    },
    
    hideSpinner: function(component) {

        var x = component.get('v.showSpinner')-1;
        component.set('v.showSpinner', x);
    },
    aumentaData: function(s, h) {
        console.log('---------------------------------------------------------------');
        console.log('-- Controller JS: CRMDinieghiSDDHelper.js - Method: aumentaData'); 
        
		var mm = h*3600000;        
        var msec = Date.parse(s);
        var d = new Date(msec+mm);
        
		return d;
    },

    controllaABICAB: function(c) {
         
		var n  = c.length;
		var d = c;        
        switch(n){
            case 5:
            	break;
            case 4:
                d = '0'+c;
                break;
            case 3:
                d = '00'+c;
                break;
            case 2:
                d = '000'+c;
                break;
        }
		return d;
    },

        MAX_FILE_SIZE: 750000, 
    
    doInit2: function(component, event){
        console.log('-------------------------------------------------------');
        console.log('-- Controller JS: CRMDinieghiSDDHelper - Method: doInit2');         

        var action = component.get("c.createRecordForUploadFile");
        action.setCallback(this, function(resp) {
            if(resp.getState()=='SUCCESS'){
                component.set("v.recordId",resp.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    
    handleUploadFinished : function(component, event){
        console.log('-------------------------------------------------------');
        console.log('-- Controller JS: CRMDinieghiSDDHelper - Method: handleUploadFinished');         

        
        var uploadedFiles = event.getParam("files");
        var documentId = uploadedFiles[0].documentId;
        var fileName = uploadedFiles[0].name;
        
        var action = component.get("c.finishUploadFile");
        action.setParams({ 
//            recordId : component.get("v.recordId"),
            recordId : component.get("v.selectedDiniego.Caseid__c"),
            documentId: documentId,
            nameFile : fileName
        });
        
        action.setCallback(this, function(resp) {
            if(resp.getState()=='SUCCESS'){
                component.set("v.elencoFile",resp.getReturnValue());
                component.set("v.refresh", false);
                component.set("v.refresh", true);
//                $A.get("e.force:refreshView").fire();
            }
        });
        $A.enqueueAction(action);
    },

    handleGetFile : function(component, event, sCaseId){
        console.log('-------------------------------------------------------');
        console.log('-- Controller JS: CRMDinieghiSDDHelper - Method: handleGetFile');         
        
        var caseId = sCaseId;
        var action = component.get("c.getFile");
		console.log('casaeId -> ' + caseId);
        action.setParams({ 
            recordId : caseId,
        });
        action.setCallback(this, function(resp) {
            if(resp.getState()=='SUCCESS'){
                console.log(resp.getReturnValue());
                component.set("v.elencoFile",resp.getReturnValue());
                console.log(component.get("v.elencoFile"));
            }
        });
        $A.enqueueAction(action);
    },

    showToast : function(message, type){

        var toastEvent = $A.get("e.force:showToast");
        console.log(' message, type '+message+ ' - '+type);
        toastEvent.setParams({
            message: message,
            type : type
        });
        toastEvent.fire();
    },
    
    handleDownloadFile : function(component, event){
        console.log('-------------------------------------------------------');
        console.log('-- Controller JS: CRMDinieghiSDDHelper - Method: handleDownloadFile');         

        var id = event.target.getAttribute("data-id");       
        console.log('Document ID: ' +id);
        var action = component.get("c.Attachment");
        action.setParams({
            DownloadAttachmentID: id,
            s : 'D'
        });
        action.setCallback(this, function(b){
            console.log('b.getState -> ' + b.getState());
            if(b.getState()=='SUCCESS'){
                console.log('passo di qui');
                component.set("v.Baseurl", b.getReturnValue());
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": b.getReturnValue()
                });
	            urlEvent.fire();
            }
        });
         $A.enqueueAction(action);
    },    

    handleCancellaFile : function(component, event){
        console.log('-------------------------------------------------------');
        console.log('-- Controller JS: CRMDinieghiSDDHelper - Method: handleCancellaFile');         

        var id = event.target.getAttribute("data-id");       
        console.log('Document ID: ' +id);
        var action = component.get("c.Attachment");
        action.setParams({
            DownloadAttachmentID: id,
            s : 'C'
        });
        action.setCallback(this, function(b){
            console.log('b.getState -> ' + b.getState());
            if(b.getState()=='SUCCESS'){
                console.log('passo di qui');
                component.set("v.refresh", false);
                component.set("v.refresh", true);
//                component.set("v.Baseurl", b.getReturnValue());
//                var urlEvent = $A.get("e.force:navigateToURL");
//                urlEvent.setParams({
//                    "url": b.getReturnValue()
//                });
//                urlEvent.fire();
            }
        });
        $A.enqueueAction(action);
    }    
    
    

})