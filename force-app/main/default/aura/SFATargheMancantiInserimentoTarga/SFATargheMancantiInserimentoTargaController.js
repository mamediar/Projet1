({
	doInit : function(component, event, helper) {
        helper.initPageReference(component, event);
        helper.callGetDateScadenza(component, event);
    },
    
    handleCompletaPratica: function(component, event, helper) {

        var casisticaScadenza = component.get("v.casisticaScadenza");

        var targa = component.get("v.targa");
        var telaio = component.get("v.telaio");
        var notaFiliale = component.get("v.notaFiliale");
        var numeroPratica = parseInt(component.get("v.numeroPratica"));
        var praticaId = component.get("v.recordId");

        var formato2L3N2L = new RegExp("^[a-zA-Z]{2}[0-9]{3}[a-zA-Z]{2}$");
        var formato2L5N = new RegExp("^[a-zA-Z]{2}[0-9]{5}$");

        if (casisticaScadenza == 1) {

            if (formato2L3N2L.test(targa) || formato2L5N.test(targa) ) {

                if (!telaio || (telaio && (telaio.length == 0 || telaio.length == 17))) {
                    var action = component.get("c.callAggiornaDati");

                    action.setParams({
                    numeroPratica: numeroPratica,
                    targa: targa,
                    telaio: telaio,
                    marca: null,
                    modello: null,
                    cilindrata: null, 
                    dataImmatricolazione: null
                    });

                    action.setCallback(this, function(response){
                        if (response.getState() == 'SUCCESS'){
                            var res = response.getReturnValue();
                            if (res.resultCode == 0 && res.resultMessage == "Ok") {
                                var completaPraticaAction = component.get("c.completaPratica");

                                completaPraticaAction.setParams({
                                praticaId: praticaId,
                                targa: targa,
                                telaio: telaio, 
                                notaFiliale: notaFiliale
                                });

                                completaPraticaAction.setCallback(this, function(response){
                                    if (response.getState() == 'SUCCESS'){
                                        helper.goToListaCase(component, event);
                                        helper.showToastOK(component, event, helper);
                                    }
                                });

                                $A.enqueueAction(completaPraticaAction);

                            }
                            else {
                                helper.showToastKO(component, event, helper, "webservice");
                            }
                        }
                    });

                    $A.enqueueAction(action);
                }
                else {
                    helper.showToastKO(component, event, helper, "telaio");
                }
            }
            else {
                helper.showToastKO(component, event, helper, "targa");
            }
        }

        else if (casisticaScadenza == 2) {

            if (notaFiliale && (formato2L3N2L.test(targa) || formato2L5N.test(targa)) ) {

                if (!telaio || (telaio && (telaio.length == 0 || telaio.length == 17))) {

                    var completaPratica2Action = component.get("c.completaPraticaEntroScadenziario");

                    completaPratica2Action.setParams({
                    praticaId: praticaId,
                    targa: targa,
                    telaio: telaio, 
                    notaFiliale: notaFiliale
                    });

                    completaPratica2Action.setCallback(this, function(response){
                        if (response.getState() == 'SUCCESS'){
                            helper.goToListaCase(component, event);
                            helper.showToastOK(component, event, helper);
                        }
                    });

                    $A.enqueueAction(completaPratica2Action);

                }
                else {
                    helper.showToastKO(component, event, helper, "telaio");
                }

            }
            else {
                helper.showToastKO(component, event, helper, "targaNote");
            }
        }

        else if (casisticaScadenza == 3) {

            if (notaFiliale && (formato2L3N2L.test(targa) || formato2L5N.test(targa)) ) {

                if (!telaio || (telaio && (telaio.length == 0 || telaio.length == 17))) {

                    var completaPratica3Action = component.get("c.completaPraticaDopoScadenziario");

                    completaPratica3Action.setParams({
                    praticaId: praticaId,
                    targa: targa,
                    telaio: telaio, 
                    notaFiliale: notaFiliale
                    });

                    completaPratica3Action.setCallback(this, function(response){
                        if (response.getState() == 'SUCCESS'){
                            helper.goToListaCase(component, event);
                            helper.showToastOK(component, event, helper);
                        }
                    });

                    $A.enqueueAction(completaPratica3Action);

                }
                else {
                    helper.showToastKO(component, event, helper, "telaio");
                }

            }
            else {
                helper.showToastKO(component, event, helper, "targaNote");
            }
        }
    }
})