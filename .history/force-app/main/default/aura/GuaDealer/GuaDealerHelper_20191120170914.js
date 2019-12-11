({
    handleManageContact : function(component, event, helper) {
        var resultat;
        var recordId= component.get('v.recordId');
        console.log('recordId', JSON.stringify(recordId));
        var action = component.get('c.getDealerByCase');
        action.setParams({"idCase":recordId}); 
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                resultat = response.getReturnValue();
                if (!resultat.erreur) {
                    var contact = resultat.resultat;
                    console.log('getDealerByCase', JSON.stringify(resultat));
                    component.set('v.caseDealer',resultat.resultat);
                    
                        var obj = contact.UAF_DatiAggiuntiviFile__c;
                        var regex = /&quot;/gi;
                        obj = obj.replace(regex, '"');
                        obj = obj.replace(/""""/gi,'""');
                        component.set('v.datiAggiuntivi', JSON.parse(obj));

                        this.getFilialeCase(component,event,helper);
                } else {
                    console.log('message', "Error");
                }
            }
        });
        $A.enqueueAction(action); 
         
    },
    getFilialeCase : function (component,event,helper){
        //getFilialeById(String idAccount)
        var resultat;
        var idFiliale= component.get('v.caseDealer.Account.Branch__c');
        console.log('caseDealer', JSON.stringify(idFiliale));
        var action = component.get('c.getFilialeById');
        action.setParams({"idAccount":idFiliale}); 
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                resultat = response.getReturnValue();
                console.log('filiale '+JSON.stringify(resultat));
                if (!resultat.erreur) {
                        component.set('v.filialeCase',resultat.filiale);
                        var tf=component.get('v.filialeCase');
                        console.log('tf '+tf);
                } else {
                    console.log('message', "Error");
                }
            }
        });
        $A.enqueueAction(action); 
    }
})