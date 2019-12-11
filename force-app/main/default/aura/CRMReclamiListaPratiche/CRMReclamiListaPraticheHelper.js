/*
({
    setColumns:function() {
        return ([{'label': 'Info', 'fieldName': 'info', 'type': 'text'},
                 {'label': 'Info2', 'fieldName': 'info2', 'type': 'text'}]);
    }
})
*/
({
    setColumns:function() {
        return ([
            {'label': 'Numero Pratica', 'fieldName': 'numPratica2', 'type': 'text'},
            {'label': 'Tipologia', 'fieldName': 'tipologia', 'type': 'text'},
            {'label': 'Stato', 'fieldName': 'stato', 'type': 'text'},
            {'label': 'PAN', 'fieldName': 'pan', 'type': 'text'},
            {'label': 'Class', 'fieldName': 'classe', 'type': 'text'},
            //{'label': 'Uff. Class.', 'fieldName': '', 'type': 'text'},
            {'label': 'Mod. Pag.', 'fieldName': 'modPag', 'type': 'text'},
            {'label': 'Dealer', 'fieldName': 'dealer', 'type': 'text'},
            {'label': 'Assicurazioni', 'fieldName': 'assicurazioni', 'type': 'text'}
        ]);
    },
     setColumnsF:function() {
        return ([
            {'label': 'Numero Pratica', 'fieldName': 'numPratica2', 'type': 'text'},
            {'label': 'Tipologia', 'fieldName': 'tipologia', 'type': 'text'},
            {'label': 'Stato', 'fieldName': 'stato', 'type': 'text'},
            {'label': 'ATC', 'fieldName': 'aziendaRagSoc', 'type': 'text'},
            {'label': 'Assic.Impegno/Pensione', 'fieldName': 'assicImpiegoRagSoc', 'type': 'text'},
            {'label': 'Assic.Vita', 'fieldName': 'assicVitaRagSoc', 'type': 'text'},
            {'label': 'Partner', 'fieldName': 'agenteRagSoc', 'type': 'text'},
            {'label': 'Class', 'fieldName': 'classe', 'type': 'text'},
            {'label': 'Uff. Class.', 'fieldName': 'uffClass', 'type': 'text'},
        ]);
    }
})