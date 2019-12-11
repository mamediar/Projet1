({
	
	campa: function(cmp,event,helper){
        
		let obj = cmp.get('v.CampaignRecord');
		cmp.set('v.recordtype',obj.RecordType.Name);
        let tipoCamp = obj.RecordType.Name;
        let ActionCode;
        tipoCamp == 'PP'?ActionCode = obj.ActionCode__c: ActionCode = obj.TMKTarget__c;
		let prod = obj.ProductCode__c;
		let codiceTelemarketing = obj.TMKProductCode__c;
		let codact = 'Codice Azione';
		let codPro = 'Codice Prodotto';
		tipoCamp ==  'PP' ?   (codact, codPro): (codact = 'Codice Target', codPro = 'Emittente');
		var actions = [
            { label: 'Visualizza/Modifica', name: 'show_details' }]; 
		cmp.set('v.columns', 
		[	
			
			{ label: 'Tipologia', fieldName: 'tipologia', type: 'text' },
			{ label: codact, fieldName: 'codiceAzione', type: 'text' },
			{ label: codPro, fieldName: 'codiceProdotto', type: 'text' },	 
			{ label: 'Codice CRM', fieldName: 'codiceCRM', type: 'text' },
			{ label: 'Descrizione Prodotto', fieldName: 'descrizione', type: 'text' },
			{ type: 'action', typeAttributes: { rowActions: actions }} 
		 ]); 
		 helper.getData(cmp,event, prod, ActionCode, codiceTelemarketing, tipoCamp);

	},

	

	redirect:function(cmp,event,helper){
        let obj = cmp.get('v.CampaignRecord');
		let action = event.getParam('action');
		let row = event.getParam('row');
		let idScript = row.Id;        
        obj.RecordType.Name ==  'PP'? cmp.set('v.showActionCode',true):cmp.set('v.showActionCode',false); 
        switch (action.name) {
            case 'show_details':
				console.log('ciaooooooo');
				cmp.set('v.idscript', idScript);
				cmp.set('v.newDate', false);
				cmp.set('v.oldDate', true);
				cmp.set('v.modal', true);
				cmp.set('v.codiceAzione', '');
				cmp.set('v.codiceTMK', '');
				cmp.set('v.codiceProdotto', '');
				cmp.set('v.codiceProdottoLvl2', '');
				cmp.set('v.tipocampagna', '');
				break;
            
        }
		
	},
	createNewScript:function(cmp,event,helper) {
        let obj = cmp.get('v.CampaignRecord');
        obj.RecordType.Name ==  'PP'? cmp.set('v.showActionCode',true):cmp.set('v.showActionCode',false); 
		let showmodal = cmp.set('v.modal', true);
			cmp.set('v.newDate', true);
			cmp.set('v.oldDate', false);

		
	}

})