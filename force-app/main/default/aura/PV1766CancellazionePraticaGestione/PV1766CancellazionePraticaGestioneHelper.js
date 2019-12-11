({
    doInit : function(cmp, event, helper) {
		//Gestiscono: BACK,DCRAV con esito,FIL,RCLM
        cmp.get("v.parent").set('v.messaggiErrore',""); 
		cmp.set("v.Branch_Or_Office__c",cmp.get("v.parent").get("v.userData.user.Branch_Or_Office__c"));
    },

    save: function (cmp, event, helper) {
        var parent = cmp.get("v.parent");
        parent.set('v.messaggiErrore','');
		
		//Se DCRAV deve aver esitato OK o KO
		if(cmp.get("v.Branch_Or_Office__c") == 'DCRAV' && $A.util.isUndefinedOrNull(cmp.get("v.esito"))){
			parent.set('v.messaggiErrore',parent.get("v.messaggiErrore") + "Selezionare un esito\n");
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
                }
                else if (response.getState() === "ERROR") {
                }
                cmp.get("v.parent").showToast(response,"","");                    
                cmp.get("v.parent").methodHideWaitComponent();
            });
            $A.enqueueAction(action);
        }
    },    
})