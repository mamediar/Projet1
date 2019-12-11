({
    setColumns : function(cmp) {
        var columns = [{label : 'Nome', fieldName : 'Name' },
                       {label : 'File', fieldName : 'Description' }];
        cmp.set('v.columns', columns);
    },
    
    loadAllegati : function(cmp) {
        var action = cmp.get('c.loadObjects');
        action.setParam('recordId', cmp.get('v.recordId'));
        action.setCallback(this,function(response){
            cmp.set('v.listaAllegati', response.getReturnValue()['allegatiSelezionati']);
            cmp.set('v.caseParent', response.getReturnValue()['caseParent']);
            cmp.set('v.codaIDM', response.getReturnValue()['codaIDM']);
            cmp.set('v.caseChild', response.getReturnValue()['caseChild']);
        });
        $A.enqueueAction(action);
    }
})