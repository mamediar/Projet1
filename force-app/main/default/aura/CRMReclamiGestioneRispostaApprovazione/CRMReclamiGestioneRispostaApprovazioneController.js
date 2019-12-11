({
	init:function(cmp, event, helper){
        helper.init(cmp,helper);
	},
    
    richiediAutorizzazione : function(cmp, event, helper){
        helper.richiediAutorizzazioneHelper(cmp);
    },
    
    handleClick : function(cmp,event,helper){
        var label=event.getSource().get('v.label');
        helper.autorizzaRespingi(cmp,label);
    }
    
})