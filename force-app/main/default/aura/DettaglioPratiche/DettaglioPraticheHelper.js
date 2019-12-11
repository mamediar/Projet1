({
	init: function(cmp, event, helper) {
		
        cmp.set('v.columns', [
            {label: 'Pratica', fieldName: 'numPratica', type: 'text',sortable : true},
			{label: 'Tipo', fieldName: 'tipoPratica', type: 'text',sortable : true},
			{label: 'Tipo Pagamento', fieldName: 'tipoPagamento', type: 'text',sortable : true},
			{label: 'Stato', fieldName: 'statoPratica', type: 'text',sortable : true},
			{label: 'EER', fieldName: 'codRecuperatore', type: 'text',sortable : true},
			{label: 'Info Comm', fieldName: 'infoComm', type: 'text',sortable : true/*,cellAttributes:{class: { fieldName: 'status' },iconName: {fieldName : 'icon'}, iconPosition: 'right'}*/},
			{label: 'Disponibilità', fieldName: 'disponibilita', type: 'text',sortable : true}
        ]);
        
        helper.transcodificaMetodoPagamento(cmp);
		
	},
	
	updateColumnSorting: function (cmp, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        cmp.set("v.sortedBy", fieldName);
        cmp.set("v.sortedDirection", sortDirection);
        helper.sortData(cmp, fieldName, sortDirection);
	},

	sortData: function (cmp, fieldName, sortDirection) {
        var data = cmp.get("v.praticheList");
        var reverse = sortDirection !== 'asc';
        //sorts the rows based on the column header that's clicked
        data.sort(this.sortBy(fieldName, reverse))
        cmp.set("v.praticheList", data);
	},
	
    sortBy: function (field, reverse, primer) {
        var key = primer ? function(x) {return primer(x[field])} : function(x) {return x[field]};
        //checks if the two rows should switch places
        reverse = !reverse ? 1 : -1;
        return function (a, b) {
            return a = key(a), b = key(b), reverse * ((a > b || !a) - (b > a || !b));
        }
    },
    transcodificaMetodoPagamento: function(cmp){
        var pratiche = cmp.get('v.praticheList');
        pratiche.forEach(pratica => {
            //transcodifica tipo pagamento
            switch(pratica.tipoPagamento){
                case 'BP':
                    pratica.tipoPagamento = 'Bollettino postale';
                    break;
                case 'RI':
                    pratica.tipoPagamento = 'Rid';
                    break;
                case 'CR':
                    pratica.tipoPagamento = 'Carta';
                    break;
            }
        })
    }
})