({
    chiamateOutboundDealer : function(component, event, helper) {

    },
    chiamateOutboundFiliale : function(component, event, helper) {
        component.set('v.isOpenModel',true);
    },
    closeModel : function(component,event,helper){
        component.set('v.isOpenModel',false);
    },
    cercaFiliale : function(component,event,helper){
        component.set('v.listFiliales','');
        var valueNameCF =component.get('v.valueCerca');
        var action = component.get('c.getFilialeByNameOrCodiceFiliale');
        var resultat;
        action.setParams({"valueNameCF":valueNameCF}
                        ); 
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                resultat = response.getReturnValue();
                console.log('resultat '+JSON.stringify(resultat));
                if (!resultat.erreur) {
                    component.set('v.listFiliales', resultat.resultat);
                } else {
                    console.log('message', "Error");
                }
            }
        });
        $A.enqueueAction(action); 
    },
    filialeSelected : function(component,event,helper){
        var fSelected = event.getSource().get('v.value');
        console.log('message'+JSON.stringify(fSelected));
        var cmpContact = $A.get("e.force:navigateToComponent");
        cmpContact.setParams({
        			componentDef : "c:GUA_Informazioni_Filiale_RecapitiCmp",
        			componentAttributes: {
                        filiale : fSelected
        			}
    		});
    		cmpContact.fire();
    }
})