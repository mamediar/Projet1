({
    utenzaPasscom: function(component, event, helper) {
        component.set("v.showUtenzaPasscom", true);
        var action = component.get("c.getRecuperaUtenzeIntermediario");
        var resultat;
        var codiceIntermediario = component.get("v.contactDetails.CodiceDealer__c");
        console.log("codiceIntermediario " + codiceIntermediario);
        var codiceUtenza = "";
        action.setParams({
          codiceIntermediario: '60757',
          codiceUtenza: codiceUtenza
        });
        action.setCallback(this, function(response) {
          if (response.getState() === "SUCCESS") {
            resultat = response.getReturnValue();
            console.log("resultat " + JSON.stringify(resultat));
            if (!resultat.erreur) {
              component.set("v.userDealerList", resultat.resultat);
            } else {
              console.log("message", "Error");
            }
          }
        });
        $A.enqueueAction(action);
      },
})
