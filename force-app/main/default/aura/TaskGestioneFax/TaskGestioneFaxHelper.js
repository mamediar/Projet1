({
    setOptions : function(cmp) {
        cmp.set('v.esitoOptions', [
            {label:'OK', value:'ok'},
            {label:'KO', value:'ko'},
            {label:'Doppio', value:'doppio'},
            {label:'Recall', value:'recall'}
        ]);
        
        cmp.set('v.configMetadataColumns', [
            {label: 'Tipologia', fieldName: 'Tipologia', type: 'Text'},           
            {label: 'Codice', fieldName: 'Codice', type: 'Text'}              
        ]);
    },
    
    setTask : function(cmp){
        var action = cmp.get('c.getCase');
        action.setParam('objId', cmp.get('v.recordId'));
        action.setCallback(this, function(response){
            console.log( response.getReturnValue() )
            if(response.getState() == 'SUCCESS'){
                var objWrap = response.getReturnValue();
                console.log( objWrap );
                cmp.set('v.statoAzione', objWrap.Stato_Azione__c);
                cmp.set('v.CodCliente', objWrap.Account.getCodice_Cliente__c);
                cmp.set('v.CodPratica', objWrap.NumeroPratica__c);
                cmp.set('v.CodProdotto', objWrap.Product__r.Name);
                cmp.set('v.TipoProdotto', objWrap.Product__r.ProductCode);
                cmp.set('v.idProd', objWrap.Product__r.RSS_External_Id__c);
                cmp.set('v.idCat', objWrap.Categoria_Riferimento__r.External_Id__c);
                cmp.set('v.recallCount', objWrap.TentativoNum__c);
                cmp.set('v.caseId', objWrap.ParentId);
                cmp.set('v.esitoValue', objWrap.GestioneFax_Esito__c);
                cmp.set('v.statoComunicazioneFinale',objWrap.Stato_Comunicazione__c);
                
                if(objWrap.Status == 'Annullato'){
                    cmp.set('v.isAnnullato', false);
                }
               /*  var action2 = cmp.get('c.getConfigFax');
                action2.setParams({'idProdotto' : cmp.get('v.idProd'),
                                   'idCategoria': cmp.get('v.idCat')                          
                                  });
                action2.setCallback(this, function(response){
                    if(response.getState() == 'SUCCESS'){
                        cmp.set('v.recallMax',response.getReturnValue());
                        console.log('recall max compontente padre = ' + cmp.get('v.recallMax'));                        
                    }
                });
                $A.enqueueAction(action2);     */
            }            
        });
        $A.enqueueAction(action);
    },
    
    sideHide : function(element){
        element.style.setProperty('width', element.offsetWidth + 'px');
        setTimeout(function(){element.style.setProperty('width', 0);}, 1);        
        setTimeout(function(){
            element.style.setProperty('display', 'none');
            element.style.removeProperty('width');
        }, 301);  
    },
    
    navigateToMyComponentPostVendita : function(idPostVendita, codiceCliente, attachments ) {
        console.log('sono arrivato in navigateToMyComponentPostVendita');
        var evt = $A.get("e.force:navigateToComponent");
        
        var component = {
            componentDef : "c:PVInserimento",
            componentAttributes: {
                parametriEsterni : { 
                    "codCategoria" :  idPostVendita, 
                    "codClienteOCS" : codiceCliente,
                    "attachmentsIDs" : attachments }
            }
        }


        console.log( component );

        evt.setParams( component );        
        evt.fire();
    },

    nuovoPv : function(cmp, helper, response ) {
        var codiceCliente = cmp.get('v.CodCliente')
        var responseAttach = response.getReturnValue();
        var attachs = Array.isArray( responseAttach ) ? responseAttach : [ responseAttach ];
        console.log( 'attachments: ' + response.getReturnValue() );
        helper.navigateToMyComponentPostVendita('', codiceCliente, attachs );
    },

    eseguiAzione : function(cmp)
    {

    },

    getAttachs : function( cmp, helper, idCase, callback ) {
        var params = { idCase : cmp.get('v.caseId') };
        var action = cmp.get("c.getAttachments");
        action.setParams( params );
        action.setCallback(this, function( response ){
            console.log( response );
            if (response.getState() === "SUCCESS") {
                callback( cmp, helper, response )
            }
            else
            {
                var toast = $A.get('e.force:showToast');
                    toast.setParams({
                        title : 'Errore',
                        type : 'error',
                        message : ''
                    });
                    toast.fire();         
            }
        })

        $A.enqueueAction(action);
    },
    
    checkAzione : function(cmp, event, helper){
        var action = cmp.get("c.checkStatusAzione");
        action.setParam('objId', cmp.get('v.recordId'));
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                cmp.set('v.statoAzione', response.getReturnValue());
            }
        });
        $A.enqueueAction(action);        
    },
    
    checkComunicazione : function(cmp, event, helper){
        var action = cmp.get("c.checkStatusComunicazione");
        action.setParam('objId', cmp.get('v.recordId'));
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                cmp.set('v.statoComunicazioneFinale', response.getReturnValue());
            }
        });
        $A.enqueueAction(action);                          
    },
    
    setToastAzione : function(cmp,event,helper){
        var toast = $A.get('e.force:showToast');
        toast.setParams({
            title : 'E\' necessario eseguire l\'azione prima di concludere la lavorazione',
            type : 'error',
            message : ' '
        });
        toast.fire();
    },
    
    setToastComunicazione : function(cmp,event,helper){
        var toast = $A.get('e.force:showToast');
        toast.setParams({
            title : 'E\' necessario eseguire la comunicazione',
            type : 'error',
            message : ' '
        });
        toast.fire();
    },
    
    setToastSuccess : function(cmp,event,helper){
        var toast = $A.get('e.force:showToast');
        toast.setParams({
            title : 'Stato del task completato',
            type : 'success',
            message : ' '
        });
        toast.fire();       
    },
    
    setToastSuccessRecall : function(cmp,event,helper){
        var toast = $A.get('e.force:showToast');
        toast.setParams({
            title : 'Contatore di Recall aggiornato',
            type : 'success',
            message : ' '
        });
        toast.fire();       
    },
    
    setToastEsito : function(cmp,event,helper){
        var toast = $A.get('e.force:showToast');
        toast.setParams({
            title : 'Valorizzare campo Esito',
            type : 'error',
            message : ' '
        });
        toast.fire();
    },
    
    setToastDataRecall : function(cmp,event,helper){
        var toast = $A.get('e.force:showToast');
        toast.setParams({
            title : 'Il campo Data Recall è obbligatorio',
            type : 'error',
            message : ' '
        });
        toast.fire();        
    },
    
    setToastComunicazioneInviate : function(cmp,event,helper){
        var toast = $A.get('e.force:showToast');
        toast.setParams({
            title : 'Non sono presenti comunicazioni',
            type : 'error',
            message : ' '
        });
        toast.fire();        
    },
    
    updateEsito : function(cmp,event,helper){
        var action = cmp.get("c.updateEsitoTask");       
        action.setParams({
            'esito' : cmp.get('v.esitoValue'),
            'objId' : cmp.get('v.recordId')                                  
        });        
        $A.enqueueAction(action);        
    }

})