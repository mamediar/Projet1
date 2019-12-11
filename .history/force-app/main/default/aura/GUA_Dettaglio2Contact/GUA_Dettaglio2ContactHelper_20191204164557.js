({
  dettaglioDealer: function(component, event, helper) {
    component.set("v.showDettaglioDealer", true);
  },
  ultimeChiamate: function(component, event, helper) {
    component.set("v.showUltimeChiamate", true);
  },
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
  produzione: function(component, event, helper) {
    component.set("v.showProduzione", true);
  },
  ultimePratiche: function(component, event, helper) {
    component.set("v.showUltimePratiche", true);
  },
  ultimeCarte: function(component, event, helper) {
    component.set("v.showUltimeCarte", true);
  },
  attivitaDealerSFA: function(component, event, helper) {
    component.set("v.showAttivitaDealerSFA", true);
  },
  chiudiEsitaChiamata: function(component, event, helper) {
    component.set("v.showChiudiEsitaChiamata", true);
  },
  fAQ: function(component, event, helper) {
    component.set("v.showFAQ", true);
  },
  showAction: function(component, event, helper) {
    component.set("v.showDettaglioDealer", false);
    component.set("v.showUltimeChiamate", false);
    component.set("v.showUtenzaPasscom", false);
    component.set("v.showProduzione", false);
    component.set("v.showUltimePratiche", false);
    component.set("v.showUltimeCarte", false);
    component.set("v.showAttivitaDealerSFA", false);
    component.set("v.showChiudiEsitaChiamata", false);
    component.set("v.showFAQ", false);
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
          //component.set('v.userDealerList', resultat.resultat);
        } else {
          console.log("message", "Error");
        }
      }
    });
    $A.enqueueAction(action);
  }
});