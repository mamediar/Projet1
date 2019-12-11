({
	init: function (cmp, event, helper) {
		//helper.openPopUp(cmp, event, helper);
		cmp.set('v.dealerColumns', [
			//{label: 'CIP', fieldName: 'OCS_External_Id__c', type: 'text'},
            {label: 'CIP', fieldName: 'CodiceClienteFilled__c', type: 'text'},
			{label: 'Nome', fieldName: 'Name', type: 'text'},
			{label: 'Indirizzo', fieldName: 'ShippingStreet', type: 'text'}, 
			{label: 'Zona', fieldName: 'zoneName', type: 'text'}
		]);
	},

	searchDealer: function(cmp, event, helper) {
		helper.doSearch(cmp, event, helper); 
	},

	openPopUp: function(cmp,event,helper){	
		helper.openPopUp(cmp, event, helper);
	},

	closePopUp : function(cmp, event, helper) {
		helper.closePopUp(cmp, event, helper);
	},

     
	selectDealer:function(cmp, event, helper) {
		helper.selectDealer(cmp, event, helper);
	}
})