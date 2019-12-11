({
    init:function(cmp,event,helper){
        helper.initHelper(cmp);
    },
    
    onChange:function(cmp,event,helper){
        cmp.set('v.attribuzioneReclamo',event.getParam('value'));
    }
})