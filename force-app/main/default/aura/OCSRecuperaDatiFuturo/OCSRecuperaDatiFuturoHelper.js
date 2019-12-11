({
    doRicercaHelper:function(cmp,event,helper){
        var paramList=['v.cognomeCliente','v.nomeCliente','v.email','v.ragioneSociale','v.telefonoCliente','v.faxCliente','v.codFiscaleCliente','v.codCliente','v.dataNascitaCliente','v.numPratica'];
        cmp.set('v.OCSClienti', null);
        cmp.set('v.idAccSelezionato',[]);
        cmp.set('v.accountSelezionato',null);
        cmp.set('v.praticheList',[]);
        cmp.set('v.praticaSelezionata',null);
        var paramMap={};
        paramList.forEach(function(temp){
            paramMap[temp.substring(2,temp.length)]=cmp.get(temp)!=undefined?cmp.get(temp):'';
        });
        var action=cmp.get('c.getClienti');
        action.setParam('data',paramMap);
        action.setParam('nameProcess',cmp.get("v.nameProcess"));
        
        action.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){
                cmp.set('v.accountList',resp.getReturnValue()['accounts']);
                cmp.set('v.OCSClienti',resp.getReturnValue()['clienti']);
                
                if(resp.getReturnValue()['accounts'].length==1){
                    var listSelId=[];
                    listSelId.push(resp.getReturnValue()['accounts'][0]['Id']);
                    cmp.set('v.idAccSelezionato',listSelId);
                    helper.getPratiche(cmp,resp.getReturnValue()['accounts'][0],helper);
                }
                console.log(resp.getReturnValue()['clienti'].length==0, 'efdafg');
            }
            cmp.set("v.showSpinner", false);
        });
        cmp.set("v.showSpinner", true);
        $A.enqueueAction(action);
    },
    
    getPratiche : function(cmp,selRows,helper) {
        var getCliente=cmp.get('c.getCliente');
        getCliente.setParam('acc',selRows);
        getCliente.setCallback(this,function(response1){
            if(response1.getState()=='SUCCESS'){
                if(cmp.get('v.showPratiche')){
                    var clienti=cmp.get('v.OCSClienti');
                    var praticheTemp=[];
                    clienti.forEach(function(c){
                        if(c['codCliente']==response1.getReturnValue()['External_Id__c'].substring(1,response1.getReturnValue()['External_Id__c'].length)){
                            praticheTemp=c['pratiche'];
                        }
                    });
                    var filtro=cmp.get('v.filtroPratiche');
                    if(filtro!=undefined && filtro!=null && filtro!=''){
                        var action=cmp.get('c.filtraPratiche');
                        action.setParam('pratiche',JSON.stringify(praticheTemp));
                        action.setParam('filtroClass',filtro);
                        action.setCallback(this,function(resp){
                            if(resp.getState()=='SUCCESS'){
                                cmp.set('v.accountSelezionato',response1.getReturnValue());
                                cmp.set('v.praticheList',resp.getReturnValue());
                            }
                            helper.hideSpinner(cmp);
                        });
                        helper.showSpinner(cmp);
                        $A.enqueueAction(action);
                    }
                    else{
                        cmp.set('v.accountSelezionato',response1.getReturnValue());
                        cmp.set('v.praticheList',praticheTemp);
                    }
                }
                else{
                    cmp.set('v.accountSelezionato',response1.getReturnValue());
                }
            }
            helper.hideSpinner(cmp);
        });
        helper.showSpinner(cmp);
        $A.enqueueAction(getCliente);
    },
    
    showSpinner : function(cmp){
        var count = cmp.get("v.spinner")+1;
        cmp.set("v.spinner", count);
    },
     
    hideSpinner : function(cmp){
        var count = cmp.get("v.spinner")-1;
        cmp.set("v.spinner", count);
    },
    checkLengthField : function(component, event, helper) {

        var change = event.getSource().get("v.name");
        if(change==='cap'){
            var val = component.find("cap").get('v.value');
            if(val.length > 5){
                var comp = component.find("cap");
                comp.set('v.value',val.substring(0,5));
            }
        }else if(change==='telFisso'){
            var val = component.get('v.telefonoCasa');
            if(val.length > 11){
                //var comp = component.get('v.telefonoCasa');
                component.set('v.telefonoCasa',val.substring(0,11));
            }
        }else if(change==='telCell'){
            var val = component.get('v.telCellulare');
            if(val.length > 10){
                //var comp = component.get('v.telCellulare');
                component.set('v.telCellulare',val.substring(0,10));
            }

        }else if(change==='telefonoCliente'){
            var val = component.get('v.telefonoCliente');
            if(val.length > 10){
                //var comp = component.get('v.telCellulare');
                component.set('v.telefonoCliente',val.substring(0,10));
            }

        }else if(change==='faxCliente'){
            var val = component.get('v.faxCliente');
            if(val.length > 10){
                //var comp = component.get('v.telCellulare');
                component.set('v.faxCliente',val.substring(0,10));
            }

        }

	},
    showToastError: function(component) {
        component.find('notifLib').showToast({
            "title": "Error",
            "message": component.get("v.toastMsg"),
            "variant": "error"
        });
    }
})