({
    init: function (cmp, event, helper) {
        cmp.set('v.columns', [
            {label: 'Numero Pratica', fieldName: 'numPratica', type: 'text'},
            {label: 'Tipologia', fieldName: 'tipologia', type: 'text'},
            {label: 'Tipo Prodotto', fieldName: 'tipoProdotto', type: 'text'},
            {label: 'Prodotto', fieldName: 'prodotto', type: 'text'},
            {label: 'Cod.Cliente', fieldName: 'codCliente', type: 'text'},
            {label: 'Ragione Sociale', fieldName: 'ragioneSociale', type: 'text'},
            {label: 'Data Liquidazione', fieldName: 'dataLiquidazione', type: 'text'},
            {label: 'Finanziato', fieldName: 'finanziato', type: 'text'},
            {label: 'Canale', fieldName: 'canale', type: 'text'},
            {label: 'Procedura', fieldName: 'procedura', type: 'text'},
            {label: 'Intermediario', fieldName: 'intermediario', type: 'text'},
            
        ]);

	},
               
	visualizzaElenco : function (component,event,helper) {
		component.set('v.showList',true);
	},
	nascondiElenco : function (component,event,helper) {
		component.set('v.showList',false);
	},
	callRestService : function (component,event,helper) {
		var allOk = helper.checkRequiredFields(component);
		  if(!allOk){
			  helper.showToast('Errore','error','Campi obbligatori mancanti. Popola tutti i campi e riprova.');
			  return;
		  }
		helper.callMethod(component);
    },

    aggiungiSelezionati : function (component,event,helper) {
        var elementiSelezionati = component.find('table').getSelectedRows();
        helper.inserisciElementi(component,elementiSelezionati);
    },

    enableAddButton : function (component,event,helper) {
        component.set('v.showAddButton', true);
        var table = component.find('table').getSelectedRows();
        if(table && table.length == 0){
            component.set('v.showAddButton', false);
        }
    },
    
    stampaPratiche : function(component,event,helper){
        window.open('/apex/SchedaVerificaFilialeStampaPDF?schedaId='+component.get("v.recordId")+'&stampaPratiche=true');    
    }

    
});