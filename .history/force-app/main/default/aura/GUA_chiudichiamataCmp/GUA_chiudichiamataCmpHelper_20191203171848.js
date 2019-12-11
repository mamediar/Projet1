({
  openModel: function(component, event, helper) {
    component.set("v.isModalOpen", true);
  },
  closeModel: function(component, event, helper) {
    $A.get("e.force:refreshView").fire();
    var refreshEvent = component.getEvent("GUA_RefreshViewEvent");
    refreshEvent.fire();
    component.set("v.isModalOpen", false);
    component.set("v.description", "");
    component.set("v.datiAggiuntivi", []);
    component.set("v.attivitaRichiestaEseguida", false);
  },
  submitDetails: function(component, event, helper) {
    var caseObject = component.get("v.case");
    var dispo = component.find("selectedDisposition").get("v.value");

    var datiAggiuntivi = component.get("v.datiAggiuntivi");
    console.log("datiAggiuntivi", JSON.stringify(datiAggiuntivi));
    var mapAgg = new Map();
    var mapAgg = datiAggiuntivi.reduce(
      (map, obj) => ((map[obj.label] = obj.value), map),
      {}
    );
    console.log("mapAgg " + JSON.stringify(mapAgg));

    if (dispo != null && dispo != "") {
      var dispos=[];
      dispos.push(''+dispo);
      for(var i=0;w<dispos.length;i++){
        dispos[i].Subject='outbound call';
      }
      var desc = component.get("v.description");
      var action = component.get("c.createTasks");
      action.setParams({
        idDispositions: dispos,
        description: desc,
        caseId: caseObject.Id,
        datiAggiuntivi: mapAgg,
        closedCase: component.get('v.closedCase')
      });
      action.setCallback(this, function(response) {
        var state = response.getState();
        var results = response.getReturnValue();
        if (state === "SUCCESS") {
          if (!results.error) {
            if (results.data) {
              this.showToast(
                "Successo",
                "Attività creata correttamente!",
                "success"
              );
              //this.closeModel(component, event, helper);
              console.log('case Chiamata: '+JSON.stringify(results));
            }
          } else {
            this.showToast(
              "Error",
              "Si è verificato un errore interno !",
              "error"
            );
          }
        } else if (state === "ERROR") {
          this.showToast("Error", "Si è verificato un errore!", "error");
        }
      });
      $A.enqueueAction(action);
    } else {
      this.showToast(
        "Information",
        "Seleziona il valore per Esito chiamata!",
        "info"
      );
    }
    this.closeModel(component, event, helper);
  },
  showToast: function(title, message, type) {
    var toastEvent = $A.get("e.force:showToast");
    toastEvent.setParams({
      title: title,
      message: message,
      type: type
    });
    toastEvent.fire();
  },

  showDatiAggiuntiviDynamic: function(component, event, helper) {
    var caseObject = component.get("v.case");
    if (caseObject == undefined) {
      return;
    }
    if (caseObject.CampaignId__r != undefined) {
      var aggiuntivi = caseObject.CampaignId__r.UAF_DatiAggiuntivi__c;
      console.log('aggiuntivi '+aggiuntivi)
      var datiAggiuntivi = [];
      if (aggiuntivi != null) {
        aggiuntivi = aggiuntivi.split(",");
        aggiuntivi.forEach(element => {
          datiAggiuntivi.push({ label: element, value: "" });
        });
        component.set("v.datiAggiuntivi", datiAggiuntivi);
        component.set("v.attivitaRichiestaEseguida", true);
      }
    }
  },

  getRelatedXCSDispositions: function(component,event,helper) {
    var caseObject = component.get("v.case");
    console.log("case id init " + caseObject.Id);
    component.set("v.isModalOpen", true);
    component.set("v.loadingData", true);
    var action = component.get("c.retrieveDispositionValues");
    action.setParams({
      caseId: caseObject.Id
    });
    action.setCallback(this, function(response) {
      component.set("v.loadingData", false);
      var state = response.getState();
      if (state === "SUCCESS") {
        var results = response.getReturnValue();
        if (!results.error) {
          if (results.data != null) {
            component.set("v.dispositionValues", results.data);
          }
        } else {
          helper.showToast(
            "Errore",
            "Si è verificato un errore interno !",
            "error"
          );
        }
      } else {
        //HANDLE ERROR WITH TOAST
        helper.showToast(
          "Errore",
          "Si è verificato un errore durante il recupero dei dati dal server!",
          "error"
        );
      }
    });
    $A.enqueueAction(action);
  },



});