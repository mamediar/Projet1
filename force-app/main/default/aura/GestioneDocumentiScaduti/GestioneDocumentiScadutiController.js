({
    doInit : function(component, event, helper) {
        var caseId = component.get('v.recordId');
        
        var action = component.get("c.getEsiti");
        action.setParams({
            "caseId": caseId
        });
        
        action.setCallback(this, function(response) {
            if ( response.getState() == 'SUCCESS' ) {
                console.log(response.getReturnValue());
                component.set('v.listaEsiti', response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    
    postSelect : function(component, event, helper){
        var esito= "";
        var dispo = event.getParam('disposition');
        console.log("DISPOSITION:" + JSON.stringify(dispo));
        if(dispo.External_Id__c == 'DP5967' || dispo.External_Id__c == 'DP5968')
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Attenzione",
                "type" : 'warning',
                "message": "Passaggio a case Post Vendita Erogazione Diretta Ancora in Analisi"
            });
            toastEvent.fire();
        }
    }
})