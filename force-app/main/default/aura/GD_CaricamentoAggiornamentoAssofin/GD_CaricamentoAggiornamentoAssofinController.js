({
	handleUpload : function(component, event, helper) {
		var btnCarica = component.find("carica-btn");
		var btnChiudi = component.find("chiudi-btn");
		btnCarica.set('v.disabled', false);
		btnChiudi.set('v.disabled', false);
	},
	handleChiudiClick : function(component, event, helper) {
		var fileInput = component.find("fileInput");
		var btnCarica = component.find("carica-btn");
		var btnChiudi = component.find("chiudi-btn");
		btnCarica.set('v.disabled', true);
		btnChiudi.set('v.disabled', true);
		fileInput.set('v.value', '');
		
	},
	handleCaricaClick : function(component, event, helper) {
		helper.processCSV(component);
		//IVASS_Dealer_courses_Iscritti__c
	},
})