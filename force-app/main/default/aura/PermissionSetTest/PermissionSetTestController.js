({
    handleClick:function(cmp,event,helper){
        /*
        if(!cmp.get('v.showCmp')){
            var action=cmp.get('c.hasPermission');
            action.setParam('permissionName','Test_Pappini');
            action.setCallback(this,function(response){
                if(response.getState()=='SUCCESS'){
                    cmp.set('v.showCmp',response.getReturnValue());
                    if(!response.getReturnValue()){
                        cmp.find('notifLib').showNotice({
                            "variant": "error",
                            "header": "Attenzione!",
                            "message": "Non hai i permessi necessari per accedere a questa funzionalità.",
                            closeCallback: function() {
                                
                            }
                        });
                    }
                }
                else{
                    cmp.find('notifLib').showToast({
                        "variant":"error",
                        "title": "Oops!",
                        "message":"Errore nell'esecuzione dell'operazione"
                    });
                }
            });
            $A.enqueueAction(action);
        }
        else{
            cmp.set('v.showCmp',false);
        }
        */
    }
})