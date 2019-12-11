({
    init : function(cmp, event, helper) {
       var codaSelezionata = cmp.get('v.codaSelezionata');
        var action = cmp.get('c.doCodeFilter');  
        action.setCallback(this, function(response) { 
            var state = response.getState(); 
            if (state == 'SUCCESS') { 
                var results = response.getReturnValue();
                cmp.set('v.options', results);
                
            }
        }); 
        $A.enqueueAction(action);
        
    },
    
    uclick: function(cmp,event,helper){
        var navService = cmp.find("navService");
        var codaSelezionata = cmp.get('v.codaSelezionata');
        var action = cmp.get('c.doRiempiCasella');
        action.setParams({'codaSelezionata': codaSelezionata});
        console.log('uclick '+codaSelezionata);
        action.setCallback(this,function(response) { 
            console.log('risposta da APEX ');
            var state = response.getState(); 
            if (state == 'SUCCESS') { 
                console.log('risposta da APEX SUCCESS '+response.getReturnValue());
                var pageReference = {
                    type: 'standard__objectPage',
                    attributes: {
                        objectApiName: 'Case',
                        actionName: 'list'
                    },
                    state: {
                        filterName: "AssignToMe" //response.getReturnValue(),                       
                    }
                };
                event.preventDefault();
                navService.navigate(pageReference);
                $A.get("e.force:refreshView").fire();
            } 
           else {
                var errors = response.getError();
                var message = 'Unknown error'; // Default error message
            // Retrieve the error message sent by the server
                if (errors && Array.isArray(errors) && errors.length > 0) {
                   console.log(JSON.stringify(errors));
                    // message = errors[0].message;
                }
                // Display the message
                console.error(message);
           } 
        }); 
        $A.enqueueAction(action);
    },
    
    componentComparsa: function(cmp,event,helper){
        cmp.set('v.body','');
        var idofqueue = cmp.get('v.codaSelezionata');
        if(idofqueue == ''){
            cmp.set('v.visibileRiempiCasella', false);
        }
        var action = cmp.get('c.getConfig');
        action.setParams({'idofqueue': idofqueue});
        action.setCallback(this,function(response) { 
            var state = response.getState(); 
            if (state == 'SUCCESS') { 
                var results = response.getReturnValue();
                cmp.set('v.configQueue',results);
                cmp.set('v.visibileRiempiCasella',results.Obj_Assigned__c == null);
                if(results.Obj_Assigned__c != null){
                    cmp.set('v.visibileRiempiCasella', false);
                    helper.createCmp(cmp,results.Obj_Assigned__c);
                }
            }
        })
        $A.enqueueAction(action);
    } 
})