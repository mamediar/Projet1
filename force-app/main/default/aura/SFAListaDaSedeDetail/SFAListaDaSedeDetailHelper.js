({
    doInit : function(component, event, helper) {
        var action = component.get('c.getCaseEsitiList');
        var caseSelected = component.get('v.caseChildSelected');
        action.setParams({
            caseActivity : caseSelected.Categoria_Riferimento__c
        });
        
        action.setCallback(this, $A.getCallback(function (response) {
            
            var state = response.getState();
            
            if (state === "SUCCESS") {
                
                var caseEsitiList = response.getReturnValue();
                console.log('caseEsitiList: '+caseEsitiList.length);
                if(caseEsitiList.length > 0){
                    
                }
            }
            
        }));
        
        $A.enqueueAction(action);
        
    },
    
    setHeaderColumns: function(component, event, helper) {
        
        component.set("v.headerColumns", [
            {label: 'Esito', fieldName: 'FullDispositionName__c', type: 'text'}
        ]);
    }
})