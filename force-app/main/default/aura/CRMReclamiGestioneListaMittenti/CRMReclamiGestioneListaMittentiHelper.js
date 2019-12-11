({
    buildTableColumnsMittente : function(cmp) {
        cmp.set('v.columns', [{'label': 'da','fieldName':'Principale__c','type':'boolean'},
                              {'label': 'Nome', 'fieldName': 'Name__c', 'type': 'text'},
                              {'label': 'Via', 'fieldName': 'Via__c', 'type': 'text' },
                              {'label': 'Città', 'fieldName': 'Citta__c', 'type': 'text'},
                              {'label': 'Provincia', 'fieldName': 'Provincia__c', 'type': 'text'},
                              {'label': 'CAP', 'fieldName': 'Codice_Postale__c', 'type': 'text'}]);
        
    },
    
    eiliminaMittenteHelper : function(cmp,mittente) {
        var listaMittenti = cmp.get('v.mittentiList');
        listaMittenti.splice(listaMittenti.indexOf(mittente), 1);
        cmp.set('v.mittentiList',listaMittenti);
    }
})