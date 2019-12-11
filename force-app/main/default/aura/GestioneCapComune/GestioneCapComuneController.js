({
	init: function(cmp, event, helper) {
        helper.init(cmp, event, helper);
    },

    handleRowAction: function (cmp, event, helper) {
        helper.handleRowAction(cmp, event, helper);
    },
    
    saveNewZone: function (cmp, event, helper) {
        helper.saveNewZone(cmp, event, helper);
    },
         
    closePopUp : function(cmp, event, helper) {
        cmp.find("theStaticModal").closeModal();
    },

    onChangeBranchSelect : function(cmp, event, helper){
        helper.onChangeBranchSelect(cmp, event, helper);
    },

    sendMessageHandler : function(cmp, event, helper){
        helper.sendMessageHandler(cmp, event, helper);
    }
})