({
    init : function(cmp, event, helper) {
        helper.setOptions(cmp);
        helper.setTask(cmp);
    },
    
    forceAction : function(cmp, event, helper){
        var toast = $A.get('e.force:showToast');
        var action = cmp.get('c.updateStatus');
        action.setParams({
            'objId' : cmp.get('v.recordId'),
            'status' : 'Azione Forzata'
        });
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                var buttonItem = cmp.find('forceActionContainer').getElement();
                helper.sideHide(buttonItem);
                cmp.set('v.statoAzione','Azione Forzata');
                toast.setParams({
                    title : 'Stato Azione aggiornato con successo',
                    type : 'success',
                    message : ' '
                });
                toast.fire();
            }
        });
        $A.enqueueAction(action);
    },
    
    updateComunicazione : function(cmp, event, helper){
        var toast = $A.get('e.force:showToast');
        var action = cmp.get('c.updateStatusConunicazione');
        action.setParams({
            'objId' : cmp.get('v.recordId'),
            'status' : 'Forzata'
        });
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){                
                toast.setParams({
                    title : 'Stato comunicazione aggiornato con successo',
                    type : 'success',
                    message : ' '
                });
                toast.fire();
                cmp.set('v.statoComunicazioneFinale','Forzata');
            }
        });
        $A.enqueueAction(action);
    },
    
    launchPostVendita : function(cmp, event, helper){
        var Idprodotto = cmp.get('v.idProd');
        var Idcategoria = cmp.get('v.idCat');
        var idRec = cmp.get("v.caseId");
        var codCliente = cmp.get("v.CodCliente");
        var action = cmp.get("c.launchPV");
        action.setParams({
            "IdProdotto": Idprodotto,
            "IdCategoria": Idcategoria,
            "recordId" : idRec,
            "codCliente" : codCliente
        });
        
        var flowParameters = {};
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                flowParameters = response.getReturnValue() ;
                console.log( 'response: ' + JSON.stringify(flowParameters) );
                if ( flowParameters ) {    
                    helper.navigateToMyComponentPostVendita( flowParameters.config.operation_cat_id__c, cmp.get('v.CodCliente'), flowParameters.ids );
                    
                    var action2 = cmp.get('c.updateStatus');
                    action2.setParams({
                        'objId' : cmp.get('v.recordId'),
                        'status' : 'Azione Eseguita'
                    });
                    action2.setCallback(this, function(response) {
                        var state2 = response.getState();
                        if (state2 === "SUCCESS") {
                            cmp.set('v.statoAzione','Azione Eseguita');
                        }
                    });                    
                    $A.enqueueAction(action2);
                }
                else{
                    var toast = $A.get('e.force:showToast');
                    toast.setParams({
                        title : 'Non è prevista alcuna Azione nel CRM',
                        type : 'error',
                        message : ' '
                    });
                    toast.fire();                    
                }
            }              
        });
        $A.enqueueAction(action);
    },
    
    navigateToNewTab : function(component, event, helper) {
        helper.getAttachs( component, helper, component.get('v.caseId'), helper.nuovoPv );
    },
    
    getTable : function(cmp, event, helper) {
        var esito = event.getSource().get('v.value');
        cmp.set('v.esitoValue',esito);
        cmp.set('v.selectedRows',[]);
        
        var isOk = cmp.get('v.esitoValue',esito);    
        if(isOk == 'ok' || isOk == 'ko')
            cmp.set('v.isVisibleForComunicazione',true);
        else{
            cmp.set('v.isVisibleForComunicazione',false);
            cmp.set('v.isInviata',false);
        }
        
        var params = {
            'esito' : cmp.get('v.esitoValue'),
            'IdProdotto': cmp.get('v.idProd'),
            'IdCategoria':cmp.get('v.idCat')                                  
        };
        console.log( params );
        var action = cmp.get("c.getComunicazioni");       
        action.setParams( params );        
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                console.log( response.getReturnValue() )
                cmp.set('v.configMetadataData', response.getReturnValue());                
            }            
        });
        $A.enqueueAction(action);
        helper.updateEsito(cmp);
    },
    
    setValueForEvo : function(cmp,event,helper){
        var valore= event.getParam('selectedRows')[0].Codice ? event.getParam('selectedRows')[0].Codice : '';
        cmp.set('v.codComunicazione',valore);       
        cmp.set('v.concatForEvo',cmp.get('v.CodPratica') + cmp.get('v.codComunicazione'));        
    },
    
    annullaTask : function(cmp, event, helper){
        var toast = $A.get('e.force:showToast');
        cmp.set('v.isAnnullato',false);        
        var action = cmp.get('c.updateTaskStatus');
        action.setParams({
            'objId' : cmp.get('v.recordId'),
            'status' : 'Annullato'
        });
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                toast.setParams({
                    title : 'Stato del task annullato',
                    type : 'success',
                    message : ' '
                });
                toast.fire();
                var tabId;
                var tabIdParent;
                var workspaceAPI = cmp.find("workspace");
                workspaceAPI.getFocusedTabInfo().then(function(response) {
                    workspaceAPI.isSubtab({
                        tabId: response.tabId,
                        tabIdParent:response.parentTabId
                    }).then(function(response) {
                        if (response) {
                            workspaceAPI.closeTab({tabId: tabId});
                        }
                        else {
                            workspaceAPI.closeTab({tabId: tabIdParent});
                            var navEvt = $A.get("e.force:navigateToSObject");
                            navEvt.setParams({
                                "recordId": cmp.get('v.caseId')
                            });
                            navEvt.fire();                           
                        }
                    });                    
                })
                
            }
        });
        $A.enqueueAction(action);        
    },
    
    finalConfirm : function(cmp,event,helper){        
        helper.checkAzione(cmp);
        helper.checkComunicazione(cmp);
        
        var isComunicazioniPresenti = cmp.get('v.isComunicazioniPresenti');
        var esito = cmp.get('v.esitoValue');
        var statoAzione = cmp.get('v.statoAzione');
        var statoComunicazione = cmp.get('v.statoComunicazioneFinale');
        var dataRecall = cmp.get('v.recallDate');
        var isRadioButton = cmp.get('v.isRadioButtonSi');
        
        if(!esito){
            helper.setToastEsito(cmp);           
        }
        else if (esito == 'ok' || esito == 'ko'){
            if(statoAzione == 'Azione Forzata' || statoAzione == 'Azione Inviata'){
                if(statoComunicazione == 'Forzata' || (statoComunicazione == 'Inviata' && isComunicazioniPresenti)){
                    var action = cmp.get('c.updateCaseTaskStatus');
                    action.setParams({
                        'objId' : cmp.get('v.recordId'),
                        'status' : 'Closed',
                        'idCase' : cmp.get('v.caseId'),
                        'note' : cmp.get('v.note')
                    });            
                    action.setCallback(this, function(response){
                        if(response.getState() == 'SUCCESS'){
                            helper.setToastSuccess(cmp);
                            $A.get('e.force:refreshView').fire();
                        }
                    });
                    $A.enqueueAction(action);
                    
                }
                else if(statoComunicazione == 'Inviata' && !isComunicazioniPresenti){
                    helper.setToastComunicazioneInviate(cmp);
                }        
                    else if(!(statoComunicazione == 'Forzata' || statoComunicazione == 'Inviata')){
                        helper.setToastComunicazione(cmp);
                    }  
                
            }       else if (!(statoAzione == 'Azione Forzata' || statoAzione == 'Azione Inviata')){
                helper.setToastAzione(cmp);            
            }
            
        } else if (esito == 'doppio'){
            if(statoAzione == 'Azione Forzata' || statoAzione == 'Azione Inviata'){
                var action = cmp.get('c.updateCaseTaskStatus');
                action.setParams({
                    'objId' : cmp.get('v.recordId'),
                    'status' : 'Closed',
                    'idCase' : cmp.get('v.caseId')
                });            
                action.setCallback(this, function(response){
                    if(response.getState() == 'SUCCESS'){
                        helper.setToastSuccess(cmp);
                        $A.get('e.force:refreshView').fire();
                    }
                });
                $A.enqueueAction(action);
                
            }
            else if (!(statoAzione == 'Azione Forzata' || statoAzione == 'Azione Inviata')){
                helper.setToastAzione(cmp);
            }
        } else if (esito == 'recall'){
            //if(statoAzione == 'Azione Forzata' || statoAzione == 'Azione Inviata'){
                if((isRadioButton  == 'valoreSi' && dataRecall) 
                   || isRadioButton == 'valoreNo'){
                    var action = cmp.get('c.updateSlaDateCase');
                    action.setParams({
                        'objId' : cmp.get('v.recordId'),
                        'recall' : cmp.get('v.recallDate'),
                        'idCase' : cmp.get('v.caseId')
                    });             
                    action.setCallback(this, function(response){
                        if(response.getState() == 'SUCCESS'){                        
                            helper.setToastSuccessRecall(cmp);                                                        
                            var workspaceAPI = cmp.find("workspace");
                            workspaceAPI.getFocusedTabInfo().then(function(response) {
                                var tabId = !response.parentTabId ? response.tabId : response.parentTabId;
                                workspaceAPI.closeTab({tabId: tabId});
                            });                                                   
                        }
                    });
                    $A.enqueueAction(action);                   
                }
                else if (isRadioButton  == 'valoreSi' && !dataRecall){
                    helper.setToastDataRecall(cmp);
                }
     
        }        
    },
    
    updateComunicazioneEvo : function(cmp, event, helper){
        var toast = $A.get('e.force:showToast');
        var action = cmp.get('c.updateStatusConunicazione');
        action.setParams({										
            'objId' : cmp.get('v.recordId'),
            'status' : 'Inviata'
        });
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                cmp.set('v.statoComunicazioneFinale','Inviata');
                cmp.set('v.isInviata',true);
                //  cmp.set('v.isComunicazioniPresenti',false);
                toast.setParams({
                    title : 'Stato comunicazione aggiornato con successo',
                    type : 'success',
                    message : ' '
                });
                toast.fire();
            }
        });
        $A.enqueueAction(action);
    },
    
    updateFlagContattoCliente : function(cmp,event, helper){        
        var action = cmp.get("c.updateFlagContatto");       
        action.setParams({
            'objId' : cmp.get('v.recordId'),
            'flagCliente': cmp.get('v.contattoClienteValue')                                              
        });
        $A.enqueueAction(action);         
    }
})