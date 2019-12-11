({
    esitaCase:function(cmp,event,helper){
        var action=cmp.get('c.handleCase');
        action.setParams({
            'esito':event.getParam('esito'),
            'recordId':cmp.get('v.recordId'),
            'note':event.getParam('note'),
        });
        action.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){                
                cmp.find('notifLib').showToast({
                        'variant':'success',
                        "title": "Successo",
                        "message": "Caso esitato con successo."
                    });
                    $A.get('e.force:refreshView').fire();
            }
            else{
                cmp.find('notifLib').showToast({
                        'variant':'error',
                        "title": "Errore",
                        "message": "Non è possibile esitare il caso."
                    });
                    $A.get('e.force:refreshView').fire();
                
            }
        });
        $A.enqueueAction(action);
    }
})