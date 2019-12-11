({
    init:function(cmp,event,helper){
        var action=cmp.get('c.getMittenti');
        action.setParam('societa',cmp.get('v.aziendaSelezionata'));
        action.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){
                cmp.set('v.filUffList',resp.getReturnValue());
                cmp.set('v.carica',true);
            }
        });
        $A.enqueueAction(action);
         
    },
    
    aggiungiFilUff:function(cmp,event,helper){
        var mittentiList=cmp.get('v.mittentiList');
        var mittenteData=null;
        cmp.get('v.filUffList').forEach(function(temp){
            if(temp['DeveloperName']==cmp.get('v.filUffSelezionato')){
                mittenteData=temp;
                return;
            }
        });
        helper.aggiungiFilUffHelper(cmp,mittenteData);
    }
})