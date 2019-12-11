({
    
   
    
    
    init : function(cmp, event, helper) {
        let obj = cmp.get('v.fileRecord');
        let action = cmp.get('c.listScriptInMaster');
        let recId = cmp.get('v.recordId').toString();
        console.log(recId);
        action.setParams({'fileTMK':recId});  
        action.setCallback(this, function(response) { 
            let state = response.getState();
            console.log(state);
            if (state == 'SUCCESS') { 
                var results = response.getReturnValue();
                console.log('ciao',results);
                const unique =  results.map((e)=> e['codiceTMK']).map((e,i,final) =>final.indexOf(e) === i && i).filter((e)=> results[e]).map(e=>results[e]);
                cmp.set('v.data',unique);
                let codact = 'Codice Azione';
		let codPro = 'Codice Prodotto';
                console.log('tipo cmpanga nel file ',obj.CampaignType__c)
		obj.CampaignType__c ==  'PP' ?   (codact, codPro): (codact = 'Codice Target', codPro = 'Emittente');
		var actions = [
            { label: 'Visualizza/Modifica', name: 'show_details' }]; 
		cmp.set('v.columns', 
		[	
			
			{ label: 'Tipologia', fieldName: 'tipologia', type: 'text' },
			{ label: codact, fieldName: 'codiceAzione', type: 'text' },
			{ label: codPro, fieldName: 'codiceTMK', type: 'text' },	 
			{ label: 'Codice CRM', fieldName: 'codiceProdotto', type: 'text' },
			{ label: 'Descrizione Prodotto', fieldName: 'descrizione', type: 'text' },
            { label: 'Script Associati', fieldName: 'flag', type: 'boolean' },
            { type: 'action', typeAttributes: { rowActions: actions }}
            
		 ]); 
            }
            
        }); 
        $A.enqueueAction(action);

    },
      redirect: function(cmp,event,helper){
            let action = event.getParam('action');
            let row = event.getParam('row');
            console.log(JSON.stringify(row));
            switch (action.name) {
            case 'show_details':
                cmp.set('v.tipologiaSel',row.tipologia);
                cmp.set('v.codiceAzioneSel', row.codiceAzione);
                cmp.set('v.codiceProdottoSel',row.codiceProdotto);
                cmp.set('v.codiceTMKSel',row.codiceTMK);
                cmp.set('v.descrizioneSel', row.descrizione);
                cmp.set('v.boolModal', true);
            break;
            
            }
      }
})