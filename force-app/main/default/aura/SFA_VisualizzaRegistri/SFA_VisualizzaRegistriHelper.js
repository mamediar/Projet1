({
	doInit : function(cmp, event, helper) {
        
        var action = cmp.get("c.typeUser");
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var usertype=response.getReturnValue();
				cmp.set("v.profileUser", usertype);
                console.log('DP usertype: '+usertype);
                if(usertype=='Branch Manager'){
                	cmp.set('v.columnsRegistroA', [
                        {label: 'Data', fieldName: 'Date__c', type:'text'},
                        {label: 'Utente', fieldName: 'username', type:'text'},
                        {label: 'Ora di uscita', fieldName: 'inizioUscita', type: 'text',editable: true},
                        {label: 'Chilom. di uscita', fieldName: 'KmInizioUscita__c', type: 'number', editable: true,typeAttributes:{minimumFractionDigits:2}},
                        {label: 'Ora di rientro', fieldName: 'fineUscita', type: 'text',editable: true},
                        {label: 'Chilom.di rientro', fieldName: 'KmFineUscita__c', type: 'number',editable: true, typeAttributes:{minimumFractionDigits:2}},
                        {label: 'Tratta percorsa', fieldName: 'Tratta__c', type: 'text',editable: true},
                        {label: 'Targa', fieldName: 'TargaVeicolo__c', type: 'text',editable: true},
                        {label: 'Attivita', fieldName: 'Note__c', type: 'text',editable: true},
                        {label: 'Firma utilizzatore', fieldName: 'AliasUser', type: 'text'},
                        {	
                            label: 'Approvato', fieldName: 'approved', type: 'text',
                            cellAttributes: { iconName: { fieldName: 'approvedIcon' }, iconPosition: 'right' }
                        }
                    ]);
                    cmp.set('v.columnsRegistroB', [
                        {label: 'Data', fieldName: 'Date__c', type:'text'},
                        {label: 'Utente', fieldName: 'username', type:'text'},
                        {label: 'Chilometraggio di riferimento', fieldName: 'KmRifornimento__c',editable: true, type: 'number', typeAttributes:{minimumFractionDigits:2}},
                        {label: 'Luogo di rifornimento', fieldName: 'LuogoRifornimento__c',editable: true, type: 'text'},
                        {label: 'Importo addebitato', fieldName: 'ImportoRifornimento__c',editable: true, type: 'number', typeAttributes:{minimumFractionDigits:2}},
                        {label: 'Targa', fieldName: 'TargaVeicolo__c', type: 'text'},
                        {label: 'Firma Utilizzatore', fieldName: 'AliasUser', type: 'text'},
                        {	
                            label: 'Approvato', fieldName: 'approved', type: 'text',
                            cellAttributes: { iconName: { fieldName: 'approvedIcon' }, iconPosition: 'right' }
                        }
                    ]);  
                }else{
                    cmp.set('v.columnsRegistroA', [
                        {label: 'Data', fieldName: 'Date__c', type:'text'},
                        {label: 'Utente', fieldName: 'username', type:'text'},
                        {label: 'Ora di uscita', fieldName: 'inizioUscita', type: 'text'},
                        {label: 'Chilom. di uscita', fieldName: 'KmInizioUscita__c', type: 'number', typeAttributes:{minimumFractionDigits:2}},
                        {label: 'Ora di rientro', fieldName: 'fineUscita', type: 'text'},
                        {label: 'Chilom.di rientro', fieldName: 'KmFineUscita__c', type: 'number', typeAttributes:{minimumFractionDigits:2}},
                        {label: 'Tratta percorsa', fieldName: 'Tratta__c', type: 'text'},
                        {label: 'Targa', fieldName: 'TargaVeicolo__c', type: 'text'},
                        {label: 'Attivita', fieldName: 'Note__c', type: 'text'},
                        {label: 'Firma utilizzatore', fieldName: 'AliasUser', type: 'text'},
                        {	
                            label: 'Approvato', fieldName: 'approved', type: 'text',
                            cellAttributes: { iconName: { fieldName: 'approvedIcon' }, iconPosition: 'right' }
                        }
                    ]);
                    cmp.set('v.columnsRegistroB', [
                        {label: 'Data', fieldName: 'Date__c', type:'text'},
                        {label: 'Utente', fieldName: 'username', type:'text'},
                        {label: 'Chilometraggio di riferimento', fieldName: 'KmRifornimento__c', type: 'number', typeAttributes:{minimumFractionDigits:2}},
                        {label: 'Luogo di rifornimento', fieldName: 'LuogoRifornimento__c', type: 'text'},
                        {label: 'Importo addebitato', fieldName: 'ImportoRifornimento__c', type: 'number', typeAttributes:{minimumFractionDigits:2}},
                        {label: 'Targa', fieldName: 'TargaVeicolo__c', type: 'text'},
                        {label: 'Firma Utilizzatore', fieldName: 'AliasUser', type: 'text'},
                        {	
                            label: 'Approvato', fieldName: 'approved', type: 'text',
                            cellAttributes: { iconName: { fieldName: 'approvedIcon' }, iconPosition: 'right' }
                        }
                    ]);
                }
			}
			else if(response.getState()=='ERROR'){
				var errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						helper.showToast("Errore: " + errors[0].message,'error');
					}else {
						helper.showToast('Errore generico','error');
					}
				} else {
					helper.showToast('Errore generico','error');
				}
			}
		}); 
		$A.enqueueAction(action);
        
		
        
        
		var spinner = cmp.find('spinnerComponent');
		spinner.incrementCounter();
		var action = cmp.get("c.initApex");
		action.setCallback(this, function(response) {
			var state = response.getState();
			spinner.decreaseCounter();
			if (state === "SUCCESS") {
				var initwrapper=response.getReturnValue();
				helper.populateExtraFields(initwrapper.noteSpese,helper);
				cmp.set("v.datiRegistri",initwrapper.noteSpese);
				cmp.set("v.dataRegistri",initwrapper.today);
				cmp.set("v.actualUser", initwrapper.actualUser);
			}
			else if(response.getState()=='ERROR'){
				var errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						helper.showToast("Errore: " + errors[0].message,'error');
					}else {
						helper.showToast('Errore generico','error');
					}
				} else {
					helper.showToast('Errore generico','error');
				}
			}
		}); 
		$A.enqueueAction(action);
	},
    
    handleSaveEdition: function (cmp, event, helper) {
        console.log('DP sono nell helper handleSaveEdition.');
        var draftValues = event.getParam('draftValues');
        var action = cmp.get("c.updateDraftNote");
        action.setParams({"sns" : draftValues});
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === 'SUCCESS'){
                $A.get('e.force:refreshView').fire();
            } else {
                 helper.showToast('Aggiornamento fallito.','error');
            }          
        });
        $A.enqueueAction(action);
        
    },   
    
	searchNoteSpese : function(cmp, event, helper){
		var emptyInputProblem=false;
		var inputs=cmp.find("searchParams");
		inputs.forEach(field =>{
			if(!field.checkValidity() && field.isRendered()){
				emptyInputProblem=true;
			}
		})
		if(!emptyInputProblem){
			var spinner = cmp.find('spinnerComponent');
			spinner.incrementCounter();
            var profileUser = cmp.get("v.profileUser");
            console.log('DP sono profilo: '+profileUser);
			var action = cmp.get("c.searchNoteSpeseApex");
			var myDataRegistri= cmp.get("v.dataRegistri");
			var myTarga= cmp.get("v.targa");
			action.setParams({
				selectedDate: myDataRegistri,
				targa: myTarga,
				actualUser: cmp.get("v.actualUser")
			})
			action.setCallback(this, function(response) {
				var state = response.getState();
				spinner.decreaseCounter();
				if (state === "SUCCESS") {
					var notaSpeseList=response.getReturnValue();
					helper.populateExtraFields(notaSpeseList,helper);
					cmp.set("v.datiRegistri",notaSpeseList);
					if(myTarga && myDataRegistri && notaSpeseList.length>0 && 
                        (profileUser !='Branch Employee' && profileUser !='Borg')){
                        
						cmp.set("v.disableApproveButton", false);
                        console.log('DP posso approvare');
					}
					else{
                        cmp.set("v.disableApproveButton", true);
						console.log('DP  NON posso approvare, sono un filialista.');
					}
				}
				else if(response.getState()=='ERROR'){
					var errors = response.getError();
					if (errors) {
						if (errors[0] && errors[0].message) {
							helper.showToast("Errore: " + errors[0].message,'error');
						}else {
							helper.showToast('Errore generico','error');
						}
					} else {
						helper.showToast('Errore generico','error');
					}
				}
			}); 
			$A.enqueueAction(action); 
		}
		else{
			helper.showToast("Campi di ricerca non corretti", "error");
		}
	},

	doApprove: function(cmp,event,helper){
		var spinner = cmp.find('spinnerComponent');
			spinner.incrementCounter();
			var noteSpese= cmp.get("v.datiRegistri");
			noteSpese.forEach(notaSpese =>{
				notaSpese.approvedIcon="utility:check";
			})
			var action = cmp.get("c.updateNoteSpese");
			var actualUser = cmp.get("v.actualUser");
			action.setParams({
				updatedNotaSpeseList: noteSpese,
				actualUser : actualUser

			})
			action.setCallback(this, function(response) {
				var state = response.getState();
				spinner.decreaseCounter();
				if (state === "SUCCESS") {
					
					helper.showToast("Approvazione note spese effettuata","success");
					var returnedValues= response.getReturnValue();
					helper.populateExtraFields(returnedValues, helper);
					cmp.set("v.datiRegistri",returnedValues);
				}
				else if(response.getState()=='ERROR'){
					var errors = response.getError();
					if (errors) {
						if (errors[0] && errors[0].message) {
							helper.showToast("Errore: " + errors[0].message,'error');
						}else {
							helper.showToast('Errore generico','error');
						}
					} else {
						helper.showToast('Errore generico','error');
					}
				}
			}); 
			$A.enqueueAction(action); 
	},
	
	populateExtraFields:function(notaSpeseList,helper){
		notaSpeseList.forEach(notaSpese=>{
			if(notaSpese.User__r){
				notaSpese.AliasUser=notaSpese.User__r.Alias;
			}
			if(notaSpese.Status__c=='Approvata'){
				notaSpese.approvedIcon="utility:check";
			}
			notaSpese.inizioUscita=helper.msToTime(notaSpese.OraInizioUscita__c);
			notaSpese.fineUscita=helper.msToTime(notaSpese.OraFineUscita__c);
			notaSpese.username=notaSpese.User__r.Name;

		})
	},

	msToTime:function(ms) {
        var seconds = (ms/1000);
        var minutes = parseInt(seconds/60, 10);
        seconds = seconds%60;
        var hours = parseInt(minutes/60, 10);
        minutes = minutes%60;
		hours = ('0' + hours).slice(-2)
		minutes = ('0' + minutes).slice(-2)
		var willBeReturned=hours + ':' + minutes;
		return willBeReturned;
	},
	
	showToast : function(message,type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "message": message,
            "type" : type
        });
        toastEvent.fire();
	},

	getExcelTitles: function(cmp,event,helper,registerLetter){
		var titles=[];
		if(registerLetter=="A"){
			titles=["Data","Utente","Ora uscita","Chilom. uscita","Ora rientro",",Chilom. rientro","Tratta percorsa","Targa","Firma utilizzatore","Conferma utilizzatore","Approvatore","Data approvazione"];
		}
		if(registerLetter=="B"){
			titles=["Data","Utente","Chilometraggio di riferimento","Luogo di rifornimento","Importo addebitato","Targa","Firma utilizzatore","Conferma utilizzatore","Approvatore","Data approvazione"];
		}
		return titles;
	},

	getExcelData:function(cmp,event,helper,registerLetter){
		var data=[];
		var rowsData=cmp.get("v.datiRegistri");
		if(registerLetter=="A"){
			rowsData.forEach(rowData =>{
				var willBeReturnedData=[];
				willBeReturnedData.push(rowData.Date__c);
				willBeReturnedData.push(rowData.username);
				willBeReturnedData.push(rowData.inizioUscita);
				willBeReturnedData.push(rowData.KmInizioUscita__c);
				willBeReturnedData.push(rowData.fineUscita);
				willBeReturnedData.push(rowData.KmFineUscita__c);
				willBeReturnedData.push(rowData.Tratta__c);
				willBeReturnedData.push(rowData.TargaVeicolo__c);
				willBeReturnedData.push(rowData.AliasUser);
				willBeReturnedData.push(rowData.Date__c);
				willBeReturnedData.push(rowData.ManagerApprovazione__r ? rowData.ManagerApprovazione__r.Alias:"");
				willBeReturnedData.push(rowData.DataApprovazione__c);
				data.push(willBeReturnedData);
			})
		}
		if(registerLetter=="B"){
			rowsData.forEach(rowData =>{
				var willBeReturnedData=[];
				willBeReturnedData.push(rowData.Date__c);
				willBeReturnedData.push(rowData.username);
				willBeReturnedData.push(rowData.KmRifornimento__c);
				willBeReturnedData.push(rowData.LuogoRifornimento__c);
				willBeReturnedData.push(rowData.ImportoRifornimento__c);
				willBeReturnedData.push(rowData.TargaVeicolo__c);
				willBeReturnedData.push(rowData.AliasUser);
				willBeReturnedData.push(rowData.Date__c);
				willBeReturnedData.push(rowData.ManagerApprovazione__r ? rowData.ManagerApprovazione__r.Alias:"");
				willBeReturnedData.push(rowData.DataApprovazione__c);
				data.push(willBeReturnedData);
			})
		}
		return data;
	},
	
	sendMessageHandler: function(component, event, helper){
		if(event.getParam("message") === "refresh" && event.getParam("channel") === "GestioneRegistri"){
				helper.doInit(component, event, helper);
		}
	},
	
	excelGenerate: function(component,event,helper){
		var tableA=[];
		tableA.push(helper.getExcelTitles(component,event,helper,"A"));
		var dataTableA=helper.getExcelData(component,event,helper,"A");
		dataTableA.forEach(data =>{
			tableA.push(data);
		})
		var tableB=[];
		tableB.push(helper.getExcelTitles(component,event,helper,"B"));
		var dataTableB=helper.getExcelData(component,event,helper,"B");
		dataTableB.forEach(data =>{
			tableB.push(data);
		})
		var today=new Date();
		var fileName="registri_auto_filiale_"+today.getFullYear()+('0' + (today.getMonth()+1)).slice(-2)+('0' + (today.getDate())).slice(-2)+('0' + (today.getHours())).slice(-2)+('0' + (today.getMinutes())).slice(-2)+('0' + (today.getSeconds())).slice(-2)+".xls";
		helper.tablesToExcel ([ tableA , tableB ]  ,['Registro A','Registro B'], fileName, 'Excel');
	},


