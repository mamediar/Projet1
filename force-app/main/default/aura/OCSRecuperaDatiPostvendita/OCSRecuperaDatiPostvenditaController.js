//----------------------------------------------------------------------
//-- - Controller JS Name : OCSRecuperaDatiPostVenditaController
//-- - Autor              : 
//-- - Date               : 05/06/2019
//-- - Description        : 
//-- - Version            : 1.0
//----------------------------------------------------------------------
({
    init:function(cmp,event,helper){
		console.log('--------------------------------------------------------------------------------------');
		console.log('-- Controller(init) JS: OCSRecuperaDatiPostVenditaController'); 
        
        //helper.checkField(cmp,event,helper);

        if(cmp.get('v.inputAccountId')){
            var action=cmp.get('c.getInputAccountOCSId');
            action.setParam('accountId',cmp.get('v.inputAccountId'));
            action.setCallback(this,function(resp){
                var state = resp.getState();
                if(resp.getState()=='SUCCESS'){
                    var results = resp.getReturnValue();
                    cmp.set('v.codCliente',results);
                    helper.doRicercaHelper(cmp,event,helper);
                    
                }
                else if (state == "ERROR") { 
                    var errors = response.getError(); 
                }
                 helper.hideSpinner(cmp);
            });
            helper.showSpinner(cmp);
            $A.enqueueAction(action);
        }
    },
    
    doRicerca:function(cmp,event,helper){
		console.log('--------------------------------------------------------------------------------------');
		console.log('-- Controller JS: OCSRecuperaDatiPostVenditaController - Method:doRicerca'); 
        
        var allValid = cmp.find("fieldToCheck").reduce(function (validFields,inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validFields && inputCmp.get('v.validity').valid;
        }, true);

        if(allValid){
            helper.doRicercaHelper(cmp,event,helper);
        }else{
            cmp.set("v.toastMsg", "Verifica la corretezza dei campi inseriti");
            helper.showToastError(cmp);
        }
        
    },
    
    selectCliente:function(cmp,event,helper){
        console.log("**** selectCliente *** PV:" + cmp.get("v.isPostVendita")+ 'SPratiche:'+cmp.get("v.showPratiche"));
        var selRow=event.getParam('selectedRows')[0];
        
        if(cmp.get("v.isPostVendita")){
            //setto oggetto cliente con il cliente selezionato e ne ricerco le pratiche (se il PV lo richiede)
        	cmp.set('v.OCSClienteSelezionato',selRow);
            console.log('MO BESTEMMIO: '+cmp.get("v.showPratiche"))
            if(cmp.get("v.showPratiche")){
                helper.getPratiche(cmp,selRow,helper);
            }
        }else{
        	helper.getPratiche(cmp,selRow,helper);    
        }
    },

    selectPratica:function(cmp,event,helper){
        cmp.set('v.praticaSelezionata',event.getParam('selectedRows')[0]);
        console.log('v.praticaSelezionata'+ JSON.stringify(cmp.get('v.praticaSelezionata')));
       // console.log('pratica id selezionata l : ' + JSON.stringify(cmp.get("v.praticaSelezionataId")));
    },
    
/*    itemsChange: function(cmp, evt) {
        console.log("numItems has changed");
        console.log("old value: " + evt.getParam("oldValue"));
        console.log("current value: " + JSON.stringify(evt.getParam("value")));
    },
*/    

    checkLength:function(cmp,event,helper){
        helper.checkLengthField(cmp,event,helper);
    },

    annulla:function(cmp,event,helper){
        //stepInserimentoCliente==4 (go back to riepilogo cliente)
        var reclamo = cmp.get('v.reclamoSelezionato');
        var step = cmp.get('v.stepInserimentoCliente');
        var numReclamo = cmp.get('v.numeroReclamo');

        var praticaSelezionata = cmp.get('v.praticaSelezionata');
        var infoPraticaSelezionata = cmp.get('v.infoPraticaSelezionata');
        var showCambiaProdotto = cmp.get('v.showCambiaProdotto');
        var filiale = cmp.get('v.filiale');
        console.log('reclamo: '+reclamo);
        console.log('step: '+step);
        console.log('step: '+numReclamo);

        console.log('praticaSelezionata: '+praticaSelezionata);
        console.log('infoPraticaSelezionata: '+infoPraticaSelezionata);
        console.log('showCambiaProdotto: '+showCambiaProdotto);
        console.log('filiale: '+filiale);

        cmp.set('v.stepInserimentoCliente',4);
        $A.get('e.force:refreshView').fire();
    }

    
 

})

/*
praticaSelezionata="{!v.praticaSelezionata}"
infoPraticaSelezionata="{!v.infoPraticaSelezionata}"
showCambiaProdotto="{!v.showCambiaProdotto}"
filiale="{!v.filiale}"
*/