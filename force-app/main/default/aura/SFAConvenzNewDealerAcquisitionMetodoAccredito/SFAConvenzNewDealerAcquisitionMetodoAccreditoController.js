({
	doInit : function(component, event, helper) {
        var actionCC = [
            { label: 'Modifica','iconName': 'utility:edit', name: 'edit' },
            { label: 'Elimina','iconName': 'utility:delete', name: 'delete' }
        ]        
        component.set('v.columnsCC', [
            {label: 'ABI', fieldName: 'ABI__c', type: 'text'},
            {label: 'CAB', fieldName: 'CAB__c', type: 'text'},
            {label: 'Conto', fieldName: 'ContoCorrente__c', type: 'text'},
            {label: 'IBAN', fieldName: 'IBAN__c', type: 'text'},
            {label: 'Descrizione', fieldName: 'Descrizione__c', type: 'text'},
            {label: 'Erogazione', fieldName: 'Erogazione_RVD_CO__c', type: 'text'},   
            {label: 'Liquidazione', fieldName: 'Liquidazione__c', type: 'text'},
            {label: 'Provvigioni', fieldName: 'Provvigioni__c', type: 'text'},
            {type: 'action', typeAttributes: { rowActions: actionCC } },
        ]);  
        
		helper.getDati(component, event);
	},
            
            
    handleRowActionCC : function(component,event,helper){            
       var action = event.getParam('action');
       var row = event.getParam('row');
       switch (action.name) {
            case 'edit':
            component.set("v.isOpen",true);
            component.set("v.CCSelezionatoId",row.Id);
            break;
            
            case 'delete':
            if (confirm('Sei sicuro di voler eliminare i dati di conto corrente selezionato?')) {
                component.set("v.CCSelezionatoId",row.Id);
                helper.eliminaCC(component, event);
            }          

            break;   

       }
            
    },            

            
    handleIbanReadyEvent : function(component, event, helper){
            component.set("v.CCNuovoId","");
            helper.getDati(component, event);
            
    }, 
            
    closeModel : function(component, event, helper){
            component.set("v.isOpen",false);
            //component.set("v.CCNuovoId","");
            helper.getDati(component, event);
    }, 
    
    showRequiredFields: function(component, event, helper){
    	$A.util.removeClass(component.find("Input_contract_type__c"), "none");
    },      
    
    actionButtonConfermaDatiAgg : function(component, event, helper) {
		helper.confermaDatiAgg(component, event);
	},
            
            
})