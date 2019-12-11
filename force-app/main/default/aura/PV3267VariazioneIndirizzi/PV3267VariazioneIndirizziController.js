({
  recuperaIndirizziCliente: function(cmp, event, helper) {
    helper.recuperaIndirizziCliente(cmp, event, helper);
  },

  selectIndirizzo: function(cmp, event, helper) {
    helper.selectIndirizzo(cmp, event, helper);
  },

  normalizza: function(cmp, event, helper) {
    console.log("normalizza");

    console.log(
      "v.thisIndirizzo: " + JSON.stringify(cmp.get("v.thisIndirizzo"))
    );
    console.log(
      "v.thisIndirizzoObj: " + JSON.stringify(cmp.get("v.thisIndirizzoObj"))
    );
  },
  cancella: function(cmp, event, helper) {
    console.log("cancella");
  }
});