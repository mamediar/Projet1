({
	onInit : function(cmp,event,helper) {
		helper.onInit(cmp,event,helper);
	},
	changeArea: function(cmp,event,helper){
		helper.changeArea(cmp,event,helper);
	},
	changeRegion: function(cmp,event,helper){
		helper.changeRegion(cmp,event,helper);
	},
	sendFestivityrecord: function(cmp,event,helper){
		helper.sendFestivityrecord(cmp,event,helper);
	},
	changeAllFiliali: function(cmp,event,helper){
		cmp.set("v.allFiliali", !cmp.get("v.allFiliali"));
	},
	handleSave: function(cmp,event,helper){
		helper.handleSave(cmp,event,helper);
	},
	handleRowAction: function (cmp, event, helper) {
		helper.handleRowAction(cmp, event, helper);
	},
	handleCancelMultiRow: function(cmp,event,helper){
		helper.handleCancelMultiRow(cmp,event,helper);
	},
	updateColumnSorting: function (cmp, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        // assign the latest attribute with the sorted column fieldName and sorted direction
        cmp.set("v.sortedBy", fieldName);
        cmp.set("v.sortedDirection", sortDirection);
        helper.sortData(cmp, fieldName, sortDirection);
	}
	
})