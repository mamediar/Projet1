({
    SearchHelper: function(component, event) {
        var searchCodOCSValue = component.find("searchCodOCS").get("v.value");
        var searchRagSocValue = component.find("searchRagSoc").get("v.value");
        var searchCodReferenteValue = component.find("searchCodReferente").get("v.value");
        var searchCognomeValue = component.find("searchCognome").get("v.value");
        var searchNomeValue = component.find("searchNome").get("v.value");
        component.set('v.results', []);
        if (searchCodOCSValue == '' && searchRagSocValue == '' && searchCodReferenteValue == '' && searchCognomeValue == '' && searchNomeValue == '') {
            this.showToast('Si prega di compilare i campi', 'Error')
        } else {
            var action = component.get("c.fetchElenco");
            action.setParams({
                'dci': component.get("v.listdealer"),
                'codOcs': component.get('v.codOcsString')
            });
            action.setCallback(this, function(response) {

                var state = response.getState();
                if (state === "SUCCESS") {
                    var storeResponse = response.getReturnValue();

                    // if storeResponse size is 0 ,display no record found message on screen.
                    if (storeResponse.length == 0) {
                        component.set("v.Message", true);
                        this.showToast('Nessun risultato', 'Error')
                    } else {
                        component.set("v.Message", false);
                    }

                    // set searchResult list with return value from server.
                    component.set("v.results", storeResponse);
                    component.set("v.listToProcess", storeResponse);
                    component.set('v.courses', []);
                    component.set('v.attachments', []);
                } else if (state === "INCOMPLETE") {
                    alert('Response is Incompleted');
                } else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            alert("Error message: " +
                                errors[0].message);
                        }
                    } else {
                        alert("Unknown error");
                    }
                }
            });
            $A.enqueueAction(action);
        }
    },

    resetFilterHelper: function(component, event, helper) {
        var data = [];
        component.set("v.results", data);
        component.set("v.listToProcess", data);
        component.set('v.listdealer', {
            'sObjectType': 'IVASS_Dealer_courses_Iscritti__c',
            'Name': '',
            'Ragione_Sociale__c': '',
            'Dealer__r': '',
            'Cognome__c': '',
            'Nome__c': '',
            'Codice_Intermediario__c': ''
        });
        component.set('v.codOcsString', '');
    },

    showToast: function(message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            message: message,
            type: type
        });
        toastEvent.fire();
    },
    convertArrayOfObjectsToCSV: function(component, objectRecords) {
        try {
            this.parseToDateArrayFromMillisecond(objectRecords);
            //console.log("08_03_2019 objectRecords: ", JSON.stringify(objectRecords));
            // declare variables
            var csvStringResult,
                counter,
                keys,
                columnDivider,
                lineDivider,
                keysLabelName;
            // check if "objectRecords" parameter is null, then return from function
            if (objectRecords == null || !objectRecords.length) {
                return null;
            }
            // store ,[comma] in columnDivider variabel for sparate CSV values and
            // for start next line use '\n' [new line] in lineDivider varaible
            columnDivider = ",";
            lineDivider = "\n";
            // in the keys variable store fields API Names as a key
            // this labels use in CSV file header
            keys = [
                "Name",
                "Cognome__c",
                "Nome__c",
                "Codice_Intermediario__c",
                "Note_x_Outsourcer__c",
                "Esito_Outsourcer__c",
            ];

            keysLabelName = [
                "Codice Referente",
                "Cognome",
                "Nome",
                "Codice Intermediario",
                "Nome Intermediario",
                "Esito Contatto"
            ];

            csvStringResult = "";
            csvStringResult += keysLabelName.join(columnDivider);
            csvStringResult += lineDivider;

            for (var i = 0; i < objectRecords.length; i++) {
                counter = 0;
                var dateMod = objectRecords[i]["LastModifiedDate"];

                var dateLiquid = objectRecords[i]["Data_Iscrizione__c"];

                if (dateMod != null) {
                    dateMod = dateMod.split("T")[0];
                    dateMod = dateMod.split("-").join("/");
                } else if (dateMod == undefined) {
                    dateMod = " ";
                }
                if (dateLiquid != null) {
                    dateLiquid = dateLiquid.split("-").join("/");
                } else if (dateLiquid == undefined) {
                    dateLiquid = " ";
                }
                //console.log("dateMod type(" + typeof dateMod + ")", dateMod);
                //console.log("dateRich(" + typeof dateRich + ")", dateRich);

                for (var sTempkey in keys) {
                    var skey = keys[sTempkey];
                    // add , [comma] after every String value,. [except first]
                    if (counter > 0) {
                        csvStringResult += columnDivider;
                    }
                    if (skey.includes(".")) {
                        var sk = skey.split(".");
                        var sk1 = sk[0];
                        var sk2 = sk[1];
                        //check if value is undefined set empty
                        if (objectRecords[i][sk1] != undefined) {
                            if (objectRecords[i][sk1][sk2] == undefined) {
                                csvStringResult += "";
                            } else {

                                csvStringResult += '"' + objectRecords[i][sk1][sk2] + '"';
                            }
                        } else {
                            csvStringResult += "";
                        }
                    } else {
                        if (skey === "Data_Iscrizione__c")
                            csvStringResult += '"' + dateLiquid + '"';
                        else if (objectRecords[i][skey] == undefined)
                            csvStringResult += " ";
                        else csvStringResult += '"' + objectRecords[i][skey] + '"';
                    }

                    counter++;
                } // inner for loop close
                csvStringResult += lineDivider;
            } // outer main for loop close
            // return the CSV formate String
        } catch (err) {
            console.log(" error ->", err);
        }
        return csvStringResult;
    },
    parseToDateArrayFromMillisecond: function(data) {
        data.forEach(function(element, index) {
            if (element.Data_Iscrizione__c)
                element.Data_Iscrizione__c = new Date(
                    element.Data_Iscrizione__c
                ).toLocaleDateString();

            data[index] = element;
        });
        return data;
    },
    getDetails: function(component) {
        var codiceReferente = component.get('v.codiceReferente');
        var action = component.get("c.dettagliAttestato");
        action.setParams({
            'codiceReferente': codiceReferente
        });
        action.setCallback(this, function(response) {

            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                component.set('v.courses', storeResponse.courses);
                component.set('v.attachments', storeResponse.attachments);
                console.log('attachments >> ', storeResponse.attachments);
                component.set('v.pickListValuesList', storeResponse.pickListValuesList);
            } else if (state === "INCOMPLETE") {
                alert('Response is Incompleted');
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert("Error message: " +
                            errors[0].message);
                    }
                } else {
                    alert("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    }
})