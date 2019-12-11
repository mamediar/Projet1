({
    getCase: function(component, event, helper) {
        var recordId = component.get('v.recordId');
        console.log('recordId >>', JSON.stringify(recordId));
        var action = component.get('c.getCase');
        action.setParams({ "idCase": recordId });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var result = response.getReturnValue();
                console.log('result >>', result);
                if (!result.erreur) {
                    component.set('v.case', result.case);
                } else {
                    console.log('message', "Error");
                }
            }
        });
        $A.enqueueAction(action);
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