({
    insertCampaign: function(component, event, helper) {
        var spinner = component.find("csvSpinner");
        $A.util.toggleClass(spinner, "slds-hide");
        var campaign = component.get("v.newCampaign");
        var action = component.get("c.saveCampaign");
        console.log('action', action);
        action.setParams({
            campaign: campaign
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state', state);
            if (state == "SUCCESS") {
                this.showToastSuccess('Campaign created successfully', 'success');
                $A.get('e.force:refreshView').fire();
                var spinner = component.find("csvSpinner");
                $A.util.addClass(spinner, "slds-hide");

            } else if (state == "ERROR") {
                //toastEvent.fire();
                this.showToastError('insertion failure: one of the fields is null or has a bad value',
                    'error');

            }
        });

        $A.enqueueAction(action);
    },

    //Function to Show suucess message on upsertion of record
    showToastSuccess: function(message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: 'Success Message',
            message: message,
            key: 'info_alt',
            mode: 'pester',
            type: type
        });
        toastEvent.fire();
    },
    //Function to Show error message on upsertion of record
    showToastError: function(message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: 'Error Message',
            message: message,
            key: 'info_alt',
            mode: 'pester',
            type: type
        });
        toastEvent.fire();
    },
    initJSONData: function(component, event, helper) {},
    textChange: function(cmp, event, helper) {
        if (event.getSource) {
            var txtVal = cmp.find("myVal").get("v.value");
            if (txtVal == '') {
                this.showToastError('Field Dati Aggiuntivi is Mandatory ',
                    'error');
            } else {
                console.log('txtVal', txtVal);
                var datiAggiuntiviList = cmp.get("v.lstItem");
                datiAggiuntiviList.push({
                    label: txtVal,
                    value: txtVal
                });
                console.log('datiAggiuntiviList', datiAggiuntiviList);

                cmp.set("v.lstItem", datiAggiuntiviList);
            }
        }
    },
    handleChange: function(component, event, helper) {
        var target = event.getSource();
        var txtVal = target.get("v.value");
        var AllRowsList = component.get("v.lstItem");
        var check;
        console.log('AllRowsList ', AllRowsList);
        var tab = [];
        var element;
        var valcheckbox;
        if (txtVal == '') {

        } else {
            for (var val in txtVal) {
                tab.push(txtVal[val]);
                element = tab.join(',');
            }
            console.log('event-value-checkbox', tab);
            console.log('element', element);
            var datiAggiuntiviToSearch = element;
            var matchedIndex = AllRowsList.map(function(obj) { return obj.label; }).indexOf(datiAggiuntiviToSearch);
            console.log(matchedIndex);
            console.log('valcheckbox sel', matchedIndex);
            component.set("v.valCheckbox", matchedIndex);
            var valcheckbox = component.get("v.valCheckbox");
            console.log('valcheckbox', valcheckbox);
            component.set("v.newCampaign.UAF_DatiAggiuntivi__c", element);
            var UAF_DatiAggiuntivi = component.get("v.newCampaign.UAF_DatiAggiuntivi__c");
            console.log('UAF_DatiAggiuntivi__c', UAF_DatiAggiuntivi);
            //alert(event.getParam('value'));
        }
    },
    // function for delete the row 
    removeDeletedRow: function(component, event, helper) {

        var AllRowsList = component.get("v.lstItem");
        var UAF_DatiAggiuntivi = component.get("v.newCampaign.UAF_DatiAggiuntivi__c");
        var valcheckbox = component.get("v.valCheckbox");
        console.log('UAF_DatiAggiuntivi remove', UAF_DatiAggiuntivi);
        console.log('valcheckbox', valcheckbox);
        if (UAF_DatiAggiuntivi == '') {
            this.showToastError('Selezionare il dato che si desidera cancellare',
                'error');
        } else {

            AllRowsList.splice(valcheckbox, 1);
            // set the contactList after remove selected row element  
            component.set("v.lstItem", AllRowsList);
        }
    },
    datecheckChange: function(component, event, helper) {
        var target = event.getSource();
        var txtVal = target.get("v.value");
        var startDate = component.get("v.newCampaign.StartDate");
        console.log('txtVal', txtVal);
        if (startDate > txtVal) {
            component.set("v.checkdate", true);
        } else {
            component.set("v.checkdate", false);
        }
    },
    startdateChange: function(component, event, helper) {
        var target = event.getSource();
        var txtVal = target.get("v.value");
        var endDate = component.get("v.newCampaign.EndDate");
        console.log('txtVal', txtVal);
        if (endDate < txtVal) {
            component.set("v.checkdate", true);
        } else {
            component.set("v.checkdate", false);
        }
    },
    cancelField: function(component, event, helper) {
        $A.get('e.force:refreshView').fire();
    },
})