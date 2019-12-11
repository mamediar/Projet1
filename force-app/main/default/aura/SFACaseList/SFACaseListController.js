({

	init: function (cmp, event, helper) {

		var colonne = cmp.get('v.colonne');
		var stato;

		if (cmp.get('v.stato'))
			stato = (cmp.get('v.stato')).toString();

		if (colonne && stato) {

			colonne = colonne.split(' ').join('');
			cmp.set('v.colonne', colonne);

			stato = stato.split(' ').join('').split(',');
			cmp.set('v.stato', stato);

			var caseId = cmp.get('v.recordId');
			var action = cmp.get("c.getCases");
			action.setParams({
				colonne: colonne,
				status: stato,
				caseId: caseId
			});
			action.setCallback(this, function(r){
				if (r.getState() == 'SUCCESS'){
					var result = r.getReturnValue();
					if(result == null){
						cmp.set("v.report", result.message);
						cmp.set("v.severity", result.statusMessage);
						cmp.set("v.errorTableFlag", true);
					}
					else{

						cmp.set("v.errorTableFlag", false);
						cmp.set("v.caseList", result);
						cmp.set("v.caseTableFlag", true);
                        if (result)
                            cmp.set("v.caseListSize", result.length);

						console.log("*** result :: " + JSON.stringify(result));
					}
				}

			});
			$A.enqueueAction(action);
		}
	},

	handleRowSelection: function (cmp, event, helper) {
		var selectedRows = event.getParam('selectedRows');
		var selectedContractIds = [];
		for (var i=0; i<selectedRows.length; i++) {
			selectedContractIds.push(selectedRows[i].Id);
		}

		cmp.set("v.selectedRows", selectedContractIds);
	}
})