({
    getFiliale: function(component){
        var detailEvent= component.get("v.detailEvent");
        var action = component.get('c.getAccountById');
        var resultat;
        action.setParams({"idAccount":detailEvent.Desk__r.Branch__c}); 
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                resultat = response.getReturnValue();
                console.log('filiale '+ JSON.stringify(resultat));
                if (!resultat.erreur) {
                    component.set("v.filialeEvent", resultat.account);
                } else {
                    console.log('message', "Error");
                }
            }
        });
        $A.enqueueAction(action); 
    },
    checkDatetime : function(component,event,isExist) {
	 	var detailEvent = component.get("v.detailEvent");
        console.log("detailEvent" + JSON.stringify(detailEvent));
        var action = component.get('c.getEventByDateActivity'); 
        action.setParams({ "activityDate ": detailEvent.ActivityDateTime}); 
        action.setCallback(this, function (response) {
            if (response.getState() == "SUCCESS") {
                var resultat = response.getReturnValue();
                if (resultat.events.length!=0){
                        console.log('### events ', JSON.stringify(resultat.events));
                        isExist=true;
                    } else {
                    isExist=false;
                }
            }
            else{
            console.log(response.getError());
            }
        });
        $A.enqueueAction(action); 
    },
    aggiornaAppuntamento : function(component,event,helper) {
	 	var detailEvent = component.get("v.detailEvent");
        console.log("detailEvent" + JSON.stringify(detailEvent));
        var action = component.get('c.updateEvent'); 
        action.setParams({"event": detailEvent,
                        "timeEvent": component.get('v.timeEvent')}); 
        action.setCallback(this, function (response) {
            if (response.getState() == "SUCCESS") {
                var resultat = response.getReturnValue();
                console.log('### detailEvent ', resultat.detailEvent);
                console.log('### resultat ', JSON.stringify(resultat));
                if (resultat.erreur==false) {
                    this.showToast("appuntamento modifica con successo","success");
                    component.set("v.detailEvent",resultat.detailEvent);
                    component.set("v.isOpen", false);
                    component.set("v.ModifyEvent",false);
                    $A.get("e.force:closeQuickAction").fire();
                } else {
                    this.showToast("errori appuntamento modifica","error");
                    component.set("v.isOpen", false);
                }
            }
            else{
            console.log(response.getError());
            }
        });
        $A.enqueueAction(action); 
    },
    showToast: function (message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            message: message,
            type: type
        });
        toastEvent.fire();
    },
    uploadRiepilogo : function(component,event,helper) { 
        var message="message";
	 	var detailEvent = component.get("v.detailEvent");
        let vfUrl = '/apex/EventRepport?data=' + JSON.stringify(detailEvent)+'&message='+message;
		window.open(vfUrl,'_self');
    },
    saveAnnulato : function(component,event,helper){
        var detailEvent = component.get("v.detailEvent");
            console.log("detailEvent" + JSON.stringify(detailEvent));
            var action = component.get('c.annulaEvent'); 
            action.setParams({ "event": detailEvent}); 
            action.setCallback(this, function (response) {
            if (response.getState() == "SUCCESS") {
                var resultat = response.getReturnValue();
                if (resultat.erreur==false) {
                    this.showToast("appuntamento annullato",'success');
                    component.set('v.showDetail',false);
                    $A.get('e.force:refreshView').fire();
                    } else {
                        this.showToast("Appuntamento Già Annullato",'error');
                    }
                }
                else{
                console.log(response.getError());
                }
            });
            $A.enqueueAction(action); 
            component.set('v.alertMessage',false);
           
    },
    annulAppuntamento :function(component,event,helper){
        component.set('v.alertMessage',true);
        component.set('v.messageError',' Confermi l\'annullamento dell\'appuntamento?');
    },
    choiceValueSelect :function(component){
        var select = document.getElementById("nuovoStato");
        var nuovoStato = select.options[select.selectedIndex].value;
        //Appuntamento Modificato
        var esitoList1=[
            {"code":"2","value":"Rinviato da cliente"},
            {"code":"3","value":"Rinviato da filiale"}];
        
        //Presentato
        var esitoList2=[
            {"code":"4","value":"Aderisce"},
            {"code":"","value":"Preventivo / Ci vuole pensare"},
            {"code":"","value":"No parametri minimi"},
            {"code":"","value":"No parametri minimi CQS"},
            {"code":"","value":"Rinuncia"},
            {"code":"25","value":"Spostato con Preventivo"}
        ];
        
        //Non presentato/Annullato
        var esitoList3=[
            {"code":"19","value":"Cliente non raggiungibile"},
            {"code":"20","value":"Non più interesssato"},
            {"code":"21","value":"Risolto con altra finanziaria"},
            {"code":"22","value":"Richiamo più avanti"},
            {"code":"","value":"Appuntamento fissato impropriamente"},
            {"code":"","value":"Impossibile recarci in filiale"}
        ];
        
        component.set('v.showMotivazione',false);
        component.set('v.showEsito',true);
        component.set("v.ModifyEvent",false);
        component.set("v.detailEvent.Stato_Azione__c",nuovoStato);
        if(nuovoStato==='Appuntamento modificato'){
            component.set("v.ModifyEvent",true);
            component.set("v.listEsito",esitoList1);
            this.controleMinutesAndHoure(component);
            //component.set('v.detailEvent.Esito__c','Rinviato da cliente');
        }else if(nuovoStato==='Presentato'){
            component.set("v.ModifyEvent",true);
            component.set("v.listEsito",esitoList2);
            this.controleMinutesAndHoure(component);
            //component.set('v.detailEvent.Esito__c','Aderisce');
        }else if(nuovoStato==='Non presentato/Annullato'){
            component.set("v.listEsito",esitoList3);
            //component.set('v.detailEvent.Esito__c','Cliente non raggiungibile');
            //this.annulAppuntamento(component,event,helper);

        }
        this.getValueFotocopieAllegare(component);
    },
    getValueList3: function (component,event,helper) {
        var select = document.getElementById("esitoList");
        var esitoSelected = select.options[select.selectedIndex].value;
        var n = esitoSelected.indexOf("-");
        var code=esitoSelected.substring(0,n);
        var value=esitoSelected.substring(n+1,esitoSelected.length);
        console.log("esitoselected "+code+"/"+value);

        //No parametri minimi
        var motivazioneList1=[
            {"code":"6","value":"Età"},
            {"code":"7","value":"Non dispone di documentazione necessaria"},
            {"code":"8","value":"Richiesto coobligato"},
            {"code":"9","value":"Già cliente non ha pagato abbastanza rate"},
            {"code":"10","value":"Anzianità lavorativa ( se prevista )"},
            {"code":"23","value":"Aderisce CQS"}
        ];

        //No parametri minimi CQS       
        var motivazioneList2=[
            {"code":"11","value":"TFR basso o insesistente"},
            {"code":"12","value":"Residuo CQS Alto"},
            {"code":"13","value":"Azienda non finanziabile"},
            {"code":"14","value":"Cliente non finanziabile"}
        ];

        //Rinuncia
        var motivazioneList3=[
            {"code":"15","value":"Tassi elevati / Concorrenza migliore"},
            {"code":"16","value":"Richiesta durata maggiore"},
            {"code":"17","value":"Vorrebbe importo maggiore"},
            {"code":"18","value":"Non vuole CQS"}
        ];

        //Appuntamento fissato impropriamente
        var motivazioneList4=[
            {"code":"26","value":"Cliente non ha capito motivo appt"},
            {"code":"27","value":"Cliente doveva svolgere altre attività"},
            {"code":"28","value":"Cliente non ha capito motivo appt."}
        ];
           
        component.set('v.showMotivazione',true);
        //component.set('v.detailEvent.Esito__c',value);
        if(value==='No parametri minimi'){
            component.set("v.listMotivazione",motivazioneList1);
        }else if(value==='No parametri minimi CQS'){
            component.set("v.listMotivazione",motivazioneList2);
        }else if(value==='Rinuncia'){
            component.set("v.listMotivazione",motivazioneList3);
        }else if(value==='Appuntamento fissato impropriamente'){
            component.set("v.listMotivazione",motivazioneList4);
            //this.annulAppuntamento(component,event,helper);
        }else{
            this.getDisposition(component,code);
            //component.set("v.detailEvent.Disposition__c",code);
            component.set('v.showMotivazione',false);
            var nuovoStato = component.get("v.detailEvent.Stato_Azione__c");
            if(nuovoStato=='Appuntamento modificato'){
                component.set("v.ModifyEvent",true);
            }else if(nuovoStato=='Presentato'){
                component.set("v.ModifyEvent",true);
            }else{
                component.set("v.ModifyEvent",false);
                this.annulAppuntamento(component,event,helper);
            }
        }
    },
    getValueMotivazione : function (component,event){
        var select = document.getElementById("motivazioneList");
        var motivazioneSelected = select.options[select.selectedIndex].value;
        var n = motivazioneSelected.indexOf("-");
        var code=motivazioneSelected.substring(0,n);
        var value=motivazioneSelected.substring(n+1,motivazioneSelected.length);
        this.getDisposition(component,code);
        //omponent.set("v.detailEvent.Disposition__c",code);
        component.set("v.ModifyEvent",true);
        var nuovoStato = component.get("v.detailEvent.Stato_Azione__c");
        if(nuovoStato=='Non presentato/Annullato'){
            this.annulAppuntamento(component,event);
        }
    },
    getDisposition : function(component,code){
        var resultat;
        var disposition;
        var action = component.get('c.getDisposition'); 
        action.setParams({ "codeExternal": code}); 
        action.setCallback(this, function (response) {
            if (response.getState() == "SUCCESS") {
                resultat = response.getReturnValue();
                disposition=resultat.disposition;
                if (resultat.erreur==false){
                        console.log('### disposition ', JSON.stringify(resultat));
                        //component.set("v.disposition",resultat.disposition.Id);
                        component.set("v.detailEvent.Disposition__c",disposition.Id);
                    }else
                    {
                        console.log("error "+resultat.messageError);
                    }
            }else{
            console.log(response.getError());
            }
        });
        $A.enqueueAction(action); 
    },
    getValuesProduct : function (component){
        var resultat;
        var productParentEvent =component.get("v.detailEvent.Product__r.Parent__c");
        var action = component.get('c.getProduct'); 
        action.setParams({"IdProdotto":productParentEvent}); 
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                resultat = response.getReturnValue();
                console.log('### parent product ', '/'+JSON.stringify(resultat));

                if (resultat.erreur===false) {
                    component.set('v.DataglioProductValues',resultat.product);
                } else {
                   console.log('error to check product'); 
                }
            }
            else{
            console.log(response.getError());
            }
        });
        $A.enqueueAction(action); 
    },
    fireRefresh : function (component, event, helper) {
    
        var evt = $A.get("e.force:navigateToComponent");
    	evt.setParams({
        	componentDef : "c:modificaAppuntamento"
    	});
    	evt.fire();
    },
    controleMinutesAndHoure : function (component){
        component.set('v.listTime',[]);
        var dateEvent=component.get("v.detailEvent.ActivityDate");
        var filialeEvent=component.get("v.filialeEvent");
        var action = component.get('c.controleDateEvent'); 
        var resultat;
        var listTimes;
        var listHour=[];
        var filialeName = filialeEvent.Name;
        console.log('### resultat ', dateEvent+'/'+JSON.stringify(filialeEvent));
        action.setParams({"dateAppuntamento": dateEvent,
                          "filialeName":filialeName}); 
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                resultat = response.getReturnValue();
                console.log('### resultat ', dateEvent+'/'+JSON.stringify(resultat));
                if (resultat.erreur===false) {
                    listTimes=resultat.data;
                    if(listTimes.length>0){
						for (var i = 0; i < listTimes.length ; i++ ) {
                            console.log(listTimes[i]);
							var milliseconds = parseInt(listTimes[i]);
							var hours = Math.floor(milliseconds / 3600000);
                            var minutes = Math.floor((milliseconds - (hours * 3600000)) / 60000);
                            if(minutes=='0'){
                                minutes='00';
                            }
        					var tim= hours + ':' + minutes; 
                            listHour.push(tim);
						}
                        component.set('v.listTime',listHour);
                        console.log(' ############ '+JSON.stringify(resultat.data));
                        console.log(' ############ resultat.slotDesk '+JSON.stringify(resultat.slotDesk));
                        
                    }
                } else{
                    console.log(response.getError());
                }
            }
            else{
            console.log(response.getError());
            }
        });
        $A.enqueueAction(action); 
    },
    controldateEvent : function(component,event,helper){
        var dateEvent=component.get("v.detailEvent.ActivityDate");
        var dateNow= new Date;
        var today =dateNow.getDate();
        var dateparseEven = Date.parse(dateEvent);
        var dateparsenow = Date.parse(today);
        
        //var minutes=dateparseEven.getMinutes();
        //console.log('minutes '+minutes);
        console.log(dateparseEven+'/'+dateparsenow);
            if(dateparseEven < dateparsenow){
                this.showToast("la data scelta non è valida", "error");
            }else{
                this.controleMinutesAndHoure(component);
            }
    },
    showToast: function (message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            message: message,
            type: type
        });
        
        toastEvent.fire();
    },
    getValueFotocopieAllegare : function(component){
        var labelFotocopoAllegaro='';
        var parentProduct= component.get('v.DataglioProductValues');
        var detailEvent= component.get("v.detailEvent");
        console.log(' external '+detailEvent.Product__r.RSS_External_Id__c);
        if(detailEvent.Product__r.RSS_External_Id__c!=null){
            if(detailEvent.Product__r.RSS_External_Id__c=='1079'){
                labelFotocopoAllegaro='nessun documento richiesto';
            }else{
                labelFotocopoAllegaro='Documento di riconoscimento \nTessera sanitaria\nPermesso di soggiorno(se sei cittadino extra UE)';
                if(detailEvent.Tipo_Occupazione__c=='Autonomo'){
                    labelFotocopoAllegaro=labelFotocopoAllegaro+'\nUltimo modello Unico con ricevuta elettronica di presentazione';
                }else if(detailEvent.Tipo_Occupazione__c=='Dipendente'){
                    labelFotocopoAllegaro=labelFotocopoAllegaro+'\nUltima Busta Paga';
                }else if(detailEvent.Tipo_Occupazione__c=='Pensionato'){
                    labelFotocopoAllegaro=labelFotocopoAllegaro+'\nUltimo documento attestante reddito da pensione';
                }else if(detailEvent.Tipo_Occupazione__c=='Altro'){
                    if((parentProduct!=null)&&(parentProduct.RSS_External_Id__c!='1079')){
                        labelFotocopoAllegaro=labelFotocopoAllegaro+'\nIn caso di assenza del documento di reddito è necessaria la presenza di un coobbligato';
                    }
                    //labelFotocopoAllegaro=labelFotocopoAllegaro+'\nIn caso di assenza del documento di reddito è necessaria la presenza di un coobbligato';
                }else{
                    labelFotocopoAllegaro=labelFotocopoAllegaro+'\nUltimo documento attestante un reddito';
                }
            }
        }
        component.set('v.fotocopieAllegare',labelFotocopoAllegaro);
    }
})