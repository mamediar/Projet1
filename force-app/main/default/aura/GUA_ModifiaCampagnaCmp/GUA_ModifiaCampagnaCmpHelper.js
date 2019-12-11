({
    handleUpdateCampaign: function(cmp, event) {
        var campaign = cmp.get("v.newCampaign");
        //var campaign = event.getSource().get("v.value")
        console.log('camp', JSON.stringify(campaign));
        console.log('camp whithout json', campaign);
        var UAF_DatiAggiuntivi = cmp.get("v.newCampaign.UAF_DatiAggiuntivi__c");
        console.log('UAF_DatiAggiuntivi handleUpdateCampaign', UAF_DatiAggiuntivi);
        var action = cmp.get("c.updateCampaign");
        console.log('action bef', JSON.stringify(action));
        action.setParams({
            "camp": campaign,
            "datiAggiuntivi": UAF_DatiAggiuntivi
        });
        console.log('action', JSON.stringify(action));
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "The record has been updated successfully.",
            "type": "success"
        });
        var toastEventError = $A.get("e.force:showToast");
        toastEventError.setParams({
            "title": "Error message!",
            "message": "Error  updated Campaign.",
            "type": "error"
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var results = response.getReturnValue();
            console.log('results', results);
            console.log('state', state);
            if (state == "SUCCESS") {
                toastEvent.fire();
                $A.get('e.force:refreshView').fire();
            } else if (state == "ERROR") {
                toastEventError.fire();
            }
        });
        $A.enqueueAction(action);
    },

    getCampaignById: function(component, selectedCampaign) {
        var selectedCampaign = component.get("v.selectedCampaign");
        var action = component.get("c.getCampaignByID");
        var datiAggiuntiviField;
        var datiAggiuntiviList = [];
        action.setParams({
            "campaignId": selectedCampaign
        });
        action.setCallback(this, function(a) {
            component.set("v.newCampaign", a.getReturnValue());
            console.log(a.getReturnValue());
            var list = component.get("v.newCampaign");
            console.log("set campaign", a.getReturnValue());
            console.log(list);
            for (var i in list) {
                datiAggiuntiviField = list[i].UAF_DatiAggiuntivi__c;
                datiAggiuntiviList.push({
                    label: datiAggiuntiviField,
                    value: datiAggiuntiviField
                });
            }
            component.set("v.lstItem", datiAggiuntiviList);
            //console.log(element);
        });
        console.log('datiAggiuntiviList', datiAggiuntiviList);
        var lstItem = component.get("v.lstItem");
        console.log('lstItem', lstItem);
        $A.enqueueAction(action);
    },
    textChange: function(cmp, event, helper) {
        if (event.getSource) {
            var txtVal = cmp.find("myVal").get("v.value");
            if (txtVal == '') {
                this.showToastError('Field Dati Aggiuntivi is Mandatory ',
                    'error');
            } else {
                console.log('txtVal', txtVal);
                var datiAggiuntiviList = cmp.get("v.lstItem");
                if (datiAggiuntiviList.lenght == 0) {
                    console.log('datiAggiuntiviList is empty', datiAggiuntiviList);
                }
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
        var startDate;
        var listnewCampaign = component.get("v.newCampaign");
        console.log('listnewCampaign', listnewCampaign);
        for (var i in listnewCampaign) {
            startDate = listnewCampaign[i].StartDate;
        }
        console.log('startDate', startDate);
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

})