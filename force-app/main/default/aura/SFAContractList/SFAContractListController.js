({

	init: function (cmp, event, helper) {

		var colonne = cmp.get('v.colonne');
		var stato = (cmp.get('v.stato')).toString();

		if (colonne && stato) {

			colonne = colonne.split(' ').join('');
			cmp.set('v.colonne', colonne);

			stato = stato.split(' ').join('').split(',');
			cmp.set('v.stato', stato);

			var caseId = cmp.get('v.recordId');
			var action = cmp.get("c.getContratti");
			action.setParams({
				colonne: colonne,
				workStatus: stato,
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
						cmp.set("v.contractList", result);
						cmp.set("v.contractTableFlag", true);
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