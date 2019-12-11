({
    init : function(cmp,event,helper){
        var action = cmp.get("c.getToastMessage");
        action.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){                    
                cmp.set('v.toastMessage',resp.getReturnValue());             
            }            
        });
        $A.enqueueAction(action);      
    },
    
    search : function(cmp,event,helper){     
        
        if(helper.checkInput(cmp) == 0){
            cmp.set('v.waiting',true);
            var action = cmp.get("c.callOCS");
            action.setParams({'codIntermediario' : cmp.get('v.codiceIntermediario'),
                              'utenza' : cmp.get('v.utenza')
                             });            
            action.setCallback(this,function(resp){
                if(resp.getState()=='SUCCESS'){  
                    cmp.set('v.waiting',false);                    
                    cmp.set('v.response',resp.getReturnValue());
                    console.log('response =' + cmp.get('v.response'));
                    if(cmp.get('v.response').length < 1)
                        helper.setToast(cmp,9);      
                    helper.sendMessage(cmp,helper);
                } 
                else
                    cmp.set('v.waiting',false);
            });
            $A.enqueueAction(action);            
        }        
        else
            helper.setToast(cmp,helper.checkInput(cmp));        
    }
})