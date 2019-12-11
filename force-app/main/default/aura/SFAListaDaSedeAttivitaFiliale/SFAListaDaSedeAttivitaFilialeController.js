({
	init : function(component, event, helper) {
		helper.doInit(component, event, helper);
        helper.setHeaderColumns(component, event, helper);
	},
    getChild : function(component, event, helper) {
		helper.getChildCase(component, event, helper);
	},
    openModal : function(component, event, helper) {
		helper.openModal(component, event, helper);
	},
    goBack : function(component, event, helper) {
		component.set('v.showModal',false);
        component.set('v.showRivediAttivita',false);
        component.set('v.showDettaglioDealer',false);
		component.set('v.showEsitazioneAttivita',false);
		
		console.log(component.get('v.showRivediAttivita'));
		console.log(component.get('v.showDettaglioDealer'));
		console.log(component.get('v.showEsitazioneAttivita'));
	},
	stampa : function(component, event, helper){
		console.log("stampato");
	},
	reloadList : function(component, event, helper) {
		if(!component.get('v.showModal')){
			helper.getChildCase(component,event,helper);
			helper.doInit(component, event, helper);
		}
	},
	goEsitaAttivita : function(component, event, helper){
		helper.goEsitaAttivita(component, event, helper);
	}
    
})