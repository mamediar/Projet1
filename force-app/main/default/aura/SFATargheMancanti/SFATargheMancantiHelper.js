({

    initHelper: function (component, event, helper) {

        var self = this;

        var today = new Date();
        component.set('v.dataScadenza', today.getFullYear() + "-" + (today.getMonth() + 1) + "-" + today.getDate());

        var action = component.get("c.checkLoadingStatus");
        action.setCallback(this, function (response) {
            if (response.getState() == 'SUCCESS') {
                var datiCase = response.getReturnValue();

                if (datiCase) {
                    component.set("v.caseNumber", datiCase.caseNumber);
                    component.set("v.caseId", datiCase.caseId);
                    component.set("v.isCasePending", datiCase.caseStatus == "Pending");
                    component.set("v.hasCaseDescription", (datiCase.caseDescription != null && datiCase.caseDescription != undefined));
                }
                else {
                    component.set("v.isCasePending", false);
                    component.set("v.hasCaseDescription", false);
                }

                var navService = component.find("navService");
                var pageReference = {
                    "type": "standard__recordPage",
                    "attributes": {
                        "recordId": component.get("v.caseId"),
                        "objectApiName": "Case",
                        "actionName": "view"
                    }
                };

                component.set("v.pageReference", pageReference);
                var defaultUrl = "#";
                navService.generateUrl(pageReference)
                    .then($A.getCallback(function (url) {
                        component.set("v.url", url ? url : defaultUrl);
                    }), $A.getCallback(function (error) {
                        component.set("v.url", defaultUrl);
                    }));

            }

            if (component.get("v.isCasePending") == true && component.get("v.hasCaseDescription") == false) {
                setTimeout(
                    function () {
                        self.initHelper(component, event, helper);
                    },
                    5000
                );
            }
        });

        $A.enqueueAction(action);
    },

    uploadFileHelper: function (component, event, helper, fileContents, fileName, fileExtension, dataScadenzaString) {

        var self = this;

        var action = component.get("c.insertFile");

        action.setParams({
            fileContents: fileContents,
            fileName: fileName,
            fileExtension: fileExtension,
            dataScadenzaString: dataScadenzaString
        });

        action.setCallback(this, function (response) {
            if (response.getState() == 'SUCCESS') {
                var datiCase = response.getReturnValue();
                component.set("v.caseNumber", datiCase.caseNumber);
                component.set("v.caseId", datiCase.caseId);
                component.set("v.hasCaseDescription", false);
                component.set("v.isCasePending", true);  

                var navService = component.find("navService");
                var pageReference = {
                    "type": "standard__recordPage",
                    "attributes": {
                        "recordId": component.get("v.caseId"),
                        "objectApiName": "Case",
                        "actionName": "view"
                    }
                };

                component.set("v.pageReference", pageReference);
                var defaultUrl = "#";
                navService.generateUrl(pageReference)
                    .then($A.getCallback(function (url) {
                        component.set("v.url", url ? url : defaultUrl);
                    }), $A.getCallback(function (error) {
                        component.set("v.url", defaultUrl);
                    }));

                setTimeout(
                    function () {
                        self.initHelper(component, event, helper);
                    },
                    5000
                );

            }
        });

        $A.enqueueAction(action);
    }
})