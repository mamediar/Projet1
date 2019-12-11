({
    doInit: function(component, event, helper) {
        helper.doInit(component);
        helper.getIntervisteDelmeseByProduct(component);        
        
    },
    navigateToIntervistaPenetrazioneDetails: function (component, event, helper) {
        var clienteIntegrativo=event.getParam('intervistaPenetrazione');
        var productsLimites=event.getParam('productsLimites');
      $A.createComponent(
          "c:IntegrativoPenetrazioneDetail", {
              'intervistaPenetrazione':clienteIntegrativo,
              'productsLimites':productsLimites,
          },
          function(newCmp) {
              if (component.isValid()) {
                  component.set("v.body", newCmp);
              }
          }
      );
   },
   navigateToEsclusioni: function (component, event, helper) {
      //console.log('recieved fired event');
     $A.createComponent(
         "c:IntegrativoEsclusioni", {},
         function(newCmp) {
             if (component.isValid()) {
                 component.set("v.body", newCmp);
             }
         }
     );
  },
})