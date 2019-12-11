({
	handleManageContact : function(component, event, helper) {
        this.getFilialeCase(component, event, helper);
       
       /* var resultat;
        var recordId= component.get('v.recordId');
        console.log('recordId', JSON.stringify(recordId));
        var action = component.get('c.getDealerByCase');
        action.setParams({"idCase":recordId}); 
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                resultat = response.getReturnValue();
                if (!resultat.erreur) {
                    //console.log('getDealerByCase', JSON.stringify(resultat));
                   	component.set('v.caseDealer',resultat.resultat);
                } else {
                    console.log('message', "Error");
                }
            }
        });
        $A.enqueueAction(action); 
        */
    },
    callCampagna: function(component, event, helper) {
        var contact = component.get('v.caseDealer');
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": contact.CampaignId__c,
            "slideDevName": "detail"
        });
        navEvt.fire();
    },
    searchCapoFiliale : function(component){
        //getCapoFiliale(String idFiliale)
        var resultat;
        var filialeId= component.get('v.caseDealer.Account.Branch__c');
        console.log('caseDealer', JSON.stringify(filialeId));
        var action = component.get('c.getCapoFiliale');
        action.setParams({"idFiliale":filialeId.Account.Branch__c}); 
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                resultat = response.getReturnValue();
                console.log('capo '+JSON.stringify(resultat));
                if (!resultat.erreur) {
                    if(resultat.filiale==true){
                        component.set('v.capoFiliale',resultat.resultat);
                    }
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
        var filialeId= component.get('v.idFiliale');
        console.log('caseDealer', JSON.stringify(filialeId));
        var action = component.get('c.getFilialeById');
        action.setParams({"idAccount":filialeId}); 
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                resultat = response.getReturnValue();
                console.log('filiale '+JSON.stringify(resultat));
                if (!resultat.erreur) {
                    if(resultat.filiale==true){
                        component.set('v.filialeCase',resultat.filiale);
                    }
                } else {
                    console.log('message', "Error");
                }
            }
        });
        $A.enqueueAction(action); 
    }
})