({
	onInit: function(cmp,event,helper){
		helper.onInit(cmp,event,helper);
	},

	insertInizioHR: function(cmp,event,helper){
		helper.insertInizioHR(cmp,event,helper);
	},

	insertFineHR: function(cmp,event,helper){
		helper.insertFineHR(cmp,event,helper);
	},

	upperCaseConverter: function(cmp,event,helper){
		helper.upperCaseConverter(cmp,event,helper);
	},

	checkRifornimentoFills: function(cmp,event,helper){
		helper.checkRifornimentoFills(cmp,event,helper);
	},

	confermaNotaSpese: function(cmp,event,helper){
		helper.confermaNotaSpese(cmp,event,helper);
	},

	evaluateKmFine: function(cmp,event,helper){
		helper.evaluateKmFine(cmp,event,helper);
	},

	backToDealerPianificaNotaSpese: function(cmp,event,helper){
		cmp.set('v.step','step1');
	},
})