({
    init:function(cmp,event,helper){
        
       
        var action=cmp.get('c.getInitValues');
        action.setParam('societa',cmp.get('v.aziendaSelezionata'));
        action.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){
                if(cmp.get('v.aziendaSelezionata')=='MBCredit Solutions'){
                    cmp.set('v.listaValoriTipoCache',resp.getReturnValue()['tipiList']);
                }
                else{
                    cmp.set('v.listaValoriTipo',resp.getReturnValue()['tipiList']);
                }
                cmp.set('v.modalitaList',resp.getReturnValue()['modList']);
                helper.initHelper(cmp);
                cmp.set('v.isOk',helper.checkValuesHelper(cmp,helper));
                cmp.set('v.outputObj',helper.buildOutputObj(cmp));
            }
        });
        $A.enqueueAction(action);
        
       
    },
    
    handleChange:function(cmp,event,helper){
        var label=event.getSource().get('v.label');
        var codeRes=[];
        
        if(label=='Area' && cmp.get('v.aziendaSelezionata')=='MBCredit Solutions'){
            helper.buildTipoValues(cmp);
        }
        if(label=='Tipo'){
            cmp.get('v.listaValoriTipo').forEach(function(temp){
                if(temp['External_Id__c']==cmp.get('v.tipoDettagli') ){
                    
                    cmp.set('v.descrizioneTipo', temp.Descrizione__c);
                    console.log('HEADER - HANDLECHANGE descrizioneTipo' + cmp.get('v.descrizioneTipo'));
                    if(temp['Descrizione__c'].includes('Assicurazione')){
                        cmp.set('v.isAssicurazione',true);
                        cmp.set('v.showDecisione',false);
                        
                    }
                    else{
                        cmp.set('v.isAssicurazione',false);
                        if(temp['Descrizione__c'].includes('Decisione')){
                            cmp.set('v.showDecisione',true);
                        }
                        else{
                            cmp.set('v.showDecisione',false);
                        }
                    }
                }
            });
        }
        if(!label && event.getParam('value')==false){
            cmp.set('v.reclamoCompleto',null);
        }
        cmp.set('v.isOk',helper.checkValuesHelper(cmp,helper));
        cmp.set('v.outputObj',helper.buildOutputObj(cmp));
        helper.aggiornaCoda(cmp,event,helper);
    },
    
    checkIfCompiled:function(cmp,event,helper){
        helper.checkIfCompiled(cmp);
    },
    
    aggiornaCoda:function(cmp,event,helper){
        helper.aggiornaCoda(cmp,event,helper);
        /*
        var cmpEvent = cmp.getEvent("aggiornaDettagli");
        if(cmpEvent!=undefined) cmpEvent.fire();
        */

    }
    
    
})