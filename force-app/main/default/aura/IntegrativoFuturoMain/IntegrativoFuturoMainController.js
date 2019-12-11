/* ({
    doInit: function(component, event, helper) {
        $A.createComponent(
            "c:IntegrativoFuturo", {
                
            },
            function(newCmp) {
                if (component.isValid()) {
                    component.set("v.body", newCmp);
                }
            }
        );
    },
}) */

({
    doInit: function(component, event, helper) {
        helper.doInit(component);
        helper.getIntervisteDelmeseByProduct(component);
        console.log('initialisation');
        
    },
    navigateToIntervistaFuturoDetails: function (component, event, helper) {
        var clienteIntegrativo=event.getParam('intervistaFuturo');
        var productsLimites=event.getParam('productsLimites');
      $A.createComponent(
          "c:IntegrativoFuturoDetail", {
              'intervistaFuturo':clienteIntegrativo,
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