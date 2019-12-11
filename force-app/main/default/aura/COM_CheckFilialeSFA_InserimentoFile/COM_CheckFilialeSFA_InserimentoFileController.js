({
	displayModal : function(component, event, helper) {
		component.set('v.showModal',true);
	},
	closeModal : function(component, event, helper) {
		component.set('v.showModal',false);
	},
	selectedTipoFile : function(component, event, helper) {
		var tipoFile =  event.getParam("value");
		component.set('v.selectTipoFile',tipoFile);
		helper.getSelectProdootoByTipoFile(component,event);
	},
	selectedProdotto : function(component, event, helper) {
		var prodotto =  event.getParam("value");
		component.set('v.selectProdotto',prodotto);
		helper.getHeadersList(component,event);
	},

})