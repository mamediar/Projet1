({
	handleManageContact : function(component, event, helper) {
        var recordId= component.get('v.recordId');
        this.searchCapoFiliale(component,recordId);
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
    searchCapoFiliale : function(component,rcdID){
        //getCapoFiliale(String idFiliale)
        var resultat;
        var filialeId= component.get('v.caseDealer.Account.Branch__c');
        console.log('caseDealer', JSON.stringify(filialeId));
        var action = component.get('c.getCapoFiliale');
    searchCapoFiliale : function(component,rcdID){
        action.setParams({"idFiliale":filialeId.Account.Branch__c,"crdId":}); 
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
        
    }
})