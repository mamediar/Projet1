({
	removeBook: function (cmp, row) {
        var rows = cmp.get('v.contractList');
        var rowIndex = rows.indexOf(row);

        rows.splice(rowIndex, 1);
        cmp.set('v.contractList', rows);
    }
})