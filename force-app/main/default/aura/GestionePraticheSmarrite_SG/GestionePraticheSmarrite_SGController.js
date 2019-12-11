({
    init : function(cmp, event, helper) {
        cmp.set('v.selectedContracts', []);
        
        cmp.set('v.columns', [
            {label: 'Data', fieldName: 'DataSmarrimento__c', type: 'date'},
            {label: 'Giorni', fieldName: 'LostDays__c', type: 'number'},
            {label: 'Lotto',fieldName: 'OCSLottoId__c', type: 'text'},
            {label: 'Contratto', fieldName: 'ContractNumber__c', type: 'text'},
            {label: 'Data Contratto', fieldName: 'StartDate', type: 'text'},
            {label: 'Accollo', fieldName: 'isAccollo__c', type: 'boolean'},
            {label: 'Cliente', fieldName: 'AccountName__c', type: 'reference'},
            {label: 'Codice Fiscale', fieldName: 'AccountFiscalCode__c', type: 'text'},
            {label: 'Data Nascita', fieldName: 'AccountBirthdate__c', type: 'date'},
            {label: 'Città Nascita', fieldName: 'AccountBirthcity__c', type: 'text'},
            {label: 'Prov. Nascita', fieldName: 'AccountBirthprovince__c', type: 'text'},
            {label: 'Città', fieldName: 'AccountCity__c', type: 'text'},
            {label: 'Provincia', fieldName: 'AccountProvince__c', type: 'text'},
            {label: 'Tipo Prodotto', fieldName: 'ProductType__c', type: 'text'}
        ]);
        helper.selectContracts(cmp);
    },
    
    generateReport: function(cmp, event, helper) {
        var contractTable = cmp.find('contractTable');
        var selectedRows = contractTable.getSelectedRows();
        if(selectedRows.length == 0)
                {
                    cmp.set('v.complaintDisabled', true);
                }
        else
                {
                    cmp.set('v.complaintDisabled', false);
                }
        var action = cmp.get('c.generatePDFPreviewURL');
        action.setParams({
            'contractList': selectedRows,
            'isPreview': 'true',
            'uniqCode': 'uniqCode=XXXXXXXX-XX'
        });
        action.setCallback(this, function(response) {
            if (response.getState() == 'SUCCESS') {
                var result = response.getReturnValue();
                cmp.set('v.url', result);
              	if(selectedRows.length == 0)
                {
                    cmp.set('v.complaintDisabled', true);
                }
                else
                {
                    cmp.set('v.complaintDisabled', false);
                }
            }
            else
            {
                cmp.set('v.complaintDisabled', true);
            }
        });
        cmp.set('v.selectedContracts', selectedRows);
        console.log(cmp.get('v.selectedContracts'));
        $A.enqueueAction(action);
    },
    
    doDenounce: function(cmp, event, helper) {
        var contractTable = cmp.find('contractTable');
        var selectedRows = contractTable.getSelectedRows();
        var action = cmp.get('c.generatePDF');
        var evt = $A.get("e.c:OpenModalEvent");
        evt.setParams({ "openModal": false });
        action.setParams({'reportedContracts': selectedRows });
        action.setCallback(this, function(response) {
            if (response.getState() == 'SUCCESS') {
                var result = response.getReturnValue();
                var contrattiKO = result.ContractKO;
                var contrattiOK = result.ContractOK;
                console.log('*** result :: ' + result);
                console.log('***222 result :: ' + contrattiKO);
                console.log('***333 result ::' + contrattiOK );
                if (result.Url == '') {
                    cmp.find('notifLib').showNotice({
                        "variant": "error",
                        "header": "Errore durante il cambio stato",
                        "message": "Abbiamo riscontrato un errore durante la richiesta di cambio stato.\nContattare l'amministratore di sistema.",
                        closeCallback: function() {
                            //alert('You closed the alert!');
                        }
                    });
                } else {
                    if(contrattiKO.length > 0)
                    {
						var testo = '';
                        var header = "Contratti Processati Con Successo: " + contrattiOK.length +"         .Errore Nei Seguenti Contratti:";
                        for (var i = 0; i < contrattiKO.length; i++) { 
                            testo += '-Contratto: ' + contrattiKO[i].ContractNumber__c + " Lotto:" + contrattiKO[i].OCSLottoId__c + "\n";
                        }
                        console.log('LUNGHEZZA :::::' + contrattiKO.length);
                        console.log(testo);
                        cmp.find('notifLib').showNotice({
                            "variant": "error",
                            "header": header,
                            "message": testo,
                        closeCallback: function() {
                            //alert('You closed the alert!');
                        }
                    }); 
                    }                   
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title: result.Url ? "Le pratiche sono state segnalate come denunciate" : "Selezionare almeno una pratica",
                        type: result.Url ? "success" : "warning",
                        message: " "
                    });
                    toastEvent.fire();
                    if (result) {
                        cmp.set('v.url', result.Url);
                       	helper.caseNewInstance(cmp, contrattiOK);
                        helper.selectContracts(cmp);
                        helper.resetSelection(cmp);
                    //    $A.get('e.force:refreshView').fire();
                    }
                }
            }
        });
        evt.fire();
        $A.enqueueAction(action);
    },
    
    openModal: function(cmp, event) {
        var contractTable = cmp.find('contractTable');
        var selectedRows = contractTable.getSelectedRows();
        if (selectedRows.length < 1) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: "Selezionare almeno una pratica",
                type: "warning",
                message: " "
            });
            toastEvent.fire();
        } else {
            var event = $A.get("e.c:OpenModalEvent");
            event.setParams({
                "openModal": true,
                "title": "Si desidera continuare?"
            });
            event.fire();
        }
    }
})