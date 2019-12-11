({
	copiaClienteHelper:function(cmp,helper){
        helper.makeMittenteFromClienteHelper(cmp,cmp.get('v.clienteSelezionato'));
	},
    
    copiaCoobbligatoHelper:function(cmp,helper){
        console.log('2-A sono in copiaCoobbligatoHelper'+ cmp.get('v.listaCoobbligati'))
        helper.makeMittentiFromClientiHelper(cmp,cmp.get('v.listaCoobbligati'));
    }, 
    
    makeMittentiFromClientiHelper:function(cmp,coobList){
        console.log('2-A sono in makeMittentIIIIIIIIIFromClientiHelper'+ cmp.get('v.mittentiList'))
        console.log(coobList);
 		var mitList=cmp.get('v.mittentiList');
        if (mitList==null || mitList==''){
             var action=cmp.get('c.makeMittentiFromClientiPR');
        }
        else{
             var action=cmp.get('c.makeMittentiFromClienti');
        }
       
        
        action.setParam('clienti',coobList);
        action.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){
                console.log('MakeMittCoobbl'+resp.getReturnValue());
                console.log(resp.getReturnValue());
                
                resp.getReturnValue().forEach(function(temp){
                	mitList.push(temp);
                });
                cmp.set('v.mittentiList',mitList);
            }
        }); 
         $A.enqueueAction(action);
    },
    
    makeMittenteFromClienteHelper:function(cmp,cliente){
        console.log('2-A sono in makeMittentEEEEEEEEEFromClientiHelper'+cmp.get('v.mittentiList'));
        
                    console.log(cmp.get('v.mittentiList'));
        var mitList=cmp.get('v.mittentiList');
        if (mitList==null || mitList==''){
            var action=cmp.get('c.makeMittenteFromClientePR');
        }
        else{
        	var action=cmp.get('c.makeMittenteFromCliente');
        }
        
        action.setParam('cliente',cliente);
        action.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){
                mitList.push(resp.getReturnValue());
                cmp.set('v.mittentiList',mitList);     
            }
        });
        $A.enqueueAction(action);
    },
    showToastError: function(component) {
        component.find('notifLib').showToast({
            "title": "Error",
            "message": component.get("v.toastMsg"),
            "variant": "error"
        });
    }
})