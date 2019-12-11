({
	doInit: function(component, event, helper) {
        $A.createComponent(
            "c:IntervistaIntegrativoCmp", {
                
            },
            function(newCmp) {
                if (component.isValid()) {
                    component.set("v.body", newCmp);
                }
            }
        );
    },
     navigateToIntervistaIntegrativoDetails: function (component, event, helper) {
    var clienteIntegrativo=event.getParam('IntervistaIntegrativo');
    var productsLimites=event.getParam('productsLimites');
       $A.createComponent(
           "c:IntervistaIntegrativoNewCmp", {
               'IntervistaIntegrativo':clienteIntegrativo,
               'productsLimites':productsLimites,
           },
           function(newCmp) {
               if (component.isValid()) {
                   component.set("v.body", newCmp);
               }
           }
       );
    },
})