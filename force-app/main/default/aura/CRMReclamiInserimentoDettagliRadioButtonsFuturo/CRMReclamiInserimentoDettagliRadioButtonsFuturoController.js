({
    init:function(cmp,event,helper){
        if(cmp.get('v.campiCase')){
            helper.setFields(cmp);
        }
        cmp.set('v.isOk',helper.checkIfOkHelper(cmp));
        cmp.set('v.output',helper.buildOutputObj(cmp));
    },
    
    checkIfOk:function(cmp,event,helper){
        cmp.set('v.isOk',helper.checkIfOkHelper(cmp));
    },
    
    buildOutput:function(cmp,event,helper){
        cmp.set('v.output',helper.buildOutputObj(cmp));
    }
})