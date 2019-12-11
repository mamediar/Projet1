({
    doInit : function (cmp, event, helper) {
        
        var action=cmp.get('c.getIfCaseAnnulled');        
        action.setParam('recordId',cmp.get('v.recordId'));
        console.log('INIT BUTTON');
        action.setCallback(this,function(response){            
            if(response.getState()=='SUCCESS'){
                var attivitaAnnullata = response.getReturnValue();
                if (attivitaAnnullata){
                    cmp.set("v.disableButton", true);
                    cmp.set("v.messageText", "Attività di convenzionamento annullata.");
                } else {
                    console.log('attività non annullata');
                }
                
            }           
        });
        $A.enqueueAction(action); 
        $A.get('e.force:refreshView').fire();
    },
    
    openModal : function (cmp, event, helper) {
        var evt = $A.get("e.c:OpenModalEvent");
        cmp.set('v.variant','warning');
        cmp.set('v.cmp','Procedere con l\'annullamento dell\'attività di convenzionamento?');
        evt.setParams({
            "openModal": true,
            "title":"Attenzione"});  
        evt.fire();        
    },
    
    
    actionButton : function (cmp, event, helper) {
            var spinner = cmp.find('spinnerComponent');
            spinner.incrementCounter();   
        
            var evt2 = $A.get("e.c:OpenModalEvent");
            evt2.setParams({
                "openModal": false
            });        
        
            var action=cmp.get('c.handleCase');        
            action.setParam('caseId',cmp.get('v.recordId'));
            action.setParam('listViewName',cmp.get('v.nameListViewToNavigate'));
            action.setCallback(this,function(response){            
                if(response.getState()=='SUCCESS'){
                    var listViewId = response.getReturnValue();
                    console.log('***disposition and status updated properly');
                    cmp.set("v.disableButton", true);
                    cmp.set("v.messageText", "Attività di convenzionamento annullata.");
                    var navEvent = $A.get("e.force:navigateToList");
                    navEvent.setParams({
                        "listViewId": listViewId,
                        "listViewName": null,
                        "scope": "Case"
                    });
                    navEvent.fire();                 
                } else {
                    console.log('***disposition and status NOT updated properly');
                }
                spinner.decreaseCounter();
            });
            $A.enqueueAction(action); 
        
    }    

})