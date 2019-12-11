({
    handleUpload: function (cmp, evt, helper) {
        var txtFile = cmp.find("file").get("v.value");
        var campaignId = cmp.get("v.campaignId");
        console.log("campaignId  handle upload: " + campaignId);
        cmp.set("v.campaignId", campaignId);
        if (txtFile == '') {
            helper.showToast("Canno't read file ,please attach a file!", "ERROR");
        } else {
            helper.readCSV(cmp, campaignId);
        }

    },
    handleSave: function (cmp, event, helper) {
        helper.saveEscluso(cmp);
    },
    handleAnnulla: function (cmp, evt, helper) {
        helper.AnnullaHelper(cmp);
    },
    setSelectedCampaign: function (component, event, helper) {
        var campaignId = event.getParam("updateCampaign");
        console.log("campaignId selected before save Case: " + campaignId);
        component.set("v.campaignId", campaignId);
    },
    cancelField: function (component, event, helper) {
        helper.cancelField(component, event, helper);
    },

})