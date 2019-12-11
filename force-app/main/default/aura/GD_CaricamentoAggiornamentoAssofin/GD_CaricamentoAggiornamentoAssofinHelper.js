({

    processCSV: function(cmp) {
        var spinner = cmp.find("csvSpinner");
        $A.util.toggleClass(spinner, "slds-hide");
        var fileInput = cmp.find("fileInput");
        fileInput = fileInput.getElement();
        var file = fileInput.files[0];

        if (file.type === "text/csv" || file.type === 'application/vnd.ms-excel') {
            var reader = new FileReader();
            reader.readAsText(file);
            reader.onload = loadHandler;
            reader.onerror = errorHandler;
        } else {
            showToast("fileTypeError!", "ERROR");
            $A.util.toggleClass(spinner, "slds-hide");
        }

        function loadHandler(event) {
            var csv = event.target.result;
            processData(csv);
        }

        function processData(csv) {
            var allLines = csv.split(/\r\n|\n/);
            cmp.set("v.headers", allLines[0].split(/,|;/));
            console.log("headers >>: ", allLines[0].split(/,|;/));
            var lines = [];
            for (var i = 1; i < allLines.length; i++) {
                var data = allLines[i].split(/,|;/);
                var tarr = [];
                for (var j = 0; j < data.length; j++) {
                    tarr.push(data[j]);
                }
                if (tarr.length > 1) {
                    console.log("tarr>>: ", tarr);
                    var name = tarr[1].split(' ');
                    console.log("name >>: ", name);
                    console.log("tarr[7] >>: ", tarr[7]);
                    var dataIscrizione = getDate(tarr[7]);
                    var sObject = {
                        'sobjectType': 'IVASS_Dealer_courses_Iscritti__c',
                        'Codice_Fiscale__c': tarr[3],
                        'Nome_Corso__c': tarr[5],
                        'Stato_Corso__c': tarr[11],
                        'Nome__c': name[0],
                        'Cognome__c': name[1],
                        'Data_Iscrizione__c': dataIscrizione,
                    };
                    lines.push(sObject);
                }
            }
            save(cmp, lines);
            cmp.set("v.data", lines);
        }

        function errorHandler(evt) {
            if (evt.target.error.name == "NotReadableError") {
                showToast("Canno't read file !", "ERROR");
            }
        }

        function save(component, data) {
            var action = component.get("c.updateSobject");
            action.setParam("data", data);
            console.log('data to send', data);
            action.setCallback(this, function(response) {
                $A.util.toggleClass(spinner, "slds-hide");
                var state = response.getState();
                if (state === "SUCCESS") {
                    var data = response.getReturnValue();
                    if (data.error) {
                        var message = "Salvataggio non effettuato!";
                        if (data.message.includes("duplicate")) {
                            message = "Insert failed, duplicate value found";
                        }
                        showToast(message, "ERROR");
                    } else {
                        showToast(data.message, "SUCCESS");
                    }
                } else {
                    showToast("Salvataggio non effettuato!", "ERROR");
                }
            });
            $A.enqueueAction(action);
        }

        function showToast(message, type) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                message: message,
                type: type
            });
            toastEvent.fire();
        }

        function getDate(dateToformat) {
            var dateTable = dateToformat.split(' ');
            var dateFormated = dateTable[0].split('/');
            var year = dateFormated[2];
            var month = dateFormated[1];
            var day = dateFormated[0];
            return new Date(year, month, day);
        }
    },

});