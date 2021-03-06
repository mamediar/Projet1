({
    init : function(cmp, event, helper) { 
        cmp.set("v.tableColumns", [
            {label: 'Esito Retention Memorizzato', fieldName:'dispositionName', type: 'text',fixedWidth:200},
            {label: 'Procedura', fieldName: 'LoanType__c', type: 'text' ,fixedWidth:120},
            {label: 'Num Pratica', fieldName: 'LoanNumber__c', type: 'text',fixedWidth:120},
            {label: 'Stato Pratica', fieldName: 'LoanStatus__c', type: 'text',fixedWidth:120},
            {label: 'Attributo Pratica', fieldName: 'LoanStatusAttribute__c', type: 'text',fixedWidth:120},
            {label: 'Prima Data Scadenza', fieldName: 'FirstDueDate__c', type: 'date',fixedWidth:120},
            {label: 'Ultima Data Scadenza', fieldName: 'LastDueDate__c', type: 'date',fixedWidth:120},
            {label: 'Cod Prodotto', fieldName: 'ProductCode__c', type: 'text',fixedWidth:120},
            {label: 'Des Prodotto', fieldName: 'ProductDescription__c', type: 'text',fixedWidth:120},
            {label: 'Mod Pagamento', fieldName: 'RepaymentMode__c', type: 'text',fixedWidth:120},
            {label: 'Importo Finanziato', fieldName: 'FinancedAmount__c', type: 'number',fixedWidth:120},
            {label: 'Montante', fieldName: 'TotalAmount__c', type: 'number',fixedWidth:120},
            {label: 'Data Liquidazione', fieldName: 'LiquidDate__c', type: 'date',fixedWidth:120},
            {label: 'Data Estinzione', fieldName: 'ExtinctionDate__c', type: 'date',fixedWidth:120},
            {label: 'Saldo Pratica', fieldName: 'Balance__c', type: 'text',fixedWidth:120},
            {label: 'Cod Cliente', fieldName: 'AccountCode', type: 'text',fixedWidth:120},
            {label: 'Data Inserimento Retention', fieldName: 'CreatedDate', type: 'date',fixedWidth:120},
            {label: 'Data Ultimo Agg. Retention', fieldName: 'LastModifiedDate', type: 'date',fixedWidth:120},
            {label: 'Retention Azione', fieldName: 'Action__c', type: 'text',fixedWidth:120},
            {label: 'Retention Valore', fieldName: 'RetentionValue__c', type: 'text',fixedWidth:120},
            {label: 'Canale', fieldName: 'Source__c', type: 'text',fixedWidth:120}
        ]);
        cmp.set("v.listTasso",[
            {"label" : "Tasso non Comunicato", "value" : ""},
            {"label" : "0,5%", "value" : "0,5"},
            {"label" : "1%", "value" : "1"}
        ]);
        cmp.set("v.listObiezione",[
            {"label" : "Nessuna Obiezione", "value" : ""},
            {"label" : "Gia transitato in filiale", "value" : "Gia transitato in filiale"},
            {"label" : "No Appuntamento Senza Offerta", "value" : "No Appuntamento Senza Offerta"},
            {"label" : "Ha offerta competitiva", "value" : "Ha offerta competitiva"}
        ]);
        var action = cmp.get('c.doInit');
        action.setParams({
            'caseId' : cmp.get('v.recordId')
        });
        action.setCallback(this, function(response)
                           {
                               if(response.getState() == 'SUCCESS' ) 
                               {
                                   var obj = response.getReturnValue();
                                   var listRetention = obj.lRetention;
                                   console.log(JSON.stringify(listRetention));
                                   for(var i = 0; i < listRetention.length ; i++)
                                   {
                            			listRetention[i].dispositionName = (listRetention[i].Disposition__c === undefined || listRetention[i].Disposition__c == null ) ? "" : listRetention[i].Disposition__r.Name ;
                                       listRetention[i].AccountCode = listRetention[i].Customer__r.getCodice_Cliente__c;
                                   }
                                   cmp.set('v.listaRetention', listRetention);
                                   cmp.set('v.currentCase',obj.c);
                               }
                           });
        $A.enqueueAction(action);
    },
    saveSelection : function(cmp, event, helper)
    {
        var dispo = event.getParam('disposition');
        var listRetentionSelected = cmp.get('v.listaRetentionSelected');
        var listRetention = cmp.get('v.listaRetention');
        for(var i = 0; i < listRetention.length ; i++)
        {
            for(var k = 0; k < listRetentionSelected.length ; k++)
            {
                if(listRetention[i].LoanNumber__c == listRetentionSelected[k].LoanNumber__c)
                {
                    listRetention[i].Disposition__c = dispo.Id;
                    listRetention[i].dispositionName = dispo.Name;   
                }   
            }
        }
        cmp.set('v.listaRetention',listRetention);
        cmp.set('v.dataTableFlag',false);
        cmp.set('v.dataTableFlag',true);
    },
    getSelected : function(cmp, event, helper)
    {
        var selectedRows = event.getParam('selectedRows');
        cmp.set('v.listaRetentionSelected',selectedRows);
    },
    handleSelezionaObiezione : function(cmp, event, helper) {
        var obiezione = cmp.find("obiezioneSelezione").get("v.value");
        cmp.set("v.obiezioneSelezionata", obiezione);
    },
    handleSelezionaTasso : function(cmp, event, helper) {
        var tasso = cmp.find("tassoSelezione").get("v.value");
        cmp.set("v.tassoSelezionato", tasso);
    },
    indietroAttivita : function(cmp, event, helper){
        window.history.back();
    },
    completaAttivita : function(cmp, event, helper){
        var action = cmp.get('c.completaAction');
        action.setParams({
            'caseId' : cmp.get('v.recordId'),
            'listaRetention' : cmp.get('v.listaRetention'),
            'noteUtente' : cmp.get('v.noteValue'),
            'tassoSelezionato' : cmp.get('v.tassoSelezionato'),
            'obiezioneSelezionata' : cmp.get('v.obiezioneSelezionata')
        });
        action.setCallback(this, function(response)
                           {
                               if(response.getState() == 'SUCCESS' ) 
                               {
                                   var toastEvent = $A.get("e.force:showToast");
                                   var wrapObj = response.getReturnValue();
                                   var check = wrapObj.res;
                                   var messToast = wrapObj.messToast;
                                   console.log("Dentro CallBack");
                                   if(check)
                                   {
                                       toastEvent.setParams({
                                           "title": "Successo",
                                           "message": messToast,
                                           "type" : "Success"	
                                       });
                                       toastEvent.fire();
                                       $A.get('e.force:refreshView').fire();
                                   }
                                   else
                                   {
                                       toastEvent.setParams({
                                           "title": "Attenzione",
                                           "message": messToast,
                                           "type" : "Warning"	
                                       });
                                       toastEvent.fire();
                                   }
                                   
                               }
                           });
        $A.enqueueAction(action);
    }
})