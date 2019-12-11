({
    setColumns:function(cmp){
        cmp.set('v.columns', [{'label': 'N° Reclamo', 'fieldName': 'Numero_Reclamo__c', 'type': 'text'},
                              //{'label': 'Categoria', 'fieldName': 'dataNascita', 'type': 'text'},
                              {'label': 'Categoria', 'fieldName': 'categoryName', 'type': 'text'}, //20190716: anomalie 0001226,0001227 
                              {'label': 'N° Pratica', 'fieldName': 'NumeroPratica__c', 'type': 'text'},
                              {'label': 'Creato il', 'fieldName': 'CreatedDate', 'type': 'date' },
                              //{'label': 'Coda', 'fieldName': 'Owner.Name', 'type': 'text'},
                              {'label': 'Coda', 'fieldName': 'OwnerName', 'type': 'text'}, //20190716: anomalie 0001226,0001227 
                              {'label': 'Stato', 'fieldName': 'Status', 'type': 'text'}]);
        
    },
    
    initHelper:function(cmp){
        var praticaCode=cmp.get('v.praticaSelezionata')?cmp.get('v.praticaSelezionata')['numPratica']:null;
        var clienteCode=cmp.get('v.clienteSelezionato')['SFId'];
        var nReclamo=cmp.get('v.numeroReclamo');
        
        var Azienda = cmp.get('v.aziendaSelezionata');
        console.log('aziendaselezionata:::::: '+Azienda);
        if (Azienda=='Compass'){ 
        	var action=cmp.get('c.getReclami');
        }
        else{
            var action=cmp.get('c.getReclamiMB_Fututo');
        }
        action.setParam('nReclamo',nReclamo);
        action.setParam('clienteCode',clienteCode);
        action.setParam('praticaCode',praticaCode);
        action.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){
                //20190716: anomalie 0001226,0001227 
                var reclami = resp.getReturnValue();
                for (var i=0; i<reclami.length; i++) {
                    reclami[i].OwnerName = reclami[i].Owner.Name;
                    reclami[i].categoryName = reclami[i].Categoria_Riferimento__r.Name;
                }
                //cmp.set('v.listaReclamiPrecedenti',resp.getReturnValue());
                cmp.set('v.listaReclamiPrecedenti',reclami);
            }
        });
        $A.enqueueAction(action);
    }
})