({
    init:function(cmp,event,helper){
        cmp.set('v.initAggiuntivi',true);
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
        if(cmp.get('v.campiCase')['Id']){
            console.log('sono nell init Helper di campi Aggiuntivi');
            helper.initIfGestione(cmp);
        }
        
    },
    
    handleChange:function(cmp,event,helper){
        helper.handleChangeHelper(cmp,helper);
    },
    
    selectValue : function(cmp,event,helper){    	
        alert('value = ' +  cmp.get('v.tipoProdottoVita'));
    },
    
    deselProdottoVita : function(cmp){
        cmp.set('v.tipoProdottoVitaInit','Selezionare');
    },
    
    deselProdottoDanni : function(cmp){
        cmp.set('v.tipoProdottoDanniInit','Selezionare');
    },
    
    deselProdottoArea : function(cmp){
        cmp.set('v.tipoProdottoAreaInit','Selezionare');
        
    },
    deselTipoReclamante : function(cmp){
        cmp.set('v.tipoReclamanteInit','Selezionare');
        
    },    
    deselareaGeograficaProponente : function(cmp){
        cmp.set('v.areaGeograficaProponenteInit','Selezionare');
        
    },
    deselTipoProponente : function(cmp){
        cmp.set('v.tipoProponenteInit','Selezionare');
        
    },
    
    salvaReclamoCampiAggiuntivi : function(cmp){
        var res = {};
        res['trattabile'] = cmp.get('v.trattabile');
        res['tipoProdottoVita'] = cmp.get('v.tipoProdottoVita');
        res['tipoProdottoDanni'] = cmp.get('v.tipoProdottoDanni');
        res['areaAziendale'] = cmp.get('v.areaAziendale');
        res['tipoProponente'] = cmp.get('v.tipoProponente');
        res['tipoReclamante'] = cmp.get('v.tipoReclamante');
        res['areaGeograficaProponente'] = cmp.get('v.areaGeograficaProponente');
        
        
        return res;
        /*
        alert('salva reclamo campi');
        var action=cmp.get('c.salvaReclamoCampiAggiuntiviApex');
        action.setParams({'recordId' : cmp.get('v.campiCase')['Id'],
            			  'trattabile' : cmp.get('v.trattabile'),
                          'tipoProdottoVita' : cmp.get('v.tipoProdottoVita'),
                          'tipoProdottoDanni' : cmp.get('v.tipoProdottoDanni'),
                          'areaAziendale' : cmp.get('v.areaAziendale'),
                          'tipoProponente' : cmp.get('v.tipoProponente'),
                          'areaGeograficaProponente' : cmp.get('v.areaGeograficaProponente'),
                          'tipoReclamante' : cmp.get('v.tipoReclamante')
            
        });
        action.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){
              alert('campi aggiunti salvati?');
            }
            else
                alert('ups qualcosa non va');
        });
        $A.enqueueAction(action);
        */
    }
    
})