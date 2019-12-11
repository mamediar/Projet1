({
  readCSV: function (cmp) {
    var fileInput = cmp.find("file").getElement();
    console.log("fileInput >> ", fileInput.files);
    if (fileInput.files.length > 0) {
      var spinner = cmp.find("csvSpinner");
      $A.util.toggleClass(spinner, "slds-hide");
      var file = fileInput.files[0];
      console.log("file.type >> ", file.type);
      if (file.type === "text/csv" || file.type === "application/vnd.ms-excel") {
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
    } else {
      cmp.set("v.fileTypeError", true);
      this.showToast("Wrong file type!", "ERROR");
      $A.util.toggleClass(spinner, "slds-hide");
    }

    function loadHandler(event) {
      var csv = event.target.result;
      processData(csv);
    }

    function processData(csv) {
      var allLines = csv.split(/\r\n|\n/);
      if (allLines.length < 2) {
        $A.util.toggleClass(spinner, "slds-hide");
        console.log("The file does not contain any records to insert!");      
      } else {
        cmp.set("v.headers", allLines[0].split(";"));
        allLines.splice(0, 1);
        var lines = [];
        var codiceOcsInCSVfile = [];
        var linesWithErrors = [];
        for (var i = 0; i < allLines.length; i++) {
          var data = allLines[i].split(";");
          if (data.length < 8) {
            console.log("The line " + (i + 2) + " is not correct. --> At least one column is missing.");            
            linesWithErrors.push(allLines[i]);
            allLines.splice(i, 1);
            i--;
          } else if (typeof data[0] !== "undefined" && data[0] !== null && data[0].trim() !== "" && data[0] && data.length == 8 && typeof data[1] !== "undefined" && data[1] !== null && data[1].trim() !== "" && data[1] && typeof data[2] !== "undefined" && data[2] !== null && data[2].trim() !== "" && data[2] && typeof data[3] !== "undefined" && data[3] !== null && data[3].trim() !== "" && data[3] && typeof data[4] !== "undefined" && data[4] !== null && data[4].trim() !== "" && data[4] && typeof data[5] !== "undefined" && data[5] !== null && data[5].trim() !== "" && data[5] && typeof data[6] !== "undefined" && data[6] !== null && data[6].trim() !== "" && data[6]) {
            
            codiceOcsInCSVfile.push(data[1].trim());
            var tarr = [];
            for (var j = 0; j < data.length; j++) {
              if (data[j]) {
                tarr.push(data[j]);
              }
            }
            lines.push(tarr);
          } else {
            console.log("The line " + (i + 2) + " is not correct. --> At least one column is missing.");
            linesWithErrors.push(allLines[i]);
            allLines.splice(i, 1);
            i--;
          }
        }
        cmp.set("v.data", lines);

        var uniqueArray = allLines.filter(function (item, pos) {
          return allLines.indexOf(item) == pos && item;
        });
        var uniqueArray2 = codiceOcsInCSVfile.filter(function (item, pos) {
          return codiceOcsInCSVfile.indexOf(item) == pos && item;
        });

        cmp.set("v.dataToSave", uniqueArray);
        cmp.set("v.codiceOcsInCSVfile", uniqueArray2);
        cmp.set("v.linesWithErrors", linesWithErrors);

        console.log("uniqueArray >>", uniqueArray);
        console.log("uniqueArray2 >>", uniqueArray2);
        console.log("dataToSave >>", allLines);
        console.log("codiceOcsInCSVfile >>", codiceOcsInCSVfile);
        console.log("linesWithErrors >>", linesWithErrors);

        $A.util.toggleClass(spinner, "slds-hide");
      }
    }

    function errorHandler(evt) {
      if (evt.target.error.name == "NotReadableError") {
        this.showToast("Canno't read file !", "ERROR");
      } else {
        this.showToast("Error during the read operation !", "ERROR");
      }
    }
  },

  saveEscluso: function (component) {
    var spinner = component.find("csvSpinner");
    $A.util.toggleClass(spinner, "slds-hide");
    var data = component.get("v.dataToSave");
    var codiceOcsInCSVfile = component.get("v.codiceOcsInCSVfile");
    var linesWithErrors = component.get("v.linesWithErrors");
    console.log("data >> ", data);
    var action = component.get("c.saveInDossierAndAccount");
    action.setParam("data", data);
    action.setParam("codiceOcsInCSVfile", codiceOcsInCSVfile);
    action.setParam("linesWithErrors", linesWithErrors);
    action.setCallback(this,
      function (response) {
        var state = response.getState();
        if (state === "SUCCESS") {
          console.log(response.getReturnValue());
          var data = response.getReturnValue();
          if (data.error) {
            var message = "Salvataggio non effettuato!";
            if (data.message.includes("duplicate")) {
              message = "Insert failed, duplicate value found";
            }
            this.showToast(message, "ERROR");
          } else {
            this.showToast("Salvataggio effettuato! " + "Success: " + data.lineSuccess + " Errors: " + data.lineError, "SUCCESS");
            //Others
          }
          $A.util.toggleClass(spinner, "slds-hide");
        } else {
          this.showToast("Salvataggio non effettuato!", "ERROR");
          console.log("Salvataggio non effettuato! >>", response.getError());
          $A.util.toggleClass(spinner, "slds-hide");
        }
      });
    $A.enqueueAction(action);
  },

	/**
   * @description : To show Toast
   * @author: Ahmet CISSE
   * @date: 06/08/2019
   * @param message
   * @param type
   */
  showToast: function (message, type) {
    var toastEvent = $A.get("e.force:showToast");
    toastEvent.setParams({
      message: message,
      type: type
    });
    toastEvent.fire();
  }
});