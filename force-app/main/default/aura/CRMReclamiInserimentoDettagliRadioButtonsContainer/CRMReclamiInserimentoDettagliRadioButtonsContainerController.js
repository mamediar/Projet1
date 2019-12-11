({
    init:function(cmp,event,helper){
         if(cmp.get('v.campiCase')){
            helper.setFields(cmp);
        }
        cmp.set('v.isOk',helper.checkIfOkHelper(cmp));
        cmp.set('v.outputObj',helper.buildOutputObj(cmp));
        console.log('INIZIO Reclami Inserimento Dettagli RadioButtons Container');
        console.log(cmp.get('v.dettagliOutputObj'));
        console.log('FINE Reclami Inserimento Dettagli RadioButtons Container');
    },
    
    handleChange:function(cmp,event,helper){
        cmp.set('v.isOk',helper.checkIfOkHelper(cmp));
        cmp.set('v.outputObj',helper.buildOutputObj(cmp));
    }
})