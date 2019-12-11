({
    handleManageContact : function(component, event, helper) {
        console.log('message ################'+JSON.stringify(component.get('v.filiale')));
    },
    actionUltimeChiama : function(component, event, helper) {
       
    },
    actionComponenti : function(component, event, helper) {
        
    },
    actionFaq : function(component, event, helper) {
        
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
        component.set("v.filiale" , fSelected);
        component.set('v.isOpenModel',false);
    }

})