/**
 * funzione creazione file excel
 * */


	tablesToExcel: function(tables, wsnames, wbname, appname) {

			var uri = 'data:application/vnd.ms-excel;base64,'
		, tmplWorkbookXML = '<?xml version="1.0"?><?mso-application progid="Excel.Sheet"?><Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet">'
		  + '<DocumentProperties xmlns="urn:schemas-microsoft-com:office:office"><Author>Axel Richter</Author><Created>{created}</Created></DocumentProperties>'
		  + '<Styles>'
		  + '<Style ss:ID="Currency"><NumberFormat ss:Format="Currency"></NumberFormat></Style>'
		  + '<Style ss:ID="Date"><NumberFormat ss:Format="Medium Date"></NumberFormat></Style>'
		  + '<Style ss:ID="s22"><Font ss:Color="#FF0000" ss:Bold="1"/></Style>'
		  + '<Style ss:ID="s23"><Font ss:FontName="Arial" ss:Size="12" ss:Bold="1"/></Style>'
		  + '</Styles>' 
		  + '{worksheets}</Workbook>'
		, tmplWorksheetXML = '<Worksheet ss:Name="{nameWS}"><Table>{rows}</Table></Worksheet>'
		, tmplCellXML = '<Cell{attributeStyleID}{attributeFormula}><Data ss:Type="{nameType}">{data}</Data></Cell>'
		, base64 = function(s) { return window.btoa(unescape(encodeURIComponent(s))) }
		, format = function(s, c) { return s.replace(/{(\w+)}/g, function(m, p) { return c[p]; }) };
		  var ctx = "";
		  var workbookXML = "";
		  var worksheetsXML = "";
		  var rowsXML = "";
	
		  for (var i = 0; i < tables.length; i++) {
			  
			if(i==0){
				rowsXML +="<Row ss:Height=\"15.75\"><Cell ss:StyleID=\"s23\"><Data ss:Type=\"String\">Registro A</Data></Cell></Row>";
			}
			if(i==1){
				rowsXML +="<Row ss:Height=\"15.75\"><Cell ss:StyleID=\"s23\"><Data ss:Type=\"String\">Registro B</Data></Cell></Row>";
			}
			

			for (var j = 0; j < tables[i].length; j++) {
			  rowsXML += '<Row>'
			  for (var k = 0; k < tables[i][j].length; k++) {
				var dataType = null;
				var dataStyle = (j==0? 's22': null);
				var dataValue = tables[i][j][k]? tables[i][j][k] : "";
				var dataFormula = null;
				dataFormula = (dataFormula)?dataFormula:(appname=='Calc' && dataType=='DateTime')?dataValue:null;
				ctx = {  attributeStyleID: (dataStyle=='Currency' || dataStyle=='Date' || dataStyle=='s22')?' ss:StyleID="'+dataStyle+'"':''
					   , nameType: (dataType=='Number' || dataType=='DateTime' || dataType=='Boolean' || dataType=='Error')?dataType:'String'
					   , data: (dataFormula)?'':dataValue
					   , attributeFormula: (dataFormula)?' ss:Formula="'+dataFormula+'"':''
					  };
				rowsXML += format(tmplCellXML, ctx);
			  }
			  rowsXML += '</Row>'
			}
			ctx = {rows: rowsXML, nameWS: wsnames[i] || 'Sheet' + i};
			worksheetsXML += format(tmplWorksheetXML, ctx);
			rowsXML = "";
		  }
	
		  ctx = {created: (new Date()).getTime(), worksheets: worksheetsXML};
		  workbookXML = format(tmplWorkbookXML, ctx);
	
	console.log(workbookXML);
	
		  var link = document.createElement("A");
		  link.href = uri + base64(workbookXML);
		  link.download = wbname || 'Workbook.xls';
		  link.target = '_blank';
		  document.body.appendChild(link);
		  link.click();
		  document.body.removeChild(link);
		}
	  
})