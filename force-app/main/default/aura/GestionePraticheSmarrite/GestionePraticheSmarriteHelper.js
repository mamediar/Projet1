({
	updateList : function(cmp,event) {
		var action = cmp.get('c.selectContract');
        action.setParams({
            'caseId' : cmp.get('v.recordId'),
            'isAccollo' : cmp.get('v.flagAccolli')
        });
        action.setCallback(this, function(element){
            if(element.getState() == 'SUCCESS'){
                var result = element.getReturnValue();
                var toBeProcessed=[];
                var processed=[];
                result.forEach(function(temp){
                    if(temp['WorkStatus__c']=='404'){
                        toBeProcessed.push(temp);
                    }
                    else{
                        processed.push(temp);
                    }
                });
                cmp.set('v.contractList', toBeProcessed);
                cmp.set('v.checkedContractList', processed);
                if(toBeProcessed.length<=0){
                    this.closeCase(cmp);
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    closeCase : function(cmp){
        var action=cmp.get('c.closeCaseApex');
        action.setParam('caseId',cmp.get('v.recordId'));
        action.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){
                cmp.set('v.disableButton', true);
                cmp.set('v.hideCheckboxColumn', true);
                $A.get('e.force:refreshView').fire();
            }
        });
        $A.enqueueAction(action);
    },

    resetSelection : function(cmp){
        var c = cmp.find('contractTable');
        var arr = cmp.get('v.contractList');
        var selectedRows = c.getSelectedRows();
        for (var i = 0; i < selectedRows.length; i++){
            var indexOfStevie = arr.findIndex(j => j.id == selectedRows[i].id);
            cmp.set('v.contractList',arr.splice(indexOfStevie,1));
        }
    },

    sortData: function (cmp, fieldName, sortDirection) {
        var data = cmp.get("v.contractList");
        var reverse = sortDirection !== 'asc';
        data.sort(this.sortBy(fieldName, reverse));
        cmp.set("v.contractList", data);
    },

    sortBy: function (field, reverse, primer) {
        var key = primer ?
            function(x) {return primer(x[field])} :
        	function(x) {return x[field]};
        reverse = !reverse ? 1 : -1;
        return function (a, b) {
            return a = key(a), b = key(b), reverse * ((a > b) - (b > a));
        }
    }
})