({
    buildTableColumnsMittente : function(cmp) {
        cmp.set('v.columns', [{'label': 'da','fieldName':'Principale__c','type':'boolean'},
                              {'label': 'Nome e Cognome', 'fieldName': 'Name__c', 'type': 'text'},
                              {'label': 'Via e numero civico', 'fieldName': 'Via__c', 'type': 'text' },
                              {'label': 'Città', 'fieldName': 'Citta__c', 'type': 'text'},
                              {'label': 'Provincia', 'fieldName': 'Provincia__c', 'type': 'text'},
                              {'label': 'CAP', 'fieldName': 'Codice_Postale__c', 'type': 'text'}]);
        
    },
    
    eiliminaMittenteHelper : function(cmp,mittente) {
        var listaMittenti = cmp.get('v.mittentiList');
        debugger;
        if(listaMittenti.length==1){
            cmp.set("v.toastMsg", "Impossibile eliminare, almeno un elemento deve essere presente nella lista");
            this.showToastError(cmp);
            //alert('Impossibile eliminare, almeno un elemento deve essere presente nella lista');
        }else{
            listaMittenti.splice(listaMittenti.indexOf(mittente), 1);
            cmp.set('v.mittentiList',listaMittenti);
        }
        
    },

    showToastSuccess: function(component) {
        component.find('notifLib').showToast({
            "title": "Success",
            "message": component.get("v.toastMsg"),
            "variant": "success"
        });
    },
    
    showToastError: function(component) {
        component.find('notifLib').showToast({
            "title": "Error",
            "message": component.get("v.toastMsg"),
            "variant": "error"
        });
    }
})