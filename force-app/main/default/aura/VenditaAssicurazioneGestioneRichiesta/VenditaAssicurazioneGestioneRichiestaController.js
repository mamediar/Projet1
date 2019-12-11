({
    init_1 : function(cmp, event, helper) {
        helper.setOptions(cmp);        
        console.log(cmp.get('v.codCliente'));
        var action = cmp.get('c.doInit');
        action.setParams({
            'codCliente' : cmp.get('v.codCliente'), 
            'formattedProfileName' : cmp.get('v.formattedProfileName'),
            'caseId' : cmp.get('v.recordId')
        });
        action.setCallback(this, function(response) {            
            if(response.getState() == 'SUCCESS') {                
                var result = action.getReturnValue();
                
                cmp.set('v.assicurazioniPosseduteData', result.assicurazioniPosseduteData);
                cmp.set('v.cartePerPagamentoData', result.cartePerPagamentoData);  
                cmp.set('v.ibanPerPagamentoData', result.ibanPerPagamentoData);
                cmp.set('v.flagCartePerPagamentoError', result.flagCartePerPagamentoError);
                cmp.set('v.flagIbanPerPagamentoError', result.flagIbanPerPagamentoError);
                cmp.set('v.clientFullName', result.clientFullName);
                cmp.set('v.clientAddress', result.clientAddress);
                cmp.set('v.evoOffice', result.evoOffice);
                cmp.set('v.scriptTelefonataStretch', result.scriptTelefonataStretch);
                cmp.set('v.productOptions', result.productOptions);
                //console.log(result.productOptions[0].value);
            }            
        })        
        $A.enqueueAction(action);        
    },    
    
    handleUploadFinished: function (cmp, event) {
        // Get the list of uploaded files
        var uploadedFiles = event.getParam("files");
        alert("Carica file : " + uploadedFiles.length);
    },
    
    showCardDetails : function(cmp, event, helper){
        //var fixedList = [];
        var numPratica = event.getSource().get('v.activeSectionName');  
        var cartePosseduteList = cmp.get('v.cartePerPagamentoData');
        var action = cmp.get('c.callWebServices');
        action.setParams({'numeroPratica':numPratica});
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                var result = response.getReturnValue();
                cmp.set('v.cartaDatiFinanziariData', result.cartaDatiFinanziariData);
                cmp.set('v.movimentiViaggiantiData', result.movimentiViaggiantiData);
                cmp.set('v.autorizzazioniData', result.autorizzazioniData);
                cmp.set('v.flagCartaDatiFinanziariError', result.flagCartaDatiFinanziariError);
                
                //helper.handleErrors(cmp, result.errors);
            }
        });        
        var fixedList = cartePosseduteList.filter(function(elem){return elem.numPratica == numPratica;});
        cmp.set('v.iterationCurrentList', fixedList);
        $A.enqueueAction(action);
    },
    
    schedulingDate : function(cmp, event, helper){
        var sourceLabel = event.getSource().get('v.label');
        var inputSchedulingDate = cmp.find('inputSchedulingDate').get('v.value');
        if(sourceLabel == 'Continua'){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParam('message', ' '); 
            if(inputSchedulingDate){                
                var action = cmp.get('c.schedule');
                action.setParams({'caseId':cmp.get('v.recordId'), 'schedulingDate':inputSchedulingDate});
                action.setCallback(this, function(response){  
                    if(response.getState() == 'SUCCESS'){
                        var result = response.getReturnValue();
                        toastEvent.setParam('type', 'success');
                        toastEvent.setParam('title', "Attività pianificata per il giorno e l'ora indicati");                    
                        toastEvent.fire();                                                                                        
                        cmp.set('v.scriptTelefonataStretch', result);                        
                        $A.get('e.force:refreshView').fire();
                    }
                });
                $A.enqueueAction(action);
            }else{      
                toastEvent.setParam('type', 'warning');
                toastEvent.setParam('title', "Selezionare la data e l'ora di ricontatto");                
                toastEvent.fire();
            }
        } else if(sourceLabel == 'Schedula'){
            var salesSchedulingDateContainer = cmp.find('salesSchedulingDateContainer');
            $A.util.addClass(salesSchedulingDateContainer, 'visible');
            cmp.set('v.schedulingButtonLabel', 'Continua');   
        }        
    },
    updateOCS : function(cmp, event, helper){
        var action = cmp.get('c.callUpdateOCS');
        action.setParam();
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                cmp.set('v.assicurazioniPosseduteTodayData', response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    /*schedulingDateLast : function(cmp, event, helper){
        var inputSchedulingDateLast = cmp.find('inputSchedulingDateLast').get('v.value');
        var action = cmp.get('c.schedule');
        action.setParams({'caseId':cmp.get('v.recordId'), 'schedulingDate':inputSchedulingDateLast});
        action.setCallback(this, function(response){  
            if(response.getState() == 'SUCCESS'){
                var result = response.getReturnValue();                                                                                                   
                cmp.set('v.scriptTelefonataStretch', result);                        
                $A.get('e.force:refreshView').fire();
            }
        });
        $A.enqueueAction(action);
        
    },*/    
    nextButton : function(cmp, event, helper){
        var toastEvent = $A.get("e.force:showToast");
        var interestValue = cmp.get('v.interestValue');
        var interestValueOutput = (interestValue == 'interessato') ? cmp.find('Sinterest').get('v.value') : 
        (interestValue == 'non_interessato') ? cmp.find('Ninterest').get('v.value') : 'Irreperibile';        
        toastEvent.setParam('message', ' ');
        
        if(interestValue && interestValueOutput){
            var inputSchedulingDateLast = (interestValueOutput == 'Inviata doc precontrattuale') ? cmp.find('inputSchedulingDateLast').get('v.value') : null;
            var modalitaInvioContratto = ( interestValueOutput == 'Inviata doc precontrattuale') ? 
                cmp.find('modalitaInvioContratto_inviataDocPrecontrattuale').get('v.value') : (interestValueOutput == 'Pratica caricata') ?
                cmp.find('modalitaInvioContratto_praticaCaricata').get('v.value') : '';
            
            if(interestValue == 'interessato' && !modalitaInvioContratto){                    
                toastEvent.setParam('type', 'warning');
                toastEvent.setParam('title', 'Selezionare la modalità d\'invo del contratto.');
                toastEvent.fire();                    
            } 
            else if(interestValueOutput == 'Inviata doc precontrattuale' && !inputSchedulingDateLast){
                toastEvent.setParam('type', 'warning');
                toastEvent.setParam('title', 'Selezionare l\'ora e la data di ricontatto.');
                toastEvent.fire();                           
                
            } else {
                //console.log(interestValueOutput);
                var noteVendita = cmp.find('noteVendita').get('v.value');
                var products =  cmp.get('v.productValue');
                var action = cmp.get('c.upshot');
                action.setParams({
                    'caseId' : cmp.get('v.recordId'),
                    'interestValue' : interestValue,
                    'interestValueOutput' : interestValueOutput,
                    'products' : products,
                    'modalitaInvioContratto' : modalitaInvioContratto,
                    'schedulingDate' : inputSchedulingDateLast,
                    'noteVendita' : noteVendita
                });
                action.setCallback(this, function(response){
                    console.log(response.getState());
                    console.log(response.getError());
                    if(response.getState() == 'SUCCESS'){
                        toastEvent.setParam('type', 'success');
                        toastEvent.setParam('title', 'Operazione completata con successo');
                        toastEvent.fire();
                        $A.get('e.force:refreshView').fire();
                    }
                });
                $A.enqueueAction(action);
            }            
        } else {
            toastEvent.setParam('type', 'warning');
            toastEvent.setParam('title', 'Selezionare l\'interesse del cliente per continuare.');
            toastEvent.fire();
        }
    },
    
    resetComboboxOptions : function(cmp, event, helper){
        cmp.set('v.NinterestValue', '');
        cmp.set('v.SinterestValue', '');
        cmp.set('v.mezzoPagamValue', '');
        cmp.set('v.freqPagamValue', '');
    },
    
    resetRadioButtonOptions : function(cmp, event, helper){
        cmp.set('v.valuesButtonInvio', '');
        cmp.set('v.valuesButtonPostaEmail', '');
    }
})