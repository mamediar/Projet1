({
    callPDF: function(component, event, helper) { 
        helper.callPDFAddProposto(component, event); 
        helper.callPDFAccettato(component, event); 
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

        var index = event.currentTarget.getAttribute("data-index");

        debugger;

        //pdfRecuperato[index];
        component.set('v.disable',true);
        debugger;

    }
 
})