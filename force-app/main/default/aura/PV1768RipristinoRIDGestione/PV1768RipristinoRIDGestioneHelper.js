({
    doInitHelper : function(cmp, event, helper) {
        var parent = cmp.get("v.parent");
        parent.set('v.messaggiErrore',""); 
        console.log("case: " + JSON.stringify(cmp.get('v.theCase')));
        cmp.set("v.Branch_Or_Office__c",cmp.get("v.parent").get("v.userData.user.Branch_Or_Office__c"));
        console.log("v.Branch_Or_Office__c : " + cmp.get("v.parent").get("v.userData.user.Branch_Or_Office__c"));
    },


    save: function (cmp, event, helper) {
        var parent = cmp.get("v.parent");
        //15100013971
        parent.set('v.messaggiErrore','');
        
        
        if(!$A.util.isUndefinedOrNull(cmp.find("esito")) && !cmp.find("esito").checkValidity()){	//auraMethod checkValidity
            cmp.find("esito").showHelpMessageIfInvalid();
            parent.set('v.messaggiErrore',parent.get("v.messaggiErrore") + "Selezionare un esito<br/>");
        }

        if(parent.get("v.messaggiErrore") == ""){
            cmp.get("v.parent").methodShowWaitComponent(); 
          var action = cmp.get('c.saveCase');
            action.setParam('form',
                {
                    "newStatus": cmp.get('v.newStatus'),
                    "note": cmp.get("v.note"),
                    "userData" : parent.get('v.userData'),
                    "esito" : cmp.get("v.esito")
                }
            );
            action.setParam('theCase', cmp.get("v.theCase"));
            // Imposto la Callback
            action.setCallback(this, function (response, helper) {
                if (response.getState() == 'SUCCESS') {
                    //qui mettere codice se c'è altro da fare in caso di SUCCESS
                    cmp.get("v.parent").showToast(response,"","");                    
                }
                else if (response.getState() === "ERROR") {
                    cmp.get("v.parent").showToast(response,"","");                    
                }
                cmp.get("v.parent").methodHideWaitComponent();
            });
            $A.enqueueAction(action);
        }
    },    
})