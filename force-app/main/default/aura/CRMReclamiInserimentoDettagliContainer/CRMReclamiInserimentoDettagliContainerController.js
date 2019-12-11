({
    init:function(cmp,event,helper){
          
        var action=cmp.get('c.getContattiPrecedenti');
        action.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){ 
                cmp.set('v.contattiPrecedenti',resp.getReturnValue());
                cmp.set('v.isOk',helper.checkIfOkHelper(cmp));
                cmp.set('v.dettagliOutputObj',helper.buildOutputObj(cmp));
                
            }
        });
        $A.enqueueAction(action);
     var coda= cmp.find("CRMReclamiInserimentoDettagliSelezioneCoda");
        coda.refresh();  
    },
    
    handleChange:function(cmp,event,helper){
        cmp.set('v.isOk',helper.checkIfOkHelper(cmp));
        var coda = cmp.get('v.codaSelezionata');
     
        cmp.set('v.dettagliOutputObj',helper.buildOutputObj(cmp));
    }, 
    
    refresh : function(cmp,event,helper){
        var coda= cmp.find("CRMReclamiInserimentoDettagliSelezioneCoda");
        coda.refresh();  
        cmp.set('v.dettagliOutputObj',helper.buildOutputObj(cmp));
    }
})