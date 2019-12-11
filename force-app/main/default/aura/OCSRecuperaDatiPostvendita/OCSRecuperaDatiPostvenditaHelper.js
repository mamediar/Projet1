({
    doRicercaHelper:function(cmp,event,helper){
        console.log('--------------------------------------------------------------------------------------');
		console.log('-- Helper JS: OCSRecuperaDatiPostVenditaHelper - Method:doRicercaHelper'); 


        this.checkField(cmp,event,helper);



        var paramList=['v.cognomeCliente','v.nomeCliente','v.pan','v.codFiscaleCliente','v.codCliente','v.dataNascitaCliente','v.numPratica','v.filtroTipoPratica', 'v.ragioneSociale', 'v.provinciaCliente', 'v.emailCliente', 'v.faxCliente', 'v.telefonoCliente', 'v.flagInfoCliente'];
        cmp.set('v.OCSClienti',null);
        cmp.set('v.idAccSelezionato',[]);
        cmp.set('v.accountSelezionato',null);
        cmp.set('v.praticheList',[]);
        cmp.set('v.praticaSelezionata',null);
        
        //sabrina: lavoro sui dati OCS        
        cmp.set('v.idOCSClienteSelezionato',[]);
        cmp.set('v.OCSClienteSelezionato',null);
        
        var paramMap={};
        paramList.forEach(function(temp){
            paramMap[temp.substring(2,temp.length)]=cmp.get(temp)!=undefined?cmp.get(temp):'';
        });
        console.log( paramMap );
        var action=cmp.get('c.getClienti');
        this.showSpinner(cmp);
        var nomeProcesso = cmp.get("v.nameProcess");
        
        action.setParam('data',paramMap);
        action.setParam('nameProcess',nomeProcesso);
        action.setCallback(this,function(resp){
            //console.log("doRicerca - getClienti - resp.getState()" + resp.getState()); 
            if(resp.getState()=='SUCCESS'){

                
                cmp.set('v.accountList',resp.getReturnValue()['accounts']);
                cmp.set('v.OCSClienti',resp.getReturnValue()['clienti']);              
                var s = JSON.stringify(resp.getReturnValue()['clienti']);
                console.log('***********/***prima****************');
                console.log(s);
                
                if(cmp.get("v.showDefaultToast"))
                {
                    if(cmp.get('v.accountList').length == 0 && cmp.get('v.OCSClienti').length == 0){
                        helper.setToast(cmp);
                        helper.hideSpinner(cmp);
                        return;
                    } 
                }
                
                if(cmp.get("v.isPostVendita")){
                    if(resp.getReturnValue()['clienti'].length==1){
                        var listSelId=[];
                      
                        listSelId.push(resp.getReturnValue()['clienti'][0]['codCliente']);	
                        cmp.set('v.idOCSClienteSelezionato',listSelId);
                        cmp.set('v.OCSClienteSelezionato',resp.getReturnValue()['clienti'][0]);
                        if(cmp.get("v.showPratiche")){
                            helper.getPratiche(cmp,resp.getReturnValue()['accounts'][0],helper);
                        }
                    }
                }else{
                    if(resp.getReturnValue()['accounts'].length==1){
                        var listSelId=[];
                        listSelId.push(resp.getReturnValue()['accounts'][0]['Id']);
                        cmp.set('v.idAccSelezionato',listSelId);
                        helper.getPratiche(cmp,resp.getReturnValue()['accounts'][0],helper);
                    }
                }
            }else{
                this.setToast(cmp,event,helper);
            }
            this.hideSpinner(cmp);
        });
        $A.enqueueAction(action);
    },
    
    
    getPratiche : function(cmp,selRows,helper) {
        console.log("Get Pratiche ************* "+cmp.get('v.filtroTipoPratica'));
        var tipoPratica=cmp.get('v.filtroTipoPratica');
        var getCliente=cmp.get('c.getCliente');
        var InfoCliente=cmp.get('v.flagInfoCliente');
        console.log("InfoCliente ************* "+InfoCliente);
        getCliente.setParam('acc',selRows);
        getCliente.setParam( 'tipoPratica', tipoPratica );
    //    if(InfoCliente==true)
     		getCliente.setParam('InfoCli',InfoCliente);
        var nameProcess = cmp.get("v.nameProcess");
        getCliente.setParam('nameProcess',selRows);
        
        helper.showSpinner(cmp);
        
        getCliente.setCallback(this,function(response1){
            if(response1.getState()=='SUCCESS'){
                var clienti=cmp.get('v.OCSClienti');
                var praticheTemp=[];
                clienti.forEach(function(c){
                    if(c['codCliente']==response1.getReturnValue()['account']['OCS_External_Id__c'].substring(1,response1.getReturnValue()['account']['OCS_External_Id__c'].length)){
                        praticheTemp=response1.getReturnValue()['pratiche'];
                    }
                });
                var filtro=cmp.get('v.filtroPratiche');
                if(filtro!=undefined && filtro!=null && filtro!=''){
                    console.log("getPratiche con filtro pratiche attivo: " + filtro);
                    var action=cmp.get('c.filtraPratiche');
                    
                    action.setParam('pratiche',praticheTemp);
                    action.setParam('filtroClass',filtro);
                    action.setCallback(this,function(resp){
                        
                        if(resp.getState()=='SUCCESS'){
                            cmp.set('v.accountSelezionato',response1.getReturnValue());
	                        cmp.set('v.praticheList',resp.getReturnValue());
                            console.log("Pratica");
                            
                            var praticaToValorize = [];
                            praticaToValorize.push(cmp.get("v.numPratica"));
                            var componentDatatable = cmp.find("praticheDatatableId");
    						componentDatatable.set("v.selectedRows", praticaToValorize);
                 			cmp.set("v.praticaSelezionataId",praticaToValorize);
                            
                            cmp.set("v.refreshDatable",false);
                   			cmp.set("v.refreshDatable",true);
                            var lista = JSON.serialize(listaPratica);
                            console.log(lista);
                        }
                        else if(resp.getState()=='ERROR'){
                            var errors = resp.getError();
                            if (errors) {
                                if (errors[0] && errors[0].message) {
                                    console.log("Error message: " + 
                                                errors[0].message);
                                    helper.showToast("Errore: " + 
                                                     errors[0].message,'error');
                                }else {
                                    console.log("Unknown error");
                                    helper.showToast('Errore generico','error');
                                }
                            } else {
                                console.log("Unknown error");
                                helper.showToast('Errore generico','error');
                            }
                        }
                        helper.hideSpinner(cmp);
                    });
                    helper.showSpinner(cmp);
                    $A.enqueueAction(action);
                    
                }
                else{
                    console.log("getPratiche senza filtro pratiche attivo : " + JSON.stringify(praticheTemp));
                    cmp.set('v.accountSelezionato',response1.getReturnValue());
                   // var listaPratica = [];
                    
                    for(var i = 0; i < praticheTemp.length ; i++){
                        praticheTemp[i].id = praticheTemp[i].numPratica;
                        console.log("Loop :" + praticheTemp[i].id);
                    }
                    //console.log("pratiche lavorate " + JSON.stringify(praticheTemp));
                    cmp.set('v.praticheList',praticheTemp);
                 //   var praticaToValorize = ['15771700'];
                 //   praticaToValorize.push("15771700");
                   // praticaToValorize.push(cmp.get("v.numPratica"))
                 //	cmp.set("v.praticaSelezionataId",praticaToValorize);
                    
                    //var componentDatatable = cmp.find("praticheDatatableId");
    				//componentDatatable.set("v.selectedRows", praticaToValorize);
                    cmp.set("v.refreshDatable",false);
                    cmp.set("v.refreshDatable",true);
                    /*
                    for(var i = 0; i < praticheTemp.length ; i++){
                        if(praticheTemp[i].numPratica == cmp.get("v.numPratica")){
                            console.log("Pratica Selezionata LOLL" + JSON.stringify(praticheTemp[i]));
                            var praticaToValorize = [];
                            praticaToValorize.push(praticheTemp[i]);
                            cmp.set("v.praticaSelezionata",praticaToValorize);
                        }
                    }*/
                    
                }
            }
            else{
                cmp.set('v.accountSelezionato',response1.getReturnValue());
            }
            helper.hideSpinner(cmp);
        });
        
        $A.enqueueAction(getCliente);
    },
    
    setToast : function(cmp,event,helper){
        var toast = $A.get('e.force:showToast');
        toast.setParams({
            title : 'La ricerca non ha prodotto alcun risultato',
            type : 'error',
            message : ' '
        });
        toast.fire();
    },
    
    showSpinner : function(cmp){
       
        var count = cmp.get("v.showSpinner")+1;
        cmp.set("v.showSpinner", count);    
         console.log("Mostro spinner "+count);
    },
    
    hideSpinner : function(cmp){
        var count = cmp.get("v.showSpinner")-1;
        cmp.set("v.showSpinner", count);        
        console.log("Nascondo spinner "+count);
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
    },
    checkField:function(component,event,helper){
        var a = component.get('v.ragioneSociale');
        var b = component.get('v.nomeCliente');
        var c = component.get('v.cognomeCliente');
        var d = component.get('v.dataNascitaCliente');
        var e = component.get('v.provinciaCliente');
        var f = component.get('v.codFiscaleCliente');
        var g = component.get('v.codCliente');
        var h = component.get('v.numPratica');
        var i = component.get('v.pan');
        var l = component.get('v.email');
        var m = component.get('v.Telefono');
        var n = component.get('v.Fax');


        if(
            this.isBlank(a) &&
            this.isBlank(b) &&
            this.isBlank(c) &&
            this.isBlank(d) &&
            this.isBlank(e) &&
            this.isBlank(f) &&
            this.isBlank(g) &&
            this.isBlank(h) &&
            this.isBlank(i) &&
            this.isBlank(l) &&
            this.isBlank(m) &&
            this.isBlank(n)
        ){
            component.set('v.showAlert2',true);
            var x = component.get('v.showAlert2');
            this.alert2(component);
            
        }else{
            component.set('v.showAlert2',false);
        }

    },

    isBlank : function(x){
        
        if(x === '' || x === null || x === undefined){
            return true;
        }else{
            return false;
        }
        
    },
    alert2 : function(cmp) {
        cmp.find('notifLib').showNotice({
            "variant":"error",
            "header":"Attenzione!",
            "message":"Compilare il form"
        });
    }
    
    
    
})