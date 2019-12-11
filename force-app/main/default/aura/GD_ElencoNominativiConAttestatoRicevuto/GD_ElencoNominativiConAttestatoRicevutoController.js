({
    Search: function(component, event, helper) {
        var searchCodOCS = component.find('searchCodOCS');
       var isValueMissingCodOCS = searchCodOCS.get('v.validity').valueMissing;
        var searchRagSoc = component.find('searchRagSoc');
       var isValueMissingRagSoc = searchRagSoc.get('v.validity').valueMissing;
        var searchCodReferente = component.find('searchCodReferente');
       var isValueMissingCodReferente = searchCodReferente.get('v.validity').valueMissing;
       var searchCognome = component.find('searchCognome');
       var isValueMissingCognome = searchCognome.get('v.validity').valueMissing;
       var searchNome = component.find('searchNome');
       var isValueMissingNome = searchNome.get('v.validity').valueMissing;
       // if value is missing show error message and focus on field
       if(isValueMissingCodOCS) {
           searchCodOCS.showHelpMessageIfInvalid();
           searchCodOCS.focus();
       }else if(isValueMissingRagSoc) {
           searchRagSoc.showHelpMessageIfInvalid();
           searchRagSoc.focus();
       }else if(isValueMissingCodReferente) {
           searchCodReferente.showHelpMessageIfInvalid();
           searchCodReferente.focus();
       }else if(isValueMissingCognome) {
        searchCognome.showHelpMessageIfInvalid();
        searchCognome.focus();
    }else if(isValueMissingNome) {
        searchNome.showHelpMessageIfInvalid();
        searchNome.focus();
    } else{
         // else call helper function 
           helper.SearchHelper(component, event);
       }
   },
   /**
   * @description: method for reset filter
   * @date::29/08/2019
   * @author:Aminata GUEYE
   * @modification: NONE
   */

  resetFilter: function(component,event,helper){
    helper.resetFilterHelper(component,event,helper);
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
    },
    onRadioChange: function(cmp, evt, helper) {
        var selected = evt.getSource().get("v.text");
        var details = selected.split("__");
        cmp.set('v.codiceReferente', details[1]);
        var iscritti = cmp.get('v.results');
        var index = details[0];
        cmp.set('v.iscritto', iscritti[index]);
        helper.getDetails(cmp);
    },
})