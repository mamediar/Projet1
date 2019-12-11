({
	doInit: function (cmp, event, helper) {
		cmp.set('v.columns', [
			//{label: 'CASE', fieldName: 'Id', type: 'text'},
			{label: 'CASE', fieldName: 'linkCase', type: 'url',sortable : true, 
				typeAttributes: {label: { fieldName: 'CaseNumber' }, target: '_self'}},
            {label: 'CATEGORIA', fieldName: 'Categoria_Riferimento__c', type: 'text',sortable : true},
            {label: 'OGGETTO', fieldName: 'Subject', type: 'text',sortable : true},
			{label: 'ESITO', fieldName: 'Esito__c', type: 'text',sortable : true},
            {label: 'STATO', fieldName: 'Status', type: 'text',sortable : true},
            {label: 'DATA APERTURA',sortable : true, fieldName: 'CreatedDate', type: 'date', typeAttributes:{
				year: "numeric",
				month: "2-digit",
				day: "2-digit",
				hour: "2-digit",
            	minute: "2-digit"
			}, }
		
		]);
		
		var spinner = cmp.find('spinnerComponent');
        spinner.incrementCounter();
		var action = cmp.get("c.doInitApex");
        action.setParams({
            'caseId': cmp.get("v.recordId"),
            'caseStatus': cmp.get("v.StatusDesired")
        });
        action.setCallback(this, function(response) {
            if ( response.getState() == 'SUCCESS' ) { 
				spinner.decreaseCounter();
				var data=response.getReturnValue();
				
				
				data.forEach(function(record){
                    record.linkCase = '/'+record.Id;
                    if( record.Categoria_Riferimento__c)
                        record.Categoria_Riferimento__c = record.Categoria_Riferimento__r.Name;
					//record.CreatedDate= CreatedDate.format('MM/DD/YYYY')
				}); 
				
                cmp.set("v.data", data);
                cmp.set("v.dataBackup",data);
			}
			else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                        helper.showToast("Error message: " + errors[0].message,"error");
                    }
                    else
                    { helper.showToast("Errore generico","error");}
                } else {
                    helper.showToast("Errore generico:","error");
                }
            }
        });
		$A.enqueueAction(action);
	},
	
	sortData: function (cmp, fieldName, sortDirection) {
        var data = cmp.get("v.data");
        var reverse = sortDirection !== 'asc';
        //sorts the rows based on the column header that's clicked
        data.sort(this.sortBy(fieldName, reverse))
        cmp.set("v.data", data);
    },
    sortBy: function (field, reverse, primer) {
        var key = primer ? function(x) {return primer(x[field])} : function(x) {return x[field]};
        //checks if the two rows should switch places
        reverse = !reverse ? 1 : -1;
        return function (a, b) {
            return a = key(a), b = key(b), reverse * ((a > b || !a) - (b > a || !b));
        }
    },
    showToast : function(message,type){
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			message: message,
			type: type,
			mode: 'sticky'
		});
		toastEvent.fire();
	}
})