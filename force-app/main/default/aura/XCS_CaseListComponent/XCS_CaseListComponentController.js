({
	init: function (cmp, event, helper) {
        helper.doInit(cmp,event,helper);

    },
    updateColumnSorting: function (cmp, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        console.log(fieldName);
        console.log(sortDirection);
        // assign the latest attribute with the sorted column fieldName and sorted direction
        cmp.set("v.sortedBy", fieldName);
        cmp.set("v.sortedDirection", sortDirection);
        helper.sortData(cmp, fieldName, sortDirection);
	},
    filterMethod: function (component, event, helper) {
        var data = component.get("v.dataBackup"),
            term = component.get("v.filterInput"),
            results = data,
            regex;
        try {
            regex = new RegExp(term, "i");
            // filter checks each row, constructs new array where function returns true
            results = data.filter(row => regex.test(row.Categoria_Riferimento__c) || regex.test(row.Esito__c) || regex.test(row.Status) || regex.test(row.Subject) || regex.test(row.CaseNumber));
        } catch (e) {
            // invalid regex, use full list
        }
        component.set("v.data", results);
    }
})