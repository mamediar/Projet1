//----------------------------------------------------------------------
//-- - Controller JS Name : CRMReclamiGestioneMittentiMainHelper.js
//-- - Autor              : Fabio Giuliani(Lynx)
//-- - Date               : 21/05/2019
//-- - Description        : 
//-- - Version            : 1.0
//----------------------------------------------------------------------
({
	copiaClienteHelper:function(cmp,helper){
        console.log('--------------------------------------------------------------------------------------');
        console.log('-- Controller JS : CRMReclamiGestioneMittentiMainHelper - Method: copiaClienteHelper'); 
        helper.makeMittenteFromClienteHelper(cmp,cmp.get('v.clienteSelezionato'));
	},
    
    copiaCoobbligatoHelper:function(cmp,helper){
        console.log('--------------------------------------------------------------------------------------');
        console.log('-- Controller JS : CRMReclamiGestioneMittentiMainHelper - Method: copiaCoobbligatoHelper'); 
        helper.makeMittentiFromClientiHelper(cmp,cmp.get('v.praticaSelezionata')['elencoCoobbligati']);
    },
    
    makeMittentiFromClientiHelper:function(cmp,coobList){
        console.log('--------------------------------------------------------------------------------------');
        console.log('Controller JS: CRMReclamiGestioneMittentiMainHelper -Method: makeMittentiFromClientiHelper1'+ cmp.get('v.mittentiList'));

        var mitList=cmp.get('v.mittentiList');
        var action=cmp.get('c.makeMittentiFromClienti');
        action.setParam('clienti',coobList);
        action.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){
                mitList.concat(resp.getReturnValue());
                cmp.set('v.mittentiList',mitList);
                console.log('Controller Js: CRMReclamiGestioneMittentiMainHelper -Method: makeMittentiFromClientiHelper1_POST'+ cmp.get('v.mittentiList'));
            }
        });
    },
    
    makeMittenteFromClienteHelper:function(cmp,cliente){
        console.log('--------------------------------------------------------------------------------------');
        console.log('Controller JS: CRMReclamiGestioneMittentiMainHelper -Method: makeMittenteFromClienteHelper2'+cmp.get('v.mittentiList'));

        var mitList=cmp.get('v.mittentiList');
        var action=cmp.get('c.makeMittenteFromCliente');
        action.setParam('cliente',cliente);
        action.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){
                mitList.push(resp.getReturnValue());
                cmp.set('v.mittentiList',mitList);
                console.log('Controller JS: CRMReclamiGestioneMittentiMainHelper -Method: makeMittenteFromClienteHelper2_POST'+cmp.get('v.mittentiList'));
            }
        });
        $A.enqueueAction(action);
    }
})