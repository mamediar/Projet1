({
    doInit: function(component, event, helper) {
        var caseList;
        var resultat;
        var accId = component.get('v.accId');
        var recordId = component.get('v.recordId');

        console.log('accId', accId);
        var cas = component.get('v.caseDetail');
        var action = component.get('c.getCaseDetail');
        action.setParams({ "caseId": recordId });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                resultat = response.getReturnValue();
                console.log('resultat', resultat);
                caseList = resultat.resultat;
                if (caseList!=null) {
                    component.set('v.caseDetail', caseList);
                    console.log('resultats dealer ', JSON.stringify(resultat));
                } else {
                    console.log('message', "Error");
                }
            }else{
                console.log('error dealer')
            }
        });
        $A.enqueueAction(action);

    }
})