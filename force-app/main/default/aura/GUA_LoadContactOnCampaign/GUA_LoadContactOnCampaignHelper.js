({
  readCSV: function (cmp, campaignId) {
    //var fileInput = cmp.find("file").get("v.value");
    //var campaignId = component.get("v.campaignId");
    console.log("campaignId  readCSV: " + campaignId);
    cmp.set("v.campaignId", campaignId);
    var fileInput = cmp.get("v.fileToBeUploaded");
    console.log('fileInput >> ', fileInput.length);
    if (fileInput.length > 0) {
      var spinner = cmp.find("csvSpinner");
      $A.util.toggleClass(spinner, "slds-hide");
      var file = fileInput[0][0];
      console.log('file.type >> ', file.type);
      if (file.type === 'text/csv' || file.type === 'application/vnd.ms-excel') {
        cmp.set("v.fileTypeError", false);
        var reader = new FileReader();
        reader.readAsText(file);
        reader.onload = loadHandler;
        reader.onerror = errorHandler;
        var btnEscluso = cmp.find("btn-escluso");
        btnEscluso.set('v.disabled', false);
      } else {
        cmp.set("v.fileTypeError", true);
        $A.util.toggleClass(spinner, "slds-hide");
      }
    }

    function loadHandler(event) {
      var csv = event.target.result;
      processData(csv);
    }

    function processData(csv) {
      var allLines = csv.split(/\r\n|\n/);
      cmp.set("v.headers", allLines[0].split(/,|;/));
      var lines = [];
      for (var i = 0; i < allLines.length; i++) {
        var data = allLines[i].split(/,|;/);
        var tarr = [];
        for (var j = 0; j < data.length; j++) {
          if (data[j] == ' ') {
            this.showToast("columns with space exists in the file !", "ERROR");
          } else {
            tarr.push(data[j]);
          }
        }
        lines.push(tarr);
      }
      cmp.set("v.data", lines);
      allLines.splice(0, 1);
      var uniqueArray = allLines.filter(function (item, pos) {
        return allLines.indexOf(item) == pos && item;
      })
      cmp.set("v.dataToSave", uniqueArray);
      console.log("uniqueArray >>", uniqueArray);
      console.log("lines >>", lines);
      console.log("dataToSave >>", allLines);
      $A.util.toggleClass(spinner, "slds-hide");
    }

    function errorHandler(evt) {
      if (evt.target.error.name == "NotReadableError") {
        this.showToast("Canno't read file !", "ERROR");
      }
    }
  },

  saveEscluso: function (component) {

    var data = component.get('v.dataToSave');
    var campaignId = component.get("v.campaignId");
    console.log("campaignId to list contact", campaignId);
    if (data.length < 1) {
      console.log("data-- >> ", data);
      console.log("campaignId is null-- >> ", campaignId);

    } else {

      var spinner = component.find("csvSpinner");
      $A.util.toggleClass(spinner, "slds-hide");
      console.log("data-- >> ", data);
      console.log("campaignId -- >> ", campaignId);
      var action = component.get("c.saveFile");
      action.setParams({
        data: data,
        campaignId: campaignId
      });
      action.setCallback(this, function (response) {
        var state = response.getState();
        var response = response.getReturnValue();
        if (state === "SUCCESS" && response != '') {
          console.log(response);
          console.log("response-- >> ", response);
          this.showToast("Salvataggio effettuato!", "SUCCESS");
          var spinner = component.find("csvSpinner");
          $A.util.addClass(spinner, "slds-hide");
        } else {
          this.showToast("Salvataggio non effettuato!", "ERROR");
        }
      });
      $A.enqueueAction(action);
    }

  },
  showToast: function (message, type) {
    var toastEvent = $A.get("e.force:showToast");
    toastEvent.setParams({
      message: message,
      type: type
    });
    toastEvent.fire();
  },
  AnnullaHelper: function (component) {
    component.set("v.headers", null);
    component.set("v.data", null);
  },
  cancelField: function (component, event, helper) {
    $A.get('e.force:refreshView').fire();
  },

})