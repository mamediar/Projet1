({
    init : function(cmp, event, helper) 
    {
        cmp.set("v.tableColumns", [
            {label: 'Codice Cliente', fieldName:'AccountgetCodice_Cliente__c', type: 'text',fixedWidth:120},
            {label: 'Cod Pratica', fieldName: 'NumeroPratica__c', type: 'text' ,fixedWidth:120},
            {label: 'Cod Area', fieldName: '', type: 'text' ,fixedWidth:120},
            {label: 'Filiale Conteggio', fieldName: 'BranchgetCodice_Cliente__c', type: 'text' ,fixedWidth:120},
            {label: 'Descrizione', fieldName: 'BranchName', type: 'text' ,fixedWidth:120},
            {label: 'Cod Prodotto', fieldName: 'Tipo_Prodotto__c', type: 'text' ,fixedWidth:120},
            {label: 'Cod Causale Conteggio', fieldName: 'Retention_CodiceCausaleConteggio__c', type: 'text' ,fixedWidth:120},
            {label: 'Descrizione Causale Conteggio', fieldName: 'Retention_DescrizioneCausaleConteggio__c', type: 'text' ,fixedWidth:120},
            {label: 'Data Conteggio', fieldName: 'Retention_DataConteggio__c', type: 'date' ,fixedWidth:120},
            {label: 'Lettera EA', fieldName: 'Retention_LetteraEstinzioneAnticipata__c', type: 'text' ,fixedWidth:120},
            {label: 'Offerta', fieldName: 'Retention_Offerta__c', type: 'text' ,fixedWidth:120}
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
        var action = cmp.get("c.doInit");
        action.setParams({'recordId': cmp.get('v.recordId')});
        action.setCallback(this,function(response){
            if(response.getState() == 'SUCCESS' ) 
            {
                var obj = response.getReturnValue();
                console.log(JSON.stringify(obj));
                obj.BranchName = obj.Branch__r.Name;
                obj.BranchgetCodice_Cliente__c = obj.Branch__r.getCodice_Cliente__c;
                obj.AccountgetCodice_Cliente__c = obj.Account.getCodice_Cliente__c;
                
                cmp.set('v.currentCase',obj);
                cmp.set('v.currentCases',obj);
            }
        });
         $A.enqueueAction(action);
    },
    saveSelection : function(cmp,event,helper)
    {
        cmp.set('v.dispositionSelected',event.getParam('disposition'));  
    },
    handleSelezionaObiezione : function(cmp, event, helper) {
        var obiezione = cmp.find("obiezioneSelezione").get("v.value");
        cmp.set("v.obiezioneSelezionata", obiezione);
    },
    handleSelezionaTasso : function(cmp, event, helper) {
        var tasso = cmp.find("tassoSelezione").get("v.value");
        cmp.set("v.tassoSelezionato", tasso);
    },
    indietroAttivita : function(cmp,event,helper) {
        window.history.back;
    },
    completa : function(cmp,event,helper) {
        var action = cmp.get('c.completaAttivita');
        action.setParams({
            'c' : cmp.get('v.currentCase'),
            'disp' : cmp.get('v.dispositionSelected'),
            'notaUtente' :  cmp.get('v.noteValue'),
            'tassoOfferto' : cmp.get('v.tassoSelezionato'),
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