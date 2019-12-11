({
    doInit: function(component, event, helper) {
        helper.doInit(component)
    },
    handleClick: function(component, event, helper) {
        helper.search(component)
    },
    selectAllCheckbox: function(component, event, helper) {
        helper.selectAll(component, event);
    },
    checkboxSelect: function(component, event, helper) {
        helper.selectRow(component, event);
    },
    downloadCsv: function(component, event, helper) {
        // get the Records list from 'listToProcess' attribute
        var stockData = component.get("v.listToProcess");
        // call the helper function which "return" the CSV data as a String
        if (stockData.length === 0) {
            helper.showToast("Non ci sono record da scaricare!", "ERROR");
            return;
        }
        var csv = helper.convertArrayOfObjectsToCSV(component, stockData);
        if (csv == null) {
            return;
        }
        var hiddenElement = document.createElement("a");
        hiddenElement.href = "data:text/csv;charset=utf-8," + encodeURI(csv);
        hiddenElement.target = "_self"; //
        hiddenElement.download = "exportReport.csv"; // CSV file Name* you can change it.[only name not .csv]
        document.body.appendChild(hiddenElement); // Required for FireFox browser
        hiddenElement.click(); // using click() js function to download csv file
    },
    onChange: function(component, event, helper) {
        var value = component.find('select').get('v.value');
        if (value) {
            if (value != 'select') {
                component.set('v.stato', value);
            }
        } else {
            helper.showToast("Seleziona uno stato!", "ERROR");
        }
        console.log('value', value);
    },
    confermaEsito: function(component, event, helper) {
        helper.updateStatus(component);
    },
    confermaNote: function(component, event, helper) {
        helper.updateNote(component);
    },
    filterEliminata: function(component, event, helper) {
        helper.showDeleted(component);
    },
    filterAll: function(component, event, helper) {
        helper.showAll(component);
    },
    modifica: function(component, event, helper) {
        var listToProcess = component.get("v.listToProcess");
        if (listToProcess.length == 1) {
            component.set("v.iscritto", listToProcess[0]);
            component.set("v.showPopup", true);
        } else {
            component.set("v.iscritto", {});
            helper.showToast("Seleziona un singolo record!", "ERROR");
        }

    },
    annullaPopup: function(component, event, helper) {
        component.set("v.iscritto", {});
        component.set("v.showPopup", false);
    },
    modificaPopup: function(component, event, helper) {
        helper.modificaPopup(component);
    },
    eliminaPopup: function(component, event, helper) {
        var currentObj = component.get("v.iscritto");
        var results = component.get("v.results");
        var listToProcess = component.get("v.listToProcess");
        var index = results.indexOf(currentObj);
        var index2 = listToProcess.indexOf(currentObj);
        results.splice(index, 1);
        listToProcess.splice(index2, 1);
        component.set("v.iscritto", {});
        component.set("v.results", results);
        component.set("v.listToProcess", listToProcess);
        helper.elimina(component, currentObj);
    },
    onCheck: function(component, event, helper) {
        var checkk = event.getSource().get("v.value");
        var iscritto = component.get("v.iscritto");
        if (checkk) {
            iscritto.Invio_all_Outsourcer__c = 'S';
        } else {
            iscritto.Invio_all_Outsourcer__c = 'N';
        }
        component.set("v.iscritto", iscritto);
    },
    checkSearch: function(component, event, helper) {
        var text = component.get("v.searchText");
        if (text == '') {
            component.set("v.results", []);
            component.set("v.listToProcess", []);
            helper.toggleDisabled(component);
        }
    },
})