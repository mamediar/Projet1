({
    
    init : function (cmp,event,helper) {
        helper.loadColumnsHelper(cmp,event,helper);
        cmp.set('v.comunicazioniPresenti', true);
    },
    
    getTable : function(cmp, event, helper) {
        console.log('sono PRIMA DELLA CALLBACK');
        var action = cmp.get('c.getComunicazioni');
        
        console.log('numero Pratica ' + cmp.get('v.numeroPratica'));
        console.log('codice cliente ' + cmp.get('v.codiceCliente'));
        console.log('tipo pratica ' + cmp.get('v.tipoPratica'));
        
        action.setParams({
            'numPratica': cmp.get('v.numeroPratica'),
            'tipoPratica' : cmp.get('v.tipoPratica'),
            //  'dataDa' : cmp.get('v.data')
            'codCliente' : cmp.get('v.codiceCliente')
            
        });
        
        //console.log('data: ' +cmp.get('v.data'));
        
        action.setCallback(this,function(response){
            
            var state = response.getState();
            console.log('STATO:::::::::::::::> ' + state);
            
            if(state=='SUCCESS') {
                console.log('sono nella CALLBACK');
                cmp.set('v.lettereInviateData', response.getReturnValue());
                if (response.getReturnValue() && response.getReturnValue().length > 0){
                    cmp.set('v.comunicazioniPresenti', true);
                    cmp.set('v.hideMessage',true);
                    console.log('comunicazioniPresenti::::::::::::> ' + cmp.get('v.comunicazioniPresenti'));
                }
                else {
                    cmp.set('v.hideMessage',false);
                    cmp.set('v.comunicazioniPresenti', false);
                    console.log('sono NELL IF FALSO');
                    console.log('comunicazioniPresenti::::::::::::> ' + cmp.get('v.comunicazioniPresenti'));
                    console.log('hideMessage::::::::::::> ' + cmp.get('v.hideMessage'));
                }
            }
            
        });
        $A.enqueueAction(action);
        
    } 
})