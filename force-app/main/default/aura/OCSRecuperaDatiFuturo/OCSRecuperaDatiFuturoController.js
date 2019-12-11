({
	init:function(cmp,event,helper){
        if(cmp.get('v.inputAccountId')){
            var action=cmp.get('c.getInputAccountOCSId');
            action.setParam('accountId',cmp.get('v.inputAccountId'));
            action.setCallback(this,function(resp){
                if(resp.getState()=='SUCCESS'){
                    cmp.set('v.codCliente',resp.getReturnValue());
                    helper.doRicercaHelper(cmp,event,helper);
                }
               helper.hideSpinner(cmp);
            });
            helper.showSpinner(cmp);
            $A.enqueueAction(action);
        }
    },
    
    doRicerca:function(cmp,event,helper){
        
        var allValid = cmp.find("fieldToCheck").reduce(function (validFields,inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validFields && inputCmp.get('v.validity').valid;
        }, true);

        if(allValid){
            helper.doRicercaHelper(cmp,event,helper);
        }else{
            cmp.set("v.toastMsg", "Verifica la corretezza dei campi inseriti");
            helper.showToastError(cmp);
        }
    },
    
    selectCliente:function(cmp,event,helper){
        var selRow=event.getParam('selectedRows')[0];
        helper.getPratiche(cmp,selRow,helper);
    },
    
    selectPratica:function(cmp,event,helper){
        cmp.set('v.praticaSelezionata',event.getParam('selectedRows')[0]);
    },
    checkLength:function(cmp,event,helper){
        helper.checkLengthField(cmp,event,helper);
    }
})