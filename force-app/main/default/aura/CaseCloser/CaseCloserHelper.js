({
    behaviour: function(cmp, event) {
        var recordId = cmp.get('v.recordId');
        var action = cmp.get('c.isClose');
        action.setParam('caseId', recordId);
        action.setCallback(this, function(response) {
            if (response.getState() == 'SUCCESS')
                cmp.set('v.isDisabled', response.getReturnValue());
        });
        $A.enqueueAction(action);
    }
})