({
	doInit : function(cmp, event, helper) {
		helper.doInit(cmp, event, helper);
	},

	addDealer : function(cmp,event,helper){
		helper.addDealer(cmp, event, helper);
	},

	onChangeDealerSelected : function(cmp, event, helper) {
		helper.onChangeDealerSelected(cmp, event, helper);
	},

	deleteDealerNonVisitati : function(cmp, event, helper) {
		helper.deleteDealerNonVisitati(cmp, event, helper);
	},

	deleteDealerNonVisitati : function(cmp, event, helper) {
		helper.deleteDealerNonVisitati(cmp, event, helper);
	},

	stepGiustificaUscita : function(cmp, event, helper) {
		helper.stepGiustificaUscita(cmp, event, helper);
	},

	ripianificaDealer : function(cmp, event, helper) {
		helper.ripianificaDealer(cmp, event, helper);
	},

	openPianificaPopup : function(cmp, event, helper) {
		helper.openPianificaPopup(cmp, event, helper);
	},

	closePianificaPopup : function(cmp, event, helper) {
		cmp.find('pianificaModalId').closeModal(); 
	},

	backToHome: function(cmp,event,helper){
		cmp.set('v.step','step0');
	},
})