({
    callPDF: function(component, event, helper) { 
        helper.callPDFAddProposto(component, event); 
        helper.callPDFAccettato(component, event); 
        helper.callPDFElencoIncaricati(component, event); 
    }, 
    
    getPDF : function(component, event, helper) {
        var base64 = event.getSource().get("v.value");
        helper.parseBase64toFile(component, event,base64);
    },

    getPDF_KO : function(component, event, helper) {
        var base64 = event.getSource().get("v.value");
        helper.showToast(component, event,"","error","Errore nel recupero dell'\intesa.","500");
    },
    changeToRedColor : function(component, event, helper) {
        
        var elem = component.find('button');      
        //$A.util.removeClass(elem, 'clrYellow');
        $A.util.addClass(elem, 'clrRed');

    },
    setDisable : function(component, event, helper) {

		var index = event.currentTarget.name;
		var name = component.get('v.name');
		//var index2 = event.getSource().set('v.disabled', true);
		var index2 = event.getSource();
		

    }
 
})