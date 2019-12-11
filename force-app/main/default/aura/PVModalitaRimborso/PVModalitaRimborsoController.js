({
	//presi da XCS_IbanController
	actionButtonCalcolaIBAN : function(cmp, event, helper) {
		helper.calcolaIBAN(cmp, event);
	},
    
	actionButtonVerificaIBAN : function(cmp, event, helper) {
		helper.verificaIBAN(cmp, event);
	},

	doValidityCheck : function(cmp, event, helper){
		helper.doValidityCheck(cmp, event);
	},
})