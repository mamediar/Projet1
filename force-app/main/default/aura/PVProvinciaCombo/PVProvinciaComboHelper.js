({
    
    loadProvince : function (cmp,event,helper) {
        var action = cmp.get('c.loadProvincesApex');
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                cmp.set('v.provinceList', response.getReturnValue());
//                console.log('v.provinceList' + JSON.stringify(cmp.get('v.provinceList')));
            }
        });
        $A.enqueueAction(action);
    },
    
})