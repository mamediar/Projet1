({
   doInit: function(component, event, helper) {
        $A.createComponent(
            "c:Assicurativo", {
            },
            function(newCmp) {
                if (component.isValid()) {
                    component.set("v.body", newCmp);
                }
            }
        );
   },
   navigationAssicurativo: function(component, event, helper) {
       
           var idinterv=event.getParam('Id');
            $A.createComponent(
                "c:AssicurativoDetail", {
                   'Id':idinterv
                   },
                function(newCmp) {
                    if (component.isValid()) {
                        component.set("v.body", newCmp);
                    }
                }
            );

   },
   GoBackToAssicurativoPratiche: function( component , event , helper )
   {
        $A.createComponent(
            "c:Assicurativo", {
            },
            function(newCmp) {
                if (component.isValid()) {
                    component.set("v.body", newCmp);
                }
            }
        );
   }
})