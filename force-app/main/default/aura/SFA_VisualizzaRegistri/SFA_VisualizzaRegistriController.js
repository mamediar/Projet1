({
	doInit : function(component, event, helper) {
		helper.doInit(component, event, helper);
	},
	onClickButton: function(component,event,helper){
		helper.searchNoteSpese(component,event,helper);
	},
	doApprove: function(component,event,helper){
		helper.doApprove(component,event,helper);
	},
	excelGenerate: function(component,event,helper){
		helper.excelGenerate(component,event,helper); 
	},
	upperCaseConverter: function(cmp,event,helper){
		var targa= cmp.get("v.targa");
		cmp.set("v.targa", targa.toUpperCase());
	},
	sendMessageHandler: function(component, event, helper){
		helper.sendMessageHandler(component, event, helper);
	},
    handleSaveEdition: function(component, event, helper){
        console.log('DP sono nel controller handleSaveEdition.');
		helper.handleSaveEdition(component, event, helper);
	},
    isRefreshed: function(component, event, helper){
		helper.isRefreshed(component, event, helper);
	}
})