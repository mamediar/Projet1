({
    init : function(cmp, event,helper){
        helper.behaviour(cmp,event);
    },

    // In questo modo è possibile, volendo, chiudere il caso anche senza allegare il file,
    // sbloccando il disabled dalla console javaScript.
    // per evitare questa falla, bisognerebbe modificare il controller apex di questo componente
    // in modo tale da rendere i metodi utilizzabli solo per questa logica di chiusura del caso, ovvero
    // controllare, di default, la presenza di allegati nel case.
    handleClick : function(cmp, event,helper) {
        var action = cmp.get("c.closeCase");
        var id = cmp.get('v.recordId');
        action.setParams({'caseId':id, 'flagAttach':cmp.get('v.checkAttachments')});
        action.setCallback(this, function(response){
            if (response.getState() === "SUCCESS") {
                var result = response.getReturnValue();
                cmp.find('notifLib').showToast({
                    "variant": result ? "Success" : "Warning",
                    "title": result ? "Operazione Completata" : "Allegare il relativo documento firmato"
                });
                helper.behaviour(cmp,event);
                if(result)$A.get('e.force:refreshView').fire();
            }
        });
        $A.enqueueAction(action);
    }
})