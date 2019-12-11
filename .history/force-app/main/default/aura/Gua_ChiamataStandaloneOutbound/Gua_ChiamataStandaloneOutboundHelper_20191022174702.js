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
        var valueNameCF =component.get('v.valueCerca');
        
        component.set('v.showUtenzaPasscom',true);
        var action = component.get('c.getFilialeByNameOrCodiceFiliale');
        var resultat;
        action.setParams({"valueNameCF":valueNameCF}
                        ); 
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                resultat = response.getReturnValue();
                console.log('resultat '+JSON.stringify(resultat));
                if (!resultat.erreur) {
                    //component.set('v.userDealerList', resultat.resultat);
                } else {
                    console.log('message', "Error");
                }
            }
        });
        $A.enqueueAction(action); 
    }
})