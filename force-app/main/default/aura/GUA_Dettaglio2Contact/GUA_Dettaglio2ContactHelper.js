({
  dettaglioDealer: function(component, event, helper) {
    component.set("v.showDettaglioDealer", true);
  },
  ultimeChiamate: function(component, event, helper) {
    component.set("v.showUltimeChiamate", true);
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
  }
});