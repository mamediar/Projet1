({
    sendSMSwithChildComponent : function(cmp,event,helper)
    {  
    	var mainInvioSMS = cmp.find('MainInvioSMS');
        mainInvioSMS.doSendSMS();
    },
    
    gestioneInvioSMSEvent : function(cmp,event,helper)
    {  
    	var action = cmp.get('c.handleInvioSMSEvent');
        console.log('DENTRO LA handleInvioSMSEvent');
        
        action.setParams({
            'recordId' : cmp.get('v.recordId')
        });
        
        action.setCallback(this, function(response) 
        {
            console.log('DENTRO LA RESPONSE');
        	
            if ( response.getState() == 'SUCCESS' ) {
                document.location.reload(true);
            }
            else {
                var obj = response.getReturnValue();
                var str = "Errore nell'aumento conteggio SMS";
                var messToast = obj == null ? str : str + ": " + obj.messToast;
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Errore",
                    "message": messToast,
                    "type" : "Error"	
                });
                toastEvent.fire();
            }
            
        });
        
        $A.enqueueAction(action);
        
    }
})