({
    init: function (cmp, event, helper) {

        // cmp.set('v.myVal', '');
        helper.initJSONData(cmp, event, helper)
        // 
    },
    textChange: function (cmp, event, helper) {
        helper.textChange(cmp, event, helper);
    },
    createCampaign: function (component, event, helper) {
        var allValid = component.find('formFieldToValidate').reduce(function (validSoFar, inputCmp) {
            // Show help message if single field is invalid
            inputCmp.showHelpMessageIfInvalid();
            // Returning the final result of validations
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        if (allValid) {
            helper.insertCampaign(component, event, helper);
        }
    },

    removeDeletedRow: function (component, event, helper) {
        helper.removeDeletedRow(component, event, helper);
    },
    handleChange: function (component, event, helper) {
        helper.handleChange(component, event, helper);
    },
    datecheckChange: function (component, event, helper) {
        helper.datecheckChange(component, event, helper);
    },
    startdateChange: function (component, event, helper) {
        helper.startdateChange(component, event, helper);
    },
    cancelField: function (component, event, helper) {
        helper.cancelField(component, event, helper);
    },



})