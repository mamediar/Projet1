({
  salvareAppuntamento: function(component, dateRichiamre) {
    var noteRichiamare = component.get("v.richiamarenote");
    console.log("noteRichiamare:" + noteRichiamare);
    console.log("dateRichiamre:" + dateRichiamre);
    var intervista = component.get("v.clienteIntervista");
    intervista.COM_Richiamare_il__c = dateRichiamre;
    intervista.Note__c = noteRichiamare;
    intervista.COM_Data_Esito__c = new Date();
    intervista.Stato__c = "Richiamare";
    intervista.Status__c = "New";
    intervista.COM_Ultimo_Esito__c = "Richiamare";
    var numberRichiamare = intervista.COM_Num_richiamare__c;
    if (isNaN(numberRichiamare)) {
      numberRichiamare = 1;
    } else {
      numberRichiamare++;
    }
    intervista.COM_Num_richiamare__c = numberRichiamare;
    console.log("Num_richiamare:" + intervista.COM_Num_richiamare__c);
    console.log("intervista >>>:" + JSON.stringify(intervista));
    var action = component.get("c.updateSobject");
    action.setParam("mySobject", intervista);
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (state === "SUCCESS") {
        component.set("v.clienteIntervista", response.getReturnValue());
        var eventRefreshIntervista = $A.get(
          "e.c:eventNavigateToIntervista"
        );
        this.showToast("appuntamento registrato!", "Success");
        eventRefreshIntervista.fire();
      } else {
        this.showToast("Salvataggio non effettuato!", "ERROR");
      }
    });
    $A.enqueueAction(action);
  },
  showToast: function(message, type) {
    var toastEvent = $A.get("e.force:showToast");
    toastEvent.setParams({
      message: message,
      type: type
    });
    toastEvent.fire();
  },
  checkDate: function(component, myDate) {
    try {
      var enteredValue = Date.parse(myDate) / 60000;
      var g = new Date();
      var valueDate = Date.parse(g) / 60000;
      var currentMns = Math.floor(valueDate);
      if (enteredValue < currentMns) {
        this.showToast(
          "L'appuntamento deve essere fissato dopo l'ora attuale",
          "ERROR"
        );
        component.set("v.showSave", true);
      } else {
        this.salvareAppuntamento(component, myDate);
      }
      // }
    } catch (e) {
      console.error("error " + e);
    }
  },
  getNotInterested: function(component) {
    var clienteIntervista = component.get("v.clienteIntervista");
    clienteIntervista.Stato__c = "Non accetta";
    clienteIntervista.Status__c = "Archived";
    var action = component.get("c.updateSobject");
    action.setParam("mySobject", clienteIntervista);
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (state === "SUCCESS") {
        //var data = response.getReturnValue();
        this.showToast("Salvataggio con successo!", "SUCCESS");
        var eventToIntervista = $A.get(
          "e.c:eventNavigateToIntervista"
        );
        eventToIntervista.fire();
      } else {
        this.showToast("Salvataggio non effettuato!", "ERROR");
      }
    });
    $A.enqueueAction(action);
  }
});