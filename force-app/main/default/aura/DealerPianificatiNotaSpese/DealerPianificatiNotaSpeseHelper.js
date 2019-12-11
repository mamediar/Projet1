({
	doInit : function(cmp, event, helper) {
		
		//cmp.set('v.columns', [{label: 'Codice OCS', fieldName: 'OCS_External_Id__c', type: 'text'},
        cmp.set('v.columns', [{label: 'Codice OCS', fieldName: 'CodiceClienteFilled__c', type: 'text'},                      
		{label: 'Nome', fieldName: 'Name', type: 'text'},
        {label: 'Indirizzo', fieldName: 'ShippingAddress', type: 'text' },
        {label: 'Zona', fieldName: 'ZoneName', type: 'text' },
		{label: 'Attività', fieldName: 'actNumber', type: 'text'},
		{label: 'Urgenti', fieldName: 'actUrgentNumber', type: 'text'},
		{label: 'Altra Visita', fieldName: 'nextVisit', type: 'text'}
		]);
		var spinner = cmp.find('spinnerComponent');
        spinner.incrementCounter();
		var action=cmp.get('c.initApex');
        action.setParams({notaSpese : cmp.get('v.notaSpeseSelected'),pianificaAttivitaList : cmp.get('v.notaSpeseSelected.Pianifica_Attivita__r')});
        action.setCallback(this,function(resp){
            spinner.decreaseCounter();
            if(resp.getState()=='SUCCESS'){
                
                var initWrapper= resp.getReturnValue();
                helper.populateExtraFields(cmp,initWrapper.dealers);
                
				cmp.set('v.attivitaPerDealer',initWrapper.pianificaAttivitaPerDealer);

                cmp.set('v.dealers', initWrapper.dealers);
                console.log('DP dealer: '+JSON.stringify(cmp.get('v.dealers'))); 
                
           		cmp.set('v.otherSlotsMap', initWrapper.otherSlotsMap);
        		        
            }
            else if(resp.getState()=='ERROR'){
                var errors = resp.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
							helper.showToast("Errore: " + errors[0].message,'error');
                    }else {
                        helper.showToast('Errore generico','error');
                    }
                } else {
                    helper.showToast('Errore generico','error');
                }
            }
        });
        $A.enqueueAction(action);

	},

    addDealer : function(cmp, event, helper) {

        cmp.find("addDealerPopUp").openPopUp();
    },


    onChangeDealerSelected : function(cmp, event, helper) {
        
        if(cmp.get('v.dealers').find(x => {return cmp.get('v.dealerSelected.Id') == x.Id;})){
            helper.showToast('Dealer già presente','error'); 
        }else{
            var action=cmp.get('c.addDealerApex');
            action.setParams({theDealer : cmp.get('v.dealerSelected'),theNotaSpese : cmp.get('v.notaSpeseSelected')});
            action.setCallback(this,function(resp){
                
                if(resp.getState()=='SUCCESS'){
                    cmp.find("addDealerPopUp").closePopUp();
                    helper.showToast('Dealer aggiunto con Successo','success');
                    cmp.set('v.notaSpeseSelected.Pianifica_Attivita__r',null);
                    helper.doInit(cmp, event, helper); 
                }
                else if(resp.getState()=='ERROR'){
                    var errors = resp.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                                helper.showToast("Errore: " + errors[0].message,'error');
                        }else {
                            helper.showToast('Errore generico','error');
                        }
                    } else {
                        helper.showToast('Errore generico','error');
                    }
                }
            });
            $A.enqueueAction(action);
        }

	},

    stepGiustificaUscita : function(cmp, event, helper) {
        var selectedRowsId = cmp.find('dealersPianifictiTableId').get('v.selectedRows');
        var dealers = cmp.get("v.dealers");
        console.log('DP Giustifica Uscita: '+JSON.stringify(dealers)); 
        
        if(selectedRowsId.length != dealers.length || selectedRowsId.length == 0){
            helper.showToast('Selezionare tutti i Dealers','error');
            return;
        }
        cmp.set('v.step','step2');
    },

    openPianificaPopup : function(cmp, event, helper) {

        var selectedRowsId = cmp.find('dealersPianifictiTableId').get('v.selectedRows');
        if(selectedRowsId.length == 0){
            helper.showToast('Selezionare almeno un Dealer','error');
            return;
        }

        var selectedRows = cmp.get('v.dealers').filter(x => {return selectedRowsId.indexOf(x.Id) != -1});

        var oldZone;

        
        for (let i = 0; i < selectedRows.length; i++) {
            if(!selectedRows[i].Zone__c){
                helper.showToast('Impossibile ripianificare perchè il Dealer '+selectedRows[i].Name+' non è assegnato a nessuna zona','error');
                return false; 
            }
            if(oldZone && selectedRows[i].Zone__c != oldZone){
                helper.showToast('Selezionare Dealer della stessa zona','error');
                oldZone = null;
                i = selectedRows.length; 
                return false; 
            }else{
                oldZone = selectedRows[i].Zone__c;
            }
            
        };

        if(oldZone){
            var otherSlotList = cmp.get('v.otherSlotsMap')[oldZone];
            if(otherSlotList){
            cmp.set('v.nextSlotId',otherSlotList[0].Id);            
            cmp.set('v.otherSlots',otherSlotList);
            cmp.set('v.selectedDealerListToRipianifica',selectedRows);
            cmp.find('pianificaModalId').openModal();
            }else{
                helper.showToast('Non sono presenti altri slot per questa Zona','error');
            }
        }
        
	},

    ripianificaDealer : function(cmp, event, helper) {

        var spinner = cmp.find('spinnerComponent');
        spinner.incrementCounter();
        var nextSlot = cmp.get('v.otherSlots').find(x => { return x.Id == cmp.get('v.nextSlotId'); });
        var action=cmp.get('c.ripianificaDealerApex');
        action.setParams({attivitaPerDealer : cmp.get('v.attivitaPerDealer'),newSlot : nextSlot,dealerList : cmp.get('v.selectedDealerListToRipianifica')});
        action.setCallback(this,function(resp){
            spinner.decreaseCounter();
            if(resp.getState()=='SUCCESS'){

                helper.showToast('Dealer ripianificati con successo','success');
				cmp.set('v.notaSpeseSelected.Pianifica_Attivita__r',null);
                helper.doInit(cmp, event, helper);
                cmp.find('pianificaModalId').closeModal(); 
            }
            else if(resp.getState()=='ERROR'){
                var errors = resp.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
							helper.showToast("Errore: " + errors[0].message,'error');
                    }else {
                        helper.showToast('Errore generico','error');
                    }
                } else {
                    helper.showToast('Errore generico','error');
                }
            }
        });
        $A.enqueueAction(action);

	},

	deleteDealerNonVisitati : function(cmp, event, helper) {
		
		var selectedRowsId = cmp.find('dealersPianifictiTableId').get('v.selectedRows');
        if(selectedRowsId.length == 0){
            helper.showToast('Selezionare almeno un Dealer','error');
            return;
        }

        var attivitaPerDealerMap = cmp.get('v.attivitaPerDealer');
		var pianificaAttivitaToDeleteList = [];
		selectedRowsId.forEach(rowId => {
			pianificaAttivitaToDeleteList.push(attivitaPerDealerMap[rowId]);
		});

		var action=cmp.get('c.deleteAttivitaDealerNonVisitati');
        action.setParams({pianificaAttivitaToDeleteList : pianificaAttivitaToDeleteList});
        action.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){

				helper.showToast('Dealer rimosso correttamente','success');
				cmp.set('v.notaSpeseSelected.Pianifica_Attivita__r',null);
				helper.doInit(cmp, event, helper);

            }
            else if(resp.getState()=='ERROR'){
                var errors = resp.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
							helper.showToast("Errore: " + errors[0].message,'error');
                    }else {
                        helper.showToast('Errore generico','error');
                    }
                } else {
                    helper.showToast('Errore generico','error');
                }
            }
        });
        $A.enqueueAction(action);

	},

	populateExtraFields: function (cmp, list) {
    	list.forEach(x=>{
            x.actNumber = String(x.Cases ? x.Cases.length : 0);
            x.actUrgentNumber = String(x.Cases ? x.Cases.filter(c =>{return (c.Priority == 'High' || c.Priority == 'Critical');}).length : 0);
            x.ShippingAddress = x.ShippingStreet && x. ShippingCity ? x.ShippingStreet + ', ' +x. ShippingCity : '';
            x.ZoneName = x.Zone__r ? x.Zone__r.Name : null;
            if(x.Attivita_Pianificate__r)    
                var nextVisit = x.Attivita_Pianificate__r[0];/*.find(x=>{
                    return x.SFA_Slot__c != cmp.get('v.slot').Id;
                });*/
                
            if(nextVisit && nextVisit.SFA_Slot__r)
                x.nextVisit = nextVisit.SFA_Slot__r.Date__c +' '+nextVisit.SFA_Slot__r.Time__c 
                //x.nextVisit = x.Attivita_Pianificate__r && x.Attivita_Pianificate__r.length > 0 ? (x.Attivita_Pianificate__r[0].SFA_Slot__r.Date__c +' '+x.Attivita_Pianificate__r[0].SFA_Slot__r.Time__c ):'';
        });
	},
	
	showToast : function(message,type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "message": message,
            "type" : type,
            "mode" : 'dismissible'
        });
        toastEvent.fire();
    },  
})