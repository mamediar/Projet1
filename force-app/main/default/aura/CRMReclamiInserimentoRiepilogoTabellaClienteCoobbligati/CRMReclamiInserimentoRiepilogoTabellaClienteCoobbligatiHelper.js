({
    buildTableColumns:function(cmp){
        cmp.set('v.columns', [{'label': 'Tipo', 'fieldName': 'tipoCliente', 'type': 'text'},
                              {'label': 'Nome', 'fieldName': 'nome', 'type': 'text' },
                              {'label': 'Cognome', 'fieldName': 'cognome', 'type': 'text'},
                              {'label': 'Sesso', 'fieldName': 'sesso', 'type': 'text'},
                              {'label': 'Cod. OCS', 'fieldName': 'codCliente', 'type': 'text'}]);
    }
})