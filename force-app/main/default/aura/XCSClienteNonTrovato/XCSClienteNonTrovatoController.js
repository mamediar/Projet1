({
	clienteNonTrovato : function(cmp, event, helper) 
    {
		var action = cmp.get('c.customerNotFound');
        action.setParams({
            "recordId" : cmp.get('v.recordId')
        });
        action.setCallback(this, function(response) 
        {
            if ( response.getState() == 'SUCCESS' ) 
            {
                var toastEvent = $A.get("e.force:showToast");
                var obj = response.getReturnValue();
                var isOk = obj.isOk;
                var ToastMess = obj.messToast;
                var noteToInsert = obj.noteToInsert;
                if(isOk)
                {
                    toastEvent.setParams({
                    "title": "Successo",
                    "message": ToastMess,
                    "type" : "Success"	
                	});
                    if(noteToInsert != null && noteToInsert != '')
                    {
                        var appEvent = $A.get("e.c:XCSClienteNonTrovatoAppEvent");
                        appEvent.setParams({'note' : noteToInsert});
                        appEvent.fire();
                        console.log("Lanciato Evento");
                    }
                    toastEvent.fire();
                    $A.get('e.force:refreshView').fire();
        		}
                else
                {
         			toastEvent.setParams({
                    "title": "Attenzione",
                    "message": ToastMess,
                    "type" : "Warning"	
                	});
                    toastEvent.fire();
                }
            }        
        }); 
        $A.enqueueAction(action);
	}
})