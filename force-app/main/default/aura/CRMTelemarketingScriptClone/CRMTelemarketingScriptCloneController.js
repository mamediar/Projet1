({
    cloneNewScript : function(cmp, event, helper) {
        cmp.set('v.modal', true);
        
    },
    
    init : function(cmp,event,helper){
        let script = cmp.get('v.ScriptRecord');
        console.log(script.Id);
    }
})