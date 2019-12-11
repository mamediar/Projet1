({

  init: function (component, event, helper) {
    helper.initHelper(component, event, helper);
  },

  goToScadenziario: function (component, event, helper) {
    var navService = component.find("navService");
    // Uses the pageReference definition in the init handler
    var pageReference = component.get("v.pageReference");
    event.preventDefault();
    navService.navigate(pageReference);
  },

  loadFile: function (component, event, helper) {
    var result = event.getSource().get("v.files");

    if (result) {
      var file = result[0];

      var fileName = file.name.split(".")[0];
      var fileExtension = file.name.split(".")[file.name.split(".").length - 1];

      var fr = new FileReader();

      fr.onload = function () {
        var fileContents = fr.result;

        var fileContentsLineArray = fileContents.split("\n");
        var length = fileContentsLineArray.length;

        if (fileContentsLineArray[length - 1] == "") {
          fileContentsLineArray.pop();
          fileContents = fileContentsLineArray.join("\n");
        }

        component.set("v.fileContents", fileContents);
        component.set("v.fileName", fileName);
        component.set("v.fileExtension", fileExtension);

      };

      fr.readAsText(file);

    }
    else {
      var toastEvent = $A.get("e.force:showToast");
      toastEvent.setParams({
        "type": "error",
        "title": "File non caricato",
        "message": "Errore nel caricamento"
      });
      toastEvent.fire();
    }

  },

  uploadFile: function (component, event, helper) {
    var fileName = component.get("v.fileName");
    var fileExtension = component.get("v.fileExtension");
    var fileContents = component.get("v.fileContents");
    var dataScadenza = component.get("v.dataScadenza");
    var dataScadenzaDate = new Date(new Date(dataScadenza).toDateString());

    var dataScadenzaString = new Date(dataScadenzaDate.getTime() - (dataScadenzaDate.getTimezoneOffset() * 60000)).toJSON();

    var today = new Date(new Date().toDateString());

    if (fileName && fileExtension && fileContents && dataScadenza) {
      if (dataScadenzaDate > today) {
        helper.uploadFileHelper(component, event, helper, fileContents, fileName, fileExtension, dataScadenzaString);
      }
      else {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
          "type": "error",
          "title": "Data di scadenza non valida",
          "message": "Selezionare una data di scadenza successiva a quella odierna"
        });
        toastEvent.fire();
      }

    }
    else {
      var toastEvent = $A.get("e.force:showToast");
      toastEvent.setParams({
        "type": "error",
        "title": "File non caricato",
        "message": "Selezionare un file ed inserire una data di scadenza"
      });
      toastEvent.fire();
    }
  },

  chiudiCasoCaricatoConErrore: function (component, event, helper) {
    var action = component.get("c.chiudiCasoConErrore");
    action.setParams({
      caseId: component.get("v.caseId")
    });
    action.setCallback(this, function (response) {
      if (response.getState() == 'SUCCESS') {
        var chiuso = response.getReturnValue();
        if (chiuso) {
          component.set("v.isCasePending", false);

          var toastEvent = $A.get("e.force:showToast");
          toastEvent.setParams({
            "title" : "Operazione completata!",
						"type" : "success",
            "message": "E' possibile procedere con un nuovo caricamento!"
          });
          toastEvent.fire();
        } else {
          var toastEvent = $A.get("e.force:showToast");
          toastEvent.setParams({
            "title" : "Errore",
						"type" : "error",
            "message": "Errore nella preparazione per un nuovo caricamento!"
          });
          toastEvent.fire();
        }

      } else {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
          "title" : "Errore",
          "type" : "error",
          "message": "Errore nella preprarzione per un nuovo caricamento!"
        });
        toastEvent.fire();
      }
    });
    $A.enqueueAction(action);
  }
})