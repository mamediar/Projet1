({
    init : function(cmp, event, helper) {

        cmp.set('v.columns', [
            {label: 'Contratto', fieldName: 'ContractNumber__c', type: 'text'},
            {label: 'Descrizione', fieldName: 'AccountName__c', type: 'text'},
            {label: 'Data',fieldName: 'StartDate',  type: 'date'},
            {label: 'Stato', fieldName: 'WorkStatusFormula__c', type: 'text'}
            //{label: 'Trovato', type: 'boolean',  fieldName: 'isFound'},
            //{label: 'Smarrito', type: 'boolean', fieldName: 'isLost'}

        ]);
        cmp.set('v.disableButton', false);
        cmp.set('v.hideCheckboxColumn', false);
        helper.updateList(cmp,event);
    },

   /* updateContractSelected : function(cmp, event, helper){
        var selectedRows = event.getParam('selectedRows');
        cmp.set('v.contractsSelected', selectedRows);
    },*/

    upStatus : function(cmp, event, helper){
        var contractTable = cmp.find("contractTable");
        var contractsSelected = contractTable.getSelectedRows();
        var statusName = event.getSource().getLocalId();
        var action = cmp.get('c.updateStatus');
        if(typeof contractsSelected != 'undefined'){
            action.setParams({
                'statusName' : statusName,
                'contractSelected' : contractsSelected
            });
            action.setCallback(this,function(response){
                if(response.getState() == 'SUCCESS'){
                    var result = response.getReturnValue();
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title: result ? ("Stato " + ((contractsSelected.length > 1)?"delle pratiche":"dalla pratica") + " aggiornato con successo") : "Selezionare almeno un documento" ,
                        type : result ? "success" : "warning",
                        message: " "
                    });
                    toastEvent.fire();
                    if(result){
                        helper.updateList(cmp,event);
                        helper.resetSelection(cmp);
                    }
                }
            });
            $A.enqueueAction(action);
        }
    },

    updateColumnSorting: function (cmp, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        cmp.set("v.sortedBy", fieldName);
        cmp.set("v.sortedDirection", sortDirection);
        helper.sortData(cmp, fieldName, sortDirection);
    },

    handleSFANoteEvent: function (cmp, event, helper) {

        var note = event.getParam("note");
        cmp.set("v.note", note);

    }
})