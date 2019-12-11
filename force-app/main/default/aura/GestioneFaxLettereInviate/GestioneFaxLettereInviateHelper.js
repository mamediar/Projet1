({
    loadColumnsHelper : function(cmp, event, helper) {
        cmp.set('v.lettereInviateColumns' , [
            {label: 'CIP', fieldName: 'codCliente', type: 'text'},
            {label: 'Lettera' ,fieldName: 'codLettera', type:'text'},
            {label: 'Procedura', fieldName: 'procedura', type: 'text'},    
            {label: 'Pratica', fieldName: 'numPratica', type:'text'},
            {label: 'Modalità Invio', fieldName: 'modalitaInvio' ,type:'text'},
            {label: 'Data', fieldName: 'data', type:'text'},
            {label: 'Ora', fieldName: 'ora', type:'text'},
            {label: 'Numero', fieldName: 'numero', type:'text'},
            {label: 'Email', fieldName: 'email', type:'text'},
            {label: 'Operatore' ,fieldName: 'operatore', type:'text'}
        ]);
        
    }
})