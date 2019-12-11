({
    checkIfOk:function(cmp,event,helper){
        cmp.set
        (
            'v.isFormOk',
            cmp.get('v.ragioneSociale') &&
            cmp.get('v.nome') &&
            cmp.get('v.cognome') &&
            cmp.get('v.cedCom') &&
            cmp.get('v.numPratica')
        );
    },
    
    onButtonPressed:function(cmp,event,helper){
        
        var rag = cmp.find('ragSociale').get('v.value');
        var nome = cmp.find('Nome').get('v.value');
        var cogn =cmp.find('Cognome').get('v.value');
        var ced = cmp.find('Cedente').get('v.value');
        var num = cmp.find('NumPratica').get('v.value');
        
        var rag1 =cmp.find('ragSociale').get('v.label');
        var nome1 = cmp.find('Nome').get('v.label');
        var cogn1 =cmp.find('Cognome').get('v.label');
        var ced1 = cmp.find('Cedente').get('v.label');
        var num1 = cmp.find('NumPratica').get('v.label');

        if(cmp.get('v.isFormOk')){
            var action=cmp.get('c.makeCliente');
            action.setParam('clienteMap',helper.getClienteMap(cmp));
            action.setParam('praticaMap',helper.getPraticaMap(cmp));
            action.setCallback(this,function(resp){
                if(resp.getState()=='SUCCESS'){
                   
                    var list=[];
                    list.push(resp.getReturnValue());
                    cmp.set('v.clienteSelezionato',resp.getReturnValue());
                    cmp.set('v.listaClienti',list);
                } else
                    alert('Qualcosa non va (MBCredit Solutions Abbina Contatto) ');
            });
            $A.enqueueAction(action);
        }
        else{
            var msg = 'Compilare i seguenti Campi: ';           
            if(!rag){
                msg = msg + '  ' + rag1;                                                                                            
             }
            
            if(!nome){
                msg = msg  + '  ' + nome1;
            }
            if(!cogn){
                msg = msg  + '  ' + cogn1;
            }
            if(!ced){
                msg = msg  + '  ' + ced1;
            }
            if(!num){
                msg = msg + '  ' + num1;
            }
            cmp.find('notifLib').showNotice({                     
                "variant": "error",                     
                "header": "Attenzione!",                         
                "message": msg                   
            }); 
        }                              
    },
    checkLength : function(component, event, helper) {
        helper.checkLengthField(component, event, helper);
    }
})