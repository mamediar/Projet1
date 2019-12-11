({
    init:function(cmp,event,helper){
        var action=cmp.get('c.getInitValues');
        action.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){
                cmp.set('v.listaTipoProdottoVita',resp.getReturnValue()['prodVita']);
                cmp.set('v.listaTipoProdottoDanni',resp.getReturnValue()['prodDanni']);
                cmp.set('v.listaAreaAziendale',resp.getReturnValue()['areaAz']);
                cmp.set('v.listaTipoProponente',resp.getReturnValue()['prop']);
                cmp.set('v.listaAreaGeograficaProponente',resp.getReturnValue()['areaProp']);
                cmp.set('v.listaTipoReclamante',resp.getReturnValue()['recl']);
                var cCase=cmp.get('v.campiCase');
                if(cCase){
                    helper.buildInitValues(cmp,cCase);
                }
            }
        });
        $A.enqueueAction(action);
        helper.handleChangeHelper(cmp,helper);
        /*
        if(cmp.get('v.campiCase')['Id']){
            console.log('sono nell init Helper di campi Aggiuntivi');
            helper.initIfGestione(cmp);
        }
        */
            
    },
    
    handleChange:function(cmp,event,helper){
        helper.handleChangeHelper(cmp,helper);
    },
    
    selectValue : function(cmp,event){

    }
})