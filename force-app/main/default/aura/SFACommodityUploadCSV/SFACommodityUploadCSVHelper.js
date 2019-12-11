({
    getSelectProdottoByTipoFile : function(component,event){
        var tipoFile = component.find("tipo_lista").get("v.value");
        var prodottoList1 = ["PP", "PAPF", "CARTA"];
        var prodottoList2 = ["CONSUMO","CARTA"];
        var prodottoList3 = [];
        if(tipoFile==''){
            // lista vuota
            component.set('v.tipologia_prodotti',prodottoList3);
            component.set('v.showUpload',false);
        } else if(tipoFile!='Variazioni Anagrafiche'){
			component.set('v.tipologia_prodotti',prodottoList1);
		}else{
			component.set('v.tipologia_prodotti',prodottoList2);
		}
    },
    showUploadSection : function(component,event){
        var prod = component.find("prodotto").get("v.value");
        if(prod==null || prod==''){  
            component.set('v.showUpload',false);
        } else {
            component.set('v.showUpload',true);
        }
    },
    readFile: function(component, helper, file) {
        if (!file) return;
        console.log('file'+file.name);
        if(!file.name.match(/\.(csv||CSV)$/)){
            return alert('only support csv files');
        }else{
            
            reader = new FileReader();
            reader.onerror =function errorHandler(evt) {
                switch(evt.target.error.code) {
                    case evt.target.error.NOT_FOUND_ERR:
                        alert('File Not Found!');
                        break;
                    case evt.target.error.NOT_READABLE_ERR:
                        alert('File is not readable');
                        break;
                    case evt.target.error.ABORT_ERR:
                        break; // noop
                    default:
                        alert('An error occurred reading this file.');
                };
            }
            //reader.onprogress = updateProgress;
            reader.onabort = function(e) {
                alert('File read cancelled');
            };
            reader.onloadstart = function(e) { 
                
                var output = '<ui type=\"disc\"><li><strong>'+file.name +'</strong> '+file.size+'bytes</li></ui>';
                component.set("v.filename",file.name);
                component.set("v.targetFileName",output);
               
            };
            reader.onload = function(e) {
                var data=e.target.result;
                component.set("v.fileContentData",data);
                //console.log("file data"+JSON.stringify(data));
                var allTextLines = data.split(/\r\n|\n/);
                var dataRows=allTextLines.length-1;
                var headers = allTextLines[0].split(',');
                
                console.log("Rows length::"+dataRows);
                component.set("v.showMain",true); 
            }
            reader.readAsText(file);
            
        }
        var reader = new FileReader();
        reader.onloadend = function() {
         
        };
        reader.readAsDataURL(file);
    },
    checkRecords : function(component,dataFile,helper){
        var errorsRec = [];
        component.set('v.errorsRecords', errorsRec);
        var action = component.get("c.checkRecordsCSV");
        component.set("v.showSpinner",true);
        action.setParams({ fileData : dataFile,
                           prodotto: component.find("prodotto").get("v.value"),
                           tipoFile: component.find("tipo_lista").get("v.value"),
                           fileName: component.get("v.filename")
                        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.showSectionError', true);
                var resultCheck = response.getReturnValue();
                if (resultCheck.header!=null) {
                    component.set('v.headerList', resultCheck.header);
                }
                if (resultCheck!=null && resultCheck.error!=null && resultCheck.error!='') {
                    component.set("v.showSpinner",false);
                    console.log('resultCheck: '+resultCheck.error);
                    var errRec = {};
                    errRec.description = resultCheck.error;
                    errRec.row = 'GENERALE';
                    errRec.rowCSSClass = 'errorRow';
                    errorsRec.push(errRec);
                    component.set('v.errorsRecords', errorsRec);
                    // se è presente un errore GENERALE non si puo' confermare
                    component.set('v.showConfirm', false);
                } else {
                    console.log('resultCheck timestamp: '+resultCheck.timeStamp);
                    // ricerca errore
                    component.set('v.timestamp', resultCheck.timeStamp);
                    this.statusJob(component, event, helper);
                }
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
                        
        });
        $A.enqueueAction(action);
    },
    confirmUpload: function (component, file, helper) {
		console.log('ready to load file:'+file);
        var action = component.get("c.createCasesCommodity");
        component.set("v.showSpinner",true);
        action.setParams({ fileName: component.get("v.filename"),
                           timestamp : component.get('v.timestamp'),
                           prodotto: component.find("prodotto").get("v.value"),
                           tipoFile: component.find("tipo_lista").get("v.value")
                        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            component.set("v.showSpinner",false);
            component.set("v.showConfirm",false);
            if (state === "SUCCESS") {
                var resultCheck = response.getReturnValue();
                component.set('v.msg', '');
                component.set('v.errormsg', '');
                if (resultCheck==null) {
                    component.set("v.showMain",false);
                    component.set('v.showSectionError', false);
                    component.set('v.fileToBeUploaded', null);     
                    component.set('v.errorsRecords', []);
                    component.set('v.msg', 'Caricamento effettuato');
                    this.showSuccessToast(component);
                } else {
                    // errore generale
                    component.set('v.errormsg', 'Errore Geneale:'+resultCheck);
                    this.showErrorToast(component);
                }
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
                        
        });
        $A.enqueueAction(action);
    },
    statusJob: function (component, event, helper) {
        console.log('statusJob:  v.filename '+ component.get('v.filename'));
        console.log('statusJob:  v.timestamp '+ component.get('v.timestamp'));
        if (component.get('v.filename')!=null && component.get('v.filename')!='' &&
            component.get('v.timestamp')!=null && component.get('v.timestamp')!='') {
            var action = component.get("c.listRecordsCompleted");
            
            action.setParams({ 
                    fileName : component.get('v.filename'),
                    timestamp : component.get('v.timestamp')
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var  listError = response.getReturnValue();
                    console.debug('listError:'+listError);
                    if(listError!=null && listError.length > 0) {
                        component.set("v.showSpinner",false);
                        var canConfirm = false;
                        console.log('canConfirm:'+canConfirm);
                        var errorsRec = [];
                        var numOK=0;
                        var numError=0;
                        for (var i = 0;i<listError.length;i++) {
                            var errRec = {};
                            errRec.index = listError[i].Index__c;
                            errRec.description = listError[i].Status__c; 
                            errRec.rowCSSClass = 'errorRow';
                            //console.log('errRec.description:'+errRec.description);
                            if (errRec.description=='OK') {
                                errRec.rowCSSClass = 'okRow';
                                canConfirm = true;
                                numOK++;
                            } else {
                                numError++;
                            }
                            errRec.row = listError[i].Row__c; 
                            errorsRec.push(errRec);
                        }
                        console.log('canConfirm:'+canConfirm);
                        if (canConfirm) {
                            component.set('v.showConfirm', true);
                            component.set('v.disableSelect', true);
                        }
                        component.set('v.numOK', numOK);
                        component.set('v.numError', numError);
                        component.set('v.showSectionError', true);
                        component.set('v.errorsRecords', errorsRec);
                        console.log('numError:'+numError);
                    }
                    else {
                        setTimeout($A.getCallback(() => this.statusJob(component, event, helper)), 3000);
                    }
                }
                if (state === "ERROR") {
                    component.set("v.showSpinner",false);
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                    errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
            });
            $A.enqueueAction(action);
        }
    },
    showSuccessToast : function(component) {
        component.find('notifLib').showToast({
            "variant": "success",
            "title": "Success!",
            "message": component.get('v.msg')
        });
    },
    showErrorToast : function(cmp) {
        cmp.find('notifLib').showToast({
            "variant": "error",
            "title": "Error!",
            "message": cmp.get('v.errormsg')
        });
    },
    setTableError : function(component){
        var actions  = [{ label: 'Show details', name: 'show_details' ,iconName: 'utility:zoomin'}];
        component.set('v.columnsError', [
            {label: 'N.Riga', fieldName: 'index', type: 'number',initialWidth: 80,  cellAttributes: { class: { fieldName: 'rowCSSClass' }}},
            {label: 'Stato', fieldName: 'description', type: 'text',initialWidth: 320,  cellAttributes: { class: { fieldName: 'rowCSSClass' }}},
            {label: 'Riga', fieldName: 'row', type: 'text',  cellAttributes: { class: { fieldName: 'rowCSSClass' }}},
            {type: 'action', typeAttributes: { rowActions: actions  } }

        ]);
    },
    showModalRow: function(component,row) {
        if (row!=null && row.row!=null) {
            var rowField = row.row.split(";");
            var headerList =  component.get('v.headerList');
            if (headerList!=null) {
                var elems =[];
                for (var i=0;i<headerList.length;i++) {
                    if (rowField[i]!=null) {
                        var elem = {};
                        elem.header = headerList[i];
                        elem.row = rowField[i];
                        elems.push(elem);
                    }
                } 
                component.set('v.rowFieldList',elems);
            }
        }
        component.set('v.showModal',true);
    }
       
})