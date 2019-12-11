({
	selectCliente:function(cmp,event,helper){
        var row=event.getParam('selectedRows')[0];
        var action=cmp.get('c.makeAccount');
         console.log('SelectCliente_SelezioneClienteeController');
        action.setParam('c',row);
        action.setParam('societa',cmp.get('v.aziendaSelezionata'));
        action.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){
                cmp.set('v.clienteSelezionato',resp.getReturnValue()['cliente']);
                
                console.log('SelectCliente_v.clienteSelezionato: '+ cmp.get('v.clienteSelezionato'));
            }
            helper.hideSpinner(cmp);
        });
        helper.showSpinner(cmp);
        $A.enqueueAction(action);
	}
})