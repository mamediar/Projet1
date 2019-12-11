({
    getClienteMap:function(cmp){
        var inputCliente=['cognome','codCliente','nome','dataNascita','codFiscale',
                          'indirizzo','cap','provincia','email','ragioneSociale','comune','telefonoCasa','telCellulare'];
        var clienteMap={};
        inputCliente.forEach(function(temp){
            clienteMap[temp]=cmp.get('v.'+temp);
        });
        return clienteMap;
    },
    
    getPraticaMap:function(cmp){
        var inputPratica=['numPratica','pan','cedCom'];
        var praticaMap={};
        inputPratica.forEach(function(temp){
            praticaMap[temp]=cmp.get('v.'+temp);
        });
        return praticaMap;
    },

    checkLengthField : function(component, event, helper) {

        var change = event.getSource().get("v.name");
        if(change==='cap'){
            var val = component.find("cap").get('v.value');
            if(val.length > 5){
                var comp = component.find("cap");
                comp.set('v.value',val.substring(0,5));
            }
        }else if(change==='telFisso'){
            var val = component.get('v.telefonoCasa');
            if(val.length > 11){
                //var comp = component.get('v.telefonoCasa');
                component.set('v.telefonoCasa',val.substring(0,11));
            }
        }else if(change==='telCell'){
            var val = component.get('v.telCellulare');
            if(val.length > 10){
                //var comp = component.get('v.telCellulare');
                component.set('v.telCellulare',val.substring(0,10));
            }

        }
    },    
    showToastError: function(component) {
        component.find('notifLib').showToast({
            "title": "Error",
            "message": component.get("v.toastMsg"),
            "variant": "error"
        });
    }
})