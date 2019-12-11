({
    doInit : function(component) {
        console.log("INIZIO DO INIT");
//
//        console.log('idCase -> '+ idCase);
        this.showSpinner(component);
        var idr = component.get('v.recordId');
        var action = component.get("c.getActivity");

        action.setParams({
            idCase: idr
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
       
            if (state === "SUCCESS") {
                console.log('state -> '+ state);
                component.set("v.selectedActivity", response.getReturnValue());
                console.log('selectedActivity -> ' + component.get('v.selectedActivity[0].Categoria__c'));
                console.log('selected -> ' + component.get('v.selectedActivity[0].Activity_id__c'));
                console.log('selectedDueDate -> ' + component.get('v.selectedActivity[0].Activity_id__r.DueDate__c'));
                var tipoProdotto = component.get('v.selectedActivity[0].Tipo_prodotto__c');
                var sCategoria = component.get('v.selectedActivity[0].Categoria__c');
                var testoNotaS = component.get('v.selectedActivity[0].Nota_sospesa__c');
                var testoNotaC = component.get('v.selectedActivity[0].Nota_compass__c');
                var globalNota = testoNotaC;
                console.log('tipo prodotto -> ' + tipoProdotto);
                console.log('global nota -> ' + globalNota);
                component.set('v.vNota',globalNota);
//                testoNotaS = testoNotaS.replace("<br/>","");
                component.set('v.sNota',testoNotaS);

                var q1 = component.get('v.selectedActivity[0].question1__c');
                var q2 = component.get('v.selectedActivity[0].question2__c');
                var q3 = component.get('v.selectedActivity[0].question3__c');
				var b=sCategoria.includes('IRREPERIBILIT');
				if(b==true){
                    console.log('irreper');
                    console.log(q1);
                    console.log(q2);
                    console.log(q3);
                    component.set('v.categoria',true);
                    component.set('v.question1Value',q1);
                    component.set('v.question2Value',q2);
                    component.set('v.question3Value',q3);
				}else{
                    var i=sCategoria.includes('INADEMPIMENTO');
                    if(i==true){
                        component.set('v.inadempimento',true);
                    }
					component.set('v.categoria',false);
				}
                console.log(tipoProdotto);
                switch(tipoProdotto){
                    case 'PP':
                        component.set('v.tipoPAPF',false);
                        component.set('v.tipoPP',true);
                        component.set('v.tipoCARTA',false);
                        component.set('v.tipoVA',false);
                        break;
                    case 'PAPF':
                        component.set('v.tipoPAPF',true);
                        component.set('v.tipoPP',false);
                        component.set('v.tipoCARTA',false);
                        component.set('v.tipoVA',false);
                        break;
                    case 'CONSUMO':
                        component.set('v.tipoPAPF',false);
                        component.set('v.tipoPP',false);
                        component.set('v.tipoCARTA',false);
                        component.set('v.tipoVA',true);
                        break;
                    case 'CARTA':
                        component.set('v.tipoPAPF',false);
                        component.set('v.tipoPP',false);
                        component.set('v.tipoCARTA',true);
                        component.set('v.tipoVA',false);
                        break;
                }
                this.recDatiCarta(component,component.get('v.selectedActivity[0].Num_Pratica__c'));
                this.recDatiPratica(component,component.get('v.selectedActivity[0].Num_Pratica__c'));
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

        console.log('DO USER');
        
        this.showSpinner(component);
        var action = component.get("c.getUserMap");
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('state doUser ->'+ state);
                component.set("v.mapUser", response.getReturnValue());
                var mappa = component.get('v.mapUser');

                component.set('v.userId',mappa.idUser);
                component.set('v.userProfile',mappa.Profile);
                component.set('v.userFiliale',mappa.Filiale);
                var vProfile = component.get('v.userProfile');
            
// DA ATTIVARE QUANDO SONO PRONTI I PROFILI FABIO
//                if (vProfile=='Branch Employee'||vProfile=='Branch Manager'){
//                    component.set('v.userIsBO', false);
//                }else if(vProfile=='BackOffice'){
//                    component.set('v.userIsBO', true);
//                }
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

    
    recDatiPratica : function(component, numPratica) {
        console.log("---------------------------------------------------");
        console.log("--recDatiPratica --");
        this.showSpinner(component);
        var action = component.get("c.getDatiPratica");

        action.setParams({
            numPratica: numPratica
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
       
            if (state === "SUCCESS") {
                component.set("v.recDatiPratica", response.getReturnValue());
                console.log(component.get('v.recDatiPratica'));
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

    recDatiCarta : function(component, numPratica) {
        console.log("---------------------------------------------------");
        console.log("--recDatiCarta --");
        this.showSpinner(component);
        var action = component.get("c.getDatiCarta");

        action.setParams({
            numPratica: numPratica
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
       
            if (state === "SUCCESS") {
                component.set("v.recDatiCarta", response.getReturnValue());
                console.log(component.get('v.recDatiCarta'));
            }
            else if (state === 'ERROR') {
//                alert('errore');
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

    handleSospendi : function(component, event){
        console.log('-------------------------------------------------------');
        console.log('-- Controller JS: SFACommodity_GestioneHelper - Method: handleSospendi');         

        var action = component.get("c.getSospendi");

        var notaSospesa = component.get('v.sNota'); 
        var q1 = component.get('v.question1Value');
        var q2 = component.get('v.question2Value');
        var q3 = component.get('v.question3Value');

//        var b = component.get('v.categoria');


//        alert('q1-> '+ q1);
//        alert('q2-> '+ q2);
//        alert('q3-> '+ q3);
        alert('nota-> '+notaSospesa);
//        alert('b-> '+b);


// CONTROLLI
        if(!notaSospesa){
            component.set('v.msg', "Inserire una nota per sospendere l'attivita");
            this.showErrorToast(component);
            return;
        }

        action.setParams({ 
            idCase : component.get("v.selectedActivity[0].Activity_id__c"),
            notaSospesa : notaSospesa,
            q1 : q1,
            q2 : q2,
            q3 : q3
        });
        
        action.setCallback(this, function(resp) {
            if(resp.getState()=='SUCCESS'){
                component.set("v.elencoFile",resp.getReturnValue());
                component.set("v.refresh", false);
                component.set("v.refresh", true);
                var dismiss = $A.get("e.force:closeQuickAction");
                dismiss.fire();
//                $A.get("e.force:refreshView").fire();
            }
        });
        $A.enqueueAction(action);
    },

    handleCompleta : function(component, event){
        console.log('-------------------------------------------------------');
        console.log('-- Controller JS: SFACommodity_GestioneHelper - Method: handleCompleta');         

        var action = component.get("c.getCompleta");

        var nota = component.get('v.sNota'); 
        var q1 = component.get('v.question1Value');
        var q2 = component.get('v.question2Value');
        var q3 = component.get('v.question3Value');

        var b = component.get('v.categoria');


//        alert('q1-> '+ q1);
//        alert('q2-> '+ q2);
//        alert('q3-> '+ q3);
//        alert('nota-> '+notaSospesa);
//        alert('b-> '+b);


// CONTROLLI
        if(!nota){
            component.set('v.msg', "Inserire una nota");
            this.showErrorToast(component);
            return;
        }

        if(b){
            if(!q1){
                component.set('v.msg', "Rispondere alla domanda: Siete riusciti a contattare il cliente?");
                this.showErrorToast(component);
                return;
            }else if(!q2){
                component.set('v.msg', "Rispondere alla domanda: Su quale telefono è stato contattato il cliente?");
                this.showErrorToast(component);
                return;

            }else if(!q3){
                component.set('v.msg', "Rispondere alla domanda: E' stato inserito un nuovo recapito utile?");
                this.showErrorToast(component);
                return;
            }
        }

        action.setParams({ 
            idCase : component.get("v.selectedActivity[0].Activity_id__c"),
            nota : nota,
            q1 : q1,
            q2 : q2,
            q3 : q3
        });
        
        action.setCallback(this, function(resp) {
            if(resp.getState()=='SUCCESS'){
                component.set("v.refresh", false);
                component.set("v.refresh", true);
                $A.get("e.force:refreshView").fire();
            }
        });
        $A.enqueueAction(action);
    },


    handleUploadFinished : function(component, event){
        console.log('-------------------------------------------------------');
        console.log('-- Controller JS: SFACommodity_GestioneHelper - Method: handleUploadFinished');         

        var uploadedFiles = event.getParam("files");
        var documentId = uploadedFiles[0].documentId;
        var fileName = uploadedFiles[0].name;
        var descAll = component.get('v.descAll');
        console.log('uploadedFiles'+uploadedFiles);
        console.log('documentId'+documentId);
        console.log('fileName'+fileName);
        console.log('descAll'+descAll);

        if (descAll!=null && descAll!="" && descAll!=undefined){
            var action = component.get("c.finishUploadFile");
            action.setParams({ 
    //            recordId : component.get("v.recordId"),
                recordId : component.get("v.selectedActivity[0].Activity_id__c"),
    //            recordId : "5005E000005Vd3yQAC",
                documentId: documentId,
                nameFile : fileName,
                Descr : descAll
            });
            
            action.setCallback(this, function(resp) {
                if(resp.getState()=='SUCCESS'){
                    component.set("v.elencoFile",resp.getReturnValue());
                    component.set("v.refresh", false);
                    component.set("v.refresh", true);
                    $A.get("e.force:refreshView").fire();
                }
            });
            $A.enqueueAction(action);
        }else{
            component.set('v.msg', "Inserire descrizione Allegato");
            this.showErrorToast(component);
            console.log('Document ID: ' +documentId);
            var action = component.get("c.Attachment");
            action.setParams({
//                DownloadAttachmentID: id,
                DownloadAttachmentID: documentId,
                s : 'C'
            });
            action.setCallback(this, function(b){
                console.log('b.getState -> ' + b.getState());
                if(b.getState()=='SUCCESS'){
                    console.log('passo di qui');
                    component.set("v.refresh", false);
                    component.set("v.refresh", true);
                }
            });
            $A.enqueueAction(action);
        }
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
        console.log('-- Controller JS: SFACommodity_GestioneHelper - Method: handleCancellaFile');         

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
    },
    handleGetFile : function(component, event, sCaseId){
        console.log('-------------------------------------------------------');
        console.log('-- Controller JS: SFACommodity_GestioneHelper - Method: handleGetFile');         
        
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
    }    

})