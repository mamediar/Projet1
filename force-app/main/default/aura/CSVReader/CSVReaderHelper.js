({
	readCSV : function(cmp) {
        var fileInput = cmp.find("file").getElement();
        console.log('fileInput >> ', fileInput.files);
        if (fileInput.files.length > 0 ){
            var spinner = cmp.find("csvSpinner");
            $A.util.toggleClass(spinner, "slds-hide");
            var file = fileInput.files[0];
            console.log('file.type >> ', file.type);
            if(file.type === 'text/csv' || file.type === 'application/vnd.ms-excel'){
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
        }else {
            cmp.set("v.fileTypeError", true);
            this.showToast("Tipo di file errato!", "ERROR");
            $A.util.toggleClass(spinner, "slds-hide");
        }
        
        
        function loadHandler(event) {
          var csv = event.target.result;
          processData(csv);
        }

        function processData(csv) {
            var allLines = csv.split(/\r\n|\n/);
            cmp.set("v.headers", allLines[0].split(/,|;/));
            var lines = [];
            for (var i=1; i<allLines.length; i++) {
                var data = allLines[i].split(/,|;/);
                var tarr = [];
                for (var j=0; j<data.length; j++) {
                  if(data[j]){
                    tarr.push(data[j]);
                  }
                }
                lines.push(tarr);
            }
            cmp.set("v.data", lines);
            allLines.splice(0, 1);
            var uniqueArray = allLines.filter(function(item, pos) {
              return allLines.indexOf(item) == pos && item;
             })
            cmp.set("v.dataToSave", uniqueArray);
            console.log("uniqueArray >>", uniqueArray);
            console.log("dataToSave >>", allLines);
            $A.util.toggleClass(spinner, "slds-hide");
        }

        function errorHandler(evt) {
          if(evt.target.error.name == "NotReadableError") {
            this.showToast("Canno't read file !", "ERROR");
          }
        }
    },
    saveEscluso : function(component){
        var data = component.get('v.dataToSave');
        console.log("data >> ", data) ;
        var action = component.get("c.savePraticaEscluso");
        action.setParam("data", data);
        action.setCallback(this, function(response) {
          var state = response.getState();
          if (state === "SUCCESS") {
            console.log(response.getReturnValue()) ;
            var data = response.getReturnValue();
            if(data.error){
              var message = "Salvataggio non effettuato!";
              if(data.message.includes("duplicate")){
                message = "Inserimento non riuscito, valore duplicato trovato";
              }
              this.showToast(message, "ERROR");
            }else{
              this.showToast("Salvataggio effettuato!", "SUCCESS");
              var eventToNavigate = $A.get("e.c:eventNavigateToIntervistaPenetrazione");
              eventToNavigate.fire();
            }
          } else {
            this.showToast("Salvataggio non effettuato!", "ERROR");
            console.log("Salvataggio non effettuato! >>", response.getError()) ;
          }
        });
        $A.enqueueAction(action);
    },

    /**
     * @description : To show Toast
     * @author: Khadim Rassoul Ndeye
     * @date: 13/03/2019
     * @param message
     * @param type
     */
    showToast: function(message, type) {
      var toastEvent = $A.get("e.force:showToast");
      toastEvent.setParams({
        message: message,
        type: type
      });
      toastEvent.fire();
    },
})