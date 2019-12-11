({
    init : function(cmp, event, helper) 
    {
        var action = cmp.get('c.doInit');
        action.setParams({'recordId' : cmp.get('v.recordId')});
        action.setCallback(this, function(response)
                           {
                               if(response.getState() == 'SUCCESS' ) 
                               {
                                   var wrapObj = response.getReturnValue();
                                   console.log('+++++++++ ' + JSON.stringify(wrapObj))
                                   var task = wrapObj.tk;
                                   var prodotto = wrapObj.prodotto;
                                   cmp.set('v.prodotto',prodotto);
                                   cmp.set('v.customerName',task.Customer__r.FirstName);
                                   cmp.set('v.customerCellulare',task.Customer__r.Telefono_Cellulare__c);
                                   cmp.set('v.customerTelefonoFisso',task.Customer__r.Telefono_Casa__c);
                                   cmp.set('v.customerOCSCode',task.Customer__r.getCodice_Cliente__c);
                                   cmp.set('v.customerCognome',task.Customer__r.LastName);
                               }
                           });
        $A.enqueueAction(action);
    },
    fissaAppuntamentoJavascript : function(cmp, event, helper)
    {
        // azione redirect in attesa del componente FIssa Appuntamento
        var action = cmp.get('c.fissaAppuntamento');
        action.setParams({'recordId' : cmp.get('v.recordId')});
        action.setCallback(this,function(response){
            if(response.getState() == 'SUCCESS' ) 
            {
                // redirect su fissaAppuntamento
                var toastEvent = $A.get("e.force:showToast"); 
                toastEvent.setParams({
                    "title": "Attenzione",
                    "message": "In Attesa del componente fissa Appuntamento",
                    "type" : "Warning"	
                });
                toastEvent.fire();   
                window.history.back();
            }
        });
        $A.enqueueAction(action);
    },
    
    saveSelect : function(cmp, event, helper)
    {
        console.log("logEvent");
        var dispo = event.getParam('disposition');
        var action = cmp.get('c.saveSelection');
        action.setParams({'recordId' :cmp.get('v.recordId'),
                          'esito' :dispo
                         });
        action.setCallback(this,function(response){
            if(response.getState() == 'SUCCESS' ) 
            {
                console.log("logEvent");
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
                    window.history.back();
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