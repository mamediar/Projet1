({
    callMethod: function (component) {

		  var method = component.get('c.restService');
		  var request = {
			'codCliente'		: component.get('v.simpleRecord.Filiale__r.CodiceClienteFilled__c'),
			'codOcsDealer'		: component.get('v.codOcsDealer'),
			'paAuto'			: component.get('v.paAuto'),
			'pfMobili'			: component.get('v.pfMobili'),
			'ppRete'			: component.get('v.ppRete'),
			'ppPoste'			: component.get('v.ppPoste'),
			'ppBanche'			: component.get('v.ppBanche'),
			'ppAgeAss'			: component.get('v.ppAgeAss'),
			'pfNoMobili'		: component.get('v.pfNoMobili'),
			'dataLiquidazioneDa': component.get('v.dataLiquidazioneDa') != null?  component.get('v.dataLiquidazioneDa').replace(new RegExp('-', 'g'),'') : '0',
			'dataLiquidazioneA'	: component.get('v.dataLiquidazioneA') != null? component.get('v.dataLiquidazioneA').replace(new RegExp('-', 'g'),'') : '0'
		};
		  method.setParams({
			  'request' : JSON.stringify(request)
		  });
		  component.set('v.showSpinner',true);
		  method.setCallback(this,function (response) {
			  var state = response.getState();
			  if(state=='SUCCESS'){
				var result = response.getReturnValue();
				if(result && 'Nessuna pratica trovata'==result){
					this.showToast('Nessuna pratica trovata','info',' ');
				} else {
					if(!result || 'errore servizio'==result){
						this.showToast('Errore','error','Errore: non è stato possibile raggiungere il servizio.');
					} else {
						if(!result || 'Utente non abilitato al servizio'==result){
							this.showToast('Errore','error','Errore: Utente non abilitato al servizio.');
						}else{
						
							component.set('v.data',JSON.parse(result));
							component.set('v.showTable',true);
						}
					}
				}
				
			  }else{
				  //error
				  var result = response.getReturnValue();
				  component.set('v.showTable',false);
				  this.showToast('Errore Generico','error','Contattare l\'amministratore del sistema o riprovare più tardi.');
			  }
			  component.set('v.showSpinner',false);
			  
		  });
		  $A.enqueueAction(method);
	},
	showToast : function(title,type,message){
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
				"title":title,
				"message":message,
				"type":type
			}
		);
		toastEvent.fire();

	},
    
    checkRequiredFields : function (component) {
        
		if(
		/*this.isBlank(component.get('v.codOcsDealer')) ||*/
		this.isBlank(component.get('v.paAuto')) ||
		this.isBlank(component.get('v.pfMobili')) ||
		this.isBlank(component.get('v.ppRete')) ||
		this.isBlank(component.get('v.ppPoste')) ||
		this.isBlank(component.get('v.ppBanche')) ||
		this.isBlank(component.get('v.ppAgeAss')) ||
		this.isBlank(component.get('v.pfNoMobili')) /*||
		this.isBlank(component.get('v.dataLiquidazioneDa')) ||
        this.isBlank(component.get('v.dataLiquidazioneA'))*/ ){
            return false;
        }
        return true;
        
	},
	isBlank : function(value){
        return value == null || value == '';
	},
	inserisciElementi : function (component,list) {
		var method = component.get('c.inserisciElementiSelezionati');
		method.setParams({
			'listaElementi'   : JSON.stringify(list.concat()),
			'schedaFilialeId' : component.get('v.recordId')
		});

		method.setCallback(this, function (response) {
			var state = response.getState();
			if(state == 'SUCCESS'){
				var result = response.getReturnValue();
				if(result == 'success'){
					this.showToast('Operazione Completata con Successo!','info',' ');
					$A.get('e.force:refreshView').fire();
				} else {
					this.showToast(result,'error',' ');
				}
			} else {
				//error 
				var result = response.getReturnValue();
				this.showToast('Errore Generico','error','Contattare l\'amministratore del sistema o riprovare più tardi.');
			}
		});
		$A.enqueueAction(method);
	}
});