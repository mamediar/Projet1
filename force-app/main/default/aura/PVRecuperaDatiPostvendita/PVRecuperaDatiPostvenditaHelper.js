/**
 * @File Name          : PVRecuperaDatiPostvenditaHelper.js
 * @Description        : 
 * @Author             : Andrea Vanelli
 * @Group              : 
 * @Last Modified By   : Andrea Vanelli
 * @Last Modified On   : 13/8/2019, 13:30:07
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    12/8/2019, 16:51:58   Andrea Vanelli     Initial Version
**/
({
    doRicercaHelper: function (cmp, event, helper) {
 // AV TODO rimettere         cmp.get("v.parent").mostraClessidra();
        
        var paramList = ['v.cognomeCliente', 'v.nomeCliente', 'v.pan', 'v.codFiscaleCliente', 'v.codCliente', 'v.dataNascitaCliente', 'v.numPratica', 'v.filtroTipoPratica'];
        cmp.set('v.OCSClienti', null);
        cmp.set('v.praticheList', []);
        cmp.set('v.praticaSelezionata', null);
        //AV non sono sicuro servano...    
        cmp.set('v.idOCSClienteSelezionato', []);
        cmp.set('v.OCSClienteSelezionato', null);


        var paramMap = {};
        paramList.forEach(function (temp) {
            paramMap[temp.substring(2, temp.length)] = cmp.get(temp) != undefined ? cmp.get(temp) : '';
        });
        var action = cmp.get('c.getClienti');
        action.setParam('data', paramMap);
        action.setParam('filtroClassName', cmp.get('v.filtroClassName'));
//        action.setParam('filtroParametriMap', cmp.get('v.filtroParametriMap'));
//        console.log("xxx filtroParametriMap " + cmp.get('v.filtroParametriMap')); 

//cmp.get('v.filtroParametriMap')
/*
var filtri = component.get("v.filtroParametriMap"); 
            var filtriMaptoSend = [];
            for (filtro in filtri){
                console.log(Art);
            var temp =  filtri[filtro]
            for (keyofMap in temp){ 

                //pushing the articles into Map/ List of component attribute
                filtriMaptoSend.push({
                    key: keyofMap,
                    value: temp[keyofMap]
                });
            } 
            }
*/

var mapToSend = {};
mapToSend['filiale'] = "030";

console.log(JSON.stringify(mapToSend));
console.log(JSON.stringify(cmp.get('v.filtroParametriMap')));
mapToSend = cmp.get('v.filtroParametriMap');

action.setParam('filtroParametriMap', mapToSend);

        action.setCallback(this, function (resp) {
            //console.log("doRicerca - getClienti - resp.getState()" + resp.getState()); 
            if (resp.getState() == 'SUCCESS') {
                
                cmp.set('v.OCSClienti', resp.getReturnValue()['clienti']);
/*
                // AV TODO se devo processare i risultati (vedi filtraPratiche)
                devo richiamare un metodo estenro...
                vedi qua :
                var filtro=cmp.get('v.filtroPratiche');
                if(filtro!=undefined && filtro!=null && filtro!=''){
                    console.log("getPratiche con filtro pratiche attivo: " + filtro);
                    var action=cmp.get('c.filtraPratiche');
                    action.setParam('pratiche',JSON.stringify(praticheTemp));
                    action.setParam('filtroClass',filtro);
                    action.setCallback(this,function(resp){

                        // fine AV TODO
*/

                if (cmp.get('v.OCSClienti').length == 0) {
                    helper.setToast(cmp);
                }
                if (resp.getReturnValue()['clienti'].length == 1) {
                    var listSelId = [];
                    // preselezione dell'unico cliente della lista
                    listSelId.push(resp.getReturnValue()['clienti'][0]['codCliente']);
                    cmp.set('v.idOCSClienteSelezionato', listSelId);
                    //setto oggetto cliente con l'unico cliente estratto per utilizzarlo da parent
                    cmp.set('v.OCSClienteSelezionato', resp.getReturnValue()['clienti'][0]);
                    if (cmp.get("v.showPratiche")) {
                        cmp.set('v.praticheList', resp.getReturnValue()['clienti'][0]['pratiche']);
                        console.log("dati cliente = " + resp.getReturnValue()['clienti'][0])
                        //helper.getPratiche(cmp, resp.getReturnValue()['accounts'][0], helper);
                    }
                }
 // AV TODO rimettere                 cmp.get("v.parent").nascondiClessidra();

            }

        });
        $A.enqueueAction(action);
    },

    selectClienteHelper: function (cmp, event, helper) {
        if (cmp.get("v.showPratiche")) {
 // AV TODO rimettere           cmp.get("v.parent").mostraClessidra();

            cmp.set('v.praticheList', []);
            cmp.set('v.praticaSelezionata', null);

            var paramMap = {};
            paramMap['codCliente'] = cmp.get("v.idOCSClienteSelezionato");
            paramMap['filtroTipoPratica'] = cmp.get("v.filtroTipoPratica");

            var action = cmp.get('c.getClienti');
            action.setParam('data', paramMap);
            action.setCallback(this, function (resp) {
                //console.log("doRicerca - getClienti - resp.getState()" + resp.getState()); 
                if (resp.getState() == 'SUCCESS') {

                    if (resp.getReturnValue()['clienti'].length == 1) {

                        cmp.set('v.praticheList', resp.getReturnValue()['clienti'][0]['pratiche']);
                        console.log("dati cliente = " + resp.getReturnValue()['clienti'][0])
                        //helper.getPratiche(cmp, resp.getReturnValue()['accounts'][0], helper);

                    } else {
                        // non dovrebbe mai arrivare qua
                        helper.setToast(cmp);
                    }

                }
 // AV TODO rimettere              cmp.get("v.parent").nascondiClessidra();

            });
            $A.enqueueAction(action);
        }


    },



    setToast: function (cmp, event, helper) {
        var toast = $A.get('e.force:showToast');
        toast.setParams({
            title: 'La ricerca non ha prodotto alcun risultato',
            type: 'error',
            message: ' '
        });
        toast.fire();
    }
})