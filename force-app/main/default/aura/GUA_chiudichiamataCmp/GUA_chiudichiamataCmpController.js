({
  doInit: function(component, event, helper) {
    helper.getRelatedXCSDispositions(component,event,helper);
  },

  openModel: function(component, event, helper) {
    helper.openModel(component, event, helper);
  },

  closeModel: function(component, event, helper) {
    helper.closeModel(component, event, helper);
  },

  submitDetails: function(component, event, helper) {
    helper.submitDetails(component, event, helper);
  },
  onXCSSelectChange:function (component,event,helper) {
    var xcsValue = component.find("selectedDisposition").get("v.value")
    console.log(xcsValue)
    if (xcsValue =='a0P0Q000000z0feUAA') {
      helper.showDatiAggiuntiviDynamic(component,event,helper)
    }else{
      component.set("v.datiAggiuntivi", []);
      component.set("v.attivitaRichiestaEseguida", false);
    }
  },

  closeCaseStatus:function (component,event,helper) {
    var checked = event.getSource().get('v.checked');
    component.set('v.closedCase', checked)
  }
});