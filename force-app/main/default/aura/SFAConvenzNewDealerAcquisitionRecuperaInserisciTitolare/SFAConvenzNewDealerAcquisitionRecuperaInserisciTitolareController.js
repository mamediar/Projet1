({
	doInit : function(component, event, helper) {
		helper.callGetDealerAcquisition(component, event);
	},
    
    handleRicercaTitolare : function(component, event, helper) {
        console.log('******handleRicercaTitolare');      
		helper.ricercaTitolareDatabase(component, event);
	},
    
    actionButtonSalvaTitolareTrovato : function(component, event, helper) {
        component.set("v.titolareId",component.get("v.titolareTrovatoSelezionato"));
        helper.setProvinciaEluogoRilascioDocumentoTitolare(component, event);
    },
    
    actionButtonInserisciNuovaAnagrafica: function(component, event, helper) {
        var showFormInserisciNuovaAnagrafica=component.get("v.showFormInserisciNuovaAnagrafica");
        component.set("v.titolareTrovatoSelezionato","");
        component.set("v.titolareId","");
        component.set("v.cittaRilascioDocumento","");
        component.set("v.provinciaRilascioDocumento","");
		component.set("v.showFormInserisciNuovaAnagrafica", !showFormInserisciNuovaAnagrafica);
        component.set("v.isRicercaEffettuataENessunTitTrovato",false);
	},
    
    
    actionButtonSalvaTitolare : function(component, event, helper) {
        console.log('*******actionButtonSalvaTitolare');
        helper.valutaSeSalvareTitolare(component, event);
	},
    
    salvaDatiIDTitolare: function(component, event, helper) { 
        helper.aggiornaDatiIDTitolare(component, event);    
	},    
    
    
    handleSubmit : function(component, event, helper) {
	},
    
    
	handleSuccess: function(component, event, helper) {
        var tit = event.getParams().response;
        console.log(tit.id);
        component.set("v.titolareId",tit.id);
        component.set("v.provinciaRilascioDocumento","");
        component.set("v.cittaRilascioDocumento","");
        console.log('titolareId:: '+component.get("v.titolareId"));
        if(component.get("v.titolareId")){
            helper.aggiornaProvinciaCittaNascitaResidenzaNewTitolare(component, event);
        }
	},

	handleError: function(component, event, helper) {
        helper.showToast(component,event,"","error","Si è verificato un errore durante il salvataggio dei dati.","500");                 
    },
    
    actionButtonAvanti : function(component, event, helper) {
        helper.avanti(component, event);
    },
    
})