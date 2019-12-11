({
	aggiungiFilUffHelper:function(cmp,mitData){
        if(mitData){
            console.log(mitData);
            var action=cmp.get('c.makeMittente');
            action.setParam('m',mitData);
            action.setCallback(this,function(resp){
                if(resp.getState()=='SUCCESS'){
                    var mitList=cmp.get('v.mittentiList');
                    mitList.push(resp.getReturnValue());
                    cmp.set('v.mittentiList',mitList);
                }
            });
            $A.enqueueAction(action);
        }
        else{
            alert('Filiale/Ufficio non selezionato.');
        }
	}
})