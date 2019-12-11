({	
    doInit : function(component, event, helper) {
        var spinner = component.find('spinnerComponent');
		spinner.incrementCounter();
		var action=component.get('c.initApex');
        action.setParams({theSlot : component.get('v.slot')});
        action.setCallback(this,function(resp){
            spinner.decreaseCounter();
            if(resp.getState()=='SUCCESS'){
                var initWrapper= resp.getReturnValue();
                
                helper.populateExtraFields(component,initWrapper.dealers);
                helper.populateExtraFields(component,initWrapper.dealersPianificati);
                helper.populateExtraFields(component,initWrapper.dealersDisabilitati);
                component.set('v.dealers', initWrapper.dealers);
                component.set('v.dealersPianificati', initWrapper.dealersPianificati);
                component.set('v.dealerDisabilitatiList',initWrapper.dealersDisabilitati);
           		component.set('v.otherSlots', initWrapper.otherSlots);
        		
        		//Reset selection 
        		component.find('dealersTableId') ? component.find('dealersTableId').set('v.selectedRows',[]) : '';
        		component.find('dealersPianifictiTableId') ? component.find('dealersPianifictiTableId').set('v.selectedRows',[]) : '';
                
        
            }
            else if(resp.getState()=='ERROR'){
                var errors = resp.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                                 helper.showToast("Errore: " + 
                                 errors[0].message,'error');
                    }else {
                        console.log("Unknown error");
                        helper.showToast('Errore generico','error');
                    }
                } else {
                    console.log("Unknown error");
                    helper.showToast('Errore generico','error');
                }
            }
        });
        $A.enqueueAction(action);
    },
    populateExtraFields: function (component, list) {
    	list.forEach(x=>{
            x.actNumber = String(x.Cases ? x.Cases.length : 0);
            x.actUrgentNumber = String(x.Cases ? x.Cases.filter(c =>{return (c.Priority == 'High' || c.Priority == 'Critical');}).length : 0);
            x.ShippingAddress = x.ShippingStreet + ', ' +x. ShippingCity;
            if(x.Attivita_Pianificate__r && x.SFA_Slot__c)    
        	var nextVisit = x.Attivita_Pianificate__r.find(x=>{
                return x.SFA_Slot__c != component.get('v.slot').Id;
            });
            if(nextVisit && nextVisit.SFA_Slot__r)
            x.nextVisit = nextVisit.SFA_Slot__r.Date__c +' '+nextVisit.SFA_Slot__r.Time__c 
            //x.nextVisit = x.Attivita_Pianificate__r && x.Attivita_Pianificate__r.length > 0 ? (x.Attivita_Pianificate__r[0].SFA_Slot__r.Date__c +' '+x.Attivita_Pianificate__r[0].SFA_Slot__r.Time__c ):'';
        });
    },
 	pianificaThisSlot: function (component, event,helper) {
    	var theSlotVar = component.get('v.slot');
        component.set('v.isRischedula',false);
        helper.pianifica(component, event,helper,theSlotVar);
    },
    pianificaNextSlot: function (component, event,helper) {
        var nextSlotVar = component.get('v.otherSlots').find(x=>{
                                                            return x.Id ==component.get('v.nextSlotId');
                                                        });
        if(nextSlotVar){
            var success = helper.pianifica(component, event,helper,nextSlotVar);
            if(success && component.get('v.isRischedula'))
                helper.removePianifica(component, event,helper);
        }
        	
    },
    pianifica: function (component, event,helper,theSlotVar) {
    	var selectedRowsId = component.find(component.get('v.isRischedula')? 'dealersPianifictiTableId':'dealersTableId').get('v.selectedRows');
        if(selectedRowsId.length == 0){
            helper.showToast('Selezionare almeno un Dealer','error');
        	return false;
        }
        var selectedRows = component.get(component.get('v.isRischedula')? 'v.dealersPianificati':'v.dealers').filter(x => { return selectedRowsId.indexOf(x.Id) == -1 ? false: true; });
    	
        if(helper.checkDuplicate(component, event,helper,theSlotVar,selectedRows))
            return false;
        
        var spinner = component.find('spinnerComponent');
		spinner.incrementCounter();
		var action=component.get('c.PianificaAttivita');
    	action.setParams({theSlot : theSlotVar, dealers : selectedRows});
        action.setCallback(this,function(resp){
            spinner.decreaseCounter();
            if(resp.getState()=='SUCCESS'){
                helper.doInit(component, event, helper);
                helper.closePianificaPopup(component, event, helper);
            }
        });
        $A.enqueueAction(action);
        return true;
    },
    checkDuplicate: function (component, event,helper,theSlotVar,selectedRows) {
        var returnValue = true;
        selectedRows.forEach(x=>{
            if(x.Attivita_Pianificate__r)
                x.Attivita_Pianificate__r.forEach(y=>{
                    if(y.SFA_Slot__c == theSlotVar.Id){
                        returnValue = false && returnValue;
                        helper.showToast('Attenzione il Dealer '+x.Name+' è già pianificato per lo Slot '+theSlotVar.Date__c+' '+theSlotVar.Time__c,'error');
                    }
                });
        });
        return !returnValue;
    },
    removePianifica: function (component, event,helper) {
        var selectedRowsId = component.find('dealersPianifictiTableId').get('v.selectedRows');
        if(selectedRowsId.length == 0){
            helper.showToast('Selezionare almeno un Dealer','error');
        	return;
        }
        var selectedRows = component.get('v.dealersPianificati').filter(x => { return selectedRowsId.indexOf(x.Id) == -1 ? false: true; });
        if(helper.checkCloseNotaSpese(component,selectedRows,helper)){
        	return;
        }
        var theSlot = component.get('v.slot');
        var pianificaAttivitaToRemoveListVar = [];
        selectedRows.forEach(x=>{
            x.Attivita_Pianificate__r.forEach(y=>{
                if(y.SFA_Slot__c == theSlot.Id){
                	pianificaAttivitaToRemoveListVar.push(y);
       			}
            });
        });
        var spinner = component.find('spinnerComponent');
		spinner.incrementCounter();
		var action=component.get('c.RemovePianificaAttivita');
    	action.setParams({pianificaAttivitaToRemoveList : pianificaAttivitaToRemoveListVar, theSlot : theSlot});
        action.setCallback(this,function(resp){
            spinner.decreaseCounter();
            if(resp.getState()=='SUCCESS'){
                helper.doInit(component, event, helper);
            }
        });
        $A.enqueueAction(action);

    },
    checkCloseNotaSpese : function(component,selectedRows,helper) {

        var dealerDisabilitatiList = component.get('v.dealerDisabilitatiList');
        var selectedDisabled = [];
        selectedRows.forEach(x => {
            dealerDisabilitatiList.forEach(y =>{
                if(x.Id == y.Id)
                    selectedDisabled.push(x);
            });
        });
        if(selectedDisabled && selectedDisabled.length > 0){
            selectedDisabled.forEach(x =>{
                helper.showToast('il Dealer '+x.Name+' non può essere rimosso perchè collegato ad una nota spese già sottomessa','error');
            });
            return true;
        }else{
            return false;
        }

    },
    openPianificaPopup : function(component, event, helper) {
        var tableId = event.getSource().get('v.class');
        if(component.get('v.otherSlots').length >0)
        	component.set('v.nextSlotId',component.get('v.otherSlots')[0].Id);
        
        var selectedRowsId = component.find(tableId).get('v.selectedRows');
        if(selectedRowsId.length >0){
            var selectedRows = component.get('v.dealersPianificati').filter(x => { return selectedRowsId.indexOf(x.Id) == -1 ? false: true; });
            if(helper.checkCloseNotaSpese(component,selectedRows,helper)){
                return;
            }
        	component.find('pianificaModalId').openModal();
        }else{
            helper.showToast('Selezionare almeno un Dealer','error');
        }
    },
    closePianificaPopup : function(component, event, helper) {
        component.find('pianificaModalId').closeModal();
    },
    goToHome : function(component, event, helper) {
        var evt = $A.get("e.force:navigateHome");
        evt.fire();
    },
    showToast : function(message,type){
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			message: message,
			type: type
		});
		toastEvent.fire();
    },
})