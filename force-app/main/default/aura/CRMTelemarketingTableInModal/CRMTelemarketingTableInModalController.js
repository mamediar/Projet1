({
    init : function(cmp, event, helper) {
        let obj = cmp.get('v.fileRecord');
        let codiceAzione = cmp.get('v.codiceAzioneSel');
        let tipologia = cmp.get('v.tipologiaSel');
        let codTMK = cmp.get('v.codiceTMKSel');
        let codiceProdotto = cmp.get('v.codiceProdottoSel');
        let action = cmp.get('c.listScriptInModal');
        let descrizione = cmp.get('v.descrizioneSel');
        let resForNew = Array();
        console.log(descrizione,codiceAzione,codTMK,codiceProdotto,tipologia,obj.StartDate__c,obj.EndDate__c);
        action.setParams({'codiceAzione':codiceAzione,'codiceTMK':codTMK,'codiceProdotto':codiceProdotto,'campType':tipologia,'startDate':obj.StartDate__c,'endDate':obj.EndDate__c});  
        action.setCallback(this, function(response) { 
            let state = response.getState();
            console.log(state);
            if (state == 'SUCCESS') { 
                var results = response.getReturnValue(); 
                results.map((element)=> {element.descrizione = descrizione; return element});
                console.log('vediamo il controllo per l override ',results.length == 0, results)
                if(results.length == 0){ 
                    
                                       let obj = {  ActionCode__c: cmp.get('v.codiceAzioneSel'),
                                                    ActionCodeLvl2__c: cmp.get('v.codiceTMKSel'),
                                                    CodProdLvl2__c:cmp.get('v.codiceProdottoSel'),
                                                    TipoCampagna__c: cmp.get('v.tipologiaSel'),
                                                    descrizione:cmp.get('v.descrizioneSel')}; 
                                                    resForNew.push(obj);
                    console.log(resForNew);
                    cmp.set('v.data', resForNew); 
                } else{ $A.get("e.force:refreshView").fire(); cmp.set('v.data',results);}
        let codact = 'Codice Azione';
		let codPro = 'Codice Prodotto';
		obj.CampaignType__c ==  'PP' ?   (codact, codPro): (codact = 'Codice Target', codPro = 'Emittente');
		var actions = [
            { label: 'Visualizza/Modifica', name: 'show_details' }]; 
		cmp.set('v.columns', 
		[	
			
			{ label: 'Tipologia', fieldName: 'TipoCampagna__c', type: 'text' },
			{ label: codact, fieldName: 'ActionCode__c', type: 'text' },
			{ label: codPro, fieldName: 'ActionCodeLvl2__c', type: 'text' },	 
			{ label: 'Codice CRM', fieldName: 'CodProdLvl2__c', type: 'text' },
			{ label: 'Descrizione Prodotto', fieldName: 'descrizione', type: 'text' }
            
            
		 ]); 
            }
            
        }); 
        $A.enqueueAction(action);

    },

    scriptPopulate : function(cmp, event, helper) {
        let idScript;  
        let startDate;
        let endDate;
        let descrizione;
        let row = event.getParam('selectedRows');
        row.map((rigaSel) => {return idScript=rigaSel.Id, startDate=rigaSel.StartDate__c,endDate=rigaSel.EndDate__c, descrizione=rigaSel.descrizione})
        if(idScript != undefined){
        cmp.set('v.idScript', idScript);
        cmp.set('v.startDate', startDate);
        cmp.set('v.endDate', endDate);
        cmp.set('v.desScript', descrizione);
        cmp.set('v.openForm', true);
        cmp.set('v.showOldDate',true);}
        else{
            helper.helperMethod(cmp,row);
        }

    },
    
})