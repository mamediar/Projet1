({
	getHeadersList : function(component, event, helper) {
		var headerConsumoPP = ["PRATICA","DIP","SOC","CLIENTE","COD_AG","AGENTE","COD_SA","SUBAGENTE","CATEGORIA","COD_ESITO","DESCR_ESITO","NOTA_SOC_ESTERNA","DATA_NOTIFICA"];
		var headerConsumoPAPF = ["PRATICA","DIP","SOC","CLIENTE","COD_CV","CONVENZIONATO","COD_PV","PUNTO_VENDITA","CATEGORIA","COD_ESITO","DESCR_ESITO","NOTA_SOC_ESTERNA","DATA_NOTIFICA"];
		var headerCarta= ["CARTA","DIP","SOC","CLIENTE","COD_CV","CONVENZIONATO","COD_PV","PUNTO_VENDITA","CATEGORIA","COD_ESITO","DESCR_ESITO","NOTA_SOC_ESTERNA","DATA_NOTIFICA"];
		var headerVariazoniAnagraficaConsumo = ["REGIONE","AREA","PRODOTTO","PRATICA","DIP","SOC","CLIENTE","COD_DEALER","DEALER","CATEGORIA","COD_ESITO","DESCR_ESITO","NOTA_SOC_ESTERNA","DATA_NOTIFICA"];
		var headerVaziazioniAnagrafiaCarta = ["REGIONE","AREA","PRODOTTO","CARTA","DIP","SOC","CLIENTE","COD_DEALER","DEALER","CATEGORIA","COD_ESITO","DESCR_ESITO","NOTA_SOC_ESTERNA","DATA_NOTIFICA"];
		var tipoFile = component.get('v.selectTipoFile');
		var prodotto =  event.getParam("value"); 
		if(tipoFile=="Esiti Critici")
		{
			if(prodotto=="PP"){
				component.set('v.headerList',headerConsumoPP);
			}
			else if(prodotto=="PAPF"){
				component.set('v.headerList',headerConsumoPAPF);
			}else if(prodotto=="CARTA"){
				component.set('v.headerList',headerCarta);
			}else{
				alert('Error, contact your administrator');
			}
		}else if(tipoFile=="Esiti Anomali"){
			if(prodotto=="PP"){
				component.set('v.headerList',headerConsumoPP);
			}
			else if(prodotto=="PAPF"){
				component.set('v.headerList',headerConsumoPAPF);
			}else if(prodotto=="CARTA"){
				component.set('v.headerList',headerCarta);
			}else{
				alert('Error, contact your administrator');
			}
		}else if(tipoFile=="VariazionI Anagrafiche"){
			if(prodotto=="CONSUMO"){
				component.set('v.headerList',headerVariazoniAnagraficaConsumo);
			}else if(prodotto=="CARTA"){
				component.set('v.headerList',headerVaziazioniAnagrafiaCarta);
			}else{
				alert('Error, contact your administrator');
				component.set('v.headerList',[]);
			}
		}else{
			alert('Error, contact your administrator');
		}
		component.set('v.titleSelect',prodotto);
		component.set('v.showUploadFile',true);
	},
	getSelectProdootoByTipoFile : function(component,event){
		var prodottoList1 = [
			{'label': 'PP', 'value': 'PP'},
			{'label': 'PAPF', 'value': 'PAPF'},
			{'label': 'CARTA', 'value': 'CARTA'},
			];
		var prodottoList2 = [
			{'label': 'CONSUMO', 'value': 'CONSUMO'},
			{'label': 'CARTA', 'value': 'CARTA'},
			];
		var tipoFile = component.get('v.selectTipoFile');
		if(tipoFile!='VariazionI Anagrafiche'){
			component.set('v.optionsProdotto',prodottoList1);
		}else{
			component.set('v.optionsProdotto',prodottoList2);
		}
	},
})