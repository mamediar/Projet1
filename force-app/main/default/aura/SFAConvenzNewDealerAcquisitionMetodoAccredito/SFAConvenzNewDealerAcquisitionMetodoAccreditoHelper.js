({
	getDati : function(component, event) {
        component.set("v.CCNuovoId",""); 
		var action = component.get("c.getCCDati");
		action.setParams({
			caseId: component.get("v.recordId")
		}); 
		action.setCallback(this, function(response){
			if (response.getState() == 'SUCCESS'){
                var dati=response.getReturnValue();
				component.set("v.dealerId", dati.dealerId);
                component.set("v.dealerInfo", dati.dealerInfo);
                var contoCorrente = dati.contiCorrenteList;
                console.log('contoCorrente:: '+JSON.stringify(contoCorrente));
                var contoCorrenteList = [];
                //contoCorrente
                for (var i=0; i< contoCorrente.length; i++){
                    var Item = {
                        Id:contoCorrente[i].Id,
                        ABI__c: contoCorrente[i].ABI__c,
                        CAB__c: contoCorrente[i].CAB__c,
                        ContoCorrente__c: contoCorrente[i].ContoCorrente__c,
                        IBAN__c: contoCorrente[i].IBAN__c,
                        Descrizione__c: contoCorrente[i].Descrizione__c,
                        Erogazione_RVD_CO__c: contoCorrente[i].Erogazione_RVD_CO__c,
                        Liquidazione__c: contoCorrente[i].Liquidazione__c,
                        Provvigioni__c: contoCorrente[i].Provvigioni__c};
                    contoCorrenteList.push(Item);
                }
				component.set("v.CCList",contoCorrenteList);                
            }
        });		
        $A.enqueueAction(action);
        //Prevalorizza i campi:
        var Gestione_PV = component.find('Gestione_PV__c').get('v.value');
        var Gestione_VE = component.find('Gestione_VE__c').get('v.value');
        var Pagamento_provvigioni = component.find('Pagamento_provvigioni__c').get('v.value');
        var DocumentiObbligatori = component.find('DocumentiObbligatori__c').get('v.value');
        var PagamentoTerzi  = component.find('PagamentoTerzi__c').get('v.value');
        if(Gestione_PV==null){
            component.find('Gestione_PV__c').set('v.value',"N");
        }
        if(Gestione_VE==null){
            component.find('Gestione_VE__c').set('v.value',"N");
        }
        if(Gestione_PV==null){
            component.find('Gestione_PV__c').set('v.value',"N");
        }
        if(Pagamento_provvigioni==null){
            component.find('Pagamento_provvigioni__c').set('v.value',"B");
        }
        if(PagamentoTerzi==null){
            component.find('PagamentoTerzi__c').set('v.value',"N");
        }        
	},
  
    eliminaCC : function(component, event) {
		var action = component.get("c.eliminaCC");
		action.setParams({
            CCSelezionatoId: component.get("v.CCSelezionatoId")
		}); 
		action.setCallback(this, function(response){
			if (response.getState() == 'SUCCESS'){
                console.log('CC eliminato');
                this.getDati(component, event);
            } else {
                console.log('CC NON eliminato');
            }
        });		
        $A.enqueueAction(action);
	},
 
    confermaDatiAgg : function(component, event) {
        var spinner = component.find('spinnerComponent');
        spinner.incrementCounter();
        
        console.log('HELPER confermaDatiAgg');
        component.find('FormDatiAggiuntivi').submit();
        
        var action = component.get("c.controllaSeSalvareDatiAggPossibile");
        var datiSalvataggio;
        action.setParams({ 
            caseId:  component.get("v.recordId"),
            dealerId: component.get("v.dealerId"),
            PagamentoTerzi: component.find('PagamentoTerzi__c').get('v.value'),
            TerzoDaLiquidare: component.find('TerzoDaLiquidare__c').get('v.value'),
            ErogatoMese: component.find('ErogatoMese__c').get('v.value'),                         
            VolumeAffari: component.find('VolumeAffari__c').get('v.value') 
        }); 
        action.setCallback(this, function(response){
            if (response.getState() == 'SUCCESS'){
                datiSalvataggio=response.getReturnValue();
                if(datiSalvataggio.erroreSalvataggio){
                    var messages=datiSalvataggio.messaggio;
                    var messaggio='';
                    console.log('Errore nel slavataggio');
                    for(var i= 0 ; i < messages.length ; i++){
                        console.log('messages[i]:: '+messages[i]);
                        messaggio=messaggio+messages[i]+'\r\n';
                    }                    
                    //TOAST::
                    console.log('messaggio 2: '+messaggio);
                    this.showToast(component,event,"","error",messaggio,"50000");                    
                } else {
                    if(!datiSalvataggio.chiamataOK_OCS){   //nel caso in cui il salvataggio sia possibile però la chiamata al servizio non va a buon fine
                        console.log('Chiamata OCS NOT OK');
                        this.showToast(component,event,"Errore nella chiamata del servizio \"Censimento Dati Aggiuntivi Convenzionato\"","error",datiSalvataggio.message_OCS,"50000");   
                    } else {
                        console.log('Chaimata OCS OK');
                        this.showToast(component,event,"","success","Dati aggiornati correttamente.","500"); 
                        component.set("v.buttonAvantiDisabled",false);                      
                    }
                }
            }
            spinner.decreaseCounter();
        });		
        $A.enqueueAction(action); 
        console.log('HELPER ho finito la chiamata');
	}, 
    
    showToast: function(component,event,title,type,message,duration){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: title,
            type: type,
            message: message,
            duration: duration
        });
        toastEvent.fire();         
    }
    
})