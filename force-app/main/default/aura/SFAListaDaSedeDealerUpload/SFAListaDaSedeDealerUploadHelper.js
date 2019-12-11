({
    initForm : function(component,event){
        var action = component.get("c.initForm");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var obj=JSON.parse(response.getReturnValue());
                component.set("v.tipologia_lista",obj[0]);
                component.set("v.tipologia_attivita",obj[1]);
            }
            else if (state === "INCOMPLETE") {
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
            //this.hide(component,event);
        });
        $A.enqueueAction(action);
    },

    preventInit : function(component, helper, file) {
        var nomeLista = component.find('nome_lista').get("v.value");
        this.show(component,event);
        var action = component.get("c.preventInitForm");
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            debugger;
            component.set("v.datenow",result);
            this.initForm(component,event);
            if(result!=null){
                this.statusJob(component, event, helper);
                //setTimeout($A.getCallback(() => this.statusJob(component, event, helper)), 2000);
            }else{
                this.hide(component,event);
            }
        });
        $A.enqueueAction(action);

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
                component.set("v.TargetFileName",output);
               
            };
            reader.onload = function(e) {
                var data=e.target.result;
                component.set("v.fileContentData",data);
                console.log("file data"+JSON.stringify(data));
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
    
    saveRecords : function(component, event, helper){
        this.show(component,event);
        var action = component.get("c.processData");

        var data_visibilita = component.find('data_visibilita').get("v.value");
        if(data_visibilita==null || data_visibilita == undefined || data_visibilita == ''){
            data_visibilita = new Date();
        }

        var fieldsList=['ocs_code','name','branch','area','region','tipo_intermediario','tipo_accordo','anag_type','birthdate','birthcity','birthprovince','sex','fiscalcode','piva','agente_ocs_code','agente_name','subagente_ocs_code','subagente_name','macroarea','prod_dom','address','town','province','cap','phone1','fax','email','phone2','address2','priority','last_name','first_name','canale_web','gestione_web','agente_d_conv','due_date'];
        //component.set("v.datenow",Date.now());
        action.setParams({ fileData : component.get("v.fileContentData"),
                          fields:fieldsList,
                          tipo_attivita: component.find('tipo_attivita').get("v.value"),
                          nome_lista: component.find('nome_lista').get("v.value"),
                          tipo_lista: component.find('tipo_lista').get("v.value"),
                          //data_elaborazione: component.get('v.datenow'),
                          data_visibilita: data_visibilita
                        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var listaC=response.getReturnValue();
                component.set("v.datenow",listaC.Data_Caricamento__c);
                component.set("v.showMain",true);
                this.refreshOrderSFAListaDaSedeGestisciListeCaricate(component, listaC);
                //this.statusJob(component, event, helper);
                setTimeout($A.getCallback(() => this.statusJob(component, event, helper)), 2000);
            }
            else if (state === "INCOMPLETE") {
                //alert('saved successfully');
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
            var status=false;
            
            
        });
        $A.enqueueAction(action);
    },
    statusJob: function (component, event, helper) {
        try{
            if(component.get('v.datenow')==null || component.get('v.datenow') == undefined || component.get('v.datenow') == ''){
                component.set("v.datenow",Date.now());
            }
            var action = component.get("c.reportUpload");
            
            action.setParams({ 
                            data_elaborazione : component.get('v.datenow')
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var obj=JSON.parse(response.getReturnValue());
                    if(obj!=null && obj.Id!='' && obj.Id!= undefined && obj.Numero_Righe__c!='-1') {
                        var d = new Date(obj.Data_Caricamento__c),
                        dformat =  this.formatDate(d);
                        component.set("v.errorHeader",obj.Nome_Lista__c+' Data Caricamento: '+ dformat);
                        this.getListaCheck(component,event, helper);
                        this.hide(component,event);
                    }
                    else {
                        setTimeout($A.getCallback(() => this.statusJob(component, event, helper)), 8000);
                        //setTimeout(this.statusJob(component,event), 10000);
                    }
                }
                if (state === "ERROR") {
                    //setTimeout($A.getCallback(() => this.statusJob(component,event)), 8000);
                    this.hide(component,event);
                        component.set("v.toastMsg", "Elaborazione fallita");
                        this.showToastError(component);
                }
                if (state === "INCOMPLETE") {
                    setTimeout($A.getCallback(() => this.statusJob(component, event, helper)), 8000);
                }
            });
            $A.enqueueAction(action);

        }catch(error){

        }
    },
    show: function (cmp, event) {
        cmp.set("v.showSpinner", true);
    },
    hide:function (cmp, event) {
        cmp.set("v.showSpinner", false);
    },
    getListaCheck : function(component, event, helper) {
        var action = component.get("c.getListaCheckWithOffset");
        action.setStorable();
        action.setParams({
            'pageSize' : component.get("v.pageSize").toString(),
            'pageNumber' : component.get("v.pageNumber").toString(),
            'data_elaborazione': component.get('v.datenow')
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            debugger;
            if (state === "SUCCESS") {
                console.log('Response Time: '+((new Date().getTime())-requestInitiatedTime));
                if(response.getReturnValue().length < component.get("v.pageSize")){
                    component.set("v.isLastPage", true);
                } else{
                    component.set("v.isLastPage", false);
                }
                component.set("v.resultSize", response.getReturnValue().length);
                var records = response.getReturnValue();
                for (var i = 0; i < records.length; i++) {
                    var row = records[i];
                    var d = new Date(row.LastModifiedDate),
                    dformat = this.formatDate(d);
					row.LastModifiedDate = dformat;
                    row.nome_lista=row.SFA_ListeCaricate__r.Nome_Lista__c;
                    row.tipo_attivita=row.SFA_ListeCaricate__r.Tipo_Attivita__r.Descrizione__c;
                }
                component.set("v.data", records);
                debugger;
                if(records.length>0) {
                    component.set("v.toastMsg", "Elaborazione avvenuta in maniera parziale, consultare gli avvisi.");
                    this.showToastWarning(component);
                }
                else {
                    component.set("v.toastMsg", "Elaborazione avvenuta con successo");
                    this.showToastSuccess(component);
                }
                this.refreshSFAListaDaSedeGestisciListeCaricate(component, event, helper);
            }
        });
        var requestInitiatedTime = new Date().getTime();
        
        $A.enqueueAction(action);
    },
    getListaCheckByName : function(component, event, nomeLista) {
        var x = nomeLista;
        debugger;
        var action = component.get("c.getListaCheckByNameListWithOffset");
        action.setStorable();
        action.setParams({
            'pageSize' : component.get("v.pageSize").toString(),
            'pageNumber' : component.get("v.pageNumber").toString(),
            'nomeLista': nomeLista
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            debugger;
            if (state === "SUCCESS") {
                console.log('Response Time: '+((new Date().getTime())-requestInitiatedTime));
                if(response.getReturnValue().length < component.get("v.pageSize")){
                    component.set("v.isLastPage", true);
                } else{
                    component.set("v.isLastPage", false);
                }
                component.set("v.resultSize", response.getReturnValue().length);
                var records = response.getReturnValue();
                for (var i = 0; i < records.length; i++) {
                    var row = records[i];
                    var d = new Date(row.LastModifiedDate),
                    dformat = this.formatDate(d);
					row.LastModifiedDate = dformat;
                    row.nome_lista=row.SFA_ListeCaricate__r.Nome_Lista__c;
                    row.tipo_attivita=row.SFA_ListeCaricate__r.Tipo_Attivita__r.Descrizione__c;
                }
                component.set("v.data", records);
                debugger;
                if(records.length>0) {
                    component.set("v.toastMsg", "Elaborazione avvenuta in maniera parziale, consultare gli avvisi.");
                    this.showToastWarning(component);
                }
                else {
                    component.set("v.toastMsg", "Elaborazione avvenuta con successo");
                    this.showToastSuccess(component);
                }
                this.refreshSFAListaDaSedeGestisciListeCaricate(component, event, helper);
            }
        });
        var requestInitiatedTime = new Date().getTime();
        
        $A.enqueueAction(action);
    },
    formatDate: function (date) {
        var hours = date.getHours();
        var minutes = date.getMinutes();
        var seconds = date.getSeconds();
        //var ampm = hours >= 12 ? 'pm' : 'am';
        //hours = hours % 12;
        hours = hours ? hours : 12; // the hour '0' should be '12'
        hours = hours < 10 ? '0'+hours : hours;
        minutes = minutes < 10 ? '0'+minutes : minutes;
        seconds = seconds < 10 ? '0'+seconds : seconds;
        var day = date.getDate()< 10 ? '0'+date.getDate() : date.getDate();
        var month = (date.getMonth()+1)<10 ? '0'+(date.getMonth()+1) : date.getMonth()+1;
        
        var strTime = hours + ':' + minutes + ':' + seconds + ' ';
        return day + "/" + month + "/" + date.getFullYear() + "  " + strTime;
    },
    showToastSuccess: function(component) {
        component.find('notifLib').showToast({
            "title": "Success",
            "message": component.get("v.toastMsg"),
            "variant": "success"
        });
    },
    
    showToastError: function(component) {
        component.find('notifLib').showToast({
            "title": "Error",
            "message": component.get("v.toastMsg"),
            "variant": "error"
        });
    },
    
    showToastWarning: function(component) {
        component.find('notifLib').showToast({
            "title": "Warning",
            "message": component.get("v.toastMsg"),
            "variant": "warning"
        });
    },
    refreshSFAListaDaSedeGestisciListeCaricate: function(component, event, helper) {
        var comp= component.find("listecaricate");
        comp.refresh();
        
    },
    refreshOrderSFAListaDaSedeGestisciListeCaricate: function(component, listaCaricata) {
        var comp= component.find("listecaricate");       
        var list =new Array();
        var tmp= null;
        debugger;
        if(listaCaricata.Chiuso__c!=null && listaCaricata.Chiuso__c) {
            tmp= {Id: listaCaricata.Id, Chiuso__c: false};
        }
        else {
        	tmp= {Id: listaCaricata.Id, Ordine_Visualizzazione__c: listaCaricata.Ordine_Visualizzazione__c};
        }
        list[0]=tmp;
        comp.loadDealer(list);
        
    },
    checkEnableElabora: function(component) {
        var tipo_attivita = component.find('tipo_attivita').get("v.value");
        var nome_lista = component.find('nome_lista').get("v.value");
        var tipo_lista = component.find('tipo_lista').get("v.value");
        component.set("v.disableElabora",true);
        // controllo valorizzazione tipo attivita
        if (tipo_attivita!=null && tipo_attivita!="") {
           // controllo valorizzazione nome lista o tipo lista
            if ((nome_lista!=null && nome_lista!="") || (tipo_lista!=null && tipo_lista!="")) {
                component.set("v.disableElabora",false);
            }
        } 
    }

});