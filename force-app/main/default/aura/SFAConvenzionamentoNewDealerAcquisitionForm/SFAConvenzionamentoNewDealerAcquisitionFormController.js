({
	doInit:	function(component, event, helper) {
        console.log('************************INIT!');
		helper.callGetDealerAcquisition(component, event);
	},

        
    avanti : function(component, event, helper) {
        helper.controllaSeAndareAvantiPossibile(component, event);
	},
    
    handleSelezionaTipoAccordo : function(component, event, helper) {

		console.log('*** handleSelezionaTipoAccordo');

		var tipoAccordoSelezionato = component.find("listaTipiAccordoId").get("v.value");
		component.set("v.tipoAccordoSelezionato", tipoAccordoSelezionato);

        var dealerAcquisitionId = component.get("v.dealerAcquisitionId");            
    	if (dealerAcquisitionId) {
    		helper.updateFields(component, event);
		}
        
	},
    
    initializeFlagProforma : function(component, event, helper) {
        helper.initializeFlagProforma(component, event);
	},
    
    MacroA : function(component, event, helper) {
        var MA = component.find("Macroarea__c").get("v.value");
        console.log('*** SelMacroArea: '+ MA);
        component.set("v.SelMacroArea",MA);
        
	},
    
    ProdDom : function(component, event, helper) {
        var PD = component.find("ProdottoDominanteMacroarea__c").get("v.value");
        console.log('*** SelProdDom: ',+ PD);
        component.set("v.SelProdDom", PD);
	}
   
})