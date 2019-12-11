({
    doInit: function(component, event, helper) {
        helper.getRelatedXCSDispositions(component, event, helper);
    },

    openModel: function(component, event, helper) {
        helper.openModel(component, event, helper);
    },

    closeModel: function(component, event, helper) {
        helper.closeModel(component, event, helper);
    },

    submitDetails: function(component, event, helper) {
        helper.submitDetails(component, event, helper);
    },
    onXCSSelectChange: function(component, event, helper) {
        var xcsValue = component.find("selectedDisposition").get("v.value")
        console.log(xcsValue);
        if (xcsValue == 'a0P0Q000000z0feUAA') {
            helper.showDatiAggiuntiviDynamic(component, event, helper)
        } else {
            component.set("v.datiAggiuntivi", []);
            component.set("v.attivitaRichiestaEseguida", false);
        }
    },

    closeCaseStatus: function(component, event, helper) {
        console.log(' closed case', document.getElementById('closedCase').checked);
    },

    addAttivita: function(component, event, helper) {
        var idDisp = component.find("selectedDisposition").get("v.value");
        var cmp = new Number(0);
        var dispositionValues = component.get('v.dispositionValues');
        var dispositions = helper.filterDispositionsById(dispositionValues, idDisp);
        if (Array.isArray(dispositions)) {
            dispositions = dispositions[0];
        }
        var dispositionValuesSelect = component.get('v.dispositionValuesSelect');
        dispositionValuesSelect.forEach(element => {
            if (element.Id == idDisp) {
                cmp++;
            }
        });
        if (cmp == 0) {
            dispositionValuesSelect.push(dispositions);
        }

        console.log('dispositionValuesSelect', JSON.stringify(dispositionValuesSelect));
        component.set('v.dispositionValuesSelect', dispositionValuesSelect);
    },

    closeCaseStatus: function(component, event, helper) {
        var checked = event.getSource().get('v.checked');
        component.set('v.closedCase', checked);
    }
});