({
	insertInizioHR: function(cmp, event, helper) {
		var orario=cmp.get("v.orarioInizioMyHr");
		if(orario!="manuale"){
			cmp.set("v.notaSpese.OraInizioUscita__c", orario);
		}
	},
	insertFineHR: function(cmp, event, helper) {
		var orario=cmp.get("v.orarioFineMyHr");
		if(orario!="manuale"){
			cmp.set("v.notaSpese.OraFineUscita__c", orario);
		}
	},
	checkRifornimentoFills: function(cmp,event,helper){
		helper.checkRifornimentoFills(cmp,event,helper);
	},

	init: function(cmp, event, helper){
		helper.init(cmp, event, helper);
	},
	getSchedules: function(cmp, event, helper){
		helper.getSchedules(cmp, event, helper);
	},
	sendExpenseReport: function(cmp,event,helper){
		helper.sendExpenseReport(cmp,event,helper);
	},
	upperCaseConverter: function(cmp,event,helper){
		var targa= cmp.get("v.notaSpese.TargaVeicolo__c");
		cmp.set("v.notaSpese.TargaVeicolo__c", targa.toUpperCase());
	}
})