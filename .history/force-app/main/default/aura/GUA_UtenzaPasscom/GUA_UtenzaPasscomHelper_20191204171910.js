({
    utenzaPasscom: function(component, event, helper) {
        component.set("v.showUtenzaPasscom", true);
        var action = component.get("c.getRecuperaUtenzeIntermediario");
        var resultat;
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
  resetPassword: function(component, event, helper) {
    var utenza = event.getSource().get("v.value");
   
    var action = component.get("c.resetPassWord");
    var resultat;

    action.setParams({ utenza: utenza });
    action.setCallback(this, function(response) {
      if (response.getState() === "SUCCESS") {
        resultat = response.getReturnValue();
        console.log("resultat " + JSON.stringify(resultat));
        if (!resultat.erreur) {
            
        } else {
          console.log("message", "Error");
        }
      }
    });
    $A.enqueueAction(action);
  }
})
