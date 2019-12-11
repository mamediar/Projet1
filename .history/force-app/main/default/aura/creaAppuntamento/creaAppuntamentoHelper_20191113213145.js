({
    crontrolleDataNascita : function(){
        
    },
    getCliente: function(component,idCliente){
        var action = component.get('c.getAccountByIdCliente');
        var resultat;
        action.setParams({"idAccount":idCliente}); 
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                resultat = response.getReturnValue();
                if (!resultat.erreur) {
                    component.set("v.cliente", resultat.account);
                    component.set("v.sesso",resultat.account.Sesso__pc);

                } else {
                    console.log('message', "Error");
                }
            }
        });
        $A.enqueueAction(action); 
    },
    getProductsInteressato: function (component){
        var action = component.get('c.getAllProductInteressato');
        var resultat;
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                resultat = response.getReturnValue();
                /**show result of all product */
                console.log('### prouct ', resultat.products);
                console.log('### resultat ', JSON.stringify(resultat));
                if (resultat) {
                    component.set("v.listProducts", resultat.products);
                } else {
                    console.log('message', "Error");
                }
            }
        });
        $A.enqueueAction(action); 
    },
    choiceProdottoInteresse : function(component,event,helper){
        var prodottoInteresse;
        var selectPI = document.getElementById("prodottoInteresse");
            if(selectPI.selectedIndex){
                prodottoInteresse = selectPI.options[selectPI.selectedIndex].value;
                var charProNameDesc = prodottoInteresse.split('/');
                this.getProductsDettaglio(component, event,charProNameDesc[0]);
            }
    },
    getProductsDettaglio : function (component,event,IdProdottoInteresse){
        var action = component.get('c.getAllProductDettaglio');
        var resultat;
        action.setParams({"idParent":IdProdottoInteresse}); 
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                resultat = response.getReturnValue();
                /**show result of all product */
                console.log('### prouct ', resultat.products);
                console.log('### resultat ', JSON.stringify(resultat));
                if (resultat) {
                    component.set("v.listProductsDettaglio", resultat.products);
                } else {
                    console.log('message', "Error");
                }
            }
        });
        $A.enqueueAction(action); 
    },
    
    getProvinceAndComune: function (component){
        var action = component.get('c.getProvince');
        var resultat;
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                resultat = response.getReturnValue();
                console.log('### xCSTown ', JSON.stringify(resultat.xCSTown));
                console.log('### resultat ', JSON.stringify(resultat));

                if (resultat.erreur === false) {
                    component.set("v.listProvince", resultat.xCSTown);
                } else {
                    console.log('message', "Error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    getComuneCastale: function(component,event,helper){
        var action = component.get('c.getCommuneByProvince');
        var resultat;
        var selectPN = document.getElementById("privinceNascita");
        var provinceNascita = selectPN.options[selectPN.selectedIndex].value;
        action.setParams({"province":provinceNascita}); 
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                resultat = response.getReturnValue();
                console.log('### resultat ', JSON.stringify(resultat));

                if (resultat.erreur === false) {
                    component.set("v.listComune", resultat.comunes);
                } else {
                    console.log('message', "Error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    calculCodiceFiscale: function (component){
        var cliente = component.get("v.cliente");
        var action = component.get('c.calcolaCodiceFiscale');
        var resultat;
        var catastale=component.get('v.catastale');
        action.setParams({"cliente":cliente,
                        "catastale":catastale}); 
        console.log('catastale '+catastale);
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                resultat = response.getReturnValue();
                component.set("v.cliente.Codice_Fiscale__pc",resultat.strCodFis);
                console.log('### codice fiscal ', JSON.stringify(resultat));
            }
            else {
                console.log('error codice fiscale ');
                console.log('### codice fiscal ', JSON.stringify(response.getReturnValue()));
            }
        });
        $A.enqueueAction(action);
    },
    checkOperatorFiliale : function(component,event,helper){
        var action = component.get('c.checkOperator');
        var idCliente= component.get("v.idCliente");
        var resultat;
        action.setParams({"idClient":idCliente}); 
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                resultat = response.getReturnValue();
                //console.log('filialeOperator '+JSON.stringify(resultat));
                if(resultat.isbranch){
                    if(resultat.filialeOperator!=""){
                        component.set("v.filialeId",resultat.filialeOperator);
                       if(resultat.eventClientExist==true){
                            if(resultat.modificaEvent){
                                component.set('v.eventAModifica',resultat.eventToModifi);
                                this.openmodelModificaEvent(component,resultat.eventToModifi);
                            }else{
                                component.set('v.messageModifica',resultat.messageExistClient);
                                this.openErrorMessage(component,resultat.messageExistClient);
                            }
                       }else{
                            this.continuCreaAppuntamento1(component,event,helper);
                       }
                    }
                    else{
                        this.continuCreaAppuntamento1(component,event,helper);
                    }
                }else{
                    this.continuCreaAppuntamento1(component,event,helper);
                }
                
            }
            else {
                console.log('### isbranch', JSON.stringify(response.getReturnValue()));
            }
        });
        $A.enqueueAction(action);
    },
    continuCreaAppuntamento1: function (component,event,helper){
        var filialeId = component.get("v.filialeId");
        var newActivity = component.get("v.newEvent");
        var cliente = component.get("v.cliente");
        var phone1 = component.get("v.cliente.Phone");
        var telefonoCellulare = newActivity.Telefono_Cellulare__c;
        component.set("v.showStep2", false);
        
       
        if (!phone1 && !telefonoCellulare) {
            component.set("v.showErrorMessagePhone", true);
            component.set("v.showErrorMessageCellulare", true);
            this.showToast("Errore del numero di telefono inserito", "error");
        } else if(((phone1.length < 5 || phone1[0] !== '0')&&(telefonoCellulare.length >=6 && telefonoCellulare[0] == '3'))
               ||((phone1.length >= 5 && phone1[0] == '0')&&(telefonoCellulare.length <6 || telefonoCellulare[0] !== '3'))){
            
             if(filialeId!=""){
            component.set("v.showStep3", true);
            component.set("v.showStep2", false);
            component.set("v.showStep1", false);
            this.getFilialeById(component,event,helper);
            var filialeAppunta = component.get("v.filialeAppunta");            
             }else {
                 this.getValueCliente(component, newActivity, cliente);
                component.set("v.showStep2", true);
            	component.set("v.showStep1", false);
             }
        } else if((phone1.length >= 5 && phone1[0] == '0')&&(telefonoCellulare.length >=6 && telefonoCellulare[0] == '3'))
        {
            if(filialeId!=""){
            component.set("v.showStep3", true);
            component.set("v.showStep2", false);
            component.set("v.showStep1", false);
            this.getFilialeById(component,event,helper);
            var filialeAppunta = component.get("v.filialeAppunta");            
            }else{
                this.getValueCliente(component, newActivity, cliente);
            	component.set("v.showStep2", true);
            	component.set("v.showStep1", false);
            }
        } 
        else{
            component.set("v.showErrorMessagePhone", true);
            component.set("v.showErrorMessageCellulare", true);
            this.showToast("Errore del numero di telefono inserito", "error");
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
    continuCreaAppuntamento2: function (component) {
        var newEvent = component.get("v.newEvent");
        if(newEvent.DurationInMinutes!==null){
            component.set("v.recapitulate", true);
            component.set("v.showStep3", false);
        }else {
            this.showToast('inserisci la durata','warning');
        }
        
    },
    continuCreaAppuntamento3: function (component,event,helper) {
        var newEvent = component.get("v.newEvent");
        var cliente = component.get("v.cliente");
		var filialeEvent=component.get("v.filialeEvent");
        var action = component.get('c.createEvent'); 
        var timeEvent = component.get('v.timeEvent');
        var filialeAppunta = component.get("v.filialeAppunta");
        var filialeId = component.get('v.filialeId');
        var filialeName;
        var resultat;
        if(filialeId!=""){
            filialeName=filialeAppunta.Name;
        }else{
            filialeName=filialeEvent.ele_text;
        }
        newEvent.Dati_aggiuntivi__c='not available';
        action.setParams({ "event": newEvent ,
                           "account": cliente,
                           "filialeName":filialeName,
                          "timeEvent":timeEvent,
                           "slotMap":component.get('v.deskLots')
                        }); 
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                resultat = response.getReturnValue();
                console.log('### newEvent ', resultat.newEvent);
                console.log('### resultat ', JSON.stringify(resultat));
                if (resultat) {
                    if(resultat.existCLiente==true){
                        this.showToast("il cliente ha già un appuntamento futuro non Annullato","error");
                        //this.showToast(resultat.messageExistClient,"error");
                        component.set('v.openmodel',false);
                    }else if(resultat.disponibilita==false){
                        this.showToast("Desk non è disponibile","error");
                        component.set('v.openmodel',false);
                    }else if(resultat.calenarExist==false){
                        this.showToast("Calendar "+resultat.calenarName+" non è disponibile","error");
                    }else if(resultat.erreur==false){
                        this.showToast("appuntamento salvato con successo","success");
                         component.set('v.openmodel',false);
                        this.callEvent(component,event,resultat.newEvent);
                        component.set("v.closeButtonRecap",false);
                        //this.fireRefresh(component, event, helper);
                    }else{
                        this.showToast("Non é possibile fissare un appuntamento","warning");
                    }
                } else {
                    alert("error");
                }
                //this.fireRefresh(component, event, helper);
            }
            else{
            console.log(response.getError());
            }
        });
        $A.enqueueAction(action); 
    },
    controlleActivityDate: function (component) {
        var dateActivity = component.get("v.newEvent.ActivityDateTime}");
        var validDate = Date.now() + 1;
        if (dateActivity < validDate){
            this.showToast("Invalid date", "error");
        }
    },
    getValueCliente: function(component) {
        var newActivity = component.get("v.newEvent");
        var cliente = component.get("v.cliente");
        var selectPI ;
        var selectDP ;
        var prodottoInteresse;
        var productDettaglio;
        var selectPN;
        var privinceNascita;
        var selectCN;
        var comuneNascita;
        var selectTO;
        var tipoOccupazione;
        var sesso;
        var existClient=component.get("v.existClient");
        	//get element prodotoo interesse
            selectPI = document.getElementById("prodottoInteresse");
            component.set("v.indexProdoto",selectPI.selectedIndex);
        	component.set("v.proDett",selectPI);
        	console.log('indexDettaglio '+component.get("v.indexProdoto"));
            if(selectPI.selectedIndex){
                prodottoInteresse = selectPI.options[selectPI.selectedIndex].value;
                var charProNameDesc = prodottoInteresse.split('/');
                console.log("prodottoInteresse "+charProNameDesc);
                newActivity.Product__c = charProNameDesc[0];
                component.set("v.nameDetaglioProdotto",charProNameDesc[1]);
                component.set('v.productExternal',charProNameDesc[2]);
                component.set("v.calculCodFis",true);
            }else{
                component.set("v.calculCodFis",false);
            }

            //get element detaglio prodotoo 
            selectDP = document.getElementById("ProductDettaglio");
            component.set("v.indexDettaglio",selectDP.selectedIndex);
            if(selectDP.selectedIndex){
                productDettaglio = selectDP.options[selectDP.selectedIndex].value;
                var charProNameDesc = productDettaglio.split('/');
                console.log("productDettaglio "+charProNameDesc);
                //component.set('v.newEvent.Product__c',charProNameDesc[0]);
                newActivity.Product__c = charProNameDesc[0];
                newActivity.Prodotto__c = charProNameDesc[1];
                component.set("v.nameProdotto",charProNameDesc[1]);
                component.set('v.parentExternal',charProNameDesc[2]);
                component.set("v.calculCodFis",true);
            }else{
                component.set("v.calculCodFis",false);
            }
            if(existClient==false){

           
            //get province 
            selectPN = document.getElementById("privinceNascita");
            if(selectPN.selectedIndex){
                privinceNascita = selectPN.options[selectPN.selectedIndex].value;
                cliente.Provincia_Nascita__pc = privinceNascita;
                component.set("v.calculCodFis",true);
            }else{
                if(selectPN.options[selectPN.selectedIndex].value==null){
                    this.showToast("completa tutti i campi obbligatori","error");
                	component.set("v.calculCodFis",false);
                }
                
            }
            //get comune 
            selectCN = document.getElementById("comuneNascita");
            if(selectCN.selectedIndex){
                comuneNascita = selectCN.options[selectCN.selectedIndex].value;
                var charProNameDesc = comuneNascita.split('/');
                component.set('v.catastale',charProNameDesc[0]);
                component.set("v.calculCodFis",true);
                cliente.Luogo_Nascita__pc = charProNameDesc[1];
            }else{
                if(selectCN.options[selectPN.selectedIndex].value==null){
                	this.showToast("completa tutti i campi obbligatori","error");
                	component.set("v.calculCodFis",false);
                }
            }
        }
            //get tipoOccupazione
            selectTO = document.getElementById("tipoOccupazione");
            if(selectTO.selectedIndex){
                tipoOccupazione = selectTO.options[selectTO.selectedIndex].value;
                newActivity.Tipo_Occupazione__c = tipoOccupazione;
            }else{
                
            }
            //get sesso 
            sesso = component.get("v.sesso");
            if(sesso){
                cliente.Sesso__pc = sesso;
                component.set("v.calculCodFis",true);
            }else{
                component.set("v.calculCodFis",false);
            }

            component.set('v.cliente',cliente);
            //show instance Activity
            console.log("Activity " + JSON.stringify(newActivity));
            this.getValueFotocopieAllegare(component);
    },
    controlDateNascita :function(component,event,helper){
        var dateNasc = component.get("v.cliente.Data_Nascita__c");
        var resultat;
        
        var action = component.get('c.controlDateNascitaCliente'); 
        action.setParams({ "dateNascita": dateNasc}); 
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                resultat = response.getReturnValue();
                if (resultat.validDate==true) {
                    component.set('v.inValidDateNascita',false);
                } else {
                    component.set('v.inValidDateNascita',true);
                    component.set('v.cliente.Codice_Fiscale__pc','');
                }
                component.set('v.testCondition',false);
                document.getElementById("idConfermaClient").disabled = true;
            }
            else{
            console.log(response.getError());
            }
        });
        $A.enqueueAction(action);
    },
    controldateEvent : function(component,event,helper){
        var dateEvent=component.get("v.newEvent.ActivityDate");
        var dateNow= new Date;
        var today =dateNow.getDate();
        var dateparseEven = Date.parse(dateEvent);
        var dateparsenow = Date.parse(today);
        
        //var minutes=dateparseEven.getMinutes();
        //console.log('minutes '+minutes);
        console.log(dateparseEven+'/'+dateparsenow);
            if(dateparseEven < dateparsenow){
                this.showToast("la data scelta non è valida", "error");
                document.getElementById("continuCA3").disabled = true;
            }else{
                this.controleMinutesAndHoure(component);
            }
    },
    checkDate : function(component,dateEvent){
        var action = component.get('c.controlleDateEvent'); 
        var resultat;
        var existDate=true;
        action.setParams({ "activityDate": dateEvent}); 
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                resultat = response.getReturnValue();
                console.log('### resultat ', dateEvent+'/'+JSON.stringify(resultat));
                existDate=resultat.existDate;
                if (existDate===true) {
                    document.getElementById("continuCA3").disabled = true;
                    this.showToast("la data esiste già","error");
                } else {
                    document.getElementById("continuCA3").disabled = false;
                }
            }
            else{
            console.log(response.getError());
            }
        });
        $A.enqueueAction(action); 
    },
    
    controleMinutesAndHoure : function (component){
        var dateEvent=component.get("v.newEvent.ActivityDate");
        var filialeEvent=component.get("v.filialeEvent");
        var action = component.get('c.controleDateEvent'); 
        var resultat;
        var listTimes;
        var listHour=[];
        var filialeAppunta = component.get("v.filialeAppunta");
        var filialeId = component.get('v.filialeId');
        var filialeName;
        if(filialeId!=""){
            filialeName=filialeAppunta.Name;
        }else{
            filialeName=filialeEvent.ele_text;
        }
        component.set('v.shoxListTime',false);
        action.setParams({"dateAppuntamento": dateEvent,
                          "filialeName":filialeName}); 
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                resultat = response.getReturnValue();
                console.log('### resultat ', dateEvent+'/'+JSON.stringify(resultat));
                document.getElementById("continuCA3").disabled = true;
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
                        component.set('v.shoxListTime',true);
                        console.log(' ############ resultat.slotDesk '+JSON.stringify(resultat.slotDesk));
                        component.set('v.deskLots',resultat.slotDesk);
                        
                    }else {
                        this.showToast("Non é possibile fissare un appuntamento","error");
                        component.set('v.shoxListTime',false);
                    }
                } else{
                    this.showToast("error apex","error");
                }
            }
            else{
                alert('error');
            console.log(response.getError());
            }
        });
        $A.enqueueAction(action); 
    },
    choiceHoure : function (component,event,helper){
    	var timeEvent = document.getElementById("idListTime");
        var valtime = timeEvent.options[timeEvent.selectedIndex].value;
        component.set('v.timeEvent',valtime);
        console.log('timeEvent '+valtime);
        document.getElementById("continuCA3").disabled = false;
	},
    fireRefresh : function (component, event, helper) {
        component.set('v.showStep1',true);
        component.set('v.inValidDateNascita',false);
        component.set('v.showStep2',false);
        component.set('v.showStep3',false);
        component.set('v.recapitulate',false);
    },
    callEvent : function (component,event,newEvent){
        var cmpEvent = $A.get("e.c:EventToCreaAppuntamento"); 
        cmpEvent.setParams({
            "appuntamento": newEvent,
            "nameDetaglioProdotto":component.get('v.nameDetaglioProdotto')
        });
        cmpEvent.fire();
    },
    getFilialeById : function(component,event,helper){
        var idFiliale =component.get('v.filialeId'); 
        var action = component.get('c.getFilialeById'); 
        var resultat;
        console.log('idFiliale '+idFiliale);
        action.setParams({ "idFiliale": idFiliale}); 
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                resultat = response.getReturnValue();
                console.log('### resultat ', JSON.stringify(resultat));
                if (resultat) {
                    if(resultat.erreur==false){
                        component.set("v.filialeAppunta",resultat.result);
                    }else{
                    }
                } else {
                }
            }
            else{
            console.log(response.getError());
            }
        });
        $A.enqueueAction(action); 
    },
    resetValueProdotto : function(component,event,helper){
        var indexDettaglio=  component.get("v.indexDettaglio");
        var valSlect= component.get("v.proDett");
        	console.log('indexDettaglio '+indexDettaglio);
            //alert('newEvent :'+component.get('v.newEvent').Prodotto__c);
            //('valSlect :'+valSlect);
        var test=valSlect.options[indexDettaglio].selectedOptions;
    },
    checkDisponibleDesk : function(component,eventSelectecd){
        component.set("v.filialeEvent",eventSelectecd);
        var filialeId =component.get('v.filialeId'); 
        var filialeEvent=component.get("v.filialeEvent");     
        var filialeAppunta = component.get("v.filialeAppunta");
        var idCliente= component.get("v.idCliente");
        var filialeName;
        var resultat;
        if(filialeId!=""){
            filialeName=filialeAppunta.Name;
        }else{
            filialeName=filialeEvent.ele_text;
        }
        var action = component.get('c.chekDisponibleDeskByFiliale'); 
        action.setParams({ "filialeName": filialeName,"idclient":idCliente}); 
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                resultat = response.getReturnValue();
                console.log('### resultat ', JSON.stringify(resultat));
                if (resultat) {
                    if(resultat.erreur==false){
                        if(resultat.deskDisponible==true){
                            if(resultat.eventClientExist){
                                if(resultat.modificaEvent){
                                    this.openmodelModificaEvent(component,resultat.eventToModifi);
                                    component.set('v.eventAModifica',resultat.eventToModifi);
                                }else{
                                    this.openErrorMessage(component,resultat.messageExistClient);
                                    component.set('v.messageModifica',resultat.messageExistClient);
                                }
                            }else{
                                component.set("v.showStep2",false);
                                component.set("v.showStep3",true);
                            }
                        }else{
                            this.showToast('la filiale non ha desk disponibile','error');
                        }
                    }else{
                        console.log('error ');                   }
                } else {
                }
            }
            else{
            console.log(response.getError());
            }
        });
        $A.enqueueAction(action); 
    },
    openmodelModificaEvent : function(component,eventM){
        component.set("v.openmodelModifica",true);
        var cmpEvent = $A.get("e.c:EventToDetail"); 
        cmpEvent.setParams({
            "newEvent": eventM
        });
        console.log("cmpEvent.getSourceEvent");
        cmpEvent.fire();
    },
    closeModifica : function(component){
        component.set("v.openmodelModifica",false);
    },
    openErrorMessage: function(component,message){
        component.set('v.alertMessage',true);
        component.set('v.messageError',message);
    },
    getValueFotocopieAllegare : function(component){
        var labelFotocopoAllegaro='';
        var parentProduct= component.get('v.DataglioProductValues');
        var newEvent= component.get("v.newEvent");
        var productExternal= component.get('v.productExternal');
        var parentExternal= component.get('v.parentExternal');
        console.log(' external '+productExternal+' ///// '+parentExternal);
        if(productExternal!=null){
            if(productExternal=='1079'){
                labelFotocopoAllegaro='nessun documento richiesto';
            }else{
                labelFotocopoAllegaro='Documento di riconoscimento \nTessera sanitaria\nPermesso di soggiorno(se sei cittadino extra UE)';
                if(newEvent.Tipo_Occupazione__c=='Autonomo'){
                    labelFotocopoAllegaro=labelFotocopoAllegaro+'\nUltimo modello Unico con ricevuta elettronica di presentazione';
                }else if(newEvent.Tipo_Occupazione__c=='Dipendente'){
                    labelFotocopoAllegaro=labelFotocopoAllegaro+'\nUltima Busta Paga';
                }else if(newEvent.Tipo_Occupazione__c=='Pensionato'){
                    labelFotocopoAllegaro=labelFotocopoAllegaro+'\nUltimo documento attestante reddito da pensione';
                }else if(newEvent.Tipo_Occupazione__c=='Altro'){
                    if((parentExternal!=null)&&(parentExternal!='1079')){
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