({

    init: function (cmp, event, helper) {
        cmp.set('v.myVal', '<p><script>alert(this)</script></p><p>hi!</p>');
        cmp.set('v.checkload', true);
        // helper.clearAll(cmp, event);
        //make Modifiacampagna tab active and show tab data
        // navigToModifiacampagnaTab
        //  cmp.find("gestionCampaignId").getElement().className = 'slds-tabs--scoped__item slds-active customClassForTab';
        //cmp.find("gestionCampaignTabDataId").getElement().className = 'slds-tabs--scoped__content slds-show customClassForTabData';
    },
    navigToNomecampagnaTab: function (component, event, helper) {
        helper.clearAll(component, event);
        component.set('v.checkload', false);
        //make Nomecampagna tab active and show tab data
        component.find("nuovaCampagnaId").getElement().className = 'slds-tabs--scoped__item slds-active customClassForTab';
        component.find("nuovaCampagnaTabDataId").getElement().className = 'slds-tabs--scoped__content slds-show customClassForTabData';
    },
    navigToModifiacampagnaTab: function (component, event, helper) {
        helper.clearAll(component, event);
        component.set('v.checkload', false);
        //make Modifiacampagna tab active and show tab data
        component.find("modifiaCampagnaId").getElement().className = 'slds-tabs--scoped__item slds-active customClassForTab';
        component.find("modifiaCampagnaTabDataId").getElement().className = 'slds-tabs--scoped__content slds-show customClassForTabData';
    },
    contatiCaricaExelTab: function (component, event, helper) {
        helper.clearAll(component, event);
        component.set('v.checkload', false);
        //make color tab active and show tab data
        component.find("contatiCaricaExelId").getElement().className = 'slds-tabs--scoped__item slds-active customClassForTab';
        component.find("contatiCaricaExelTabDataId").getElement().className = 'slds-tabs--scoped__content slds-show customClassForTabData';
    },
    annullaChiamateTab: function (component, event, helper) {
        helper.clearAll(component, event);
        component.set('v.checkload', false);
        //make color tab active and show tab data
        component.find("annullaChiamateId").getElement().className = 'slds-tabs--scoped__item slds-active customClassForTab';
        component.find("annullaChiamateTabDataId").getElement().className = 'slds-tabs--scoped__content slds-show customClassForTabData';
    },
    clickCreate: function (component, event, helper) {
        var validCampaign = component.find('campaignform').reduce(function (validSoFar, inputCmp) {
            // Displays error messages for invalid fields
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        // If we pass error checking, do some real work
        if (validCampaign) {
            var campaign = component.get("v.newCampaign");
            console.log("campaign", campaign);
            var action = component.get("c.saveCampaign");
            action.setParams({
                campaign: campaign
            });

            action.setCallback(this, function (response) {
                var state = response.getState();
                console.log("namestate", state);
                if (state === "SUCCESS") {
                    console.log("Success", state);
                    component.set("v.newCampaign", {
                        'Name': '',
                        'StartDate': '',
                        'EndDate': '',
                        'UAF_Script__c': '',
                        'UAF_DatiAggiuntivi__c': ''
                    });
                    alert('Record is Created Successfully');
                } else if (state == "ERROR") {
                    alert('Error in calling server side action');
                }
            });
            $A.enqueueAction(action);
        }
    },

    onSuccess: function (component, event, helper) {
        //Show Success message on upsertion of record
        var resultToast = $A.get("e.force:showToast");
        resultToast.setParams({
            "title": "Success!",
            "message": "Record Saved Successfully"
        });
        resultToast.fire();
        //Navigate to sObject home page
        var homeEvent = $A.get("e.force:navigateToObjectHome");
        homeEvent.setParams({
            "scope": "Campaign"
        });
        homeEvent.fire();
    }
})