({
    
    initNotaSpeseList: function (cmp, event, helper) {
        var spinner = cmp.find('spinnerComponent');
        spinner.incrementCounter();
        cmp.set('v.columns', [
            {label: 'Data Pianificata', fieldName: 'Date__c', type: 'text'},
            {label: 'Periodo', fieldName: 'Time__c', type: 'text'},
            {label: 'Stato', fieldName: 'Status__c', type: 'text'},
            {label: '', type: 'button',typeAttributes:{title: 'Gestisci',variant:'base',name:'gestisci',iconName: 'utility:send'}},
            {label: '', type: 'button',typeAttributes:{title: 'Cancella',variant:'base',name:'delete',iconName: 'utility:delete'}}
        ]);
        var action = cmp.get("c.initApex");
        action.setCallback(this, function(response) {
            var state = response.getState();
            spinner.decreaseCounter();
            if (state === "SUCCESS") {
                var initWrapper = response.getReturnValue();
                cmp.set('v.data',initWrapper.notaSpeseList);
                console.log('DP initWrapper.notaSpeseList: '+JSON.stringify(initWrapper.notaSpeseList));
                cmp.set('v.giorniNotaSpeseMap',initWrapper.giorniNotaSpese);
            }
            else if(response.getState()=='ERROR'){
                var errors = response.getError();
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

    handleRowAction: function (cmp, event, helper) {
        var action = event.getParam('action');
        var listaNotaSpese = cmp.get("v.data");
         
        var notaSpeseRow = listaNotaSpese.find(function( obj ) {
           return obj.Id === event.getParam('row').Id;
        });

        switch (action.name) {
            case 'delete':
                helper.deleteNotaSpese(cmp, event, helper,notaSpeseRow);
                break;
            case 'gestisci':
                helper.gestisciNotaSpese(cmp, event, helper,notaSpeseRow);
                break;
            default:
                break;
        }
    },

    deleteNotaSpese: function (cmp, event, helper,notaSpeseRow) {
        var spinner = cmp.find('spinnerComponent');
        spinner.incrementCounter();
        var action = cmp.get("c.deleteNotaSpese");
        action.setParams({notaSpese : notaSpeseRow,pianificaAttivitaList : notaSpeseRow.Pianifica_Attivita__r}); 
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                spinner.decreaseCounter();
                helper.showToast("Nota Spese cancellata","success");
                helper.initNotaSpeseList(cmp, event, helper);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        helper.showToast("Error message: " + errors[0].message,"error");
                    }
                    else helper.showToast("Errore generico","error");
                } else helper.showToast("Errore generico:","error");
                
            }
        });
        $A.enqueueAction(action);
    },

    gestisciNotaSpese: function (cmp, event, helper,notaSpeseRow) {
        
        if(cmp.get('v.data').indexOf(notaSpeseRow) == 0){
            if(cmp.get('v.giorniNotaSpeseMap')[notaSpeseRow.Id] < 0){
                console.log('DP v.giorniNotaSpeseMap: '+cmp.get('v.giorniNotaSpeseMap'));
                helper.showToast('Impossibile gestire una nota spese per date future.','error');
                return;
            }
            if(cmp.get('v.giorniNotaSpeseMap')[notaSpeseRow.Id] >= 35){
                helper.showToast('Impossibile gestire una nota spese con data creazione maggiore di 35 giorni.','error');
                return;
            }else{
                cmp.set('v.notaSpeseSelected',notaSpeseRow);
                cmp.set('v.step','step1'); 
            }
        }else{
            helper.showToast('Gestire prima la nota spese iniziale.','error');
            return;
        }
    },

    showToast : function(message,type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "message": message,
            "type" : type
        });
        toastEvent.fire();
    }, 
	
})