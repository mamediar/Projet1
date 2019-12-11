({
    doInit : function(component, event, helper) {
        helper.doInit(component)
    },
    handleClick : function(component, event, helper) {
        helper.search(component)
    },
    selectAllCheckbox : function(component, event, helper) {
        helper.selectAll(component, event);
    },
    checkboxSelect : function(component, event, helper) {
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
    onChange: function (component, event, helper) {
        var value = component.find('select').get('v.value');
        if(value){
            if(value != 'select'){
                component.set('v.stato', value);
            }
        }else{
            helper.showToast("Seleziona uno stato!", "ERROR");
        }
        console.log('value', value);
    },
})