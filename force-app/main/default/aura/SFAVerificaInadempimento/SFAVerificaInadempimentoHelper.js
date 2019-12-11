({
    handleInit: function(cmp) {
        this.setColumns(cmp);
        this.getData(cmp);
    },
    
    loadCaseHelper: function(cmp, c) {
        this.showSpinner(cmp);
        var action = cmp.get('c.loadCaseCtrl');
      action.setParams({
            caseId : c.Id
        });
        action.setCallback(this,function (response){
            if(response.getState() == 'SUCCESS'){
                var cas = response.getReturnValue();
                cmp.set('v.selectedCase', cas);
                cmp.set('v.isInserimento', cas.Subject == 'Apertura reclamo');
                cmp.set("v.isSFA", cas.Abbuono_Chiusura__c);
                this.getNotes(cmp);
                this.getEmails(cmp);
            }
            else
                console.log('errore nella risposta del server');
            this.hideSpinner(cmp);
            
        });
        $A.enqueueAction(action);
    },
    
    esita: function(cmp) {
        this.showSpinner(cmp);
        var action = cmp.get('c.esitaCtrl');
      action.setParams({
            ident :   cmp.get('v.selectedCase').Id,
          note : cmp.get('v.noteValue')
        });
        action.setCallback(this,function (response){
            if(response.getState() == 'SUCCESS'){
                cmp.set('v.msg','Operazione Riuscita');
                showSuccessToast(cmp);
                 $A.get('e.force:refreshView').fire();
            }
            else
                console.log('errore nella risposta del server');
            this.hideSpinner(cmp);
            
        });
        $A.enqueueAction(action);
    },
    
    setColumns : function(cmp) {
        cmp.set('v.inadempimentiColumns' , [//Capire quale campo caricare {label: 'Data Alert', fieldName: 'confidence', type: 'date' },
            //Capire quale campo caricare {label: 'Tipo Alert', fieldName: 'confidence', type: 'percent' },
            {label: 'Reclamo N.', fieldName: 'Numero_Reclamo__c', type: 'text' },
            //Capire quale campo caricare{label: 'Nome', fieldName: 'confidence', type: 'percent' },
            // Capire quale campo caricare {label: 'Cognome', fieldName: 'confidence', type: 'percent' },
            {label: 'Tipo', fieldName: 'Tipo_Reclamo__c', type: 'text' },
            {label: 'Categoria', fieldName: 'CategoriaName', type: 'text' },
            {label: 'Dealer', fieldName: 'DealerName__c', type: 'text' },
            //Capire quale campo caricare {label: 'Ricevuto in data', fieldName: 'confidence', type: 'percent' },
            {label: 'Tipo Pratica', fieldName: 'Tipo_Pratica__c', type: 'text' },
            {label: 'ID Filiale', fieldName: 'SuppliedCompany', type: 'text' }, // da verificare
            {label: 'Grave', fieldName: 'Inadempimento_Grave__c', type: 'boolean' },
            {label: 'Pratica N.', fieldName: 'NumeroPratica__c', type: 'text' },
            {label: 'Stato', fieldName: 'Status', type: 'text' }
        ]);

        cmp.set('v.noteColumns' , [
            {label: 'Titolo', fieldName: 'Title', type: 'text' },
            {label: 'Testo', fieldName: 'TextPreview', type: 'text' },
            {label: 'Data', fieldName: 'CreatedDate', type: 'date', initialWidth: 150, typeAttributes:{ year: "2-digit", month: "2-digit", day: "2-digit" } },
        ]);

        cmp.set('v.emailColumns' , [
            {label: 'Oggetto', fieldName: 'Subject', type: 'text' },
            {label: 'Messaggio', fieldName: 'TextBody', type: 'text' },
            {label: 'Inviata a', fieldName: 'ToAddress', type: 'text' },
            {label: 'Data', fieldName: 'MessageDate', type: 'date', initialWidth: 150, typeAttributes:{ year: "2-digit", month: "2-digit", day: "2-digit" } },
        ]);

        cmp.set('v.fileColumns' , [
            {label: 'Nome', fieldName: 'Link', type: 'url', typeAttributes:{ label: { fieldName: 'Title' } }},
            {label: 'Data', fieldName: 'CreatedDate', type: 'date', initialWidth: 150, typeAttributes:{ year: "2-digit", month: "2-digit", day: "2-digit" } },
        ]);
        
        
    },
    
    getData : function (cmp) {
        this.showSpinner(cmp);
        var action = cmp.get('c.loadCase');
        action.setCallback(this,function (response){
            if(response.getState() == 'SUCCESS'){
                var cases = response.getReturnValue();
                for (var i=0; i<cases.length; i++) {
                    cases[i].CategoriaName = cases[i].Categoria_Riferimento__r ? cases[i].Categoria_Riferimento__r.Name : null;
                    cases[i].IdFiliale = cases[i].Branch__r ? cases[i].Branch__r.getCodice_Cliente__c : null;
                }
                cmp.set('v.caseList', cases);
                
            }
            else
                console.log('errore nella risposta del server');
            this.hideSpinner(cmp);
            
        });
        $A.enqueueAction(action);
    },

    getFiles: function(cmp) {
        this.showSpinner(cmp);
        var action = cmp.get("c.getFiles");

        action.setParams({
            caseId : cmp.get('v.selectedCase').Id
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var files = response.getReturnValue();
                for (var i=0; i<files.length; i++) {
                    files[i].Link = '/sfc/servlet.shepherd/version/download/'+files[i].Id;
                }
                cmp.set("v.fileList", files);
            }
            else if (state === 'ERROR') {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        cmp.set('v.msg', errors[0].message);
                        this.showErrorToast(cmp);
                    }
                } else {
                    cmp.set('v.msg', 'Unknown error');
                    this.showErrorToast(cmp);
                }
            }
            this.hideSpinner(cmp);
        })
        
        $A.enqueueAction(action);
    },

    getAttachments: function(cmp) {
        this.showSpinner(cmp);
        var action = cmp.get("c.getAttachments");

        action.setParams({
            caseId : cmp.get('v.selectedCase').Id
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.allegatiOriginali", response.getReturnValue());
                cmp.set("v.staticFileList", response.getReturnValue());
            }
            else if (state === 'ERROR') {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        cmp.set('v.msg', errors[0].message);
                        this.showErrorToast(cmp);
                    }
                } else {
                    cmp.set('v.msg', 'Unknown error');
                    this.showErrorToast(cmp);
                }
            }
            this.hideSpinner(cmp);
        })
        
        $A.enqueueAction(action);
    },

    saveAttachments: function(cmp) {
        this.showSpinner(cmp);
        var action = cmp.get("c.saveAttachments");

        action.setParams({
            caseId : cmp.get('v.selectedCase').Id,
            allegati: cmp.get('v.staticFileList'),
            allegatiOriginali: cmp.get('v.allegatiOriginali').length
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('file salvati');
            }
            else if (state === 'ERROR') {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        cmp.set('v.msg', errors[0].message);
                        this.showErrorToast(cmp);
                    }
                } else {
                    cmp.set('v.msg', 'Unknown error');
                    this.showErrorToast(cmp);
                }
            }
            this.hideSpinner(cmp);
        })
        
        $A.enqueueAction(action);
    },

    getNotes: function(cmp) {
        this.showSpinner(cmp);
        var action = cmp.get("c.getNotes");

        action.setParams({
            caseId : cmp.get('v.selectedCase').Id
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.noteList", response.getReturnValue());
            }
            else if (state === 'ERROR') {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        cmp.set('v.msg', errors[0].message);
                        this.showErrorToast(cmp);
                    }
                } else {
                    cmp.set('v.msg', 'Unknown error');
                    this.showErrorToast(cmp);
                }
            }
            this.hideSpinner(cmp);
        })
        
        $A.enqueueAction(action);
    },

    getEmails: function(cmp) {
        this.showSpinner(cmp);
        var action = cmp.get("c.getEmails");

        action.setParams({
            caseId : cmp.get('v.selectedCase').Id
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.emailList", response.getReturnValue());
            }
            else if (state === 'ERROR') {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        cmp.set('v.msg', errors[0].message);
                        this.showErrorToast(cmp);
                    }
                } else {
                    cmp.set('v.msg', 'Unknown error');
                    this.showErrorToast(cmp);
                }
            }
            this.hideSpinner(cmp);
        })
        
        $A.enqueueAction(action);
    },

    refresh: function(cmp) {
        cmp.set('v.selectedCase', null);
        cmp.find('inadempimenti-datatable').set('v.selectedRows', []);
        this.handleInit(cmp);
    },

    isBlank: function (input) {
        var value = input.get('v.value');
        if (value === undefined || value === null || value == '' || value == ' ') {
            return true;
        }
        return false;
    },

    assignToCentroRecuperoLegale: function(cmp) {
        this.showSpinner(cmp);
        var action = cmp.get("c.assignToCentroRecuperoLegale");

        action.setParams({
            myCase: cmp.get('v.selectedCase')
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                this.refresh(cmp);
            }
            else if (state === 'ERROR') {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        cmp.set('v.msg', errors[0].message);
                        this.showErrorToast(cmp);
                    }
                } else {
                    cmp.set('v.msg', 'Unknown error');
                    this.showErrorToast(cmp);
                }
            }
            this.hideSpinner(cmp);
        })
        
        $A.enqueueAction(action);
    },

    showSuccessToast : function(cmp) {
        cmp.find('notifLib').showToast({
            "variant": "success",
            "title": "Success!",
            "message": cmp.get('v.msg')
        });
    },

    showErrorToast : function(cmp) {
        cmp.find('notifLib').showToast({
            "variant": "error",
            "title": "Error!",
            "message": cmp.get('v.msg')
        });
    },

    showInfoToast : function(cmp) {
        cmp.find('notifLib').showToast({
            "variant": "info",
            "title": "Info",
            "message": cmp.get('v.msg')
        });
    },

    showWarningToast : function(cmp) {
        cmp.find('notifLib').showToast({
            "variant": "warning",
            "title": "Warning!",
            "message": cmp.get('v.msg')
        });
    },
	
	showNotice : function(cmp) {
        cmp.find('notifLib').showNotice({
            "variant": "info",
            "header": "Info",
            "message": cmp.get("v.notifMsg"),
            closeCallback: function() {
                
            }
        });
    },

    showSpinner: function(cmp) {
        cmp.set('v.showSpinner', true);
    },

    hideSpinner: function(cmp) {
        cmp.set('v.showSpinner', false);
    }
})