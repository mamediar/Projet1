({
	searchAction : function(component, event, helper) {
		helper.searchAction(component, event, helper);
	},
	externalCallAction: function(component, event, helper) {
		helper.externalCallAction(component, event, helper);
	},

	selectCliente:function(cmp,event,helper){
        var selRow=event.getParam('selectedRows')[0];
		cmp.set('v.accountSelezionato', selRow);
		cmp.set('v.idAccSelezionato', selRow);
	}
})