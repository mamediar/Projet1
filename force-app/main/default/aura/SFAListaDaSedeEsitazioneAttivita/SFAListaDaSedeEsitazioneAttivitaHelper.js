({
    doInit : function(component, event, helper) {

        var action = component.get('c.getCaseEsitiList');
        var caseSelected = component.get('v.caseChildSelected');
        

        //var titolo = caseSelected.SFA_ListeCaricate__r.SFA_TipologiaLista__r.Name +' ['+ caseSelected.SFA_ListeCaricate__r.Nome_Lista__c +'] - '+ caseSelected.DealerName__c +' (Scadenza: '+caseSelected.DueDate__c+' )';
        var titolo = caseSelected.SFA_ListeCaricate__r.Tipo_Attivita__r.Descrizione__c +' ['+ caseSelected.SFA_ListeCaricate__r.Nome_Lista__c +'] - '+ (caseSelected.DealerName__c != null ? caseSelected.DealerName__c : "")  +' (Scadenza: '+caseSelected.DueDate__c+' )';
        component.set('v.titolo',titolo);
        component.set('v.caseNumber',caseSelected.CaseNumber);
        component.set('v.accountId',caseSelected.AccountId);

        action.setParams({
            //caseActivity : caseSelected.Tipologia_Lista__c
            //caseActivity : caseSelected.SFA_ListeCaricate__r.SFA_TipologiaLista__c
            caseActivity : caseSelected.SFA_ListeCaricate__r.Tipo_Attivita__c
        });
        
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var caseEsitiList = response.getReturnValue();
                
                console.log('caseEsitiList: '+caseEsitiList.length);
                if(caseEsitiList.length > 0){
                    component.set('v.esitiList',caseEsitiList);
                }/*else{
                    component.set("v.toastMsg", "Esiti non trovati per questo tipo di attività");
                    this.showToastError(component);
                }*/
            }
            
        }));
        
        $A.enqueueAction(action);
        
    },
    
    setHeaderColumns: function(component, event, helper) {
        component.set("v.headerColumns", [
            {label: 'Esito', fieldName: 'FullDispositionName__c', type: 'text'}
        ]);
    },

    esitaCase : function(component, event, helper) {
        var editedRecords =  component.find("table").getSelectedRows();
        var caseSelected = component.get('v.caseChildSelected');
        var note = component.find('note').get('v.value');
        
        var action = component.get('c.setEsitoCase');

        this.loadSpinner(component);
        component.set('v.hideBox',false);
        if(editedRecords.length > 0){

            action.setParams({
                caseSelected : caseSelected,
                esito : editedRecords[0],
                note : note
            });

            action.setCallback(this, $A.getCallback(function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var x = response.getReturnValue();
                    console.log(response.getReturnValue());
                    component.set("v.toastMsg", "Esito assegnato correttamente");
                    this.showToastSuccess(component);
                    component.set('v.showModal',false);
                    
                    
                    this.hideSpinner(component);
                }
            }));
            $A.enqueueAction(action);

        }else{
            component.set("v.toastMsg", "Selezionare almeno un esito da assegnare");
            this.showToastError(component);
            this.hideSpinner(component);
            component.set('v.showInternalModal',false);
            //this.doInit(component, event, helper);
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
    },
    loadSpinner : function(component, event, helper) {
        console.log('showSpinner');
        component.set("v.showSpinner", true);
    },
    
    hideSpinner : function(component, event, helper) {
        component.set("v.showSpinner", false);
        console.log('hideSpinner');
    }
})