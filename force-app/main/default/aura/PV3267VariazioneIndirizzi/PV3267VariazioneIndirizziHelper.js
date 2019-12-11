({
  recuperaIndirizziCliente: function(cmp, event, helper) {
    var codCliente = cmp.get("v.PVForm.cliente.codCliente");
    if (codCliente != null) {
      var action = cmp.get("c.doRecuperaIndirizziCliente");

      action.setParams({
        codCliente: codCliente
      });

      action.setCallback(this, function(response, helper) {
        if (response.getState() == "SUCCESS" && response.getReturnValue()) {
          // Conversione CAP 00000 ---> ""
          // Conversione TipoIndirizzo: D --> Domicilio, R --> Residenza, P --> Precedente
          var indirizzi = response.getReturnValue();

          indirizzi.forEach(function(indirizzo) {
            switch (indirizzo["tipoIndirizzo"]) {
              case "D":
                indirizzo["tipoIndirizzo"] = "Domicilio";
                break;
              case "R":
                indirizzo["tipoIndirizzo"] = "Residenza";
                break;
              case "P":
                indirizzo["tipoIndirizzo"] = "Precedente";
                break;
            }
            if (indirizzo["cap"] == "00000") {
              indirizzo["cap"] = "";
            }
          });

          cmp.set("v.OCSIndirizzi", response.getReturnValue());
        }
      });
      $A.enqueueAction(action);
    }
  },

  selectIndirizzo: function(cmp, event, helper) {
    var thisIndirizzo = event.getParam("selectedRows")[0];
    console.log("varThisIndirizzo: ");
    console.log(thisIndirizzo);
    console.log("JSONvarThisIndirizzo: " + JSON.stringify(thisIndirizzo));

    cmp.set("v.thisIndirizzoObj", thisIndirizzo);

    console.log(
      "v.thisIndirizzoObj: " + JSON.stringify(cmp.get("v.thisIndirizzoObj"))
    );
  }
});