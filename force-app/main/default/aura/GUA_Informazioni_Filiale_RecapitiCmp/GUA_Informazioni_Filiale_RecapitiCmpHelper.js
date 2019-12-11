({
    handleManageContact: function(component, event, helper) {
        console.log('message ################' + JSON.stringify(component.get('v.filiale')));
    },
    actionUltimeChiama: function(component, event, helper) {

    },
    actionComponenti: function(component, event, helper) {

    },
    actionFaq: function(component, event, helper) {

    },
    closeModel: function(component, event, helper) {
        component.set('v.isOpenModel', false);
        component.set('v.showDetailFiliale', false);
        console.log('closed++++++++ '+ component.get('v.showDetailFiliale'));
    },
    cercaFiliale: function(component, event, helper) {
        component.set('v.listFiliales', '');
        var valueNameCF = component.get('v.valueCerca');
        var action = component.get('c.getFilialeByNameOrCodiceFiliale');
        var resultat;
        action.setParams({ "valueNameCF": valueNameCF });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                resultat = response.getReturnValue();
                console.log('resultat ' + JSON.stringify(resultat));
                if (!resultat.erreur) {
                    component.set('v.listFiliales', resultat.resultat);
                } else {
                    console.log('message', "Error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    filialeSelected: function(component, event, helper) {
        var fSelected = event.getSource().get('v.value');
        console.log('message' + JSON.stringify(fSelected));
        component.set("v.filiale", fSelected);
        if(fSelected.hasOwnProperty('Cases')){
            var caseObject = fSelected.Cases[0];
            component.set('v.caseObject',caseObject);
        }
        component.set('v.isOpenModel', false);
    },
    getUtente: function(component, event, helper) {
        //component.set('v.showUtenzaPasscom', true);
        var action = component.get('c.getRecuperaUtenzeIntermediario');
        var resultat;
        var codiceIntermediario = '60757';
        var codiceUtenza = '';
        action.setParams({
            "codiceIntermediario": codiceIntermediario,
            "codiceUtenza": codiceUtenza
        });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                resultat = response.getReturnValue();
                console.log('resultat ' + JSON.stringify(resultat));
                if (!resultat.erreur) {
                    component.set('v.userDealerList', resultat.resultat);
                } else {
                    console.log('message', "Error");
                }
            }
        });
        $A.enqueueAction(action);
    },

})